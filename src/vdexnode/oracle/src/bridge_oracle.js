let json = require('./VTX.json')
const Web3 = require('web3')
const { Api, JsonRpc, RpcError } = require('eosjs')
const { JsSignatureProvider } = require('eosjs/dist/eosjs-jssig')
const fetch = require('node-fetch')
const { TextEncoder, TextDecoder } = require('util')
require('dotenv').config({
  path: require('find-config')('.env'),
})
const {
  ETH_NODE_URL,
  ETH_TOKEN_CONTRACT,
  ETH_POOL_ADDRESS,
  EOS_TOKEN_CONTRACT,
  EOS_POOL_ACCOUNT,
  EOS_NODE_URL,
  EOS_ACCOUNT,
  EOS_ACCOUNT_PK,
  EOS_CUSTODIAN_ACCOUNT,
} = process.env

async function main() {
  // CONNECT TO WEB3 PROVIDER
  const web3Provider = new Web3.providers.HttpProvider(ETH_NODE_URL)
  const web3 = new Web3(web3Provider)
  const contract = new web3.eth.Contract(json.abi, ETH_TOKEN_CONTRACT)

  // Checks if ethereum node is syncing
  const isSyncing = await web3.eth.isSyncing()
  if (isSyncing) {
    console.log("Ethereum chain is syncing. ABORT")
    return
  }

  // Setup EOS RPC
  const eos_rpc = new JsonRpc(EOS_NODE_URL, { fetch })

  // Updates EOS balance
  async function update_balance() {
    // Retrieve ETH_POOL_ADDRESS VTX balance
    let eth_vtx_balance = await contract.methods.balanceOf(ETH_POOL_ADDRESS).call()
    console.log('ETH VTX balance: ', eth_vtx_balance)

    // Retrieve EOS VTX Balance
    let eos_vtx_balance = await eos_rpc.get_currency_balance(EOS_TOKEN_CONTRACT, EOS_POOL_ACCOUNT, 'VTX')
    console.log('EOS VTX balance: ', eos_vtx_balance)

    // Update balance
    await send_balance_EOS(eth_vtx_balance)
  }

  // Execute update_balance every 3 seconds
  function callback() {
    setTimeout(() => {
      update_balance()
        .then(callback, (error) => {
          if ('json' in error) {
            console.error(JSON.stringify(error.json, null, 2))
          } else {
            console.error(error)
          }
          callback()
        })
    }, 3000)
  }
  callback()
  console.log('Listening...')
}

async function send_balance_EOS(balance) {
  console.log(`SEND BALANCE "${balance}"\n`)
  const signatureProvider = new JsSignatureProvider([EOS_ACCOUNT_PK])
  const rpc = new JsonRpc(EOS_NODE_URL, {
    fetch,
  })
  const api = new Api({
    rpc,
    signatureProvider,
    textDecoder: new TextDecoder(),
    textEncoder: new TextEncoder(),
  })
  const timestamp = Date.now()
  const info = await rpc.get_info()
  console.log(`CHAIN_ID: ${info.chain_id}`)
  const data = {
    account: EOS_ACCOUNT,
    balance: balance,
    timestamp,
  }
  console.log(`data: "${JSON.stringify(data)}"\n`)
  const result = await api.transact({
    actions: [
      {
        account: EOS_CUSTODIAN_ACCOUNT,
        name: 'updtblnc',
        authorization: [
          {
            actor: EOS_ACCOUNT,
            permission: 'active',
          },
        ],
        data,
      },
    ],
  }, {
    blocksBehind: 3,
    expireSeconds: 30,
  })
  console.dir(result)
}

main()
