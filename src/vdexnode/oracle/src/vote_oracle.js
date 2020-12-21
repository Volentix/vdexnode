const { Api, JsonRpc } = require('eosjs')
const { JsSignatureProvider } = require('eosjs/dist/eosjs-jssig')
const fetch = require('node-fetch')
const { TextEncoder, TextDecoder } = require('util')
require('dotenv').config({ path: require('find-config')('.env') })
const {
  EOS_NODE_URL,
  EOS_ACCOUNT,
  EOS_ACCOUNT_PK,
  EOS_DISTRIBUTION_ACCOUNT,
  NODE_INFO_URL,
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
      )
  }, 3000)
}

async function update_voting_info_EOS() {
  const response = await fetch(NODE_INFO_URL)
  const dht = await response.json()
  console.log('***************************************\n')
  console.log("Node is up", dht)
  console.log('***************************************\n')
  console.log(dht.id)
  console.log('SENDING VOTE INFO...\n')
  const signatureProvider = new JsSignatureProvider([EOS_ACCOUNT_PK])
  const rpc = new JsonRpc(EOS_NODE_URL, { fetch })
  const api = new Api({ rpc, signatureProvider, textDecoder: new TextDecoder(), textEncoder: new TextEncoder() })
  const info = await rpc.get_info()
  console.log(`Chain id: ${info.chain_id}`)
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
          node_id: EOS_ACCOUNT,
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
