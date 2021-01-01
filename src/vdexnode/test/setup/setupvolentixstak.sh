killall nodeos
killall keosd
# Bring up vdexnode
docker-compose down
docker stop $(docker ps -a -q)
docker rm -f $(docker ps -a -q)
docker rmi -f $(docker images -a -q)
#Mainnet account
cleos wallet create -n vistribution --file vistribution
cat vistribution > cleos wallet unlock -n vistribution
#keosd conf should be set to unlocked
#~/eosio-wallet/config.ini
#unlock-timeout = 9000000
#create distribution on admin contract 
# cleos --url  http://eos.greymass.com:443 create account  eosio vistribution EOS8UrDjUkeVxfUzUS1hZQtmaGkdWbGLExyzKF6569kRMR5TzSnQT EOS8UrDjUkeVxfUzUS1hZQtmaGkdWbGLExyzKF6569kRMR5TzSnQT
# cleos wallet unlock -n eosio --password "Input 1"
cleos wallet unlock -n vistribution --password "input"
cleos wallet create -n eosio --file password 
cleos wallet import -n eosio --private-key "5JDCvBSasZRiyHXCkGNQC7EXdTNjima4MXKoYCbs9asRiNvDukc"
cd ../vDexNode && docker build . -t volentix/vdexnode
docker network create --driver=bridge --subnet=172.20.0.0/24 vdexnode_volentix
#edit docker-compose.yml
cd ../ && docker-compose up -d > /dev/pts/0& 
cd biosboot/template/
sleep 1
stop.sh
clean.sh
sh start.sh& 
#Make sure vdex is running
ID=$(curl -s http://127.0.0.1:8000/ | jq '.id')
if [ -z "$ID" ]; then killall nodeos; fi
if [ -z "$ID" ]; then docker-compose down; fi
if [ -z "$ID" ]; then exit 1; fi
#sleep 3
IP=$(curl -s http://127.0.0.1:8000/ | jq '.ips')
#echo "$IP"
sleep 3
EOS_KEY=$(curl -s http://127.0.0.1:8000/ | jq '.key')
#sleep 3
NODE_KEY=$(curl -s http://127.0.0.1:8000/ | jq '.public_key')
#echo "|____________________________________________________________________________________________________________________________________________|"
cleos --url  http://140.82.56.143:8888 create account  eosio v11111111111 EOS8UrDjUkeVxfUzUS1hZQtmaGkdWbGLExyzKF6569kRMR5TzSnQT EOS8UrDjUkeVxfUzUS1hZQtmaGkdWbGLExyzKF6569kRMR5TzSnQT
cleos --url  http://140.82.56.143:8888 create account  eosio v22222222222 EOS8UrDjUkeVxfUzUS1hZQtmaGkdWbGLExyzKF6569kRMR5TzSnQT EOS8UrDjUkeVxfUzUS1hZQtmaGkdWbGLExyzKF6569kRMR5TzSnQT
cleos --url  http://140.82.56.143:8888 create account  eosio v33333333333 EOS8UrDjUkeVxfUzUS1hZQtmaGkdWbGLExyzKF6569kRMR5TzSnQT EOS8UrDjUkeVxfUzUS1hZQtmaGkdWbGLExyzKF6569kRMR5TzSnQT 
cleos --url  http://140.82.56.143:8888 create account  eosio v44444444444 EOS8UrDjUkeVxfUzUS1hZQtmaGkdWbGLExyzKF6569kRMR5TzSnQT EOS8UrDjUkeVxfUzUS1hZQtmaGkdWbGLExyzKF6569kRMR5TzSnQT
cleos --url  http://140.82.56.143:8888 create account  eosio v55555555555 EOS8UrDjUkeVxfUzUS1hZQtmaGkdWbGLExyzKF6569kRMR5TzSnQT EOS8UrDjUkeVxfUzUS1hZQtmaGkdWbGLExyzKF6569kRMR5TzSnQT
cleos --url  http://140.82.56.143:8888 create account  eosio x11111111111 EOS8UrDjUkeVxfUzUS1hZQtmaGkdWbGLExyzKF6569kRMR5TzSnQT EOS8UrDjUkeVxfUzUS1hZQtmaGkdWbGLExyzKF6569kRMR5TzSnQT
cleos --url  http://140.82.56.143:8888 create account  eosio x22222222222 EOS8UrDjUkeVxfUzUS1hZQtmaGkdWbGLExyzKF6569kRMR5TzSnQT EOS8UrDjUkeVxfUzUS1hZQtmaGkdWbGLExyzKF6569kRMR5TzSnQT 
cleos --url  http://140.82.56.143:8888 create account  eosio x33333333333 EOS8UrDjUkeVxfUzUS1hZQtmaGkdWbGLExyzKF6569kRMR5TzSnQT EOS8UrDjUkeVxfUzUS1hZQtmaGkdWbGLExyzKF6569kRMR5TzSnQT
cleos --url  http://140.82.56.143:8888 create account  eosio volentixvote EOS8UrDjUkeVxfUzUS1hZQtmaGkdWbGLExyzKF6569kRMR5TzSnQT EOS8UrDjUkeVxfUzUS1hZQtmaGkdWbGLExyzKF6569kRMR5TzSnQT

cleos --url  http://140.82.56.143:8888 create account  eosio volentixtsys EOS8UrDjUkeVxfUzUS1hZQtmaGkdWbGLExyzKF6569kRMR5TzSnQT EOS8UrDjUkeVxfUzUS1hZQtmaGkdWbGLExyzKF6569kRMR5TzSnQT
cleos --url  http://140.82.56.143:8888 create account  eosio volentixsale EOS8UrDjUkeVxfUzUS1hZQtmaGkdWbGLExyzKF6569kRMR5TzSnQT EOS8UrDjUkeVxfUzUS1hZQtmaGkdWbGLExyzKF6569kRMR5TzSnQT
cleos --url  http://140.82.56.143:8888 create account  eosio volentixwvtx EOS8UrDjUkeVxfUzUS1hZQtmaGkdWbGLExyzKF6569kRMR5TzSnQT EOS8UrDjUkeVxfUzUS1hZQtmaGkdWbGLExyzKF6569kRMR5TzSnQT
cleos --url  http://140.82.56.143:8888 create account  eosio vtxcustodian EOS8UrDjUkeVxfUzUS1hZQtmaGkdWbGLExyzKF6569kRMR5TzSnQT EOS8UrDjUkeVxfUzUS1hZQtmaGkdWbGLExyzKF6569kRMR5TzSnQT
cleos --url  http://140.82.56.143:8888 create account  eosio volentixstak EOS8UrDjUkeVxfUzUS1hZQtmaGkdWbGLExyzKF6569kRMR5TzSnQT EOS8UrDjUkeVxfUzUS1hZQtmaGkdWbGLExyzKF6569kRMR5TzSnQT
cleos --url  http://140.82.56.143:8888 create account  eosio vtxtestpool1 EOS8UrDjUkeVxfUzUS1hZQtmaGkdWbGLExyzKF6569kRMR5TzSnQT EOS8UrDjUkeVxfUzUS1hZQtmaGkdWbGLExyzKF6569kRMR5TzSnQT
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

echo "|____________________________________________________________________________________________________________________________________________|"
cleos --url  http://140.82.56.143:8888 set contract volentixtsys ../tokens/volentixgsys/ volentixgsys.wasm volentixgsys.abi -p volentixtsys@active
cleos --url  http://140.82.56.143:8888 set contract volentixstak ../contracts/volentixstak/ volentixstak.wasm volentixstak.abi -p volentixstak@active
cleos --url  http://140.82.56.143:8888 set contract vtxcustodian ../contracts/vtxcustodian/ vltxcstdn.wasm vltxcstdn.abi -p vtxcustodian@active
cleos --url  http://140.82.56.143:8888 set contract vistribution ../contracts/vtxdistribut/ vtxdistribut.wasm vtxdistribut.abi -p vistribution@active
cleos --url  http://140.82.56.143:8888 set contract volentixvote ../contracts/volentixvote/ volentixvote.wasm volentixvote.abi -p volentixvote@active
cleos --url  http://140.82.56.143:8888 set contract vtxtestpool1 ../contracts/volentixpool/ volentixpool.wasm volentixpool.abi -p vtxtestpool1@active
echo "|____________________________________________________________________________________________________________________________________________|"
cleos --url  http://140.82.56.143:8888 set account permission volentixstak active volentixstak --add-code
cleos --url  http://140.82.56.143:8888 set account permission volentixgsys active volentixtsys --add-code
cleos --url  http://140.82.56.143:8888 set account permission v11111111111 active volentixtsys --add-code
cleos --url  http://140.82.56.143:8888 set account permission volentixvote active volentixvote --add-code
cleos --url  http://140.82.56.143:8888 set account permission vtxcustodian active volentixtsys --add-code
cleos --url  http://140.82.56.143:8888 set account permission vistribution active vistribution --add-code
cleos --url  http://140.82.56.143:8888 set account permission vistribution active vtxtestpool1 --add-code
cleos --url  http://140.82.56.143:8888 set account permission vtxtestpool1 active volentixtsys --add-code -p vtxtestpool1@active
cleos --url  http://140.82.56.143:8888 get account vtxtestpool1
echo "|_______________________________________________________________________________________________________________________________________________________________________|"
cleos --url  http://140.82.56.143:8888 push action volentixtsys create '{"issuer": "volentixtsys", "maximum_supply": "2100000000.00000000 VTX"}' -p volentixtsys@active
cleos --url  http://140.82.56.143:8888 push action volentixtsys issue '{"to": "v11111111111", "quantity": "200000.00000000 VTX", "memo": "tester"}' -p volentixtsys@active
cleos --url  http://140.82.56.143:8888 push action volentixtsys issue '{"to": "v22222222222", "quantity": "200000.00000000 VTX", "memo": "tester"}' -p volentixtsys@active
cleos --url  http://140.82.56.143:8888 push action volentixtsys issue '{"to": "v33333333333", "quantity": "200000.00000000 VTX", "memo": "tester"}' -p volentixtsys@active
cleos --url  http://140.82.56.143:8888 push action volentixtsys issue '{"to": "v44444444444", "quantity": "200000.00000000 VTX", "memo": "tester"}' -p volentixtsys@active
cleos --url  http://140.82.56.143:8888 push action volentixtsys issue '{"to": "v55555555555", "quantity": "200000.00000000 VTX", "memo": "tester"}' -p volentixtsys@active
cleos --url  http://140.82.56.143:8888 push action volentixtsys issue '{"to": "x11111111111", "quantity": "200000.00000000 VTX", "memo": "tester"}' -p volentixtsys@active
cleos --url  http://140.82.56.143:8888 push action volentixtsys issue '{"to": "x22222222222", "quantity": "200000.00000000 VTX", "memo": "tester"}' -p volentixtsys@active
cleos --url  http://140.82.56.143:8888 push action volentixtsys issue '{"to": "x33333333333", "quantity": "200000.00000000 VTX", "memo": "tester"}' -p volentixtsys@active
cleos --url  http://140.82.56.143:8888 push action volentixtsys issue '{"to": "volentixsale", "quantity": " 128153044.02514328 VTX", "memo": "ETH ethereum"}' -p volentixtsys@active
cleos --url  http://140.82.56.143:8888 push action volentixtsys issue '{"to": "vistribution", "quantity": "1000000.00000000 VTX", "memo": "rewards pool"}' -p volentixtsys@active
cleos --url  http://140.82.56.143:8888 get currency stats volentixtsys VTX
echo "|_______________________________________________________________________________________________________________________________________________________________________________________|"
cleos --url  http://140.82.56.143:8888 push action volentixstak initglobal '{}' -p volentixstak@active
#whale
cleos --url  http://140.82.56.143:8888 push action volentixtsys transfer '{"from":"v11111111111", "to":"volentixstak", "quantity":"100000.00000000 VTX", "memo":"1"}' -p v11111111111@active
#normal
cleos --url  http://140.82.56.143:8888 push action volentixtsys transfer '{"from":"v22222222222", "to":"volentixstak", "quantity":"10000.00000000 VTX", "memo":"1"}' -p v22222222222@active
cleos --url  http://140.82.56.143:8888 push action volentixtsys transfer '{"from":"v33333333333", "to":"volentixstak", "quantity":"10000.00000000 VTX", "memo":"1"}' -p v33333333333@active
cleos --url  http://140.82.56.143:8888 push action volentixtsys transfer '{"from":"v44444444444", "to":"volentixstak", "quantity":"10000.00000000 VTX", "memo":"1"}' -p v44444444444@active
cleos --url  http://140.82.56.143:8888 push action volentixtsys transfer '{"from":"v55555555555", "to":"volentixstak", "quantity":"10000.00000000 VTX", "memo":"1"}' -p v55555555555@active
cleos --url  http://140.82.56.143:8888 push action volentixtsys transfer '{"from":"x11111111111", "to":"volentixstak", "quantity":"10000.00000000 VTX", "memo":"1"}' -p x11111111111@active
cleos --url  http://140.82.56.143:8888 push action volentixtsys transfer '{"from":"x11111111111", "to":"volentixstak", "quantity":"10000.00000000 VTX", "memo":"1"}' -p x22222222222@active
cleos --url  http://140.82.56.143:8888 push action volentixtsys transfer '{"from":"x11111111111", "to":"volentixstak", "quantity":"10000.00000000 VTX", "memo":"1"}' -p x33333333333@active
WORD="$ID"
MATCH="to_change"
echo "|____________________________________________________________________________________________________________________________________________________________________________________________________|"
PAYLOAD='{"producer":"v11111111111","producer_name":"v11111111111","url":"","key":"EOS6p2vZXiRpzz7FKhMtxFpKVKNZfnNb27coTJgSUZE4KzeSDdoCZ","node_id":to_change,"job_ids":[1,2]}'
PAYLOAD=$(echo "$PAYLOAD" | sed "s/$MATCH/$WORD/g")
cleos --url  http://140.82.56.143:8888 push action volentixvote regproducer $PAYLOAD -p v11111111111@active
echo "|____________________________________________________________________________________________________________________________________________________________________________________________________|"
PAYLOAD='{"producer":"v22222222222","producer_name":"v22222222222","url":"","key":"EOS5ygr9wmVQbUmQBCLMebHx5hCkjs1vLEnUzYVp6nDiTFvP2uVfM","node_id":to_change,"job_ids":[1]}'
PAYLOAD=$(echo "$PAYLOAD" | sed "s/$MATCH/$WORD/g")
cleos --url  http://140.82.56.143:8888 push action volentixvote regproducer $PAYLOAD -p v22222222222@active
echo "|_____________________________________________________________________________________________________________________________________________________________________________________________________|"
PAYLOAD='{"producer":"v33333333333","producer_name":"v33333333333","url":"","key":"EOS5EYGEkiKUXRQ21eCcKgjv1uhtyVsx88njnR6urPYHGEZbkKmk1","node_id":to_change,"job_ids":[1,2]}'
PAYLOAD=$(echo "$PAYLOAD" | sed "s/$MATCH/$WORD/g")0
cleos --url  http://140.82.56.143:8888 push action volentixvote regproducer $PAYLOAD -p v33333333333@active
echo "|_____________________________________________________________________________________________________________________________________________________________________________________________________|"
PAYLOAD='{"producer":"v44444444444","producer_name":"v44444444444","url":"","key":"EOS5EYGEkiKUXRQ21eCcKgjv1uhtyVsx88njnR6urPYHGEZbkKmk1","node_id":to_change,"job_ids":[1,2]}'
PAYLOAD=$(echo "$PAYLOAD" | sed "s/$MATCH/$WORD/g")0
cleos --url  http://140.82.56.143:8888 push action volentixvote regproducer $PAYLOAD -p v44444444444@active
echo "|_____________________________________________________________________________________________________________________________________________________________________________________________________|"
PAYLOAD='{"producer":"v55555555555","producer_name":"v55555555555","url":"","key":"EOS5EYGEkiKUXRQ21eCcKgjv1uhtyVsx88njnR6urPYHGEZbkKmk1","node_id":to_change,"job_ids":[1,2]}'
PAYLOAD=$(echo "$PAYLOAD" | sed "s/$MATCH/$WORD/g")0
cleos --url  http://140.82.56.143:8888 push action volentixvote regproducer $PAYLOAD -p v55555555555@active
echo "|_____________________________________________________________________________________________________________________________________________________________________________________________________|"
PAYLOAD='{"producer":"x11111111111","producer_name":"x1111111111111","url":"","key":"EOS5EYGEkiKUXRQ21eCcKgjv1uhtyVsx88njnR6urPYHGEZbkKmk1","node_id":to_change,"job_ids":[1,2]}'
PAYLOAD=$(echo "$PAYLOAD" | sed "s/$MATCH/$WORD/g")0
cleos --url  http://140.82.56.143:8888 push action volentixvote regproducer $PAYLOAD -p x11111111111@active
echo "|_____________________________________________________________________________________________________________________________________________________________________________________________________|"
PAYLOAD='{"producer":"x222222222222","producer_name":"x22222222222","url":"","key":"EOS5EYGEkiKUXRQ21eCcKgjv1uhtyVsx88njnR6urPYHGEZbkKmk1","node_id":to_change,"job_ids":[1,2]}'
PAYLOAD=$(echo "$PAYLOAD" | sed "s/$MATCH/$WORD/g")0
cleos --url  http://140.82.56.143:8888 push action volentixvote regproducer $PAYLOAD -p x22222222222@active
echo "|_____________________________________________________________________________________________________________________________________________________________________________________________________|"
PAYLOAD='{"producer":"v44444444444","producer_name":"v444444444444","url":"","key":"EOS5EYGEkiKUXRQ21eCcKgjv1uhtyVsx88njnR6urPYHGEZbkKmk1","node_id":to_change,"job_ids":[1,2]}'
PAYLOAD=$(echo "$PAYLOAD" | sed "s/$MATCH/$WORD/g")0
cleos --url  http://140.82.56.143:8888 push action volentixvote regproducer $PAYLOAD -p v444444444444@active
echo "|_____________________________________________________________________________________________________________________________________________________________________________________________________|"
cleos --url  http://140.82.56.143:8888 push action volentixvote activateprod '{"producer":"v11111111111"}' -p v11111111111@active
cleos --url  http://140.82.56.143:8888 push action volentixvote activateprod '{"producer":"v22222222222"}'-p v22222222222@active
cleos --url  http://140.82.56.143:8888 push action volentixvote activateprod '{"producer":"v33333333333"}'-p v33333333333@active
cleos --url  http://140.82.56.143:8888 push action volentixvote activateprod '{"producer":"v44444444444"}'-p v44444444444@active
cleos --url  http://140.82.56.143:8888 push action volentixvote activateprod '{"producer":"v55555555555"}'-p v55555555555@active
cleos --url  http://140.82.56.143:8888 push action volentixvote activateprod '{"producer":"x11111111111"}'-p x11111111111@active
cleos --url  http://140.82.56.143:8888 push action volentixvote activateprod '{"producer":"x11111111111"}'-p x22222222222@active
cleos --url  http://140.82.56.143:8888 push action volentixvote activateprod '{"producer":"x11111111111"}'-p x33333333333@active

cleos --url  http://140.82.56.143:8888 push action vistribution initup '{"account":"v11111111111"}' -p v11111111111@active
cleos --url  http://140.82.56.143:8888 push action vistribution initup '{"account":"v22222222222"}' -p v22222222222@active
cleos --url  http://140.82.56.143:8888 push action vistribution initup '{"account":"v33333333333"}' -p v33333333333@active
cleos --url  http://140.82.56.143:8888 push action vistribution initup '{"account":"v33333333333"}' -p v44444444444@active
cleos --url  http://140.82.56.143:8888 push action vistribution initup '{"account":"v33333333333"}' -p v55555555555@active
cleos --url  http://140.82.56.143:8888 push action vistribution initup '{"account":"v33333333333"}' -p x11111111111@active
cleos --url  http://140.82.56.143:8888 push action vistribution initup '{"account":"v33333333333"}' -p x22222222222@active
cleos --url  http://140.82.56.143:8888 push action vistribution initup '{"account":"v33333333333"}' -p x33333333333@active


cleos --url  http://140.82.56.143:8888 push action vistribution setrewardrule '{"rule":{"reward_id":"1","reward_period":"100","reward_amount":"10.00000000 VTX","standby_amount":"2.00000000 VTX","rank_threshold":"3","standby_rank_threshold":"0", "memo":"Voting","standby_memo":"Voting"}}' -p vistribution@active
cleos --url  http://140.82.56.143:8888 push action vistribution setrewardrule '{"rule":{"reward_id":"2","reward_period":"100","reward_amount":"66.00000000 VTX","standby_amount":"2.00000000 VTX","rank_threshold":"3","standby_rank_threshold":"0", "memo":"Oracle","standby_memo":"Oracle"}}' -p vistribution@active

cleos --url  http://140.82.56.143:8888 push action volentixvote voteproducer  '{"voter_name": "v11111111111", "producers":["v22222222222"]}' -p v11111111111@active 
cleos --url  http://140.82.56.143:8888 push action volentixvote voteproducer  '{"voter_name": "v22222222222", "producers":["v11111111111"]}' -p v22222222222@active 
cleos --url  http://140.82.56.143:8888 push action volentixvote voteproducer  '{"voter_name": "v33333333333", "producers":["v11111111111"]}' -p v33333333333@active 
cleos --url  http://140.82.56.143:8888 push action volentixvote voteproducer  '{"voter_name": "v33333333333", "producers":["v11111111111"]}' -p v44444444444@active 
cleos --url  http://140.82.56.143:8888 push action volentixvote voteproducer  '{"voter_name": "v33333333333", "producers":["v11111111111"]}' -p v55555555555@active 
cleos --url  http://140.82.56.143:8888 push action volentixvote voteproducer  '{"voter_name": "v33333333333", "producers":["v11111111111"]}' -p x11111111111@active 
cleos --url  http://140.82.56.143:8888 push action volentixvote voteproducer  '{"voter_name": "v33333333333", "producers":["v11111111111"]}' -p x22222222222@active 
cleos --url  http://140.82.56.143:8888 push action volentixvote voteproducer  '{"voter_name": "v33333333333", "producers":["v11111111111"]}' -p x33333333333@active 


cleos --url  http://140.82.56.143:8888 push action vtxcustodian initbalance '{"balance":1985099999687}' -p vtxcustodian@active

FROM_ACCOUNT=0x511bfda122bfff8df03bcfa6fca082e341f06ee6
TO_ACCOUNT=1957ce2d67aeeefd47fbaea5bc37faa7a0a537a8
CONTRACT_ADDRESS=0xf5B719378261d911a788E1498fCE36308EB9caff
AMOUNT=100

# Convert amount to 256bit hexdecimal
AMOUNT=$(printf "%064x" $AMOUNT)

# Create TX data: FUNCTION SELECTOR + TO_ACCOUNT + AMOUNT
TX_DATA="0xa9059cbb000000000000000000000000$TO_ACCOUNT$AMOUNT"

curl localhost:8540 \
  -H "Content-Type: application/json" \
  -X POST \
  --data '{
    "id": 1,
    "jsonrpc":"2.0",
    "method": "eth_call",
    "params": [{
      "from": "'$FROM_ACCOUNT'",
      "to": "'$CONTRACT_ADDRESS'",
      "gas": "0xfffff",
      "gasPrice": "0x9184e72a000",
      "value": "0x0",
      "data": "'$TX_DATA'"
    }]
  }'
