use structopt::StructOpt;

#[derive(Debug, StructOpt)]
#[structopt(name = "api", about = "VDexNode API")]
pub struct Opt {
    #[structopt(short = "n", long = "network", default_value = "0")]
    pub network: u32,

    #[structopt(short = "e", long = "eoskey", default_value = "")]
    pub eoskey: String,

    #[structopt(short = "b", long = "bootstrap")]
    pub bootstrap: String,

    #[structopt(short = "c", long = "certificate")]
    pub certificate: String,

    #[structopt(short = "k", long = "privkey")]
    pub privkey: String,

    #[structopt(short = "p", long = "port", default_value = "4222")]
    pub port: u16,
}