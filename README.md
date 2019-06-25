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


## selection criteria
1. Geolocation<br />
    We will prioritize nodes as to diversify our network geographically.
2. Computer architecture, ressources and bandwidth.
3. VTX<br />
    We will prioritize the most serious holders of VTX
### Approval
- Please send public key to marwan@volentixlabs.com 
  for approval.
  
## Install

You have two options when installing vDexNode. In one case, mostly for dev work, you may want to deploy just the container, however, if you want to run vDexNode in an operational environment, you will need to first install Vulcan. This is the cloud operating system that Volentix is building.

### Docker

**Note: only docker linux availabale for now**

Clone the repo:
```bash
git clone git@github.com:Volentix/vDexNode.git
```

Change into the docker folder:
```bash
cd vDexNode/docker
```

Build the container locally:
```bash
docker build -t volentix/node .
```

Finally, you can run the container locally:
```bash
docker run -d --name volentixnode -e "EOSKEY=InsertYourKeyHere" -p 9080:9080 -p 8100:8100 -p 4222:4222/udp volentix/node
```

### Vulcan

```bash
Note that the Vulcan install leverages a container stored in Dockerhub. The team will update the build scripts as new versions become available.
```

In order to install Vulcan, [you must follow the instructions](https://volentixvulcan.readthedocs.io/en/latest/install.html).

Once Vulcan is installed, install Vulcan. Note that the install of Vulcan will require 2 command line arguments.

1. **eos_public_address:** Your public address on EOS that will be credited.
2. **namespace:** You are able to install multiple instances of vdex on one Vulcan install, however, each instance will require its own namespace. Namespaces are named logic partisions on Vulcan. You cannot deploy multiple versions of vdex into the same namespace. If this is unclear, just use `vdex` as your namespace. Please note that namespaces CANNOT have spaces of special chars in them. For now the script is pretty bare so please be careful.

As a helper, you can use the shell script to deploy your cluster. Future, more advanced scripts will be built on Helm but for now this should get us going.

First, clone the repo:
```bash
git clone git@github.com:Volentix/vDexNode.git
```

Change into the kube directory:
```bash
cd vDexNode/kube
```

Next deploy vdex with the shell script. Note replace `YOUR_EOS_PUBLIC_ADDRESS` with your eos address. Also, replace the`YOUR_NAMESPACE` with one of your choosing:
```bash
./deploy.sh YOUR_EOS_PUBLIC_ADDRESS YOUR_NAMESPACE
```

The script will create the yaml files in a directory called deploy. It then runs the kubernetes intall commands. Note that the files are kept in case inspection is desired, however, they will be ignored by git.

## Usage

If you have installed vDex on Vulcan, you will need to run open up some ports to communicate with vDex. This is not necessary with the docker install. Note this restriction will be removed in a future release.

As above, replace the `YOUR_NAMESPACE` below with the namespace you are using. Note that it appears twice in the commands.

### Get Node Info

To the the node info, you will need to run the following if you have deployed on **Vulcan**.
```bash
k3s kubectl -n YOUR_NAMESPACE port-forward $(k3s kubectl -n YOUR_NAMESPACE get pod -l app=vdex-node -o jsonpath='{.items[0].metadata.name}') 8100:8100
```

You can then curl the instance for the nodes information:
```bash
curl http://localhost:8100
```
### Scan Nodes

To the the list of nodes, you will need to run the following if you have deployed on **Vulcan**.
```bash
k3s kubectl -n YOUR_NAMESPACE port-forward $(k3s kubectl -n YOUR_NAMESPACE get pod -l app=vdex-node -o jsonpath='{.items[0].metadata.name}') 9080:9080
```

You can then curl the instance:
```bash
curl http://localhost:9080/getConnectedNodes
```
### Kiali

If you have installed vdex on Vulcan, you can open up the Kiali dashboard to get information about the cluster. First open the port:
```bash
k3s kubectl -n istio-system port-forward $(k3s kubectl -n istio-system get pod -l app=kiali -o jsonpath='{.items[0].metadata.name}') 20001:20001
```

You can now, in the web browser of your choosing, open up the dashboard. Note that the default username and password are both `admin`.
```bash
http://localhost:20001/kiali/console/
```
## Backup Keys

You can backup node keys from docker to your local host with the following:
```bash
docker cp volentixnode:/volentix/node.key .
docker cp volentixnode:/volentix/node.crt .
```

## Maintainers

[@sylvaincormier](https://github.com/sylvaincormier)

## Contribute

See [the contribute file](.github/CONTRIBUTING.md)!

PRs accepted.

Small note: If editing the README, please conform to the [standard-readme](https://github.com/RichardLitt/standard-readme) specification.

## Acknowledgements
This project was originally based on https://github.com/jech/dht by Juliusz Chroboczek.
It is independent from another project called OpenDHT (Sean Rhea. Ph.D. Thesis, 2005), now extinct.
