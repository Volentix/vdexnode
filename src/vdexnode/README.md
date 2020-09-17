# Volentix network

[![standard-readme compliant](https://img.shields.io/badge/standard--readme-OK-green.svg?style=flat-square)](https://github.com/RichardLitt/standard-readme)

 
## Offer

As a part of VolentixLabs R&D, you can to rent your node to the network before the launch on the main net.

Your public key will be assigned to your node and verified with your private key.
VTX rewards amount to come.
**_Disclaimer: this is a test network and the sole purpose of this network is for R&D purposes.
The network might not work as intended and you temporarily might not receive VTX at all on a certain day or until issues are resolved.
Please report if you have not received your VTX but do not expect this VTX as guaranteed._**

### Prerequisites
#### linux



- This install was tested on Bionic 18.04 (LTS)

Check your Ubuntu: `Activities -> about`


#### Docker installation
Docker software is required to simplify the vDex Node installation.
Follow the instruction below:

Just in case, it is recommended to remove old versions of docker, if they were installed earlier

```bash
sudo apt-get remove docker docker-engine docker.io containerd runc
```
```bash
sudo apt-get update
sudo apt-get install build-essential apt-transport-https ca-certificates curl gnupg-agent software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker $(whoami)
reboot # or log out and back in
```
     

Run this command to download the current stable release of Docker Compose:

```
sudo curl -L "https://github.com/docker/compose/releases/download/1.27.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
```

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
Go to the repository we will build the container from.
```bash
cd ~/vDexNode/src/vdexnode
```

### Configure the node 

Edit values for EOSKEY, BITCOIN_USER, and BITCOIN_PASS below line 30 of docker-compose.yml. 
* See below to see where these values come from. *

##### EOSIO active key
EOSKEY=Your EOSIO active key
You need to get your `active` EOS public key (The key you got from Verto app) which is associated with your EOSIO account name
If you only have your EOSIO account name, follow the instructions below:
- Go to EOS block explorer: https://eosflare.io/
- Insert EOS account name in the search field (12 characters)
- Go to permissions tab
- Copy your `active` EOS public key
<img width="1414" alt="Screen Shot 2019-08-28 at 10 12 41 AM" src="https://user-images.githubusercontent.com/2269864/63877425-77876380-c97c-11e9-88e3-cd0a43d4cca5.png">


##### Bitcoin 
  1. BITCOIN_USER=admin
  2. BITCOIN_PASS=VY4o23magpJekugpJtXA66xzOUSlm21MozwB_DR0jI8=

* You need to run the rpcauth.py against your user name to obtain BITCOIN_PASS

```bash
python3 rpcauth.py "yournewusername"
```
The output will give you: 
- BITCOIN_USER
- BITCOIN_PASS

### Build and run

```bash
docker-compose build 
```
Then, upon success: 
```bash
docker-compose up 
```

That's it!

### Node infos

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


### Update 

To update your node to a new version, Do the following:

1. Stop the current docker container
2. Delete the current docker container
3. Git pull changes
4. Compile new image
5. Start the new docker container

Follow the screenshot with an example of updating the version from `0.0.1` to `0.0.2`.
<img width="1419" alt="update" src="https://user-images.githubusercontent.com/2269864/65898339-319c3180-e366-11e9-8f9d-55efbe64772b.png">

- Command `docker ps` returns you your running containers, as you see in the list there is only one container named `vdexnode`.

  ```bash
  docker ps
  ```

- Next command `docker stop vdexnode` stops the container

  ```bash
  docker stop vdexnode
  ```

- Next command `docker rm vdexnode` removes the container

  ```bash
  docker rm vdexnode
  ```
 List images 

  ```bash
  docker images
  ```
Remove images
  ```bash
  docker rmi imageid
  ```

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
