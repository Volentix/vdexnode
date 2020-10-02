#change line 17 volentixstak.hpp to #define STAKE_PERIOD 1
killall nodeos
killall keosd
docker-compose down
docker stop $(docker ps -a -q)
docker rm -f $(docker ps -a -q)
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

echo 'volentixstak'
cleos get currency balance volentixtsys volentixstak
echo 'v11111111111'
cleos get currency balance volentixtsys v11111111111
cleos get table volentixstak v11111111111 accountstake
echo 'sleeping'
sleep 30
echo 'unstake'
cleos push action volentixstak unstake '{"owner":"v11111111111"}' -p v11111111111@active
echo 'volentixstak'
cleos get currency balance volentixtsys volentixstak
echo 'v11111111111'
cleos get currency balance volentixtsys v11111111111
cleos get table volentixstak v11111111111 accountstake
exit 0
