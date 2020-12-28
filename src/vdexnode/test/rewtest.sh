sh setrewardruleon.sh 
sleep 10
PAYLOAD='{"account":"v11111111111","job_ids":[1,2],"node_id":1,"memo":"1"}'
cleos --url  http://140.82.56.143:8888 push action vistribution uptime $PAYLOAD -p v11111111111@active
sh setrewardruleoff.sh 
