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

mod eosnode;
mod handler;
mod opt;
mod server;

use crate::eosnode::*;
use crate::handler::Handler;
use crate::server::Server;
use crate::opt::Opt;
use opendht::{ InfoHash, Value };
use rmps::Deserializer;
use rmps::decode::Error;
use serde::Deserialize;
use std::collections::HashMap;
use std::io::Cursor;
use std::sync::{ Arc, Mutex };
use structopt::StructOpt;

fn main() {
    let opt = Opt::from_args();
    let shared_info = Arc::new(Mutex::new(HashMap::new()));
    let mut node = EosNode::new(opt);
    node.announce();

    // TODO: inject --certificate && --privkey 
    // TODO MultiParty Threshold

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
    };
    let _ = node.dht.listen(&InfoHash::get("eos"), &mut value_cb);

    let handler = Handler::new(shared_info);
    Server::run(Arc::new(Mutex::new(handler)))
}
