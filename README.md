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



## offer
As a part of VolentixLabs R&D, 
you can to rent your node to the 
network before the launch on the main net.
Your public key will be assigned to your node.
VTX rewards will be set for: <br />
    -  First come first serve to the 1st 21 nodes @ 10 VTX/day <br />
    -  Sebsequent 21 to 50 nodes @ 5 VTX/day <br />
Offer ends Sept 1 2019

## conditions

1. Your machine is always on and available on needed ports.<br />
2. Logs are on.<br />
3. Update mechanism is working.<br />
4. You have staked enough vtx.<br />

## approval
- Please send key to marwan@volentixlabs.com 
  for approval.
  
## install
**Mac**
1. install brew
2. brew install git gnutls msgpack
3. git clone git@github.com:Volentix/vDexNetwork.git

**linux**
1. sudo apt install git libncurses5-dev libreadline-dev nettle-dev libgnutls28-dev 
    <br />libargon2-0-dev libmsgpack-dev
    <br />librestbed-dev libjsoncpp-dev
2. sudo apt-get install cython3 python3-dev python3-setuptools<br />
3. git clone git@github.com:Volentix/vDexNetwork.git<br />


## usage:WIP

### docker
1. cd vDexNetwork
2. make 

### bare-metal
1. cd vDexNetwork/vDexNode/tools
2. ./dhtnode


## API:WIP



## Maintainers

[@sylvaincormier](https://github.com/sylvaincormier)

## Contribute

See [the contribute file](.github/CONTRIBUTING.md)!

PRs accepted.

Small note: If editing the README, please conform to the [standard-readme](https://github.com/RichardLitt/standard-readme) specification.

## License

MIT © 2019 Volentix

Copyright (C) 2014-2019 Savoir-faire Linux Inc.

OpenDHT is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

See COPYING or https://www.gnu.org/licenses/gpl-3.0.en.html for the full GPLv3 license.


## Acknowledgements
This project was originally based on https://github.com/jech/dht by Juliusz Chroboczek.
It is independent from another project called OpenDHT (Sean Rhea. Ph.D. Thesis, 2005), now extinct.
