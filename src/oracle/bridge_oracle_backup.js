//ETH_NODE_URL=http://localhost:8540
//ETH_TOKEN_CONTRACT=0xf5B719378261d911a788E1498fCE36308EB9caff
//ETH_POOL_ADDRESS=0x7d5592066fae5cc14a62477eeb5074036610415c
//EOS_TOKEN_CONTRACT=volentixtsys
//EOS_POOL_ACCOUNT=volentixsale
//EOS_ACCOUNT=v11111111111
//CUSTODIAN_ACCOUNT=vtxcustodian
//EOS_DISTRIBUTION_ACCOUNT=vistribution
//
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
let nodeos = 'http://140.82.56.143:8888/';
var result; 

async function main(){
    eth_balance();
  }
//1985099999687
//curl --data '{"method":"eth_sendTransaction","params":[{"from": "0xf5B719378261d911a788E1498fCE36308EB9caff","to": "0x7d5592066fae5cc14a62477eeb5074036610415c","gas": "0x76c0","gasPrice": "0x9184e72a000","value":"0x1ce312e29c7"}],"id":1,"jsonrpc":"2.0"}' -H "Content-Type: application/json" -X POST localhost:8540
async function eth_balance(){
    for (i =0;;i++) {
            var web3Provider = new Web3.providers.HttpProvider('http://localhost:8540');
	    var web3 = new Web3(web3Provider);
	    //check = web3.eth.isSyncing().then(result=>{return result;}).catch(result => {});
	    //check = await check;
            try{
                //if((check.highestBlock - check.currentBlock) > 0  || check.currentBlock == 0 || check.highestBlock == 0){
			//    console.log('Openethereum not yet synced: ', check.highestBlock - check.currentBlock, ' blocks to go');  
		//console.log('Meantime, Infura')
                    // web3 = new Web3(new Web3.providers.HttpProvider("https://ropsten-rpc.linkpool.io/"));
                   // web3 = new Web3("https://ropsten.infura.io/v3/c3436ae558954d85ae242a2ea517475c");
               // }
                await sleep(3000);
               
		 //console.log(getCurrentProvider(web3));
                contract = new web3.eth.Contract(json.abi, eth_token_contract);
                //console.log(contract);
		    //"0x03b5164e62a6f9e8fac070aa29beea7832874b84","0x1957ce2d67aeeefd47fbaea5bc37faa7a0a537a8","0x511bfda122bfff8df03bcfa6fca082e341f06ee6","0xaffaad98e93d3c73d1b196f1c7ce5e55fc00d2f4"]
		new_vtx_balance = contract.methods.balanceOf(eth_pool_address).call((err, result) => {}); 
		//balance1 = contract.methods.balanceOf("0x03b5164e62a6f9e8fac070aa29beea7832874b84").call((err, result) => {}); 
		balance2 = contract.methods.balanceOf("0x1957ce2d67aeeefd47fbaea5bc37faa7a0a537a8").call((err, result) => {}); 
		balance3 = contract.methods.balanceOf("0x7d5592066fae5cc14a62477eeb5074036610415c").call((err, result) => {}); 
		//balance3 = contract.methods.balanceOf("0x511bfda122bfff8df03bcfa6fca082e341f06ee6").call((err, result) => {}); 
	//	balance3 = contract.methods.balanceOf("0xf5B719378261d911a788E1498fCE36308EB9caff").call((err, result) => {}); 
          //      console.log(await balance1);
                console.log(await balance2);
                console.log(await balance3);
            //    console.log(await balance3);
              //  console.log(await balance4);
		new_vtx_balance = await new_vtx_balance;
                from_wei = web3.utils.fromWei(new_vtx_balance, 'ether');
                from_wei = from_wei.toString();
                from_wei = from_wei.slice(0, -6);
                new_vtx_balance = new_vtx_balance.toString();
                new_vtx_balance = new_vtx_balance.slice(0, -10);
                console.log('Raw balance sent to custodian', new_vtx_balance);
                if(new_vtx_balance > 0){
                    //send_balance_EOS(new_vtx_balance);
                }
                const rpc = new JsonRpc(nodeos, { fetch });
                eos_vtx_balance = rpc.get_currency_balance(eos_pool_account, eos_pool_account, 'VTX').then((balance) => {return balance})
                eos_vtx_balance = await eos_vtx_balance;
                console.log('ETH balance', from_wei);
                console.log('EOS balance', eos_vtx_balance);
        }catch(err){
            console.log('provider not available. wait........');
        }
    }
}

async function send_balance_EOS(balance){
    console.log('SEND BALANCE\n');
    var rpc; 
    try{
       
        const signatureProvider = new JsSignatureProvider([defaultPrivateKey]);
	//rpc = new JsonRpc(nodeos, { fetch }); 
        
	const rpc = new JsonRpc('http://140.82.56.143:8888', { fetch });
	const api = new Api({ rpc, signatureProvider, textDecoder: new TextDecoder(), textEncoder: new TextEncoder() });
        const timestamp = Date.now(); 
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
    }catch(err){
        console.log(err);
        return;
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


