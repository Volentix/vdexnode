# Volentix network

[![standard-readme compliant](https://img.shields.io/badge/standard--readme-OK-green.svg?style=flat-square)](https://github.com/RichardLitt/standard-readme)

 
## Offer

As a part of VolentixLabs R&D, you can to rent your node to the network before the launch on the main net.

Your public key will be assigned to your node and verified with your private key.
VTX rewards amount to come.
**_Disclaimer: this is a test network and the sole purpose of this network is for R&D purposes.
The network might not work as intended and you temporarily might not receive VTX at all on a certain day or until issues are resolved.
Please report if you have not received your VTX but do not expect this VTX as guaranteed._**

### Get the node

Copy paste the following command in terminal to get the vDex Node docker image:
Go to your home directory.
```bash
cd ~/
```
Clone the repository.
```bash
git clone https://github.com/Volentix/vDexNode.git
```
Choose one of these directories and follow the instructions in the README.

```bash
cd ~/vDexNode/src/vdexnode
```
```bash
cd ~/vDexNode/Kubernetes
```
```bash
cd ~/vDexNode/Ansible
```

### General node usage

#### Current node

```
curl http://localhost:8000/
{"id":"231411ce831c009918e3fd5234762ec7f4b15541","ips":["200.200.54.96:0"],"key":"YOUR_KEY","public_key":"b248b1f7463ce657ab30989d3c77545f710e5535"}
```

Retrieve infos on the current node.

#### Connected nodes

```
curl http://localhost:8000/getConnectedNodes
{"Result":"Success","id":"EOSKEY"}
```

#### Connected ips

```
curl http://localhost:8000/getConnectedIPs
{"Result":"Success","ip":"EOSKEY"}
```

#### Nodes Locations

```
curl http://localhost:8000/getNodesLocation
{"c77ae2f9c593f3ea87ee1888702020e470f642f8":["CITY","LOCATION"],"1e3170ed060fb14793f3fb66e731f7658c6e5b7f":["New York City","40.7143,-74.0060"]}
```

#### Nodes Locations

```
curl http://localhost:8000/GetCountryIp?ip=x.x.x.x
{"Country":"..."}
```

### Chat

Once online, a vDexNode has some endpoints to chat with others

#### Stream a room

```
curl http://localhost:8000/room/foo/ --output -
{"author":"9dd80917572616db28af1237b6c69e9f0960d41f","body":"Hello World","encrypted":false}
{"author":"9dd80917572616db28af1237b6c69e9f0960d41f","body":"Encrypted hello world","encrypted":true}
```

Note: for now, Rocket only accepts to transmit a buffer when this buffer is full. So, for now, the output is a binary output filled with 0x00

#### Send a message to a room

```
curl http://localhost:8000/room/foo/ -X POST -d "{\"message\":\"Hello World\"}" -H 'Content-Type: application/json'
```

Where `foo` is the chat room.

#### Send a message to a specific user

```
curl http://localhost:8000/room/foo/9dd80917572616db28af1237b6c69e9f0960d41f -X POST -d "{\"message\":\"Encrypted hello world\"}" -H 'Content-Type: application/json'
```

Where `foo` is the chat room and `9dd80917572616db28af1237b6c69e9f0960d41f` the public key id. You can know this key via `curl http://localhost:8000` under `public_key`

### Bitcoin

#### Get new address

```
curl http://localhost:8000/bitcoin/getnewaddress
{"address":"2N5oLT38VEg1BkAjSPEwTtwsVAjmfFNgTzw"}
```

#### Get balance

```
curl http://localhost:8000/bitcoin/getbalance
{"balance":"0.00000000"}
```

#### Dump priv key

```
curl http://localhost:8000/bitcoin/dumpprivkey/2MwxGvpPi1x9cAYu3kGgDNQiKzxZa9WtfA2                                   
{"privkey":"cQysVU1NuBoJ6SDuYmGu8aaXrbnyDmJZEamU6m4cMsbmD56X82JZ"}
```

#### Add multi sig address

```
curl http://localhost:8000/bitcoin/addmultisigaddress/ -X POST -d "{\"n\":2,\"keys\":[\"04A97B658C114D77DC5F71736AB78FBE408CE632ED1478D7EAA106EEF67C55D58A91C6449DE4858FAF11721E85FE09EC850C6578432EB4BE9A69C76232AC593C3B\",\"04019EF04A316792F0ECBE5AB1718C833C3964DEE3626CFABE19D97745DBCAA5198919081B456E8EEEA5898AFA0E36D5C17AB693A80D728721128ED8C5F38CDBA0\"]}" -H 'Content-Type: application/json'
{"address":"2My2rR6eYesBQB7MP4ooH2kdUXjFM1Mfa9T","redeemScript":"524104a97b658c114d77dc5f71736ab78fbe408ce632ed1478d7eaa106eef67c55d58a91c6449de4858faf11721e85fe09ec850c6578432eb4be9a69c76232ac593c3b4104019ef04a316792f0ecbe5ab1718c833c3964dee3626cfabe19d97745dbcaa5198919081b456e8eeea5898afa0e36d5c17ab693a80d728721128ed8c5f38cdba052ae"}
```

### Create multi sig

```
curl http://localhost:8000/bitcoin/createmultisig/ -X POST -d "{\"n\":2,\"keys\":[\"04A97B658C114D77DC5F71736AB78FBE408CE632ED1478D7EAA106EEF67C55D58A91C6449DE4858FAF11721E85FE09EC850C6578432EB4BE9A69C76232AC593C3B\",\"04019EF04A316792F0ECBE5AB1718C833C3964DEE3626CFABE19D97745DBCAA5198919081B456E8EEEA5898AFA0E36D5C17AB693A80D728721128ED8C5F38CDBA0\"]}" -H 'Content-Type: application/json' 
{"redeemScript":"524104a97b658c114d77dc5f71736ab78fbe408ce632ed1478d7eaa106eef67c55d58a91c6449de4858faf11721e85fe09ec850c6578432eb4be9a69c76232ac593c3b4104019ef04a316792f0ecbe5ab1718c833c3964dee3626cfabe19d97745dbcaa5198919081b456e8eeea5898afa0e36d5c17ab693a80d728721128ed8c5f38cdba052ae","address":"2My2rR6eYesBQB7MP4ooH2kdUXjFM1Mfa9T"}%
```

## How to debug

You can attach a terminal to your vdexnode by running `docker exec -ti vdexnode bash`

Then, you can use `bitcoin-cli` directly if you want: `bitcoin-cli -rpcuser="YOUR_USERNAME" -rpcpassword="YOUR_PASSWORD" -rpcport=18443 -rpcconnect="bitcoin" getnewaddress`.


### Support

If you need any help, write to our telegram support channel: https://t.me/volentixnodesupport

## Maintainers

[@sylvaincormier](https://github.com/sylvaincormier)

## Contribute

See [the contribute file](.github/CONTRIBUTING.md)!

PRs accepted.

Small note: If editing the README, please conform to the [standard-readme](https://github.com/RichardLitt/standard-readme) specification.

## Acknowledgements

This project was originally based on https://github.com/jech/dht by Juliusz Chroboczek.
It is independent from another project called OpenDHT (Sean Rhea. Ph.D. Thesis, 2005), now extinct.

## License

- [License file](LICENSE)
- [Copying file](COPYING)
- [Security file](SECURITY.md)
- [Code of conduct](CODE_OF_CONDUCT.md)
