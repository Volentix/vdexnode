#![feature(proc_macro_hygiene, decl_macro)]

extern crate env_logger;
#[macro_use]
extern crate log;
extern crate opendht;
#[macro_use] extern crate rocket;
extern crate rocket_contrib;
extern crate rocket_cors;
extern crate reqwest;
extern crate rmp_serde as rmps;
extern crate serde_derive;
extern crate serde;
extern crate serde_json;
extern crate uuid;

mod eosnode;
mod handler;
mod opt;
mod server;

use crate::eosnode::*;
use crate::handler::*;
use crate::server::Server;
use crate::opt::Opt;
use opendht::{ InfoHash, Value };
use opendht::crypto::OpToken;
use rmps::Deserializer;
use rmps::decode::Error;
use serde::Deserialize;
use std::collections::HashMap;
use std::io::Cursor;
use std::sync::{ Arc, Mutex };
use std::sync::atomic::{AtomicBool, Ordering};
use std::{ thread, time };
use structopt::StructOpt;

fn main() {
    let opt = Opt::from_args();
    let shared_info = Arc::new(Mutex::new(HashMap::new()));
    let chat_events = Arc::new(Mutex::new(Vec::new()));
    let chat_events_cloned = chat_events.clone();
    let mut node = EosNode::new(opt, shared_info.clone());
    node.announce();
    println!("Current node id: {}", node.info.id);
    let pk = node.dht.id();
    println!("Public Key: {}", pk);

    // Follow other nodes
    let mut value_cb = |v: Box<Value>, expired: bool| {
        let cur = Cursor::new(v.as_bytes());
        let mut de = Deserializer::new(cur);
        let result: Result<EosNodeInfo, Error> = Deserialize::deserialize(&mut de);
        if result.is_ok() {
            let node = result.unwrap();
            if expired {
                info!("Node expired: {}", node.id);
                (*shared_info.lock().unwrap()).remove(&*node.id);
            } else {
                info!("Node detected: {}", node.id);
                (*shared_info.lock().unwrap()).insert(node.id.clone(), node);
            }
        }
        true
    };
    let _ = node.dht.listen(&InfoHash::get("eos"), &mut value_cb);

    // Chat loop
    // TODO move into handler
    let node = Arc::new(Mutex::new(node));
    let node_cloned = node.clone();
    let stop_chat_loop  = Arc::new(AtomicBool::new(false));
    let stop_chat_loop_cloned  = stop_chat_loop.clone();
    let chat_thread = thread::spawn(move || {
        let delay = time::Duration::from_millis(25);
        let mut tokens: HashMap<(u64, String), Box<OpToken>> = HashMap::new();
        while !stop_chat_loop_cloned.load(Ordering::SeqCst) {
            let events;
            {
                let mut chat_events = chat_events.lock().unwrap();
                events = chat_events.clone();
                chat_events.clear();
            }
            for event in &events {
                match event {
                    ChatEvent::Join(id, room, msg) => {
                        info!("Join room {}. id: {}", room, id);
                        let mut value_cb = |v: Box<Value>, expired: bool| {
                            if expired {
                                return true;
                            }
                            let body = String::from_utf8(v.as_bytes()).unwrap_or(String::new());
                            if body.is_empty() {
                                return true;
                            }
                            let mut author = String::new();
                            if v.owner().is_some() {
                                author = format!("{}", v.owner().unwrap().id());
                            }
                            msg.lock().unwrap().push(ChatMessage {
                                author,
                                body,
                                encrypted: (v.recipient() == pk),
                            });
                            true
                        };
                        let mut node_cloned = node_cloned.lock().unwrap();
                        let token = node_cloned.dht.listen(&InfoHash::get(&*room), &mut value_cb);
                        tokens.insert((*id, room.to_string()), token);
                    },
                    ChatEvent::Leave(id, room) => {
                        if tokens.contains_key(&(*id, room.to_string())) {
                            let mut node_cloned = node_cloned.lock().unwrap();
                            let value = tokens.remove(&(*id, room.to_string())).unwrap();
                            node_cloned.dht.cancel_listen(&InfoHash::get(&*room), value);
                            info!("Leave room {}. id: {}", room, id);
                        } else {
                            warn!("Leave room - Invalid parameter. Room: {}. id: {}", room, id);
                        }
                    }
                }
            }
            thread::sleep(delay);
        }
    });

    let handler = Handler::new(node, chat_events_cloned);
    Server::run(Arc::new(Mutex::new(handler)));
    stop_chat_loop.store(true, Ordering::Relaxed);
    let _ = chat_thread.join();
}