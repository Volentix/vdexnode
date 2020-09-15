#!/bin/bash -e

set -o errexit      # make your script exit when a command fails.
set -o nounset      # exit when your script tries to use undeclared variables.

case "$1" in
  nodeos)
    exec /usr/bin/nodeos --config /eosio/config.ini --data-dir /eosio/data --genesis-json /eosio/genesis.json --disable-replay-opts
    ;;
  keosd)
    exec /usr/bin/keosd  --wallet-dir /eosio/wallet  --http-server-address 8901
    ;;
  *)
    exec "$@"
esac