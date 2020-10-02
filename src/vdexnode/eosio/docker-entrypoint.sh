#!/bin/bash -e

set -o errexit      # make your script exit when a command fails.
set -o nounset      # exit when your script tries to use undeclared variables.

case "$1" in
  nodeos)
exec /usr/bin/nodeos -e -p eosio --private-key '["EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV", "5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3"]' --config /eosio/config.ini --data-dir /eosio/data --genesis-json /eosio/genesis.json --disable-replay-opts --delete-all-blocks 
    ;;
  keosd)
    # exec /usr/bin/keosd  --wallet-dir /eosio/wallet  --http-server-address 8901
    echo 'test'
    ;;
  *)
    exec "$@"
esac
