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
const custodian_account = process.env.EOS_CUSTODIAN_ACCOUNT 
const distribution_account = process.env.EOS_DISTRIBUTION_ACCOUNT
var defaultPrivateKey = '5JoNVLWQ4Wq7hZRgHu6vyjbqUpU4enHPn7sMMsnwtcJEzWrhaHY'
const node_ip_address = process.env.NODE_IP_ADDRESS;





let web3;
let contract;
let check; 
let nodeos = ' http://140.82.56.143:8888 ';
var result; 

async function main(){
    eth_balance();
  }
async function eth_balance(){
    for (i =0;;i++) {
            var web3Provider = new Web3.providers.HttpProvider('http://127.0.0.1:8540');
            var web3 = new Web3(web3Provider);
            check = web3.eth.isSyncing().then(result=>{return result;}).catch(result => {});
            check = await check;
            try{
                if((check.highestBlock - check.currentBlock) > 0  || check.currentBlock == 0 || check.highestBlock == 0){
                    console.log('Openethereum not yet synced: ', check.highestBlock - check.currentBlock, ' blocks to go');  
                    console.log('Meantime, Infura')
                    // web3 = new Web3(new Web3.providers.HttpProvider("https://ropsten-rpc.linkpool.io/"));
                    web3 = new Web3("https://ropsten.infura.io/v3/c3436ae558954d85ae242a2ea517475c");
                }
                await sleep(3000);
               
                console.log(getCurrentProvider(web3));
               
                contract = new web3.eth.Contract(json.abi, eth_token_contract);
                new_vtx_balance = contract.methods.balanceOf(eth_pool_address).call((err, result) => {}); 
                new_vtx_balance = await new_vtx_balance;
                from_wei = web3.utils.fromWei(new_vtx_balance, 'ether');
                from_wei = from_wei.toString();
                from_wei = from_wei.slice(0, -6);
                new_vtx_balance = new_vtx_balance.toString();
                new_vtx_balance = new_vtx_balance.slice(0, -10);
                console.log('Raw balance sent to custodian', new_vtx_balance);
                if(new_vtx_balance > 0){
                    send_balance_EOS(new_vtx_balance);
                }
                const rpc = new JsonRpc(nodeos, { fetch });
                eos_vtx_balance = rpc.get_currency_balance(eos_pool_account, eos_pool_account, 'WVTX').then((balance) => {return balance})
                eos_vtx_balance = await eos_vtx_balance;
                console.log('ETH balance', from_wei);
                console.log('EOS balance', eos_vtx_balance);
                // if(i%10){
                // register_up(new_vtx_balance); 
                // }
        }catch(err){
            console.log('provider not available. wait........');
        }
    }
}

async function send_balance_EOS(balance){
    console.log('******************send blance*********************\n');
    var rpc;
    const response = await fetch(nodeos);
    const myJson = await response.json(); //extract JSON from the http response
    console.log('***************************************\n'); 
    console.log("Node is up", myJson);
    console.log('***************************************\n');
     
    try{
        console.count('******************send blance*********************');
        const signatureProvider = new JsSignatureProvider([defaultPrivateKey]);
        rpc = new JsonRpc(nodeos, { fetch }); 
        const api = new Api({ rpc, signatureProvider, textDecoder: new TextDecoder(), textEncoder: new TextEncoder() });
        const timestamp = Date.now(); // Unix timestamp in milliseconds
        info = await rpc.get_info();
        console.log(info.chain_id);
        (async () => {
            const result = await api.transact({
            actions: [{
                account: 'vtxcustodian',
                name: 'updtblnc',
                authorization: [{
                actor: eos_account,
                permission: 'active',
                }],
                data: {
                account: eos_account,    
                balance: balance,
                timestamp: timestamp,
                },
            }]
            }, {
            blocksBehind: 3,
            expireSeconds: 30,
            });
            console.dir(result);
        })();
        if(myJson > 0){
            console.log('*************Send up**************\n');
            var jobs = new Int32Array();
            jobs[0] = 1;
            jobs[1] = 2;
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
                        job_ids:jobs
                    },
                }]
                }, {
                blocksBehind: 3,
                expireSeconds: 30,
                });
                console.dir(result);
            })();
        }else{
            var jobs = new Int32Array();
            jobs[0] = 1;
            jobs[1] = 2;
            sleep(3000);
            (async () => {
                const result = await api.transact({
                actions: [{
                    account: 'vistribution',
                    name: 'paycore',
                    authorization: [{
                    actor: eos_account,
                    permission: 'active',
                    }],
                    data: {
                        job_ids:jobs
                    },
                }]
                }, {
                blocksBehind: 3,
                expireSeconds: 30,
                });
                console.dir(result);
            })();

        }
    }catch(err){
        console.log(err);
    }
}

function register_up(balance){
   
    var rpc;
    try{
        console.log('*****************UP*********************');
        console.log(distribution_account);
        console.log(eos_account);
        const signatureProvider = new JsSignatureProvider([defaultPrivateKey]);
        rpc = new JsonRpc(nodeos, { fetch }); 
        const api = new Api({ rpc, signatureProvider, textDecoder: new TextDecoder(), textEncoder: new TextEncoder() });
        const timestamp = Date.now(); // Unix timestamp in milliseconds
        (async () => {
            const result = await api.transact({
            actions: [{
                account: distribution_account,
                name: 'uptime',
                authorization: [{
                actor: eos_account,
                permission: 'active',
                }],
                data: {
                account: eos_account,    
                test: ''
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
    }
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


