cleos --url  http://140.82.56.143:8888 push action vistribution setrewardrule '{"rule":{"reward_id":"1","reward_period":"10","reward_amount":"10.00000000 VTX","standby_amount":"2.00000000 VTX","rank_threshold":"1","standby_rank_threshold":"10", "memo":"","standby_memo":""}}' -p vistribution@active
cleos --url  http://140.82.56.143:8888 push action vistribution setrewardrule '{"rule":{"reward_id":"2","reward_period":"10","reward_amount":"66.00000000 VTX","standby_amount":"2.00000000 VTX","rank_threshold":"1","standby_rank_threshold":"10", "memo":"","standby_memo":""}}' -p vistribution@active
n=1
while [ $n -le 5 ]
do
    WORD="10101010101010"
    MATCH="to_change"
    
    
    
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


   
   
    n = n+1
done
cleos --url  http://140.82.56.143:8888 push action vistribution setrewardrule '{"rule":{"reward_id":"2","reward_period":"1000000","reward_amount":"66.00000000 VTX","standby_amount":"2.00000000 VTX","rank_threshold":"0","standby_rank_threshold":"0", "memo":"Oracle","standby_memo":"Oracle"}}' -p vistribution@active
cleos --url  http://140.82.56.143:8888 push action vistribution setrewardrule '{"rule":{"reward_id":"1","reward_period":"1000000","reward_amount":"10.00000000 VTX","standby_amount":"2.00000000 VTX","rank_threshold":"0","standby_rank_threshold":"0", "memo":"Voting","standby_memo":"Voting"}}' -p vistribution@active