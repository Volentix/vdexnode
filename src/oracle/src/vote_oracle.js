const { Api, JsonRpc, RpcError } = require('eosjs')
const { JsSignatureProvider } = require('eosjs/dist/eosjs-jssig')
const fetch = require('node-fetch')
const { TextEncoder, TextDecoder } = require('util')
require('dotenv').config({ path: require('find-config')('.env') })
const {
  EOS_NODE_URL,
  EOS_ACCOUNT,
  EOS_ACCOUNT_PK,
  EOS_DISTRIBUTION_ACCOUNT,
} = process.env

async function main() {
  // Execute update_voting_info_EOS every 3 seconds
  setTimeout(() => {
    update_voting_info_EOS()
      .then(
        (result) => { // Success callback
          console.dir(result)
          main()
        },
        (error) => { // Error callback
          if ('json' in error) {
            console.error(JSON.stringify(error.json, null, 2))
          } else {
            console.error(error)
          }
          main()
        },
        () => main(), // Success callback
        (error) => { // Error callback
          console.error(error)
          main()
        }
      )
  }, 3000)
}

async function update_voting_info_EOS() {
  const response = await fetch("http://127.0.0.1:8000");
  const dht = await response.json();
  console.log('***************************************\n')
  console.log("Node is up", dht)
  console.log('***************************************\n')
  console.log(dht.id)
  console.log('SEND VOTE INFO\n')
  const signatureProvider = new JsSignatureProvider([EOS_ACCOUNT_PK])
  const rpc = new JsonRpc(EOS_NODE_URL, { fetch })
  const api = new Api({ rpc, signatureProvider, textDecoder: new TextDecoder(), textEncoder: new TextEncoder() })
  const data = {
    account: EOS_ACCOUNT,
    node_id: EOS_ACCOUNT,
    memo: "hey",
  }
  console.log(`Chain id: ${info.chain_id}`)
  console.log(`DATA: ${JSON.stringify(data, null, 2)}`)
  return await api.transact({
    actions: [
      {
        account: EOS_DISTRIBUTION_ACCOUNT,
        name: 'uptime',
        authorization: [
          {
            actor: EOS_ACCOUNT,
            permission: 'active',
          },
        ],
        data: {
          account: EOS_ACCOUNT,
          node_id: "11111111",
          memo: "hey",
        },
      },
    ],
  }, {
    blocksBehind: 3,
    expireSeconds: 30,
  })
}

main()
