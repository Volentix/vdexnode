
# vdexnetwork

[![standard-readme compliant](https://img.shields.io/badge/standard--readme-OK-green.svg?style=flat-square)](https://github.com/RichardLitt/standard-readme)

> Nodes of the VDEx network

vDexNode provides:

- Distributed in-memory data store


## Table of Contents
- [Offer](#offer)
- [Conditions](#selection-criteria)
- [Install](#install)
- [Maintainers](#maintainers)
- [Contribute](#contribute)
- [License](#license)



## Offer
As a part of VolentixLabs R&D, you can to rent your node to the network before the launch on the main net.

Your public key will be assigned to your node and verified with your private key.
VTX rewards will be set for:
   - 1st 21 nodes @ ~8 VTX/day 
   - 22 to 42 nodes @ 3 VTX/day 

***Disclaimer: this is a test network and the sole purpose of this network is for R&D purposes. 
The network might not work as intended and you temporarily might not receive VTX at all on a certain day or until issues are resolved.
Please report if you have not received your VTX but do not expect this VTX as guaranteed.*** 


## Selection criteria
1. Geolocation (No residents or servers from the United States)
2. Your machine is always on without interruptions.
3. You have an EOS account for your public key
4. 10000+ VTX on the balance
5. Computer architecture, ressources and bandwidth.

## Install
### Prerequisites
You will find detailed instructions on configuring a server for a vDexNode [here](DEPLOYING.md).

Docker software is required to simplify the vDex Node installation.
You need the 64-bit version of one of these Ubuntu versions to install the Docker software:
-   Bionic 18.04 (LTS)

Check your Ubuntu: `Activities -> about`

Just in case, it is recommended to remove old versions of docker, if they were installed earlier
```bash
sudo apt-get remove docker docker-engine docker.io containerd runc
```


### Docker installation
Follow the instruction below:
```bash
sudo apt-get update
sudo apt-get install build-essential apt-transport-https ca-certificates curl gnupg-agent software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker $(whoami)
reboot # or log out and back in
```

### Docker container
Copy paste the following command in terminal to get the vDex Node docker image:
```bash
docker pull volentix/vdexnode:0.0.2
```

Now you need to get you `active` EOS public key (The key you got from Verto app) which is associated with your EOS account name

If you only have your EOS account name, follow the instructions below:

* Go to EOS block explorer: https://eosflare.io/
* Insert EOS account name in the search field (12 characters)
* Go to permissions tab
* Copy your `active` EOS public key

<img width="1414" alt="Screen Shot 2019-08-28 at 10 12 41 AM" src="https://user-images.githubusercontent.com/2269864/63877425-77876380-c97c-11e9-88e3-cd0a43d4cca5.png">

To run the Docker container copy paste the following command in terminal:

Don't forget to replace the `Your public key` with your real `active` EOS public key before executing the command.
```bash
docker run -d --name vdexnode -e "IP=95.216.0.79" -e "EOSKEY=Your public key" -p 9080:9080 -p 8100:8100 -p 4222:4222/udp volentix/vdexnode:0.0.2
```
That's it!

To check running nodes on the network copy paste the command below into your terminal:
```bash
curl http://localhost:9080/getConnectedNodes
```
The output will look something like this:
<img width="1254" alt="Screen_Shot_2019-08-28_at_10_21_20_AM" src="https://user-images.githubusercontent.com/2269864/63878270-1f516100-c97e-11e9-8c53-5b18fac324cb.png">

But you can try the command below that will make the output prettier and make sure that your `active` EOS public key appears in the list:
```bash
curl http://localhost:9080/getConnectedNodes | json_pp
```
<img width="753" alt="Screen_Shot_2019-08-28_at_10_21_47_AM" src="https://user-images.githubusercontent.com/2269864/63878247-0f398180-c97e-11e9-8623-e072beb6a083.png">

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
* [License file](LICENSE)
* [Copying file](COPYING)
* [Security file](SECURITY.md)
* [Code of conduct](CODE_OF_CONDUCT.md)
