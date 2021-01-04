#cleos --url  http://140.82.56.143:8888 push action volentixtsys transfer '{"from":"v11111111111", "to":"volentixstak", "quantity":"10000.00000000 VTX", "memo":"1"}' -p v11111111111@active
WORD="test"
MATCH="to_change"
echo "|____________________________________________________________________________________________________________________________________________|"
PAYLOAD='{"producer":"v11111111111","producer_name":"v11111111111","url":"https://ca.linkedin.com/in/sylvain-cormier-0592805?challengeId=AQGxyq1T82aaFgAAAXTZnJr9dxcc_QYJcrXQPqU8IJoUmXhDNY2IWtRDXf5R3CRTPrGPshqGewv4F4Gml-X20cQX-XuVkxaw9Q&submissionId=7d9297ca-7d3d-3916-7ed9-4b6721432015","key":"EOS6p2vZXiRpzz7FKhMtxFpKVKNZfnNb27coTJgSUZE4KzeSDdoCZ","node_id":to_change,"job_ids":[1,2]}'
PAYLOAD=$(echo "$PAYLOAD" | sed "s/$MATCH/$WORD/g")
cleos --url  http://140.82.56.143:8888 push action volentixvote regproducer $PAYLOAD -p v11111111111@active
PAYLOAD='{"producer":"v22222222222","producer_name":"v22222222222","url":"https://www.facebook.com/weirdal/","key":"EOS5ygr9wmVQbUmQBCLMebHx5hCkjs1vLEnUzYVp6nDiTFvP2uVfM","node_id":"1a2b3bc4d5e6f7g8h9i1j0k1l1m1n2o1p3q","job_ids":[1,2]}'
cleos --url  http://140.82.56.143:8888 push action volentixvote regproducer $PAYLOAD -p v22222222222@active
PAYLOAD='{"producer":"v33333333333","producer_name":"v33333333333","url":"https://www.investopedia.com/terms/s/satoshi-nakamoto.asp","key":"EOS5EYGEkiKUXRQ21eCcKgjv1uhtyVsx88njnR6urPYHGEZbkKmk1","node_id":"1a2b3bc4d5e6f7g8h9i1j0k1l1m1n2o1p3q","job_ids":[1,2]}'
PAYLOAD=$(echo "$PAYLOAD" | sed "s/$MATCH/$WORD/g")
cleos --url  http://140.82.56.143:8888 push action volentixvote regproducer $PAYLOAD -p v33333333333@active
cleos --url  http://140.82.56.143:8888 push action vistribution setrewardrule '{"rule":{"reward_id":"1","reward_period":"10","reward_amount":"10.00000000 VTX","standby_amount":"2.00000000 VTX","rank_threshold":"5","standby_rank_threshold":"10", "memo":"Oracle","standby_memo":"Oracle standby"}}' -p vistribution@active
cleos --url  http://140.82.56.143:8888 push action vistribution setrewardrule '{"rule":{"reward_id":"2","reward_period":"10","reward_amount":"66.00000000 VTX","standby_amount":"2.00000000 VTX","rank_threshold":"5","standby_rank_threshold":"10", "memo":"Vote","standby_memo":"Vote standby"}}' -p vistribution@active
n=1
cleos --url  http://140.82.56.143:8888 get currency balance volentixtsys v11111111111
while [ $n -le 5 ]
do
    WORD="10101010101010"
    MATCH="to_change"
    # Vote for oneself//To do not working
    cleos --url  http://140.82.56.143:8888 push action volentixvote voteproducer  '{"voter_name": "v11111111111", "producers":["v22222222222"]}' -p v11111111111@active 
    cleos --url  http://140.82.56.143:8888 push action volentixvote voteproducer  '{"voter_name": "v22222222222", "producers":["v33333333333"]}' -p v22222222222@active 
    cleos --url  http://140.82.56.143:8888 push action volentixvote voteproducer  '{"voter_name": "v33333333333", "producers":["v22222222222"]}' -p v33333333333@active 

    PAYLOAD='{"account":"v11111111111","job_ids":[1,2],"node_id":1,"memo":"1"}'
    cleos --url  http://199.247.30.155:8888 get table vistribution vistribution rewardhistor
    cleos --url  http://199.247.30.155:8888 get table vistribution vistribution nodereward
    cleos --url  http://140.82.56.143:8888 push action vistribution uptime $PAYLOAD -p v11111111111@active
    
    # sleep 1
    # cleos --url  http://140.82.56.143:8888 push action vistribution uptime $PAYLOAD -p v11111111111@active
    # sleep 1
    # cleos --url  http://140.82.56.143:8888 push action vistribution uptime $PAYLOAD -p v11111111111@active
    # sleep 1
    # cleos --url  http://140.82.56.143:8888 push action vistribution uptime $PAYLOAD -p v11111111111@active
    cleos --url  http://199.247.30.155:8888 get table vistribution vistribution rewardhistor
    cleos --url  http://199.247.30.155:8888 get table vistribution vistribution nodereward


   
cleos --url  http://140.82.56.143:8888 get currency balance volentixtsys v11111111111   

done

cleos --url  http://140.82.56.143:8888 push action vistribution setrewardrule '{"rule":{"reward_id":"2","reward_period":"1000000","reward_amount":"66.00000000 VTX","standby_amount":"2.00000000 VTX","rank_threshold":"0","standby_rank_threshold":"0", "memo":"Oracle","standby_memo":"Oracle"}}' -p vistribution@active
cleos --url  http://140.82.56.143:8888 push action vistribution setrewardrule '{"rule":{"reward_id":"1","reward_period":"1000000","reward_amount":"10.00000000 VTX","standby_amount":"2.00000000 VTX","rank_threshold":"0","standby_rank_threshold":"0", "memo":"Voting","standby_memo":"Voting"}}' -p vistribution@active