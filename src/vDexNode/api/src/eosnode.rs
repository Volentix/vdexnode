use crate::opt::Opt;
use opendht::{ DhtRunner, DhtRunnerConfig, InfoHash, Value };
use opendht::crypto::{ DhtCertificate, PrivateKey };
use serde::{ Deserialize, Serialize };
use rmps::Serializer;
use std::collections::HashMap;
use std::{ thread, time };
use std::sync::{Arc, Mutex};

/**
 * Contains node informations announced on hash(eos)
 * and used for /getConnectedNodes /getNodesLocation
 */
#[derive(Serialize, Deserialize)]
pub struct EosNodeInfo {
    pub id: String,
    pub ips: Vec<String>,
    pub key: String,
    pub public_key: String,
}

impl Clone for EosNodeInfo {
    fn clone(&self) -> Self {
        Self {
            id: self.id.clone(),
            key: self.key.clone(),
            public_key: self.public_key.clone(),
            ips: self.ips.clone(),
        }
    }
}

/**
 * Represents the EOSNode
 */
pub struct EosNode {
    pub info: EosNodeInfo,
    pub dht: Box<DhtRunner>, // used as a storage
    pub nodes: Arc<Mutex<HashMap<String, EosNodeInfo>>>, // known informations about the network
}

impl EosNode {
    /**
     * Bootstrap to the eos network and init info.
     * @param opt       nodes options given by the user
     * @param nodes     will store known infos on the network
     */
    pub fn new(opt: Opt, nodes: Arc<Mutex<HashMap<String, EosNodeInfo>>>) -> EosNode {
        let mut dht = DhtRunner::new();
        let mut config = DhtRunnerConfig::new();
        let cert = DhtCertificate::import(&*opt.certificate).ok().expect("Can't read cert file. Make sure that keys are generated");
        let pk = PrivateKey::import(&*opt.privkey, &*opt.password).ok().expect("Can't read key file. Make sure that keys are generated");
        config.set_identity(cert, pk);
        config.dht_config.node_config.network = opt.network;
        if opt.bootstrap.is_empty() {
            config.dht_config.node_config.is_bootstrap = true;
        }
        dht.run_config(opt.port, config);
        if !opt.bootstrap.is_empty() {
            let service : Vec<&str> = opt.bootstrap.rsplitn(2, ":").collect();
            let mut port = 4222;
            let host;
            if service.len() == 2 {
                port = service[0].parse().unwrap_or(4222);
                host = service[1];
            } else {
                host = service[0];
            }
            dht.bootstrap(host, port);
        }
        let node_id = dht.node_id();
        let public_key = format!("{}", dht.id());
        let mut node = EosNode {
            dht,
            info: EosNodeInfo {
                id: format!("{}", node_id),
                ips: Vec::new(),
                public_key,
                key: opt.eoskey,
            },
            nodes,
        };
        if !opt.bootstrap.is_empty() {
            node.init_ips();
        } else {
            node.get_public_ips();
        }
        node
    }

    /**
     * Get the public ips detected through the DHT
     */
    fn init_ips(&mut self) {
        println!("Retrieving public addresses...");
        let mut public_addresses = self.dht.public_addresses();
        let ten_millis = time::Duration::from_millis(10);
        let mut idx = 0;
        while public_addresses.len() == 0 {
            public_addresses = self.dht.public_addresses();
            thread::sleep(ten_millis);
            idx += 1;
            if idx == 3000 && public_addresses.len() == 0 {
                panic!("No public address found. Abort");
            }
        }

        println!("Public addresses collected!");
        let public_addresses: Vec<String> = public_addresses.iter().map(|addr| format!("{}", addr)).collect();
        self.info.ips = public_addresses;
    }

    /**
     * Get the public ips through an API (because no node to give detected ip)
     */
    fn get_public_ips(&mut self) {
        println!("Retrieving public ipv4 address (bootstrap)...");
        let ipv4 = reqwest::get("https://api.ipify.org");

        println!("Retrieving public ipv6 address (bootstrap)...");
        let ipv6 = reqwest::get("https://api6.ipify.org");

        let mut addresses : Vec<String> = Vec::new();
        if ipv4.is_ok() {
            let ipv4 = ipv4.unwrap().text().unwrap();
            if !ipv4.is_empty() {
                addresses.push(ipv4);
            }
        }
        if ipv6.is_ok() {
            let ipv6 = ipv6.unwrap().text().unwrap();
            if !ipv6.is_empty() && !ipv6.contains(".") {
                addresses.push(ipv6);
            }
        }
        if addresses.is_empty() {
            panic!("No public address found. Abort");
        }
        println!("Public addresses collected!");
        self.info.ips = addresses;
    }

    /**
     * Do a permanent put on the DHT to announce the presence of the node
     */
    pub fn announce(&mut self) {
        let mut buf = Vec::new();
        self.info.serialize(&mut Serializer::new(&mut buf)).unwrap();
        let mut put_done_cb = |_: bool| {
            info!("Node successfully announced");
        };
        self.dht.put_signed(&InfoHash::get("eos"), Value::from_bytes(&buf), &mut put_done_cb, true);
    }
}