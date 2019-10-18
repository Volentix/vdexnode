use crate::eosnode::EosNodeInfo;
use reqwest;
use std::collections::HashMap;
use std::net::SocketAddr;
use std::str::FromStr;
use std::sync::{Arc, Mutex};

pub struct Handler {
    nodes: Arc<Mutex<HashMap<String, EosNodeInfo>>>,
}

impl Handler {
    pub fn new(nodes: Arc<Mutex<HashMap<String, EosNodeInfo>>>) -> Handler {
        Handler {
            nodes,
        }
    }

    pub fn get_connected_nodes(&mut self) -> HashMap<String, String> {
        let mut result = HashMap::new();
        for (id, node) in &(*self.nodes.lock().unwrap()) {
            result.insert(id.clone(), node.key.clone());
        }
        result
    }

    pub fn get_nodes_location(&mut self) -> HashMap<String, Vec<String>> {
        let mut locations = HashMap::new();

        for (_, node) in &(*self.nodes.lock().unwrap()) {
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

}
