eosio-cpp -I ../../contracts/volentixstak/volentixstak.hpp -o ../../contracts/volentixvote/volentixvote.wasm ../../contracts/volentixvote/volentixvote.cpp --abigen
cleos --url  http://45.77.137.183:8888 set contract volentixvote ../../contracts/volentixvote/ volentixvote.wasm volentixvote.abi -p volentixvote@active

