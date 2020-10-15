#apt-get install -y python 3.x cmake git g++ build-essential python3-pip openssl curl jq psmisc
# exec nodeos -e -p eosio --disable-replay-opts --delete-all-blocks --contracts-console --chain-state-history  --verbose-http-errors 2> /dev/pts/2& 

killall nodeos
python3 ../scripts/unlock_wallets.py
cd ~/biosboot/genesis/
sh genesis_start.sh

sleep 3
cleos get info
cleos create account eosio eosio.bpay EOS88zoCUmSaUYiyZLLNZyA7YJqDxyVvMvQ5F69jE5LiAHkJGfzn6
cleos create account eosio eosio.msig EOS7DTFGFTttABMQ5nP2imLRnXMNAhvBZDDX67m2H5bqxADRPL2cW
cleos create account eosio eosio.names EOS8fgro2YWCc8wwxoDMa7mFPcEjttvRBGycbGBF89G59YFNDtLiD
cleos create account eosio eosio.ram EOS7P96GArztS6HbnFKhhamGG6uLVR4Rirdt2h4jWJXQ4fmpGx8XY
cleos create account eosio eosio.ramfee EOS8gPHiLEsuot5PbRDMnipAZ19ULZb7s8YUWcTCtcUctv8sRkhk4
cleos create account eosio eosio.saving EOS6XvJesyDwcRhGN84BJPhju9DN1VR4yV2geVGWFjrcqsVdzHR6C
cleos create account eosio eosio.stake EOS8anV4mmVpHHehVDfDmrJyYiLSeruUP847shNJwo5yRjYMTg7yJ
cleos create account eosio eosio.token EOS8covVEZE7W6wyVknoqe4SeKicpSXJ2BfXT7RdGDQP3g9uCCtGv
cleos create account eosio eosio.vpay EOS75av7RYvYAJcHRmYggE8sWwvontpJ3mtbm2jKpxn5epvSFAh74
cleos create account eosio eosio.rex EOS5DZJwRJgFREgAtg4bJJzi6ezmpqbfmDRpqHRGoerm58bg2xo46
cleos set contract eosio.token ~/eosio.contracts/build/contracts/eosio.token/
cleos set contract eosio.msig ~/eosio.contracts/build/contracts/eosio.msig/
cleos push action eosio.token create '[ "eosio", "10000000000.0000 SYS" ]' -p eosio.token@active
cleos push action eosio.token issue '[ "eosio", "1000000000.0000 SYS", "memo" ]' -p eosio@active

#sudo apt remove -y eosio.cdt
#cd ~/eosio.contracts-1.8.x
#wget https://github.com/eosio/eosio.cdt/releases/download/v1.6.3/eosio.cdt_1.6.3-1-ubuntu-18.04_amd64.deb
#sudo apt install -y ./eosio.cdt_1.6.3-1-ubuntu-18.04_amd64.deb
#git checkout release/1.8.x
#./build.sh -y 
#echo "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
#sudo apt remove -y eosio.cdt
#cd ~/eosio.contracts
#wget https://github.com/eosio/eosio.cdt/releases/download/v1.7.0/eosio.cdt_1.7.0-1-ubuntu-18.04_amd64.deb
#sudo apt install ./eosio.cdt_1.7.0-1-ubuntu-18.04_amd64.deb
#cmake .
#make
cd ~/eosio.contracts-1.8.x/contracts/eosio.system/
echo "schedule_protocol_feature_activations"
curl --request POST \
    --url http://127.0.0.1:8888/v1/producer/schedule_protocol_feature_activations \
    -d '{"protocol_features_to_activate": ["0ec7e080177b2c02b278d5088611686b49d739925a92d9bfcacd7fc6b74053bd"]}'
echo "schedule_protocol_feature_activations"
sleep 1
cleos set contract eosio . eosio.system.wasm eosio.system.abi 
cleos get info
sleep 4
cleos set contract eosio . eosio.system.wasm eosio.system.abi 
cleos push action eosio activate '["f0af56d2c5a48d60a4a5b5c903edfb7db3a736a94ed589d0b797df33ff9d3e1d"]' -p eosio
cleos push action eosio activate '["2652f5f96006294109b3dd0bbde63693f55324af452b799ee137a81a905eed25"]' -p eosio
cleos push action eosio activate '["8ba52fe7a3956c5cd3a656a3174b931d3bb2abb45578befc59f283ecd816a405"]' -p eosio
cleos push action eosio activate '["ad9e3d8f650687709fd68f4b90b41f7d825a365b02c23a636cef88ac2ac00c43"]' -p eosio
cleos push action eosio activate '["68dcaa34c0517d19666e6b33add67351d8c5f69e999ca1e37931bc410a297428"]' -p eosio
cleos push action eosio activate '["e0fb64b1085cc5538970158d05a009c24e276fb94e1a0bf6a528b48fbc4ff526"]' -p eosio
cleos push action eosio activate '["ef43112c6543b88db2283a2e077278c315ae2c84719a8b25f25cc88565fbea99"]' -p eosio
cleos push action eosio activate '["4a90c00d55454dc5b059055ca213579c6ea856967712a56017487886a4d4cc0f"]' -p eosio
cleos push action eosio activate '["1a99a59d87e06e09ec5b028a9cbb7749b4a5ad8819004365d02dc4379a8b7241"]' -p eosio
cleos push action eosio activate '["4e7bf348da00a945489b2a681749eb56f5de00b900014e137ddae39f48f69d67"]' -p eosio
cleos push action eosio activate '["4fca8bd82bbd181e714e283f83e1b45d95ca5af40fb89ad3977b653c448f78c2"]' -p eosio
cleos push action eosio activate '["299dcb6af692324b899b39f16d5a530a33062804e41f09dc97e9f156b4476707"]' -p eosio

cd ~/eosio.contracts/contracts/eosio.system
ls
sleep 4
cleos set contract eosio . eosio.system.wasm eosio.system.abi