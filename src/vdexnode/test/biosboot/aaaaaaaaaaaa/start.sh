#!/bin/bash
DATADIR="./blockchain"
CURDIRNAME=${PWD##*/}

if [ ! -d $DATADIR ]; then
  mkdir -p $DATADIR;
fi

nodeos \
--genesis-json $DATADIR"/../../genesis.json" \
--signature-provider  EOS4zQoD6NYPy6udZW5TknisqsYjBG3kfzUC3mKA1ztvktVXPCKa5=KEY:5JFWGy3XmX1DpV1GzLrxd5xi7XJaQc11VAZ5pHcW1D9oAobWiX2 \
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
--http-server-address 199.247.30.155:8888 \
--p2p-listen-endpoint 199.247.30.155:9010 \
--access-control-allow-origin=* \
--contracts-console \
--http-validate-host=false \
--verbose-http-errors \
--enable-stale-production \
--p2p-peer-address 140.82.56.143:9010 \
#--p2p-peer-address localhost:9012 \
#--p2p-peer-address localhost:9013 \
>> $DATADIR"/nodeos.log" 2>&1 & \
echo $! > $DATADIR"/eosd.pid"
