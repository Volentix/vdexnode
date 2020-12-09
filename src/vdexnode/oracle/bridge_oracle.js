let json = require('./VTX.json');
const Web3 = require('web3');
const { Api, JsonRpc, RpcError } = require('eosjs');
const { JsSignatureProvider } = require('eosjs/dist/eosjs-jssig');
const fetch = require('node-fetch');
const { TextEncoder, TextDecoder } = require('util');
require('dotenv').config({
    path: require('find-config')('.env')
})
const {
  ETH_NODE_URL,
  ETH_TOKEN_CONTRACT,
  ETH_POOL_ADDRESS,
  EOS_TOKEN_CONTRACT,
  EOS_POOL_ACCOUNT,
  EOS_ACCOUNT,
  EOS_CUSTODIAN_ACCOUNT,
  EOS_DISTRIBUTION_ACCOUNT,
  EOS_NODE_URL,
  EOS_PRIVATE_KEY,
} = process.env

async function eth_balance() {
    // CONNECT TO WEB3 PROVIDER
    const web3Provider = new Web3.providers.HttpProvider(ETH_NODE_URL);
    const web3 = new Web3(web3Provider);
    const contract = new web3.eth.Contract(json.abi, ETH_TOKEN_CONTRACT);

    // WAIT FOR SYNC
    const isSyncing = await web3.eth.isSyncing();
    if (isSyncing) {
      console.log("Ethereum chain is syncing. ABORT")
      return
    }

    // Handler
    const eos_rpc = new JsonRpc(EOS_NODE_URL, { fetch });
    let last_eth_vtx_balance = await contract.methods.balanceOf(ETH_POOL_ADDRESS).call();
    let eth_vtx_balance = last_eth_vtx_balance
    let eos_vtx_balance = await eos_rpc.get_currency_balance(EOS_TOKEN_CONTRACT, EOS_POOL_ACCOUNT, 'VTX');
    console.log('ETH VTX balance: ', eth_vtx_balance);
    console.log('EOS VTX balance: ', eos_vtx_balance);
    console.log('Listening...');
    await sleep(3000)

    while(true) {
      try {
          // Retrieve ETH_POOL_ADDRESS VTX balance
          eth_vtx_balance = await contract.methods.balanceOf(ETH_POOL_ADDRESS).call();
          // eth_vtx_balance = new BigInt(last_eth_vtx_balance)

          console.log('ETH VTX balance: ', eth_vtx_balance);

          // update balance
          send_balance_EOS(eth_vtx_balance);
          last_eth_vtx_balance = eth_vtx_balance

          // Retrieve EOS VTX Balance
          eos_vtx_balance = await eos_rpc.get_currency_balance(EOS_TOKEN_CONTRACT, EOS_POOL_ACCOUNT, 'VTX');
          console.log('EOS VTX balance: ', eos_vtx_balance);
          await sleep(5000)
      } catch (err) {
          console.error(err);
      }
    }
    console.log('Stopping Bridge Oracle...')
}

async function send_balance_EOS(balance) {
    console.log(`SEND BALANCE "${balance}"\n`);
    try {
        const signatureProvider = new JsSignatureProvider([EOS_PRIVATE_KEY]);
        const rpc = new JsonRpc(EOS_NODE_URL, {
            fetch
        });
        const api = new Api({
            rpc,
            signatureProvider,
            textDecoder: new TextDecoder(),
            textEncoder: new TextEncoder()
        });
        const timestamp = Date.now();
        const info = await rpc.get_info();
        console.log(info.chain_id);
        const result = await api.transact({
            actions: [{
                account: EOS_CUSTODIAN_ACCOUNT,
                name: 'updtblnc',
                authorization: [{
                    actor: EOS_ACCOUNT,
                    permission: 'active',
                }],
                data: {
                    account: EOS_ACCOUNT,
                    balance: balance,
                    timestamp: timestamp,
                },
            }]
        }, {
            blocksBehind: 3,
            expireSeconds: 30,
        });
        console.dir(result);
    } catch (err) {
        console.log(err);
        return;
    }
}

function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

eth_balance();
