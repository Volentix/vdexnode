#!/bin/bash
DATADIR="./blockchain"
CURDIRNAME=${PWD##*/}

if [ ! -d $DATADIR ]; then
  mkdir -p $DATADIR;
fi
#Private key: 5JU3EK9LQoJpHctzaMJ6NBMdZari3uE7kAN9VqRDS9ryFRc4TMh
#Public key: EOS5g6mXhM4UesmKm4XDwmJYiz4A2tXAUQMpp3VWYkTAWad6G9c78
nodeos \
--genesis-json $DATADIR"/../../genesis.json" \
--signature-provider EOS5g6mXhM4UesmKm4XDwmJYiz4A2tXAUQMpp3VWYkTAWad6G9c78=KEY:5JU3EK9LQoJpHctzaMJ6NBMdZari3uE7kAN9VqRDS9ryFRc4TMh \
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
--http-server-address 45.77.137.183:8888 \
--p2p-listen-endpoint 45.77.137.183:9010 \
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
