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

killall nodeos
killall keosd
docker-compose down
docker stop $(docker ps -a -q)
sleep 5
docker rm -f $(docker ps -a -q)
# docker rmi -f $(docker images -a -q)
# cp -r ~/eosio-wallet/  /root
python3 ../scripts/unlock_wallets.py
cleos wallet list
# cd ../vDexNode && docker build . -t volentix/vdexnode
docker network create --driver=bridge --subnet=172.20.0.0/24 vdexnode_volentix
cd ../ && docker-compose up -d > /dev/pts/0& 
sleep 2
# networks:
#   volentix:
#     driver: bridge
#     ipam:
#       driver: default
#       config:
#       - subnet: 172.20.0.0/24


sudo docker network inspect bridge

exec nodeos -e -p eosio --disable-replay-opts --delete-all-blocks --contracts-console --chain-state-history  --verbose-http-errors 2> /dev/pts/2& 

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
cleos create account  eosio vtxtestpool1 EOS7njdfzQnpGaYhBbSKnJeBuL2B9hzkYzg1bwCZYM5pSuQjwsh1W EOS8GumsZzQMuXyovNeGda4dUfqUFmjKRrmFycWLKFgLqN8xpapZv
echo "|____________________________________________________________________________________________________________________________________________|"
rm ../tokens/volentixgsys/*.abi*
rm ../contracts/volentixstak/*.abi*
rm ../contracts/vtxcustodian/*.abi*
rm ../contracts/vtxdistribut/*.abi*
rm ../contracts/volentixvote/*.abi*
rm ../contracts/volentixpool/*.abi*
rm ../tokens/volentixgsys/*.wasm*
rm ../contracts/volentixstak/*.wasm*
rm ../contracts/vtxcustodian/*.wasm*
rm ../contracts/vtxdistribut/*.wasm*
rm ../contracts/volentixvote/*.wasm*
rm ../contracts/volentixpool/*.wasm*
eosio-cpp -o ../tokens/volentixgsys/volentixgsys.wasm ../tokens/volentixgsys/volentixgsys.cpp --abigen
eosio-cpp -o ../contracts/volentixstak/volentixstak.wasm ../contracts/volentixstak/volentixstak.cpp --abigen
eosio-cpp -I ../contracts/volentixstak/volentixstak.hpp -o ../contracts/vtxcustodian/vltxcstdn.wasm ../contracts/vtxcustodian/vltxcstdn.cpp --abigen
eosio-cpp -I ../contracts/volentixstak/volentixstak.hpp -o ../contracts/volentixvote/volentixvote.wasm ../contracts/volentixvote/volentixvote.cpp --abigen
eosio-cpp -I ../contracts/volentixstak/volentixstak.hpp -o ../contracts/volentixpool/volentixpool.wasm ../contracts/volentixpool/volentixpool.cpp --abigen
echo "build distribution contract"
eosio-cpp -I ../contracts/volentixstak/volentixstak.hpp -o ../contracts/vtxdistribut/vtxdistribut.wasm ../contracts/vtxdistribut/vtxdistribut.cpp --abigen

# while [ condition ]
# do
#    echo "run nodeos for now "
# done

echo "|____________________________________________________________________________________________________________________________________________|"
cleos set contract volentixtsys ../tokens/volentixgsys/ volentixgsys.wasm volentixgsys.abi -p volentixtsys@active
cleos set contract volentixstak ../contracts/volentixstak/ volentixstak.wasm volentixstak.abi -p volentixstak@active
cleos set contract vtxcustodian ../contracts/vtxcustodian/ vltxcstdn.wasm vltxcstdn.abi -p vtxcustodian@active
cleos set contract vistribution ../contracts/vtxdistribut/ vtxdistribut.wasm vtxdistribut.abi -p vistribution@active
cleos set contract volentixvote ../contracts/volentixvote/ volentixvote.wasm volentixvote.abi -p volentixvote@active

cleos set contract vtxtestpool1 ../contracts/volentixpool/ volentixpool.wasm volentixpool.abi -p vtxtestpool1@active

echo "|____________________________________________________________________________________________________________________________________________|"
cleos set account permission volentixstak active volentixstak --add-code
cleos set account permission volentixtsys active volentixtsys --add-code
cleos set account permission v11111111111 active volentixtsys --add-code
cleos set account permission volentixvote active volentixvote --add-code
cleos set account permission vtxcustodian active volentixtsys --add-code
cleos set account permission vistribution active vistribution --add-code
# cleos set account permission vistribution active vtxtestpool1 --add-code
# cleos set account permission vtxtestpool1 active volentixtsys --add-code -p vtxtestpool1@active
cleos get account vtxtestpool1

echo "|____________________________________________________________________________________________________________________________________________|"
cleos push action volentixtsys create '{"issuer": "volentixtsys", "maximum_supply": "2100000000.00000000 VTX"}' -p volentixtsys@active
cleos push action volentixtsys issue '{"to": "v11111111111", "quantity": "200000.00000000 VTX", "memo": "tester"}' -p volentixtsys@active
cleos push action volentixtsys issue '{"to": "v22222222222", "quantity": "200000.00000000 VTX", "memo": "tester"}' -p volentixtsys@active
cleos push action volentixtsys issue '{"to": "v33333333333", "quantity": "200000.00000000 VTX", "memo": "tester"}' -p volentixtsys@active
cleos push action volentixtsys issue '{"to": "volentixsale", "quantity": " 128153044.02514328 VTX", "memo": "ETH ethereum"}' -p volentixtsys@active
cleos push action volentixtsys issue '{"to": "vistribution", "quantity": "1000000.00000000 VTX", "memo": "rewards pool"}' -p volentixtsys@active
# cleos get currency stats volentixtsys VTX
echo "|____________________________________________________________________________________________________________________________________________|"
cleos push action volentixstak initglobal '{}' -p volentixstak@active
cleos push action volentixtsys transfer '{"from":"v11111111111", "to":"volentixstak", "quantity":"10000.00000000 VTX", "memo":"1"}' -p v11111111111@active
cleos push action volentixtsys transfer '{"from":"v22222222222", "to":"volentixstak", "quantity":"10000.00000000 VTX", "memo":"1"}' -p v22222222222@active
cleos push action volentixtsys transfer '{"from":"v33333333333", "to":"volentixstak", "quantity":"10000.00000000 VTX", "memo":"1"}' -p v33333333333@active
WORD="$ID"
MATCH="to_change"
# echo "|____________________________________________________________________________________________________________________________________________|"
PAYLOAD='{"producer":"v11111111111","producer_name":"v11111111111","url":"https://ca.linkedin.com/in/sylvain-cormier-0592805?challengeId=AQGxyq1T82aaFgAAAXTZnJr9dxcc_QYJcrXQPqU8IJoUmXhDNY2IWtRDXf5R3CRTPrGPshqGewv4F4Gml-X20cQX-XuVkxaw9Q&submissionId=7d9297ca-7d3d-3916-7ed9-4b6721432015","key":"EOS6p2vZXiRpzz7FKhMtxFpKVKNZfnNb27coTJgSUZE4KzeSDdoCZ","node_id":to_change,"job_ids":[1,2]}'
PAYLOAD=$(echo "$PAYLOAD" | sed "s/$MATCH/$WORD/g")
cleos push action volentixvote regproducer $PAYLOAD -p v11111111111@active
PAYLOAD='{"producer":"v22222222222","producer_name":"v22222222222","url":"https://www.facebook.com/weirdal/","key":"EOS5ygr9wmVQbUmQBCLMebHx5hCkjs1vLEnUzYVp6nDiTFvP2uVfM","node_id":"1a2b3bc4d5e6f7g8h9i1j0k1l1m1n2o1p3q","job_ids":[1]}'
cleos push action volentixvote regproducer $PAYLOAD -p v22222222222@active
PAYLOAD='{"producer":"v33333333333","producer_name":"v33333333333","url":"https://www.investopedia.com/terms/s/satoshi-nakamoto.asp","key":"EOS5EYGEkiKUXRQ21eCcKgjv1uhtyVsx88njnR6urPYHGEZbkKmk1","node_id":"1a2b3bc4d5e6f7g8h9i1j0k1l1m1n2o1p3q","job_ids":[1,2]}'
PAYLOAD=$(echo "$PAYLOAD" | sed "s/$MATCH/$WORD/g")
cleos push action volentixvote regproducer $PAYLOAD -p v33333333333@active
cleos push action volentixvote activateprod '{"producer":"v11111111111"}' -p v11111111111@active
cleos push action volentixvote activateprod '{"producer":"v222222222222"}'-p v22222222222@active
cleos push action volentixvote activateprod '{"producer":"v333333333333"}'-p v33333333333@active

cleos push action vistribution initup '{"account":"v11111111111"}' -p v11111111111@active
cleos push action vistribution initup '{"account":"v22222222222"}' -p v22222222222@active
cleos push action vistribution initup '{"account":"v33333333333"}' -p v33333333333@active
cleos push action vistribution setrewardrule '{"rule":{"reward_id":"1","reward_period":"10","reward_amount":"10.00000000 VTX","standby_amount":"2.00000000 VTX","rank_threshold":"10","standby_rank_threshold":"0", "memo":"Voting","standby_memo":"Voting"}}' -p vistribution@active
cleos push action vistribution setrewardrule '{"rule":{"reward_id":"2","reward_period":"10","reward_amount":"66.00000000 VTX","standby_amount":"2.00000000 VTX","rank_threshold":"10","standby_rank_threshold":"0", "memo":"Oracle","standby_memo":"Oracle"}}' -p vistribution@active
# cleos get table vistribution vistribution rewards

cleos get table volentixvote volentixvote producers
cleos push action volentixvote voteproducer  '{"voter_name": "v11111111111", "producers":["v22222222222"]}' -p v11111111111@active 
cleos push action volentixvote voteproducer  '{"voter_name": "v22222222222", "producers":["v11111111111"]}' -p v22222222222@active 
cleos push action volentixvote voteproducer  '{"voter_name": "v33333333333", "producers":["v11111111111"]}' -p v33333333333@active 
sleep 3
echo "STARTING OPENETHEREUM"
docker run -id -p 8545:8545 -p 8546:8546 -p 30303:30303 -p 30303:30303/udp openethereum/openethereum:v3.0.0 --chain ropsten --jsonrpc-interface all& #-d 2> /dev/pts/3& 
docker ps
sleep 10

echo "STARTED OPENETHEREUM" 
cd ../oracle
rm -rf node_modules
rm package.json
npm install --save web3 --unsafe-perm=true --allow-root
npm install --save eosjs@20.0.0 --unsafe-perm=true --allow-root
npm install --save node-fetch --unsafe-perm=true --allow-root
npm install --save dotenv --unsafe-perm=true --allow-root
npm install --save web3-eth --unsafe-perm=true --allow-root
npm install --save find-config --unsafe-perm=true --allow-root
cleos push action vtxcustodian initbalance '{"balance":1985099999687}' -p vtxcustodian@active

node bridge_oracle.js 2> /dev/pts/1& 
node vote_oracle2.js 2> /dev/pts/1& 

# n=1
# while [ $n -le 5 ]
# do
#     echo "let period go by"
#     sleep 2
#     echo "Uptime_____________________________________"
#     PAYLOAD='{"account":"v11111111111","job_ids":[1,2],"node_id":to_change,"memo":"1"}'
#     PAYLOAD=$(echo "$PAYLOAD" | sed "s/$MATCH/$WORD/g")
#     echo "$PAYLOAD"
#     cleos push action vistribution uptime $PAYLOAD -p v11111111111@active
#     sleep 1
#     PAYLOAD='{"account":"v22222222222","job_ids":[1],"node_id":to_change,"memo":"2"}'
#     PAYLOAD=$(echo "$PAYLOAD" | sed "s/$MATCH/$WORD/g")
#     echo "$PAYLOAD"
#     cleos push action vistribution uptime $PAYLOAD -p v22222222222@active
#     echo "v11111111111 balance_____________________"
#     cleos get currency balance volentixtsys v11111111111
#     echo "v22222222222 balance_____________________"
#     cleos get currency balance volentixtsys v22222222222
#     echo "v33333333333 balance_____________________"
#     cleos get currency balance volentixtsys v33333333333
#     i=$[$i+1]
#     # echo "uptimes__________________________________"
#     # cleos get table vistribution vistribution uptimes
#     # echo "reward history___________________________"
#     # cleos get table vistribution vistribution rewardhistor
#     # echo "producers________________________________"
#     # cleos get table volentixvote volentixvote producers
#     # echo "voters___________________________________"
#     # cleos get table volentixvote volentixvote voters
#     # echo "dht___________________________________"
#     # cleos get table vistribution vistribution dht
#     # echo "inituptime___________________________________" 
#     # cleos get table vistribution vistribution inituptime
#     # echo "nodereward___________________________________"
#     # cleos get table vistribution vistribution nodereward

# done

# cleos get account vtxtestpool1

# echo "uptimes__________________________________"
# cleos get table vistribution vistribution uptimes
# echo "reward history___________________________"
# cleos get table vistribution vistribution rewardhistor
# echo "producers________________________________"
# cleos get table volentixvote volentixvote producers
# echo "voters___________________________________"
# cleos get table volentixvote volentixvote voters
# echo "dht___________________________________"
# cleos get table vistribution vistribution dht
# echo "inituptime___________________________________" 
# cleos get table vistribution vistribution inituptime
# echo "nodereward___________________________________"
# cleos get table vistribution vistribution nodereward
# killall nodeos
# exit 1

# cleos get table vistribution vistribution rewards

