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

    optboot=""
    if [ ! -z ${IP+x} ]
    then
      optboot="--bootstrap ${IP}:4222"
    fi

    optbtcuser=""
    if [ ! -z ${BITCOIN_USER+x} ]
    then
      optbtcuser="--bitcoin-user ${BITCOIN_USER}"
    fi

    optbtcpass=""
    if [ ! -z ${BITCOIN_PASS+x} ]
    then
      optbtcpass="--bitcoin-password ${BITCOIN_PASS}"
    fi

    optbtcedp=""
    if [ ! -z ${BITCOIN_ENDPOINT+x} ]
    then
      optbtcedp="--bitcoin-connect ${BITCOIN_ENDPOINT}"
    fi

    optbtcport=""
    if [ ! -z ${BITCOIN_PORT+x} ]
    then
      optbtcport="--bitcoin-port ${BITCOIN_PORT}"
    fi

    api \
        --certificate /volentix/node.crt \
        --privkey /volentix/node.key \
        ${optboot} \
        ${optbtcuser} \
        ${optbtcpass} \
        ${optbtcedp} \
        ${optbtcport} \
        --eoskey ${EOSKEY} | tee log.txt
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