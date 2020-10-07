# apt-get update && apt-get install -y  git wget nodejs npm 
#eosio_2.0.7-1-ubuntu-16.04_amd64
#wget https://github.com/EOSIO/eos/releases/download/v2.0.7/eosio_2.0.7-1-ubuntu-18.04_amd64.deb \
#apt install -y ./eosio_2.0.7-1-ubuntu-18.04_amd64.deb \
#rm ./eosio_2.0.7-1-ubuntu-18.04_amd64.deb \
#rm -rf /var/lib/apt/lists/*
# apt install -y software-properties-common 
# set -o errexit      # make your script exit when a command fails.
# set -o nounset      # exit when your script tries to use undeclared variables.
# apt update 
# apt install -y python3.8 
# cp -r /home/vltxnode/test/eosio-wallet  /root  
killall nodeos
killall keosd
docker-compose down
docker stop $(docker ps -a -q)
docker rm -f $(docker ps -a -q)
# docker rmi -f $(docker images -a -q)
python3 ../scripts/unlock_wallets.py
cd ../vDexNode && docker build . -t volentix/vdexnode
cd ../ && docker-compose up -d&
nodeos -e -p eosio --disable-replay-opts --delete-all-blocks --contracts-console  --verbose-http-errors >/dev/null 2>/dev/null&
sleep 4
ID=$(curl -s http://127.0.0.1:8000/ | jq '.id')
if [ -z "$ID" ]; then killall nodeos; fi
if [ -z "$ID" ]; then docker-compose down; fi
if [ -z "$ID" ]; then exit 1; fi
sleep 3
IP=$(curl -s http://127.0.0.1:8000/ | jq '.ips')
echo "$IP"
sleep 3
EOS_KEY=$(curl -s http://127.0.0.1:8000/ | jq '.key')
sleep 3
NODE_KEY=$(curl -s http://127.0.0.1:8000/ | jq '.public_key')
echo "|____________________________________________________________________________________________________________________________________________|"

cleos wallet list 
echo " _____________________________________________________________________________________________________________________________________________"
echo "|____________________________________________________________________________________________________________________________________________|"
cleos create account  eosio v11111111111 EOS8EhYUFqg6aBBJBGQ6YHDaGgpwKvmN6f2xugvHMFAZJpUAkAdap EOS6p2vZXiRpzz7FKhMtxFpKVKNZfnNb27coTJgSUZE4KzeSDdoCZ
cleos create account  eosio v22222222222 EOS5CJHrUAfrgHqiqcKTQmTwo88B5i8GCw9mzrGke9Tg2aPWjUND4 EOS5ygr9wmVQbUmQBCLMebHx5hCkjs1vLEnUzYVp6nDiTFvP2uVfM
cleos create account  eosio v33333333333 EOS6t3dBU3n1EQEZpdARxQNYbwAhDxSiQSgyRc5xPHKnRABxmiHVz EOS5EYGEkiKUXRQ21eCcKgjv1uhtyVsx88njnR6urPYHGEZbkKmk1 
cleos create account  eosio v44444444444 EOS85jnmqLxunEyQNchBTdZqexGyJgipEkDaPE51Tjd7PA8cmhchr EOS5YG6aKxwPnNoA66kvDkEeARD3BNAGHcMBiGPr4jnuNd5559qEZ
cleos create account  eosio v55555555555 EOS8batxa7sSJrSdX1oPnpjZZZFBoG82ehihwMExkWSGdfUfac3nQ EOS7eiGxgLog6d9tD7KpZULvwz5fvUMj11ZrSoAGkHUo11ZNBje5w
cleos create account  eosio x11111111111 EOS7hDytPxrDD4ZPfn86DPUKDeNp8fnHKvSx8VvYH7adzfvXKwGqD EOS725Agx1tsXH3QfHXRbMkixhGxzcN45byRnrSXtrtZvJ3qBvTSi
cleos create account  eosio x22222222222 EOS8i4CkKfkYAo5pnP7BEYnf2ZFQEemYjCxGnqLgjmoZc9uw8xfW2 EOS6jqNf5cwjauaU6gzaM3RvhrdDzQ3Uub8mA2phDEsdRMNPUaTDD 
cleos create account  eosio x33333333333 EOS7at2brDFGf5miZeF8XHjFb78tETcfeCXyB78A2sCQeoDZiZj3U EOS8JE83j8xwCV6ks1xPWGYJLgYBVaPbkXcJkvsaYgJCiTubBUxNQ
cleos create account  eosio volentixvote EOS8hhR7YSY7EkYoeiWjj4ea3jsyFWXdDdCgYsXJEXfHRf4ftF5a9 EOS8Qw3NxLPmNKtbskEyAPHvJLFv7qJ21EqVcvRebrA36z6WWjHir
cleos create account  eosio vistribution EOS8chNCZjo58Xa77uectUrND6AKNNsGFsY47xFLUXNryZqQ4Ect5 EOS5LSp5V1cbHgWmZoUHyKibG8xwmpyKZinyfpjVpQujHw3ZWrB9q
cleos create account  eosio volentixtsys EOS78pFtmUPnyshkTuDgsDC7UpVWfmDuJr3WMrSKtbEk9ajHknPGL EOS7Rk7gd2bNRyU3yFUPYX3eSsmgCqSKo4FXcWpgotDjKHqJ84ERD
cleos create account  eosio volentixsale EOS8UDRf4xaFz7qRXTnSE8W5AeVDHcAHe5iMwozTJTLEqSuz6ca6z EOS7WB1Aiw45csnC5HdpzUSLtLsVmnugpbeBUM6E9Yj2LdXB95orz
cleos create account  eosio volentixwvtx EOS66pRhPmw3nxMU7Xc3uAF2XVg5VqyNCyXi19EUk8Zo6E7X3NrcU EOS8g7iLbA3sLC5Ltr6zYaa9ULJYppn5csPNCp8x84u73XNpjDSST
cleos create account  eosio vtxcustodian EOS7PZNPBFKcLdsRc4MqhU59atQ6tbdnxJiUahZ7TFuJk3RGELHkK EOS5qzuqCSuLqGpnXGWaaSzPr7wvcbXRZPkp7EPs95M8AfcNALWkQ
cleos create account  eosio volentixstak EOS8RxnWpo8rMJRALZed4krEHLKwC9h4fbSBeM5PF3YgW5xxd64kP EOS62LpFVm6KucNfGDxpybQanjN51ga7WUxHthKAuAvHEQDyneBfp
# cleos create account  eosio vltxstakenow EOS6c9WQnuT2WT6sPhZqRnqEVZSbf1kCKarpCo6eZpfMG5Z2dtm2R EOS8UDRf4xaFz7qRXTnSE8W5AeVDHcAHe5iMwozTJTLEqSuz6ca6z
echo "|____________________________________________________________________________________________________________________________________________|"
eosio-cpp -o ../tokens/volentixgsys/volentixgsys.wasm ../tokens/volentixgsys/volentixgsys.cpp --abigen
eosio-cpp -o ../contracts/volentixstak/volentixstak.wasm ../contracts/volentixstak/volentixstak.cpp --abigen
eosio-cpp -I ../contracts/volentixstak/volentixstak.hpp -o ../contracts/vtxcustodian/vltxcstdn.wasm ../contracts/vtxcustodian/vltxcstdn.cpp --abigen
eosio-cpp -I ../contracts/volentixstak/volentixstak.hpp -o ../contracts/vdexdposvote/vdexdposvote.wasm ../contracts/vdexdposvote/vdexdposvote.cpp --abigen
echo "|____________________________________________________________________________________________________________________________________________|"
cleos set contract volentixtsys ../tokens/volentixgsys/ volentixgsys.wasm volentixgsys.abi -p volentixtsys@active
cleos set contract volentixstak ../contracts/volentixstak/ volentixstak.wasm volentixstak.abi -p volentixstak@active
cleos set contract vtxcustodian ../contracts/vtxcustodian/ vltxcstdn.wasm vltxcstdn.abi -p vtxcustodian@active
cleos set contract vistribution ../contracts/vtxdistribut/ vtxdistribut.wasm vtxdistribut.abi -p vistribution@active
cleos set contract volentixvote ../contracts/vdexdposvote/ vdexdposvote.wasm vdexdposvote.abi -p volentixvote@active
echo "|____________________________________________________________________________________________________________________________________________|"
cleos set account permission volentixstak active volentixstak --add-code
cleos set account permission volentixtsys active volentixtsys --add-code
cleos set account permission volentixtsys active volentixtsys --add-code
cleos set account permission v11111111111 active volentixtsys --add-code
cleos set account permission volentixvote active volentixvote --add-code
cleos set account permission vtxcustodian active volentixtsys --add-code
echo "|____________________________________________________________________________________________________________________________________________|"
cleos push action volentixtsys create '{"issuer": "volentixtsys", "maximum_supply": "2100000000.00000000 VTX"}' -p volentixtsys@active
cleos push action volentixtsys issue '{"to": "v11111111111", "quantity": "100000.00000000 VTX", "memo": "tester"}' -p volentixtsys@active
cleos push action volentixtsys issue '{"to": "v22222222222", "quantity": "100000.00000000 VTX", "memo": "tester"}' -p volentixtsys@active
cleos push action volentixtsys issue '{"to": "volentixsale", "quantity": " 128153044.02514328 VTX", "memo": "ETH ethereum"}' -p volentixtsys@active
cleos get currency stats volentixtsys VTX
echo "|____________________________________________________________________________________________________________________________________________|"
cleos push action volentixstak initglobal '{}' -p volentixstak@active
cleos push action volentixtsys transfer '{"from":"v11111111111", "to":"volentixstak", "quantity":"10000.00000000 VTX", "memo":"1"}' -p v11111111111@active
cleos push action volentixtsys transfer '{"from":"v22222222222", "to":"volentixstak", "quantity":"10000.00000000 VTX", "memo":"1"}' -p v22222222222@active
# # cleos get abi volentixstak
cleos get table volentixstak volentixstak globalamount
# cleos get table volentixstak volentixstak accountstake
cleos get table volentixstak v11111111111 accountstake
# echo "|____________________________________________________________________________________________________________________________________________|"
WORD="$ID"
MATCH="to_change"
# echo "|____________________________________________________________________________________________________________________________________________|"
PAYLOAD='{"producer":"v11111111111","producer_name":"v11111111111","url":"https://ca.linkedin.com/in/sylvain-cormier-0592805?challengeId=AQGxyq1T82aaFgAAAXTZnJr9dxcc_QYJcrXQPqU8IJoUmXhDNY2IWtRDXf5R3CRTPrGPshqGewv4F4Gml-X20cQX-XuVkxaw9Q&submissionId=7d9297ca-7d3d-3916-7ed9-4b6721432015","key":"EOS6p2vZXiRpzz7FKhMtxFpKVKNZfnNb27coTJgSUZE4KzeSDdoCZ","node_id":to_change,"job_ids":[1,2]}'
PAYLOAD=$(echo "$PAYLOAD" | sed "s/$MATCH/$WORD/g")
cleos push action volentixvote regproducer $PAYLOAD -p v11111111111@active
PAYLOAD='{"producer":"v22222222222","producer_name":"v22222222222","url":"https://www.facebook.com/weirdal/","key":"EOS5ygr9wmVQbUmQBCLMebHx5hCkjs1vLEnUzYVp6nDiTFvP2uVfM","node_id":"1a2b3bc4d5e6f7g8h9i1j0k1l1m1n2o1p3q","job_ids":[1]}'
cleos push action volentixvote regproducer $PAYLOAD -p v22222222222@active
cleos get table volentixvote volentixvote producers
cleos push action volentixvote activateprod '{"producer":"v11111111111"}' -p v11111111111@active
cleos push action vistribution initup '{"account":"v11111111111"}' -p v11111111111@active
# if [ -z "$PAYLOAD" ]; then killall nodeos; fi
# if [ -z "$PAYLOAD" ]; then docker-compose down; fi
# if [ -z "$PAYLOAD" ]; then exit 1; fi
cleos push action vistribution setrewardrule '{"rule":{"reward_id":"1","reward_period":"1","reward_amount":"10.00000000 VTX","standby_amount":"2.00000000 VTX","rank_threshold":"1","standby_rank_threshold":"0", "memo":"Thank you for supporting the Volentix network","standby_memo":"Thank you for supporting the Volentix network"}}' -p vistribution@active
cleos push action vistribution setrewardrule '{"rule":{"reward_id":"2","reward_period":"1","reward_amount":"60.00000000 VTX","standby_amount":"2.00000000 VTX","rank_threshold":"1","standby_rank_threshold":"0", "memo":"Thank you for supporting the Volentix network","standby_memo":"Thank you for supporting the Volentix network"}}' -p vistribution@active
cleos get table vistribution vistribution rewards
docker run -id -p 8545:8545 -p 8546:8546 -p 30303:30303 -p 30303:30303/udp openethereum/openethereum:v3.0.0 --jsonrpc-interface all& 
cd ../oracle
# rm -rf node_modules
# rm package.json
# npm install --save web3 --unsafe-perm=true --allow-root
# npm install --save eosjs@20.0.0 --unsafe-perm=true --allow-root
# npm install --save node-fetch --unsafe-perm=true --allow-root
# npm install --save dotenv --unsafe-perm=true --allow-root
# npm install --save web3-eth --unsafe-perm=true --allow-root
# npm install --save find-config --unsafe-perm=true --allow-root

cleos push action vtxcustodian initbalance '{"balance":1985099999687}' -p vtxcustodian@active
cleos push action volentixvote voteproducer  '{"voter_name": "v11111111111", "producers":["v22222222222"]}' -p v11111111111@active 
cleos push action
node oracle_test_sep30.js&
# cleos get table vtxcu

cleos get table vtxcustodian vtxcustodian currentbal

sleep 60


# killall node
cleos get currency balance volentixtsys vltxstakenow
cleos get currency balance volentixtsys v11111111111
# exit 0
# # sudo apt install -y software-properties-common 
# # sudo apt update 
# # sudo apt install -y python3.8 
# # cleos wallet list 
# killall nodeos
# killall keosd
# docker-compose down
# sleep 10
# exit 0 