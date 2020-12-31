rm ../contracts/vtxcustodian/*.wasm*
eosio-cpp -I ../contracts/volentixstak/volentixstak.hpp -o ../contracts/vtxcustodian/vltxcstdn.wasm ../contracts/vtxcustodian/vltxcstdn.cpp --abigen
cleos --url  http://199.247.30.155:8888 set contract volentixvote ../contracts/volentixvote/ volentixvote.wasm volentixvote.abi -p volentixvote@active

