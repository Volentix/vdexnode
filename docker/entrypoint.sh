if test -f "/volentix/node.key"; then
    echo "Node keys present";
else
    echo "First start, generate key for node";
    openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 -nodes -keyout /volentix/node.key -out /volentix/node.crt -subj /CN=example.com
fi;

api --network 1 --certificate /volentix/node.crt --privkey /volentix/node.key --bootstrap ${IP}:4222 --eoskey ${EOSKEY} > /api/log.txt