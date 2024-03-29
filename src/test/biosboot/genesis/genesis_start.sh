#!/bin/bash
DATADIR="./blockchain"

if [ ! -d $DATADIR ]; then
  mkdir -p $DATADIR;
fi

nodeos \
--genesis-json $DATADIR"/../../genesis.json" \
--signature-provider  EOS8UrDjUkeVxfUzUS1hZQtmaGkdWbGLExyzKF6569kRMR5TzSnQT=KEY:5JDCvBSasZRiyHXCkGNQC7EXdTNjima4MXKoYCbs9asRiNvDukc=KEY:5JDCvBSasZRiyHXCkGNQC7EXdTNjima4MXKoYCbs9asRiNvDukc \
--plugin eosio::producer_plugin \
--plugin eosio::producer_api_plugin \
--plugin eosio::chain_plugin \
--plugin eosio::chain_api_plugin \
--plugin eosio::http_plugin \
--plugin eosio::net_plugin \
--plugin eosio::history_api_plugin \
--plugin eosio::history_plugin \
--data-dir $DATADIR"/data" \
--blocks-dir $DATADIR"/blocks" \
--config-dir $DATADIR"/config" \
--producer-name eosio \
--http-server-address 140.82.56.143:8888 \
--p2p-listen-endpoint 140.82.56.143:9010 \
--access-control-allow-origin=* \
--contracts-console \
--http-validate-host=false \
--verbose-http-errors \
--enable-stale-production \
--p2p-peer-address 45.77.137.183:9010 \
#--p2p-peer-address localhost:9012 \
#--p2p-peer-address localhost:9013 \
--delete-all-blocks& 
#2> /dev/pts/2& 
#>> $DATADIR"/nodeos.log" 2>&1 & \
# echo $! > $DATADIR"/eosd.pid"
