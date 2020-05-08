#!/bin/bash -e

set -o errexit      # make your script exit when a command fails.
set -o nounset      # exit when your script tries to use undeclared variables.

/usr/bin/nodeos --config /eosio/config.ini --data-dir /eosio/data --genesis-json /eosio/genesis.json --disable-replay-opts $@
