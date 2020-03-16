use crate::handler::{ ChatReader, Handler };
use crate::eosnode::EosNodeInfo;
use rocket::response::Stream;
use rocket::http::RawStr;
use rocket::State;
use rocket_contrib::json::Json;
use std::sync::{ Arc, Mutex };
use std::collections::HashMap;
use std::str::FromStr;
use std::fs;
use std::io::{ self, Error, ErrorKind };
use serde::{ Deserialize, Serialize };
use rmps::Serializer;
use uuid::Uuid;

/**
 * The following struct are used for MultiParty Threshold
 */
#[derive(Hash, PartialEq, Eq, Clone, Debug, Serialize, Deserialize)]
pub struct TupleKey {
    pub first: String,
    pub second: String,
    pub third: String,
    pub fourth: String,
}

#[derive(Clone, PartialEq, Debug, Serialize, Deserialize)]
pub struct PartySignup {
    pub number: u32,
    pub uuid: String,
}

#[derive(Clone, PartialEq, Debug, Serialize, Deserialize)]
pub struct Index {
    pub key: TupleKey,
}

#[derive(Clone, PartialEq, Debug, Serialize, Deserialize)]
pub struct Entry {
    pub key: TupleKey,
    pub value: String,
}

#[derive(Serialize, Deserialize)]
pub struct Params {
    pub parties: String,
    pub threshold: String,
}

/**
 * MPT /set. Send a key on the DHT
 */
#[post("/set", format = "json", data = "<request>")]
fn set(
    handler: State<Arc<Mutex<Handler>>>,
    request: Json<Entry>,
) -> Json<Result<(), ()>> {
    let entry: Entry = request.0;
    let mut handler = handler.lock().unwrap();
    let mut buf = Vec::new();
    entry.key.serialize(&mut Serializer::new(&mut buf)).unwrap();
    // The following value is used to get unique hashes for nodes
    // Because if all nodes are using the same hashes, we can have
    // multiple MPT transactions
    let salt: Vec<u8> = handler.info().id.as_bytes().to_vec();
    buf.extend(salt);
    handler.insert(buf, entry.value);
    Json(Ok(()))
}

#[post("/get", format = "json", data = "<request>")]
fn get(
    handler: State<Arc<Mutex<Handler>>>,
    request: Json<Index>,
) -> Json<Result<Entry, ()>> {
    let index: Index = request.0;
    let mut handler = handler.lock().unwrap();
    let mut buf = Vec::new();
    index.key.serialize(&mut Serializer::new(&mut buf)).unwrap();
    // Same here
    let salt: Vec<u8> = handler.info().id.as_bytes().to_vec();
    buf.extend(salt);
    match handler.get(buf) {
        Some(v) => {
            let entry = Entry {
                key: index.key,
                value: format!("{}", v.clone()),
            };
            Json(Ok(entry))
        }
        None => Json(Err(())),
    }
}

#[post("/signupkeygen", format = "json")]
fn signup_keygen(
    handler: State<Arc<Mutex<Handler>>>
) -> Json<Result<PartySignup, ()>> {
    let data = fs::read_to_string("config/server.conf")
        .expect("Unable to read params, make sure config file is present in the same folder ");
    let params: Params = serde_json::from_str(&data).unwrap();
    let parties: u32 = params.parties.parse::<u32>().unwrap();
    // The initial hash will be hash(TupleKey + salt)
    let key = TupleKey {
        first: "signup".to_string(),
        second: "keygen".to_string(),
        third: "".to_string(),
        fourth: "".to_string(),
    };
    let party_signup: PartySignup;
    let mut handler = handler.lock().unwrap();
    let mut buf = Vec::new();
    key.serialize(&mut Serializer::new(&mut buf)).unwrap();
    // same here
    let salt: Vec<u8> = handler.info().id.as_bytes().to_vec();
    buf.extend(salt);
    {
        let value = handler.get(buf.clone()).unwrap();
        let party_i_minus1_signup: PartySignup = serde_json::from_str(&value).unwrap();
        if party_i_minus1_signup.number < parties {
            let party_num = party_i_minus1_signup.number + 1;
            party_signup = PartySignup {
                number: party_num.clone(),
                uuid: party_i_minus1_signup.uuid,
            };
        } else {
            let uuid = Uuid::new_v4().to_string();
            let party1 = 1;
            party_signup = PartySignup {
                number: party1,
                uuid,
            };
        }
    }
    handler.insert(buf, serde_json::to_string(&party_signup).unwrap());
    return Json(Ok(party_signup));
}

#[post("/signupsign", format = "json")]
fn signup_sign(handler: State<Arc<Mutex<Handler>>>) -> Json<Result<PartySignup, ()>> {
    //read parameters:
    let data = fs::read_to_string("config/server.conf")
        .expect("Unable to read params, make sure config file is present in the same folder ");
    let params: Params = serde_json::from_str(&data).unwrap();
    let threshold: u32 = params.threshold.parse::<u32>().unwrap();
    let key = TupleKey {
        first: "signup".to_string(),
        second: "sign".to_string(),
        third: "".to_string(),
        fourth: "".to_string(),
    };
    let party_signup: PartySignup;
    let mut handler = handler.lock().unwrap();
    let mut buf = Vec::new();
    key.serialize(&mut Serializer::new(&mut buf)).unwrap();
    // same here
    let salt: Vec<u8> = handler.info().id.as_bytes().to_vec();
    buf.extend(salt);
    {
        let value = handler.get(buf.clone()).unwrap();
        let party_i_minus1_signup: PartySignup = serde_json::from_str(&value).unwrap();
        if party_i_minus1_signup.number < threshold + 1 {
            let party_num = party_i_minus1_signup.number + 1;
            party_signup = PartySignup {
                number: party_num.clone(),
                uuid: party_i_minus1_signup.uuid,
            };
        } else {
            let uuid = Uuid::new_v4().to_string();
            let party1 = 1;
            party_signup = PartySignup {
                number: party1,
                uuid,
            };
        }
    }
    handler.insert(buf, serde_json::to_string(&party_signup).unwrap());
    return Json(Ok(party_signup));
}

/**
 * Return currently detected nodes on the DHT
 */
#[get("/getConnectedNodes")]
fn connected_nodes(handler: State<Arc<Mutex<Handler>>>) -> Json<HashMap<String, String>> {
    let mut handler = handler.lock().unwrap();
    let mut connected_nodes = handler.get_connected_nodes();
    connected_nodes.insert("Result".to_string(), "Success".to_string());
    Json(connected_nodes)
}


#[get("/getConnectedIPs")]
fn connected_ips(handler: State<Arc<Mutex<Handler>>>) -> Json<HashMap<String, String>> {
    let mut handler = handler.lock().unwrap();
    let mut connected_nodes = handler.get_connected_ips();
    connected_nodes.insert("Result".to_string(), "Success".to_string());
    Json(connected_nodes)
}

/**
 * Return nodes location on the DHT
 */
#[get("/getNodesLocation")]
fn nodes_location(handler: State<Arc<Mutex<Handler>>>) -> Json<HashMap<String, Vec<String>>> {
    let mut handler = handler.lock().unwrap();
    let nodes_location = handler.get_nodes_location();
    Json(nodes_location)
}

/**
 * Return nodes location on the DHT
 */
#[get("/getCountryIP?<ip>")]
fn country(handler: State<Arc<Mutex<Handler>>>, ip: &RawStr) -> Json<HashMap<String, String>> {
    let mut handler = handler.lock().unwrap();
    let ip = ip.url_decode().unwrap_or(String::new());
    let country = handler.get_country(ip);
    let mut result: HashMap<String, String> = HashMap::new();
    match country {
        Some(c) => result.insert(String::from("Country"), c),
        None => result.insert(String::from("Err"), String::from("No country found"))
    };
    Json(result)
}

#[get("/room/<room>")]
fn stream(handler: State<Arc<Mutex<Handler>>>, room: &RawStr) -> io::Result<Stream<ChatReader>> {
    let mut handler = handler.lock().unwrap();
    let room = room.url_decode().unwrap_or(String::new());
    if room.is_empty() {
        return Err(Error::new(ErrorKind::Other, "Cannot decode room"));
    }
    Ok(Stream::from(handler.join(room)))
}

#[derive(Serialize, Deserialize)]
pub struct Message {
    pub message: String
}

#[post("/room/<room>", format = "application/json", data = "<message>")]
fn put_msg(handler: State<Arc<Mutex<Handler>>>, room: &RawStr, message: Json<Message>) -> Json<bool> {
    let mut handler = handler.lock().unwrap();
    let room = room.url_decode().unwrap_or(String::new());
    if room.is_empty() {
        return Json(false);
    }
    handler.send(room, &*message.message);
    Json(true)
}

#[post("/room/<room>/<user>", format = "application/json", data = "<message>")]
fn put_encrypted_msg(handler: State<Arc<Mutex<Handler>>>, room: &RawStr, user: &RawStr, message: Json<Message>) -> Json<bool> {
    let mut handler = handler.lock().unwrap();
    let room = room.url_decode().unwrap_or(String::new());
    let user = user.url_decode().unwrap_or(String::new());
    if room.is_empty() || user.is_empty() {
        return Json(false);
    }
    handler.send_to_user(room, user, &*message.message);
    Json(true)
}

/**
 * Return node's infos
 */
#[get("/")]
fn node_infos(handler: State<Arc<Mutex<Handler>>>) -> Json<EosNodeInfo> {
    let mut handler = handler.lock().unwrap();
    let info = handler.info();
    Json(info)
}

/// BITCOIN

#[get("/getnewaddress")]
fn getnewaddress(handler: State<Arc<Mutex<Handler>>>) -> Json<HashMap<String, String>> {
    let bitcoin = handler.lock().unwrap().bitcoin.clone();
    Json(bitcoin.getaddr())
}

#[get("/dumpprivkey/<address>")]
fn dumpprivkey(handler: State<Arc<Mutex<Handler>>>, address: &RawStr) -> Json<HashMap<String, String>> {
    let bitcoin = handler.lock().unwrap().bitcoin.clone();
    let address = address.url_decode().unwrap_or(String::new());
    Json(bitcoin.dumpprivkey(address))
}

#[get("/getbalance")]
fn getbalance(handler: State<Arc<Mutex<Handler>>>) -> Json<HashMap<String, String>> {
    let bitcoin = handler.lock().unwrap().bitcoin.clone();
    Json(bitcoin.balance())
}

#[derive(Serialize, Deserialize)]
pub struct SignRequest {
    pub n: u32,
    pub keys: Vec<String>
}

#[post("/addmultisigaddress", format = "application/json", data = "<signrequest>")]
fn addmultisigaddress(handler: State<Arc<Mutex<Handler>>>, signrequest: Json<SignRequest>) -> Json<HashMap<String, String>> {
    let bitcoin = handler.lock().unwrap().bitcoin.clone();
    Json(bitcoin.addmultisigaddress(signrequest.n, &signrequest.keys))
}

#[post("/createmultisig", format = "application/json", data = "<signrequest>")]
fn createmultisig(handler: State<Arc<Mutex<Handler>>>, signrequest: Json<SignRequest>) -> Json<HashMap<String, String>> {
    let bitcoin = handler.lock().unwrap().bitcoin.clone();
    Json(bitcoin.createmultisig(signrequest.n, &signrequest.keys))
}

#[derive(Serialize, Deserialize)]
pub struct GetTransactionRequest {
    pub txid: String,
}

#[post("/gettransaction", format = "application/json", data = "<req>")]
fn gettransaction(handler: State<Arc<Mutex<Handler>>>, req: Json<GetTransactionRequest>) -> Json<HashMap<String, String>> {
    let bitcoin = handler.lock().unwrap().bitcoin.clone();
    Json(bitcoin.gettransaction(req.txid.clone()))
}

#[derive(Serialize, Deserialize)]
pub struct SendToRequest {
    pub bitcoinaddress: String,
    pub amount: String,
}

#[post("/sendtoaddress", format = "application/json", data = "<req>")]
fn sendtoaddress(handler: State<Arc<Mutex<Handler>>>, req: Json<SendToRequest>) -> Json<HashMap<String, String>> {
    let bitcoin = handler.lock().unwrap().bitcoin.clone();
    Json(bitcoin.sendtoaddress(req.bitcoinaddress.clone(), req.amount.clone()))
}


#[derive(Serialize, Deserialize)]
pub struct BcSignRequest {
    pub bitcoinaddress: String,
    pub message: String,
}

#[post("/signmessage", format = "application/json", data = "<req>")]
fn signmessage(handler: State<Arc<Mutex<Handler>>>, req: Json<BcSignRequest>) -> Json<HashMap<String, String>> {
    let bitcoin = handler.lock().unwrap().bitcoin.clone();
    Json(bitcoin.signmessage(req.bitcoinaddress.clone(), req.message.clone()))
}

pub struct Server;

impl Server {
    pub fn run(handler: Arc<Mutex<Handler>>) {
        // CORS!
        let allowed_origins = rocket_cors::AllowedOrigins::all();
        let allowed_methods: rocket_cors::AllowedMethods = ["Get", "Post", "Delete", "Head", "Options", "Put", "Patch"]
            .iter().map(|s| FromStr::from_str(s).unwrap()).collect();

        let cors = rocket_cors::CorsOptions {
            allowed_origins,
            allowed_methods,
            allowed_headers: rocket_cors::AllowedHeaders::all(),
            allow_credentials: true,
            ..Default::default()
        }
        .to_cors().ok().expect("Incorrect CORS specified");

        // Announce uuid for MPT.
        // TODO: move?
        let keygen_key = TupleKey {
            first: "signup".to_string(),
            second: "keygen".to_string(),
            third: "".to_string(),
            fourth: "".to_string(),
        };
        let sign_key = TupleKey {
            first: "signup".to_string(),
            second: "sign".to_string(),
            third: "".to_string(),
            fourth: "".to_string(),
        };
        let uuid_keygen = Uuid::new_v4().to_string();
        let uuid_sign = Uuid::new_v4().to_string();

        let party1 = 0;
        let party_signup_keygen = PartySignup {
            number: party1.clone(),
            uuid: uuid_keygen,
        };
        let party_signup_sign = PartySignup {
            number: party1.clone(),
            uuid: uuid_sign,
        };
        {
            let mut handler = handler.lock().unwrap();
            let mut buf = Vec::new();
            keygen_key.serialize(&mut Serializer::new(&mut buf)).unwrap();
            let salt: Vec<u8> = handler.info().id.as_bytes().to_vec();
            buf.extend(salt.clone());
            handler.insert(
                buf,
                serde_json::to_string(&party_signup_keygen).unwrap(),
            );
            let mut buf = Vec::new();
            sign_key.serialize(&mut Serializer::new(&mut buf)).unwrap();
            buf.extend(salt);
            handler.insert(buf, serde_json::to_string(&party_signup_sign).unwrap());
        }

        // Launch server
        rocket::ignite()
            .manage(handler)
            .mount("/", routes![nodes_location, connected_nodes, connected_ips, get,
                        put_msg, put_encrypted_msg, set, signup_keygen, signup_sign,
                        stream, node_infos, country])
            .mount("/bitcoin", routes![addmultisigaddress, createmultisig, getbalance,
                        getnewaddress, dumpprivkey, gettransaction, sendtoaddress,
                        signmessage])
            .attach(cors)
            .launch();
    }
}