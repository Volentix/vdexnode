use crate::handler::Handler;
use rocket::State;
use rocket_contrib::json::Json;
use std::sync::{ Arc, Mutex };
use std::collections::HashMap;


#[get("/getConnectedNodes", format="json")]
fn connected_nodes(handler: State<Arc<Mutex<Handler>>>) -> Json<HashMap<String, String>> {
    let mut handler = handler.lock().unwrap();
    let mut connected_nodes = handler.get_connected_nodes();
    connected_nodes.insert("Result".to_string(), "Success".to_string());
    Json(connected_nodes)
}

#[get("/getNodesLocation", format="json")]
fn nodes_location(handler: State<Arc<Mutex<Handler>>>) -> Json<HashMap<String, Vec<String>>> {
    let mut handler = handler.lock().unwrap();
    let nodes_location = handler.get_nodes_location();
    Json(nodes_location)
}

pub struct Server;

impl Server {
    pub fn run(handler: Arc<Mutex<Handler>>) {
        rocket::ignite()
            .manage(handler)
            .mount("/", routes![nodes_location, connected_nodes])
            .launch();
    }
}