# Install docker vdex node:

To run the node in for development purposes, you can do it without docker containers. Follow the following instruction

1. Build docker image:

```bash
make build
```

2. Run new node:

```bash
IP="InsertYouBootstrapIP" EOSKEY="InsertYourKeyHere" make run-server
```

3. You can get node info via curl:

```bash
curl http://localhost:8000
```

4. You can scan nodes and keys:

```bash
curl http://localhost:8000/getConnectedNodes
```

5. You can backup node keys from docker to local host:

```bash
docker cp vdexnode:/volentix/node.key .
docker cp vdexnode:/volentix/node.crt .
```

6. Run in separate terminals

```bash
make client=tester1 run-key_gen
make client=tester2 run-key_gen
```

to generate keys for parties. Keys will appear in `client_data` directory.

7. Run in separate terminals

```bash
make client=tester1 msg="test message" run-sign
make client=tester2 msg="test message" run-sign
```

to sign test message. The same message should be used by all signers.
Once t+1 parties join the protocol will run and will output to screen signatue (R,s)

# Chat

Once online, a vDexNode has some endpoints to chat with others

## Stream a room

```
curl http://localhost:8000/room/foo/ --output -
{"author":"9dd80917572616db28af1237b6c69e9f0960d41f","body":"Hello World","encrypted":false}
{"author":"9dd80917572616db28af1237b6c69e9f0960d41f","body":"Encrypted hello world","encrypted":true}
```

Note: for now, Rocket only accepts to transmit a buffer when this buffer is full. So, for now, the output is a binary output filled with 0x00

## Send a message to a room

```
curl http://localhost:8000/room/foo/ -X POST -d "{\"message\":\"Hello World\"}" -H 'Content-Type: application/json'
```

Where `foo` is the chat room.

## Send a message to a specific user

```
curl http://localhost:8000/room/foo/9dd80917572616db28af1237b6c69e9f0960d41f -X POST -d "{\"message\":\"Encrypted hello world\"}" -H 'Content-Type: application/json'
```

Where `foo` is the chat room and `9dd80917572616db28af1237b6c69e9f0960d41f` the public key id. You can know this key via `curl http://localhost:8000` under `public_key`
