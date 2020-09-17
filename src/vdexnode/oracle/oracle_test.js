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
const defaultPrivateKey = '5KkddYRe4VJdp5E5m8oiZiJuzGD6F2CVR5zcv8C2hbsCv5sZ9ZS'
const node_ip_address = process.env.NODE_IP_ADDRESS;

// let web1;
// let web2;
// let web3;
let contract;
let check; 
// let url = 'http://' + node_ip_address + ':8545'; 

async function main(){
    eth_balance();
  }
async function eth_balance(){
    for (i =0;;i++) {
            var web3Provider1 = new Web3.providers.HttpProvider('https://ropsten.infura.io/v3/c3436ae558954d85ae242a2ea517475c');
            var web3Provider2 = new Web3.providers.HttpProvider('https://ropsten-rpc.linkpool.io/');
            var web3Provider3 = new Web3.providers.HttpProvider('http://openethereum:8545');
            var web1 = new Web3(web3Provider1);
            var web2 = new Web3(web3Provider2);
            var web3 = new Web3(web3Provider3);
            

            // check = web3.eth.isSyncing().then(result=>{return result;}).catch(result => {});
            // check = await check;
            // try{
            //     if((check.highestBlock - check.currentBlock) > 0  || check.currentBlock == 0 || check.highestBlock == 0){
            //         console.log('Openethereum not yet synced: ', check.highestBlock - check.currentBlock, ' blocks to go');  
            //         console.log('Meantime, Chainlink')
            //         // web3 = new Web3(new Web3.providers.HttpProvider("https://ropsten-rpc.linkpool.io/"));
            //         web3 = new Web3("https://ropsten.infura.io/v3/c3436ae558954d85ae242a2ea517475c");
            //     }
                await sleep(3000);
                // console.log('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                // console.log(getCurrentProvider(web1));
                // console.log('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                // console.log('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                // console.log(getCurrentProvider(web2));
                // console.log('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                // console.log('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                // console.log(getCurrentProvider(web3));
                
                contract1 = new web1.eth.Contract(json.abi, eth_token_contract);
                contract2 = new web2.eth.Contract(json.abi, eth_token_contract);
                contract3 = new web1.eth.Contract(json.abi, eth_token_contract);
                new_vtx_balance1 = contract1.methods.balanceOf(eth_pool_address).call((err, result) => {}); 
                new_vtx_balance2 = contract2.methods.balanceOf(eth_pool_address).call((err, result) => {}); 
                new_vtx_balance3 = contract3.methods.balanceOf(eth_pool_address).call((err, result) => {}); 
                new_vtx_balance1 = await new_vtx_balance1;
                new_vtx_balance2 = await new_vtx_balance2;
                new_vtx_balance3 = await new_vtx_balance3;
                console.log('Raw balance Infura', new_vtx_balance1);
                console.log('Raw balance Chainlink', new_vtx_balance2);
                console.log('Raw balance Openethereum', new_vtx_balance3);
                // from_wei = web3.utils.fromWei(new_vtx_balance, 'ether');
                // from_wei = from_wei.toString();
                // from_wei = from_wei.slice(0, -6);
                // new_vtx_balance = new_vtx_balance.toString();
                // new_vtx_balance = new_vtx_balance.slice(0, -10);
                // console.log('Raw balance sent to custodian', new_vtx_balance1);
                // from_wei = web3.utils.fromWei(new_vtx_balance2, 'ether');
                // from_wei = from_wei.toString();
                // from_wei = from_wei.slice(0, -6);
                // new_vtx_balance2 = new_vtx_balance2.toString();
                // new_vtx_balance2 = new_vtx_balance2.slice(0, -10);
                
            //     if(new_vtx_balance > 0){
            //         send_balance_EOS(new_vtx_balance);
            //         var txDetail = await eos.getTransaction(req.params.txid);
            //         console.log(txDetail.trx.receipt.status)
                    
            //     }
            //     const rpc = new JsonRpc('https://jungle2.cryptolions.io:443', { fetch });
            //     eos_vtx_balance = rpc.get_currency_balance(eos_pool_account, eos_pool_account, 'WVTX').then((balance) => {return balance})
            //     eos_vtx_balance = await eos_vtx_balance;
            //     console.log('ETH balance', from_wei);
            //     console.log('EOS balance', eos_vtx_balance);
        // }catch(err){
        //     console.log('provider not available. wait........');
        // }
    }
}

function send_balance_EOS(balance){
    var rpc;
    try{
        const signatureProvider = new JsSignatureProvider([defaultPrivateKey]);
        rpc = new JsonRpc('https://jungle2.cryptolions.io:443', { fetch }); 
        const api = new Api({ rpc, signatureProvider, textDecoder: new TextDecoder(), textEncoder: new TextEncoder() });
        const timestamp = Date.now(); // Unix timestamp in milliseconds
        (async () => {
            result = await api.transact({
            actions: [{
                account: custodian_account,
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
        console.log(result);
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


