# vdexnetwork

[![standard-readme compliant](https://img.shields.io/badge/standard--readme-OK-green.svg?style=flat-square)](https://github.com/RichardLitt/standard-readme)

> Nodes of the VDEx network

vDexNode provides:

- Distributed in-memory data store 


## Table of Contents

- [offer](#offer)
- [conditions](#conditions)
- [install](#install)
- [usage](#usage)
- [API](#api)
- [Maintainers](#maintainers)
- [Contribute](#contribute)
- [License](#license)



## Offer
As a part of VolentixLabs R&D, 
you can to rent your node to the 
network before the launch on the main net.
Your public key will be assigned to your node and verified with your private key.
VTX rewards will be set for: <br />
    -  First come first serve to the 1st 21 nodes @ ~10 VTX/day TBD<br />
    -  Sebsequent 21 to 50 nodes @ ~5 VTX/day TBD<br />
Start of this offer: TBD(soon).

### Conditions

1. Your machine is always on without interruptions.<br />
2. Logs are on.<br />
3. Update mechanism is working.<br />
4. You have staked enough vtx.<br />
5. You have an EOS account for your public key

## selection criteria
1. Geolocation<br />
    We will prioritize nodes as to diversify our network geographically.
2. Computer architecture, ressources and bandwidth.
3. VTX<br />
    We will prioritize the most serious holders of VTX
### Approval
- Please send public key to marwan@volentixlabs.com 
  for approval or for EOS account.
  
### Install

Check your install is 18.0.3 LTS

* sudo apt-get update
* sudo apt-get upgrade
* sudo apt-get install git build-essential
* sudo apt-get update

* sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
* curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
* sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
* sudo apt-get update
* sudo apt-get install docker-ce docker-ce-cli containerd.io
* sudo usermod -aG docker $(whoami)
* reboot
* docker pull volentixlabs/vdexnode:0.0.1
* EOS block explorer: https://eosflare.io/
* Insert EOS account name (12 characters)
* Copy active key
* Insert in following command:<br />
docker run -d --name vdexnode -e "IP=95.216.0.79" -e "EOSKEY=Your public key" -p 9080:9080 -p 8100:8100 -p 4222:4222/udp volentixlabs/vdexnode:0.0.1
* curl http://localhost:9080/getConnectedNodes




## Maintainers

[@sylvaincormier](https://github.com/sylvaincormier)

## Contribute

See [the contribute file](.github/CONTRIBUTING.md)!

PRs accepted.

Small note: If editing the README, please conform to the [standard-readme](https://github.com/RichardLitt/standard-readme) specification.

## Acknowledgements
This project was originally based on https://github.com/jech/dht by Juliusz Chroboczek.
It is independent from another project called OpenDHT (Sean Rhea. Ph.D. Thesis, 2005), now extinct.
