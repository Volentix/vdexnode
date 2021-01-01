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

#killall nodeos
#killall keosd
#docker-compose down
#docker stop $(docker ps -a -q)
#sleep 5
#docker rm -f $(docker ps -a -q)
# docker rmi -f $(docker images -a -q)
# cp -r ~/eosio-wallet/  /root
#python3 ../scripts/unlock_wallets.py
cleos --url  http://140.82.56.143:8888 wallet list
# cd ../vDexNode && docker build . -t volentix/vdexnode
#docker network create --driver=bridge --subnet=172.20.0.0/24 vdexnode_volentix
#cd ../ && docker-compose up -d > /dev/pts/0& 
#sleep 2
# networks:
#   volentix:
#     driver: bridge
#     ipam:
#       driver: default
#       config:
#       - subnet: 172.20.0.0/24


#sudo docker network inspect bridge

# exec nodeos -e -p eosio --disable-replay-opts --delete-all-blocks --contracts-console --chain-state-history  --verbose-http-errors 2> /dev/pts/2& 

#ID=$(curl -s http://127.0.0.1:8000/ | jq '.id')
#if [ -z "$ID" ]; then killall nodeos; fi
#if [ -z "$ID" ]; then docker-compose down; fi
#if [ -z "$ID" ]; then exit 1; fi
sleep 3
#IP=$(curl -s http://127.0.0.1:8000/ | jq '.ips')
echo "$IP"
sleep 3
EOS_KEY=$(curl -s http://127.0.0.1:8000/ | jq '.key')
sleep 3
NODE_KEY=$(curl -s http://127.0.0.1:8000/ | jq '.public_key')
echo "|____________________________________________________________________________________________________________________________________________|"
#cleos --url  http://140.82.56.143:8888 create account  eosio v11111111111 EOS8EhYUFqg6aBBJBGQ6YHDaGgpwKvmN6f2xugvHMFAZJpUAkAdap EOS6p2vZXiRpzz7FKhMtxFpKVKNZfnNb27coTJgSUZE4KzeSDdoCZ
#cleos --url  http://140.82.56.143:8888 create account  eosio v22222222222 EOS5CJHrUAfrgHqiqcKTQmTwo88B5i8GCw9mzrGke9Tg2aPWjUND4 EOS5ygr9wmVQbUmQBCLMebHx5hCkjs1vLEnUzYVp6nDiTFvP2uVfM
#cleos --url  http://140.82.56.143:8888 create account  eosio v33333333333 EOS6t3dBU3n1EQEZpdARxQNYbwAhDxSiQSgyRc5xPHKnRABxmiHVz EOS5EYGEkiKUXRQ21eCcKgjv1uhtyVsx88njnR6urPYHGEZbkKmk1 
#cleos --url  http://140.82.56.143:8888 create account  eosio v44444444444 EOS85jnmqLxunEyQNchBTdZqexGyJgipEkDaPE51Tjd7PA8cmhchr EOS5YG6aKxwPnNoA66kvDkEeARD3BNAGHcMBiGPr4jnuNd5559qEZ
#cleos --url  http://140.82.56.143:8888 create account  eosio v55555555555 EOS8batxa7sSJrSdX1oPnpjZZZFBoG82ehihwMExkWSGdfUfac3nQ EOS7eiGxgLog6d9tD7KpZULvwz5fvUMj11ZrSoAGkHUo11ZNBje5w
#cleos --url  http://140.82.56.143:8888 create account  eosio x11111111111 EOS7hDytPxrDD4ZPfn86DPUKDeNp8fnHKvSx8VvYH7adzfvXKwGqD EOS725Agx1tsXH3QfHXRbMkixhGxzcN45byRnrSXtrtZvJ3qBvTSi
#cleos --url  http://140.82.56.143:8888 create account  eosio x22222222222 EOS8i4CkKfkYAo5pnP7BEYnf2ZFQEemYjCxGnqLgjmoZc9uw8xfW2 EOS6jqNf5cwjauaU6gzaM3RvhrdDzQ3Uub8mA2phDEsdRMNPUaTDD 
#cleos --url  http://140.82.56.143:8888 create account  eosio x33333333333 EOS7at2brDFGf5miZeF8XHjFb78tETcfeCXyB78A2sCQeoDZiZj3U EOS8JE83j8xwCV6ks1xPWGYJLgYBVaPbkXcJkvsaYgJCiTubBUxNQ
#cleos --url  http://140.82.56.143:8888 create account  eosio volentixvote EOS8hhR7YSY7EkYoeiWjj4ea3jsyFWXdDdCgYsXJEXfHRf4ftF5a9 EOS8Qw3NxLPmNKtbskEyAPHvJLFv7qJ21EqVcvRebrA36z6WWjHir
#cleos --url  http://140.82.56.143:8888 create account  eosio vistribution EOS8chNCZjo58Xa77uectUrND6AKNNsGFsY47xFLUXNryZqQ4Ect5 EOS5LSp5V1cbHgWmZoUHyKibG8xwmpyKZinyfpjVpQujHw3ZWrB9q
#cleos --url  http://140.82.56.143:8888 create account  eosio volentixtsys EOS78pFtmUPnyshkTuDgsDC7UpVWfmDuJr3WMrSKtbEk9ajHknPGL EOS7Rk7gd2bNRyU3yFUPYX3eSsmgCqSKo4FXcWpgotDjKHqJ84ERD
#cleos --url  http://140.82.56.143:8888 create account  eosio volentixsale EOS8UDRf4xaFz7qRXTnSE8W5AeVDHcAHe5iMwozTJTLEqSuz6ca6z EOS7WB1Aiw45csnC5HdpzUSLtLsVmnugpbeBUM6E9Yj2LdXB95orz
#cleos --url  http://140.82.56.143:8888 create account  eosio volentixwvtx EOS66pRhPmw3nxMU7Xc3uAF2XVg5VqyNCyXi19EUk8Zo6E7X3NrcU EOS8g7iLbA3sLC5Ltr6zYaa9ULJYppn5csPNCp8x84u73XNpjDSST
#cleos --url  http://140.82.56.143:8888 create account  eosio vtxcustodian EOS7PZNPBFKcLdsRc4MqhU59atQ6tbdnxJiUahZ7TFuJk3RGELHkK EOS5qzuqCSuLqGpnXGWaaSzPr7wvcbXRZPkp7EPs95M8AfcNALWkQ
#cleos --url  http://140.82.56.143:8888 create account  eosio volentixstak EOS8RxnWpo8rMJRALZed4krEHLKwC9h4fbSBeM5PF3YgW5xxd64kP EOS62LpFVm6KucNfGDxpybQanjN51ga7WUxHthKAuAvHEQDyneBfp
#cleos --url  http://140.82.56.143:8888 create account  eosio vtxtestpool1 EOS7njdfzQnpGaYhBbSKnJeBuL2B9hzkYzg1bwCZYM5pSuQjwsh1W EOS8GumsZzQMuXyovNeGda4dUfqUFmjKRrmFycWLKFgLqN8xpapZv
#echo "|____________________________________________________________________________________________________________________________________________|"
#rm ../tokens/volentixgsys/*.abi*
#rm ../contracts/volentixstak/*.abi*
#rm ../contracts/vtxcustodian/*.abi*
#rm ../contracts/vtxdistribut/*.abi*
#rm ../contracts/volentixvote/*.abi*
#rm ../contracts/volentixpool/*.abi*
#rm ../tokens/volentixgsys/*.wasm*
#rm ../contracts/volentixstak/*.wasm*
#rm ../contracts/vtxcustodian/*.wasm*
#rm ../contracts/vtxdistribut/*.wasm*
#rm ../contracts/volentixvote/*.wasm*
#rm ../contracts/volentixpool/*.wasm*
#eosio-cpp -o ../tokens/volentixgsys/volentixgsys.wasm ../tokens/volentixgsys/volentixgsys.cpp --abigen
#eosio-cpp -o ../contracts/volentixstak/volentixstak.wasm ../contracts/volentixstak/volentixstak.cpp --abigen
#eosio-cpp -I ../contracts/volentixstak/volentixstak.hpp -o ../contracts/vtxcustodian/vltxcstdn.wasm ../contracts/vtxcustodian/vltxcstdn.cpp --abigen
#eosio-cpp -I ../contracts/volentixstak/volentixstak.hpp -o ../contracts/volentixvote/volentixvote.wasm ../contracts/volentixvote/volentixvote.cpp --abigen
#eosio-cpp -I ../contracts/volentixstak/volentixstak.hpp -o ../contracts/volentixpool/volentixpool.wasm ../contracts/volentixpool/volentixpool.cpp --abigen
#echo "build distribution contract"
#eosio-cpp -I ../contracts/volentixstak/volentixstak.hpp -o ../contracts/vtxdistribut/vtxdistribut.wasm ../contracts/vtxdistribut/vtxdistribut.cpp --abigen

# while [ condition ]
# do
#    echo "run nodeos for now "
# done

cd ../oracle
rm -rf node_modules
rm package.json
npm install --save web3 --unsafe-perm=true --allow-root
npm install --save eosjs@20.0.0 --unsafe-perm=true --allow-root
npm install --save node-fetch --unsafe-perm=true --allow-root
npm install --save dotenv --unsafe-perm=true --allow-root
npm install --save web3-eth --unsafe-perm=true --allow-root
npm install --save find-config --unsafe-perm=true --allow-root
cleos --url  http://140.82.56.143:8888 push action vtxcustodian initbalance '{"balance":1985099999687}' -p vtxcustodian@active

node bridge_oracle.js& #2> /dev/pts/1& 
# node vote_oracle2.js 2> /dev/pts/1& 




