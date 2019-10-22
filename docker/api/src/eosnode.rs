use crate::opt::Opt;
use opendht::{ DhtRunner, DhtRunnerConfig, InfoHash, Value };
use serde::{ Deserialize, Serialize };
use rmps::Serializer;
use std::{ thread, time };

#[derive(Serialize, Deserialize)]
pub struct EosNodeInfo {
    pub id: String,
    pub ips: Vec<String>,
    pub key: String,
}

pub struct EosNode {
    pub info: EosNodeInfo,
    pub dht: Box<DhtRunner>,
}

impl EosNode {
    pub fn new(opt: Opt) -> EosNode {
        let mut dht = DhtRunner::new();
        let mut config = DhtRunnerConfig::new();
        config.dht_config.node_config.network =  opt.network;
        dht.run_config(opt.port, config);
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
        let node_id = dht.node_id();
        let mut node = EosNode {
            dht,
            info: EosNodeInfo {
                id: format!("{}", node_id),
                ips: Vec::new(),
                key: opt.eoskey,
            },
        };
        node.init_ips();
        node
    }

    fn init_ips(&mut self) {
        let mut public_addresses = self.dht.public_addresses();
        let ten_millis = time::Duration::from_millis(10);
        let mut idx = 0;
        while public_addresses.len() == 0 {
            public_addresses = self.dht.public_addresses();
            thread::sleep(ten_millis);
            idx += 1;
        }

        if idx == 1000 && public_addresses.len() == 0 {
            panic!("No public address found. Abort");
        }

        println!("Current node id: {}", self.dht.node_id());
        let public_addresses: Vec<String> = public_addresses.iter().map(|addr| format!("{}", addr)).collect();
        self.info.ips = public_addresses;
    }

    pub fn announce(&mut self) {
        let mut buf = Vec::new();
        self.info.serialize(&mut Serializer::new(&mut buf)).unwrap();
        let mut put_done_cb = |_: bool| {
            info!("Node successfully announced");
        };
        self.dht.permanent_put(&InfoHash::get("eos"), Value::from_bytes(&buf), &mut put_done_cb);
    }
}