# Volentix network

[![standard-readme compliant](https://img.shields.io/badge/standard--readme-OK-green.svg?style=flat-square)](https://github.com/RichardLitt/standard-readme)

vdexmainpool 800MM VTX
Supporting the VDex network’s infrastructure and the capacity to back transactions.
*All subsidies are reduced by 21% every 21MM seconds (243.06 days)

## VDex Nodes

1. Voting Node
    - stake >= 10.00000000 VTX
    - votes for core network and/or for proposals for the volentixtrez
    - signs transactions

    #### Subsidy:
    - 66 VTX/day for running the bridging oracle
    - 10 VTX/day for voting
    

2. VDex Node

    - stake >= 10.00000000 VTX 
    - Superset of the voting node, sign transactions and receive vDex Node subsidies
    - Core 21 signing network 

    #### Subsidy:
    - 66 VTX/day of uptime
    - 10 VTX/vote
    - *% of transactions processed (in VTX)
    - 210 VTX/21MM seconds (24.31 days)
    
3. VDex Node Pro
    
    - stake >= 10.00000000 VTX 
    - Sign transactions and receive vDex Node subsidies
    - Must provide ssh connection to dev team 
    - Meets the minimum hardware and bandwidth requirements { 2T SSD, 32GBRAM, High speed internet } 
    - Guaranteed continuous uptime 
    - Core 8 bridging oracle network
    
    #### Subsidy:
     - 300 VTX/day of uptime
     - 10 VTX/vote
     - *% of transactions signed (in VTX)
     - 2,100 VTX/21MM seconds (24.31 days)


**_Disclaimer: this is a test network and the sole purpose of this network is for R&D purposes.
The network might not work as intended and you temporarily might not receive VTX at all on a certain day or until issues are resolved.
Please report if you have not received your VTX but do not expect this VTX as guaranteed._**

## Get the code

Copy paste the following command in terminal to get the vDex Node docker image:
Go to your home directory.
```bash
cd ~/
```
Clone the repository.
```bash
git clone https://github.com/Volentix/vDexNode.git
```

The node system development is undergoing the finals steps in integration of the bridging oracle, voting and rewards.
For status pleas erefer to this document:
[Test Plan](https://github.com/Volentix/vdexnode/blob/master/doc/test_plan.md)


## How to debug

You can attach a terminal to your vdexnode by running `docker exec -ti vdexnode bash`

Then, you can use `bitcoin-cli` directly if you want: `bitcoin-cli -rpcuser="YOUR_USERNAME" -rpcpassword="YOUR_PASSWORD" -rpcport=18443 -rpcconnect="bitcoin" getnewaddress`.


### Support

If you need any help, write to our telegram support channel: https://t.me/volentixnodesupport

## Maintainers

[@sylvaincormier](https://github.com/sylvaincormier)

## Contribute

See [the contribute file](.github/CONTRIBUTING.md)!

PRs accepted.

Small note: If editing the README, please conform to the [standard-readme](https://github.com/RichardLitt/standard-readme) specification.

## Acknowledgements

This project was originally based on https://github.com/jech/dht by Juliusz Chroboczek.
It is independent from another project called OpenDHT (Sean Rhea. Ph.D. Thesis, 2005), now extinct.

## License

- [License file](LICENSE)
- [Copying file](COPYING)
- [Security file](SECURITY.md)
- [Code of conduct](CODE_OF_CONDUCT.md)
