use crate::eosnode::*;
use opendht::{ InfoHash, Value };
use reqwest;
use serde::{ Deserialize, Serialize };
use std::collections::HashMap;
use std::net::SocketAddr;
use std::str::FromStr;
use std::sync::{ Arc, Condvar, Mutex };
use std::sync::atomic::{AtomicBool, Ordering};
use std::io::Read;
use std::{ thread, time };

#[derive(Serialize, Deserialize)]
pub struct ChatMessage {
    pub author: String,
    pub body: String,
    pub encrypted: bool,
}

#[derive(Clone)]
pub enum ChatEvent {
    Join(u64, String, Arc<Mutex<Vec<ChatMessage>>>),
    Leave(u64, String)
}

pub struct ChatReader {
    id: u64,
    room: String,
    chat: Arc<Mutex<Vec<ChatMessage>>>,
    events: Arc<Mutex<Vec<ChatEvent>>>,
    stopped: AtomicBool,
}

impl ChatReader {
    pub fn new(id: u64, room: String, chat: Arc<Mutex<Vec<ChatMessage>>>, events: Arc<Mutex<Vec<ChatEvent>>>) -> ChatReader {
        let result = ChatReader {
            id,
            room,
            chat,
            events,
            stopped: AtomicBool::new(false),
        };
        result.events.lock().unwrap().push(ChatEvent::Join(result.id, result.room.clone(), result.chat.clone()));
        result
    }
}

impl Read for ChatReader {
    fn read(&mut self, buf: &mut [u8]) -> std::io::Result<usize> {
        // Reset buffer
        // HACK but mandatory due to https://github.com/SergioBenitez/Rocket/issues/33
        // Also this means that the output is a binary output
        for i in 0..buf.len() {
            buf[i] = 0x00;
        }
        if !self.stopped.load(Ordering::Relaxed) {
            {
                let mut messages = self.chat.lock().unwrap();
                if !messages.is_empty() {
                    let message = serde_json::to_string(messages.get(0).unwrap());
                    if !message.is_ok() {
                        messages.remove(0);
                        return Ok(0);
                    }
                    let message = message.unwrap() + "\n";
                    let read = std::cmp::min(buf.len(), message.len());
                    buf[..read].clone_from_slice(&message.as_bytes());
                    if read < message.len() {
                        return Ok(0);
                    }
                    messages.remove(0);
                    return Ok(buf.len());
                }
            }
            thread::sleep(time::Duration::from_millis(100));
            return Ok(buf.len());
        }
        Ok(0)
    }
}

impl Drop for ChatReader {
    fn drop(&mut self) {
        self.stopped.store(true, Ordering::Relaxed);
        self.events.lock().unwrap().push(ChatEvent::Leave(self.id, self.room.clone()))
    }
}

/**
 * Do get and put operations on the DHT and format info for the server
 */
pub struct Handler {
    eosnode: Arc<Mutex<EosNode>>,
    chat_events: Arc<Mutex<Vec<ChatEvent>>>,
    chat_readers_idx: u64,
}

impl Handler {
    pub fn new(eosnode: Arc<Mutex<EosNode>>, chat_events: Arc<Mutex<Vec<ChatEvent>>>) -> Handler {
        Handler {
            eosnode,
            chat_events,
            chat_readers_idx: 0,
        }
    }

    /**
     * Retrieve known nodes from the EOS Node
     * @return      The format returned will be {node_id: eos_key}
     */
    pub fn get_connected_nodes(&mut self) -> HashMap<String, String> {
        let mut result = HashMap::new();
        for (id, node) in &(*self.eosnode.lock().unwrap().nodes.lock().unwrap()) {
            result.insert(id.clone(), node.key.clone());
        }
        result
    }

    pub fn get_connected_nodes_IP(&mut self) -> HashMap<String, String> {
        let mut result = HashMap::new();
        for (_id, node) in &(*self.eosnode.lock().unwrap().nodes.lock().unwrap()) {
            result.insert(node.ips.get(0).unwrap().clone(), node.key.clone());
        }
        result
    }
    /**
     * Get nodes locations via ipinfo.io
     * @return      { node_id: [city, location]}
     */
    pub fn get_nodes_location(&mut self) -> HashMap<String, Vec<String>> {
        let mut locations = HashMap::new();

        for (_, node) in &(*self.eosnode.lock().unwrap().nodes.lock().unwrap()) {
            for ip in &node.ips {
                let ip = SocketAddr::from_str(&*ip);
                if !ip.is_ok() {
                    continue;
                }
                let addr = format!("https://ipinfo.io/{}/json", ip.unwrap().ip());
                let res = reqwest::get(&*addr);
                if !res.is_ok() {
                    continue;
                }
                let resp: HashMap<String, String> = res.unwrap().json().unwrap_or(HashMap::new());
                if !resp.contains_key("loc") || !resp.contains_key("city") {
                    continue;
                }

                locations.insert(node.id.clone(), vec![
                    resp.get("city").unwrap().to_string(),
                    resp.get("loc").unwrap().to_string()
                ]);
            }
        }
        locations
    }

    /**
     * Insert a key on the DHT, this does a permanent put on the DHT
     * @param key       key of the hashmap
     * @param value     value of the hashmap
     */
    pub fn insert(&mut self, key: Vec<u8>, value: String) {
        let mut put_done_cb = |_: bool| {
            info!("Key successfully announced");
        };
        self.eosnode.lock().unwrap().dht.put_signed(
            &InfoHash::from_bytes(&key), Value::new(&*value), &mut put_done_cb, true);
    }

    /**
     * Retrieve a value at a given hash
     * @return one value retrieven
     * @note this return only one value!
     */
    pub fn get(&mut self, key: Vec<u8>) -> Option<String> {
        let mut result = None;
        let pair = Arc::new((Mutex::new(false), Condvar::new()));
        let pair2 = pair.clone();
        let mut get_cb = |v: Box<Value>| {
            result = Some(String::from_utf8(v.as_bytes()).unwrap_or(String::new()));
            true
        };
        let mut done_cb = |_: bool| {
            let (lock, cvar) = &*pair2;
            let mut done = lock.lock().unwrap();
            *done = true;
            cvar.notify_one();
        };
        self.eosnode.lock().unwrap().dht.get(&InfoHash::from_bytes(&key), &mut get_cb, &mut done_cb);
        let (lock, cvar) = &*pair;
        let mut done = lock.lock().unwrap();
        while !*done {
            done = cvar.wait(done).unwrap();
        }
        result
    }

    /**
     * Return the node infos
     */
    pub fn info(&mut self) -> EosNodeInfo {
        self.eosnode.lock().unwrap().info.clone()
    }

    /**
     * Join a Room
     * @param room  Room to join
     */
    pub fn join(&mut self, room: String) -> ChatReader {
        self.chat_readers_idx += 1;
        info!("Join room {}. id: {}", room, self.chat_readers_idx);
        ChatReader::new(
            self.chat_readers_idx,
            room,
            Arc::new(Mutex::new(Vec::new())),
            self.chat_events.clone()
        )
    }

    /**
     * Sens a message to a room
     * @param room  Room to send a message
     * @param msg   Message to send
     */
    pub fn send(&mut self, room: String, msg: &str) {
        let mut put_done_cb = |_: bool| {};
        self.eosnode.lock().unwrap().dht.put_signed(
            &InfoHash::get(&*room), Value::new(msg), &mut put_done_cb, false);
    }

    /**
     * Sens a message to a room
     * @param room  Room to send a message
     * @param to    Destination
     * @param msg   Message to send
     */
    pub fn send_to_user(&mut self, room: String, to: String, msg: &str) {
        let mut put_done_cb = |_: bool| {};

        self.eosnode.lock().unwrap().dht.put_encrypted(
            &InfoHash::get(&*room), &InfoHash::from_hex(&*to), Value::new(msg), &mut put_done_cb, false);
    }
}
