#apt-get install -y python 3.x cmake git g++ build-essential python3-pip openssl curl jq psmisc
# exec nodeos -e -p eosio --disable-replay-opts --delete-all-blocks --contracts-console --chain-state-history  --verbose-http-errors 2> /dev/pts/2& 
python3 ../scripts/unlock_wallets.py
sh genesis_start.sh
# eosio.bpay
# eosio.msig
# eosio.names
# eosio.ram
# eosio.ramfee
# eosio.saving
# eosio.stake
# eosio.token
# eosio.vpay
# eosio.rex
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


