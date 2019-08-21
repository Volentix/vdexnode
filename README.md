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
    -  First come first serve to the 1st 21 nodes @ ~8 VTX/day TBD<br />
    -  Sebsequent 22 to 42 nodes @ 3 VTX/day TBD<br />



## selection criteria
1. Geolocation
2. Your machine is always on without interruptions.
3. You have an EOS account for your public key 
4. 10000 VTX + 
5. Computer architecture, ressources and bandwidth.
     

  
### Install

Check your install is Ubuntu Bionic Beaver 18.04.3 LTS: Activities->about

Copy paste the following commands in terminal one by one:

* sudo apt-get update
* sudo apt-get upgrade
* sudo apt-get install git build-essential apt-transport-https ca-certificates curl gnupg-agent software-properties-common
* curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
* sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
* sudo apt-get update
* sudo apt-get install docker-ce docker-ce-cli containerd.io
* sudo usermod -aG docker $(whoami)

* reboot

Copy paste the following command in terminal:
* docker pull volentixlabs/vdexnode:0.0.1

Retreive your EOS public key(the key you got from Verto) from your account name:<br />

If you only have your account name:

* EOS block explorer: https://eosflare.io/
* Insert EOS account name (12 characters)
* Go to permissions
* Copy public key


Copy paste the following command in terminal:
* docker run -d --name vdexnode -e "IP=95.216.0.79" -e "EOSKEY=Your public key" -p 9080:9080 -p 8100:8100 -p 4222:4222/udp volentixlabs/vdexnode:0.0.1
<br />

---END OF INSTALL---

To check running nodes on the network:
* curl http://localhost:9080/getConnectedNodes

### Support
Telegram: https://t.me/volentixnodesupport


## Maintainers

[@sylvaincormier](https://github.com/sylvaincormier)

## Contribute

See [the contribute file](.github/CONTRIBUTING.md)!

PRs accepted.

Small note: If editing the README, please conform to the [standard-readme](https://github.com/RichardLitt/standard-readme) specification.

## Acknowledgements
This project was originally based on https://github.com/jech/dht by Juliusz Chroboczek.
It is independent from another project called OpenDHT (Sean Rhea. Ph.D. Thesis, 2005), now extinct.
