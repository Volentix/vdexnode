# Install docker volentix node:

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
docker cp volentixnode:/volentix/node.key .
docker cp volentixnode:/volentix/node.crt .
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