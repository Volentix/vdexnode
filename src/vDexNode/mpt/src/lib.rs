#[macro_use]
extern crate serde_derive;
extern crate serde;
extern crate serde_json;
extern crate subtle;

extern crate centipede;
extern crate curv;
extern crate paillier;
extern crate zk_paillier;
pub mod utils;

#[derive(Copy, PartialEq, Eq, Clone, Debug)]
pub enum Error {
    InvalidKey,
    InvalidSS,
    InvalidCom,
    InvalidSig,
}
