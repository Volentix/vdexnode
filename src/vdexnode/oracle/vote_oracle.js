let json = require('./VTX.json');
const Web3 = require('web3');
const { Api, JsonRpc, RpcError } = require('eosjs');
const { JsSignatureProvider } = require('eosjs/dist/eosjs-jssig'); 
const fetch = require('node-fetch');                                    
const { TextEncoder, TextDecoder } = require('util');  
const { mainModule } = require('process');
var Accounts = require('web3-eth-accounts');
const Eth = require('web3-eth');
require('dotenv').config({ path: require('find-config')('.env')})
const eth_token_contract = process.env.ETH_TOKEN_CONTRACT; 
const eth_pool_address =  process.env.ETH_POOL_ADDRESS;  
const eos_token_contract = process.env.EOS_TOKEN_CONTRACT 
const eos_pool_account = process.env.EOS_POOL_ACCOUNT 
const eos_account = process.env.EOS_ACCOUNT 
const custodian_account = process.env.CUSTODIAN_ACCOUNT 
const distribution_account = process.env.EOS_DISTRIBUTION_ACCOUNT
var defaultPrivateKey = '5JoNVLWQ4Wq7hZRgHu6vyjbqUpU4enHPn7sMMsnwtcJEzWrhaHY'
const node_ip_address = process.env.NODE_IP_ADDRESS;

let web3;
let contract;
let check; 
let nodeos = 'http://127.0.0.1:8888';
var result; 

async function main(){
  
    eth_balance();
  }
async function eth_balance(){
    for (i =0;;i++) {
           
            try{
                
                await sleep(3000);
               
                
               
                    send_balance_EOS(new_vtx_balance);
               
              
        }catch(err){
            console.log('provider not available. wait........');
        }
    }
}

async function send_balance_EOS(balance){
    var rpc;
    const response = await fetch("http://127.0.0.1:8000");
    const dht = await response.json(); //extract JSON from the http response
    console.log('***************************************\n'); 
    console.log("Node is up", dht);
    console.log('***************************************\n');
    console.count('******************uptime*********************');
    const signatureProvider = new JsSignatureProvider([defaultPrivateKey]);
    rpc = new JsonRpc(nodeos, { fetch }); 
    const api = new Api({ rpc, signatureProvider, textDecoder: new TextDecoder(), textEncoder: new TextEncoder() });
    const timestamp = Date.now(); // Unix timestamp in milliseconds
    info = await rpc.get_info();
    console.log(info.chain_id);
    console.log('*************UPTIME**************\n');
    var jobs = new Int32Array();
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
}



function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

function getCurrentProvider(web3) {
  if (!web3) return 'unknown';

  if (web3.currentProvider.isMetaMask)
      return 'metamask';

  if (web3.currentProvider.isTrust)
      return 'trust';

  if (web3.currentProvider.isGoWallet)
      return 'goWallet';

  if (web3.currentProvider.isAlphaWallet)
      return 'alphaWallet';

  if (web3.currentProvider.isStatus)
      return 'status';

  if (web3.currentProvider.isToshi)
      return 'coinbase';

  if (typeof __CIPHER__ !== 'undefined')
      return 'cipher';

  if (web3.currentProvider.constructor.name === 'EthereumProvider')
      return 'mist';

  if (web3.currentProvider.constructor.name === 'Web3FrameProvider')
      return 'parity';

  if (web3.currentProvider.host && web3.currentProvider.host.indexOf('infura') !== -1)
      return 'infura';

  if (web3.currentProvider.host && web3.currentProvider.host.indexOf('localhost') !== -1)
      return 'localhost';

  return 'unknown';
}


main();


