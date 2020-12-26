#cp -r ~/eosio-wallet/  /root
#python3 ../scripts/unlock_wallets.py
rm ../contracts/volentixpool/*.abi*
eosio-cpp -I ../contracts/volentixstak/volentixstak.hpp -o ../contracts/volentixpool/volentixpool.wasm ../contracts/volentixpool/volentixpool.cpp --abigen
cleos --url  http://199.247.30.155:8888 set contract vtxtestpool1 ../contracts/volentixpool/ volentixpool.wasm volentixpool.abi -p vtxtestpool1@active
#echo "|____________________________________________________________________________________________________________________________________________|"
cleos --url  http://199.247.30.155:8888 set account permission vistribution active vtxtestpool1 --add-code
 cleos --url  http://199.247.30.155:8888 get table vistribution vistribution nodereward
