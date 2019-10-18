
#[derive(Serialize, Deserialize)]
pub struct EosNode {
    pub id: String,
    pub ips: Vec<String>,
    pub key: String,
}