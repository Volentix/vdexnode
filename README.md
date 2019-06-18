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


## conditions

1. Your machine is always on without interruptions.<br />
2. Logs are on.<br />
3. Update mechanism is working.<br />
4. You have staked enough vtx.<br />

## approval
- Please send key to marwan@volentixlabs.com 
  for approval.
  
## install

**only docker linux availabale for now**
1. sudo apt-get install docker git
2. git clone git@github.com:Volentix/vDexNode.git
3. cd docker
4. docker build -t volentix/node .


## usage

docker run -d --name volentixnode -p 8100:8100 -p 4222:4222/udp volentix/node



## API
docker exec -it volentixnode /usr/bin/dhtscanner -b 127.0.0.1 -p 60999 | grep 'Node' | grep -v ':60999' | awk '{print $2}'



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
