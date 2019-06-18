# Install docker opendht:

1. Build docker image:
```bash
docker build -t volentix/node .
```

2. Run new node:
```bash
docker run -d --name volentixnode -p 8100:8100 -p 4222:4222/udp volentix/node
```

3. You can get node info via curl:
```bash
curl http://localhost:8100
```
