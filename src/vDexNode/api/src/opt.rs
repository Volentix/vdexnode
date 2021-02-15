use structopt::StructOpt;

// TODO move to config file
#[derive(Debug, StructOpt)]
#[structopt(name = "api", about = "VDexNode API")]
pub struct Opt {
    #[structopt(short = "n", long = "network", default_value = "0")]
    pub network: u32,

    #[structopt(short = "e", long = "eoskey", default_value = "")]
    pub eoskey: String,

    #[structopt(short = "b", long = "bootstrap", default_value = "")]
    pub bootstrap: String,

    #[structopt(short = "c", long = "certificate")]
    pub certificate: String,

    #[structopt(short = "k", long = "privkey")]
    pub privkey: String,

    #[structopt(short = "s", long = "password", default_value = "")]
    pub password: String,

    #[structopt(short = "p", long = "port", default_value = "4222")]
    pub port: u16,

    #[structopt(long = "bitcoin-cli", default_value = "bitcoin-cli")]
    pub bitcoin_cli: String,

    #[structopt(long = "bitcoin-user", default_value = "")]
    pub bitcoin_user: String,

    #[structopt(long = "bitcoin-password", default_value = "")]
    pub bitcoin_password: String,

    #[structopt(long = "bitcoin-connect", default_value = "localhost")]
    pub bitcoin_connect: String,

    #[structopt(long = "bitcoin-port", default_value = "8332")]
    pub bitcoin_port: String,
}