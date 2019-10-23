use crate::eosnode::*;
use reqwest;
use std::collections::HashMap;
use std::net::SocketAddr;
use std::str::FromStr;
use std::sync::{ Arc, Condvar, Mutex };
use opendht::{ InfoHash, Value };

pub struct Handler {
    eosnode: EosNode,
}

impl Handler {
    pub fn new(eosnode: EosNode) -> Handler {
        Handler {
            eosnode,
        }
    }

    pub fn get_connected_nodes(&mut self) -> HashMap<String, String> {
        let mut result = HashMap::new();
        for (id, node) in &(*self.eosnode.nodes.lock().unwrap()) {
            result.insert(id.clone(), node.key.clone());
        }
        result
    }

    pub fn get_nodes_location(&mut self) -> HashMap<String, Vec<String>> {
        let mut locations = HashMap::new();

        for (_, node) in &(*self.eosnode.nodes.lock().unwrap()) {
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

    pub fn insert(&mut self, key: Vec<u8>, value: String) {
        let mut put_done_cb = |_: bool| {
            println!("Key successfully announced");
        };
        println!("INSERT {}", InfoHash::from_bytes(&key));
        self.eosnode.dht.permanent_put(&InfoHash::from_bytes(&key), Value::new(&*value), &mut put_done_cb);
    }

    pub fn get(&mut self, key: Vec<u8>) -> Option<String> {
        let mut result = None;
        let pair = Arc::new((Mutex::new(false), Condvar::new()));
        let pair2 = pair.clone();
        let mut get_cb = |v: Box<Value>| {
            println!("Get value: {}", *v);
            result = Some(String::from_utf8(v.as_bytes()).unwrap_or(String::new()));
        };
        let mut done_cb = |_: bool| {
            let (lock, cvar) = &*pair2;
            let mut done = lock.lock().unwrap();
            *done = true;
            cvar.notify_one();
        };
        println!("GET {}", InfoHash::from_bytes(&key));
        self.eosnode.dht.get(&InfoHash::from_bytes(&key), &mut get_cb, &mut done_cb);
        let (lock, cvar) = &*pair;
        let mut done = lock.lock().unwrap();
        while !*done {
            done = cvar.wait(done).unwrap();
        }
        result
    }

}
