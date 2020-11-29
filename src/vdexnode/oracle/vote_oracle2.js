const { Api, JsonRpc, RpcError } = require('eosjs');
const { JsSignatureProvider } = require('eosjs/dist/eosjs-jssig'); 
const fetch = require('node-fetch');                                    
const { TextEncoder, TextDecoder } = require('util');  
const { mainModule } = require('process');
var Accounts = require('web3-eth-accounts');
require('dotenv').config({ path: require('find-config')('.env')})
const eos_token_contract = process.env.EOS_TOKEN_CONTRACT 
const eos_pool_account = process.env.EOS_POOL_ACCOUNT 
const eos_account = process.env.EOS_ACCOUNT 
const distribution_account = process.env.EOS_DISTRIBUTION_ACCOUNT
var defaultPrivateKey = '5JoNVLWQ4Wq7hZRgHu6vyjbqUpU4enHPn7sMMsnwtcJEzWrhaHY'
const node_ip_address = process.env.NODE_IP_ADDRESS;


let nodeos = 'http://140.82.56.143:8888';

async function main(){
    uptime();
  }
async function uptime(){
    for (i =0;;i++) {
        try{
                await sleep(3000);
                update_voting_info_EOS();
        }catch(err){
            console.log('provider not available. wait........');
        }
    }
}

async function update_voting_info_EOS(){
    var rpc;
    const response = await fetch("http://127.0.0.1:8000");
    const dht = await response.json();
    console.log('***************************************\n'); 
    console.log("Node is up", dht);
    console.log('***************************************\n');
    console.log(dht.id);
    console.log('SEND VOTE INFO\n');
    try{
        const signatureProvider = new JsSignatureProvider([defaultPrivateKey]);
        rpc = new JsonRpc(nodeos, { fetch }); 
        const api = new Api({ rpc, signatureProvider, textDecoder: new TextDecoder(), textEncoder: new TextEncoder() });
        const timestamp = Date.now(); // Unix timestamp in milliseconds
        info = await rpc.get_info();
        console.log(info.chain_id);
        (async () => {
            const result = await api.transact({
            actions: [{
                account: 'vistribution',
                name: 'uptime',
                authorization: [{
                actor: eos_account,
                permission: 'active',
                }],
                data: {
                    account: eos_account,    
                    node_id:"11111111",
                    memo:"hey"
                },
            }]
            }, {
            blocksBehind: 3,
            expireSeconds: 30,
            });
            console.dir(result);
        })();
    }catch(err){
        console.log(err);
        return;
    }
}

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

main();


