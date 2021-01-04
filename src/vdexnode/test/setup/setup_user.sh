# install ubuntu 18.04
# install docker
# - https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-18-04
# Install eos
#  - wget https://github.com/EOSIO/eos/releases/download/v2.0.7/eosio_2.0.7-1-ubuntu-18.04_amd64.deb \
#  - apt install -y ./eosio_2.0.7-1-ubuntu-18.04_amd64.deb \
# install cdt
#  - wget https://github.com/eosio/eosio.cdt/releases/download/v1.7.0/eosio.cdt_1.7.0-1-ubuntu-18.04_amd64.deb
#  - sudo apt install ./eosio.cdt_1.7.0-1-ubuntu-18.04_amd64.deb
# apt-get update && apt-get install -y  git wget nodejs npm python3.8
# make sure ports are open for eos:8888, eth:, vdexnode:8000   
# cd ~/
# git clone git@github.com:Volentix/vdexnode.github
# git checkout vltxnode
# mainnet turn off network
# keosd conf should be set to permanent unlock for tests
# edit ~/eosio-wallet/config.ini 
#  cleos create key --to-console
#  save keys and wallet on veracrypt usb keys
#  cleos wallet create -n <PRODUCER_ACCOUNT_NAME>
#  cleos wallet import -n <PRODUCER_ACCOUNT_NAME> --private-key  <PRODUCER_PRIVATE_KEY>
#unlock-timeout = 9000000
#  erase your history ~/.bash_history && clear previous console output
#  cleos --url  http://140.82.56.143:8888 create account  eosio <PRODUCER_ACCOUNT_NAME> <PRODUCER_PUBLIC_KEY>
#  mainnet turn on network
#  cd vdexnode/src/vdexnode/test/biosboot
#  cp -r node_template <PRODUCER_ACCOUNT_NAME>
#  edit start.sh 
#    - signature-provider  <PRODUCER_PUBLIC_KEY>=KEY:<PRODUCER_PRIVATE_KEY>
#    - http-server-address <PRODUCER_EXTERNAL_IP> 
#    - p2p-listen-endpoint <PRODUCER_EXTERNAL_IP>
#  cd ../../     
#  edit docker-compose.yml file
#    - EOSKEY=<PRODUCER_EOS_KEY>
#docker network create --driver=bridge --subnet=172.20.0.0/24 vdexnode_volentix
#Bring up vdexnode
#docker stop $(docker ps -a -q)
#docker rm -f $(docker ps -a -q)
#docker rmi -f $(docker images -a -q)
#cd ../vDexNode && docker build . -t volentix/vdexnode
#docker network create --driver=bridge --subnet=172.20.0.0/24 vdexnode_volentix
#cd ../ && docker-compose up -d > /dev/pts/0& 
#sudo docker network inspect bridge
#Make sure vdex is running
# ID=$(curl -s http://127.0.0.1:8000/ | jq '.id')
# if [ -z "$ID" ]; then killall nodeos; fi
# if [ -z "$ID" ]; then docker-compose down; fi
# if [ -z "$ID" ]; then exit 1; fi
# #sleep 3
# IP=$(curl -s http://127.0.0.1:8000/ | jq '.ips')
# #echo "$IP"
# sleep 3
# EOS_KEY=$(curl -s http://127.0.0.1:8000/ | jq '.key')
# #sleep 3
# NODE_KEY=$(curl -s http://127.0.0.1:8000/ | jq '.public_key')
