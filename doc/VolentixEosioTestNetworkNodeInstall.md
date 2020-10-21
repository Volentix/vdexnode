# Volentix node install instructions

## Requirements

	2TB SSD
	32GB RAM*
	recent CPU* 
	open ports tcp/8888, tcp-udp/9010, tcp-udp/9011, tcp-udp/9012
## Download vdexnode

`git clone https://github.com/Volentix/vdexnode.git`

## Install EOSIO

https://developers.eos.io/manuals/eos/latest/install/install-prebuilt-binaries

## Configure EOSIO test network node

This is a EOSIO network created by the vdexnodes for testing purposes

### *You can join the Volentix EOSIO test network*

*Although we will try to minimize the effects, this network will temporarily undergo frequent maintenance, expect restarts* 

create a public/private keypair:

`cleos create keys`

create a wallet and insert the keys:

`cleos wallet create -n <account_name> --to-console`

Save the password. 

Insert the private key in your wallet:

`cleos wallet import -n <account_name>`

Only one set of keys is needed for this account

`cd vdexnode/src/vdexnode/test/`

`cp eosio.wallet /root/eosio-wallet`

Select an account name and:

`cp -r node_template <VDEX_NODE_OPERATOR_ACCOUNT_NAME>

Unlock the eosio wallet:

`cd <VDEX_NODE_OPERATOR_ACCOUNT_NAME>`

`sh unlock.sh`

Create your account

`cleos --url http://140.82.56.143:8888 create account eosio <VDEX_NODE_OPERATOR_ACCOUNT_NAME><EOSIO_TEST_NODE_PRODUCER_PUBLIC_KEY> <EOSIO_TEST_NODE_PRODUCER_PUBLIC_KEY> -p eosio@active`

(same pub key twice)

edit start.sh replacing the values in brackets <> with your own:

```
#!/bin/bash
DATADIR="./blockchain"
CURDIRNAME=${PWD##*/}

if [ ! -d $DATADIR ]; then
  mkdir -p $DATADIR;
fi

nodeos \
--genesis-json $DATADIR"/../../genesis.json" \
--signature-provider <EOSIO_TEST_NODE_PRODUCER_PUBLIC_KEY>=KEY:<EOSIO_TEST_NODE_PRODUCER_PRIVATE_KEY> \
--plugin eosio::producer_plugin \
--plugin eosio::producer_api_plugin \
--plugin eosio::chain_plugin \
--plugin eosio::chain_api_plugin \
--plugin eosio::http_plugin \
--plugin eosio::history_api_plugin \
--plugin eosio::history_plugin \
--data-dir $DATADIR"/data" \
--blocks-dir $DATADIR"/blocks" \
--config-dir $DATADIR"/config" \
--producer-name $CURDIRNAME \
--http-server-address <EOSIO_TEST_NODE_PRODUCER_PUBLIC_IP>:8888 \
--p2p-listen-endpoint <EOSIO_TEST_NODE_PRODUCER_PUBLIC_IP>:9010 \
--access-control-allow-origin=* \
--contracts-console \
--http-validate-host=false \
--verbose-http-errors \
--enable-stale-production \
#genesis node or other
--p2p-peer-address 140.82.56.143:9010 \
#--p2p-peer-address localhost:9012 \
#--p2p-peer-address localhost:9013 \
>> $DATADIR"/nodeos.log" 2>&1 & \
echo $! > $DATADIR"/eosd.pid"

```

Then start your node:

sh start.sh

To stop your node do Ctrl-c or:

`sudo killall node`

before you restart the node you must do:

`rm -rf biosboot//blockchain/`<VDEX_NODE_OPERATOR_ACCOUNT_NAME>



