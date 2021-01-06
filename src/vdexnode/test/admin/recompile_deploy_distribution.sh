eosio-cpp -I ../../contracts/volentixstak/volentixstak.hpp -o ../../contracts/vtxdistribut/vtxdistribut.wasm ../../contracts/vtxdistribut/vtxdistribut.cpp --abigen
cleos --url  http://45.77.137.183:8888 set contract vistribution ../../contracts/vtxdistribut/ vtxdistribut.wasm vtxdistribut.abi -p vistribution@active

