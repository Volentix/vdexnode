use crate::handler::Handler;
use rocket::State;
use rocket_contrib::json::Json;
use std::sync::{ Arc, Mutex };
use std::collections::HashMap;
use std::str::FromStr;


#[get("/getConnectedNodes")]
fn connected_nodes(handler: State<Arc<Mutex<Handler>>>) -> Json<HashMap<String, String>> {
    let mut handler = handler.lock().unwrap();
    let mut connected_nodes = handler.get_connected_nodes();
    connected_nodes.insert("Result".to_string(), "Success".to_string());
    Json(connected_nodes)
}

#[get("/getNodesLocation")]
fn nodes_location(handler: State<Arc<Mutex<Handler>>>) -> Json<HashMap<String, Vec<String>>> {
    let mut handler = handler.lock().unwrap();
    let nodes_location = handler.get_nodes_location();
    Json(nodes_location)
}

pub struct Server;

impl Server {
    pub fn run(handler: Arc<Mutex<Handler>>) {
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

        rocket::ignite()
            .manage(handler)
            .mount("/", routes![nodes_location, connected_nodes])
            .attach(cors)
            .launch();
    }
}