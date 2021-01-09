
#/bin/bash
# eosio-cpp -o ../../tokens/volentixgsys/volentixgsys.wasm ../../tokens/volentixgsys/volentixgsys.cpp --abigen
# eosio-cpp -o ../../contracts/volentixstak/volentixstak.wasm ../../contracts/volentixstak/volentixstak.cpp --abigen
# eosio-cpp -I ../../contracts/volentixstak/volentixstak.hpp -o ../../contracts/vtxcustodian/vltxcstdn.wasm ../../contracts/vtxcustodian/vltxcstdn.cpp --abigen
# eosio-cpp -I ../../contracts/volentixstak/volentixstak.hpp -o ../../contracts/volentixvote/volentixvote.wasm ../../contracts/volentixvote/volentixvote.cpp --abigen
# eosio-cpp -I ../../contracts/volentixstak/volentixstak.hpp -o ../../contracts/volentixpool/volentixpool.wasm ../../contracts/volentixpool/volentixpool.cpp --abigen
sh ../../contracts/volentixwork/scripts/build.sh

