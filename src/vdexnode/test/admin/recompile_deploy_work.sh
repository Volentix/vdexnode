eosio-cpp  -o ../../contracts/volentixstak/volentixstak.wasm ../../contracts/volentixstak/volentixstak.hpp --abigen
cleos --url  http://45.77.137.183:8888 set contract  --suppress-duplicate-check --force-unique vltxstakenow .../../contracts/volentixstak/ volentixstak.wasm volentixstak.abi -p vltxstakenow@active

