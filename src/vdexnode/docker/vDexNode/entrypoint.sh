#!/bin/bash -e

set -o errexit      # make your script exit when a command fails.
set -o nounset      # exit when your script tries to use undeclared variables.

case "$1" in
  server)
    if test -f "/volentix/node.key"; then
        echo "Node keys present";
    else
        echo "First start, generate key for node";
        openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 -nodes -keyout /volentix/node.key -out /volentix/node.crt -subj /CN=example.com
    fi;

    api --network 1 \
        --certificate /volentix/node.crt \
        --privkey /volentix/node.key \
        --bootstrap ${IP}:4222 \
        --bitcoin-user ${BITCOIN_USER} \
        --bitcoin-password ${BITCOIN_PASS} \
        --bitcoin-connect ${BITCOIN_ENDPOINT} \
        --bitcoin-port ${BITCOIN_PORT} \
        --eoskey ${EOSKEY} > /log.txt
    ;;
  key_gen)
    generate_key $2 $3;
    ;;
  sign)
    sign $2 $3 "'$4'";
    ;;
  *)
    exec "$@"
esac