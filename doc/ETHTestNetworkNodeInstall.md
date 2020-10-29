# Volentix node install instructions

## Requirements

	2TB SSD
	32GB RAM*
	recent CPU* 
	open ports tcp/8888, tcp-udp/9010, tcp-udp/9011, tcp-udp/9012
## Download vdexnode

`git clone https://github.com/Volentix/vdexnode.git`

## Install OpenEthereum

https://openethereum.github.io/wiki/Setup

## Configure ETH test network node

This is a Ethereum network created by the vdexnodes for testing purposes

### *You can use the Volentix Ethereum test network*

*This network undergo frequent restarts for testing purposes* 
```
	cd ~/vdexnode/src/vdexnode/test/eth_test_network/
```
```
openethereum account new --config node1.toml
```
Take the address obtained and insert it in node1.toml

```
[parity]
chain = "demo-spec.json"
base_path = "/tmp/parity1"
[network]
port = 30301
[rpc]
port = 8541
apis = ["web3", "eth", "net", "personal", "parity", "parity_set", "traces", "rpc", "parity_accounts"]
[websockets]
port = 8451
[ipc]
disable = true
[account]
password = ["node.pwds"]
[mining]
engine_signer = "<Insert address here>"
reseal_on_txs = "none"
```
Then start your node.
```
openethereum --config node1.toml
```
Take the output of this command:
```
curl --data '{"jsonrpc":"2.0","method":"parity_enode","params":[],"id":0}' -H "Content-Type: application/json" -X POST localhost:8540
```
Replace the "enode://RESULT" in the following command.
```
curl --data '{"jsonrpc":"2.0","method":"parity_addReservedPeer","params":["enode://RESULT"],"id":0}' -H "Content-Type: application/json" -X POST localhost:8540
```

Now the nodes should indicate #-of-peers/25 peers in the console, which means they are connected to each other.
