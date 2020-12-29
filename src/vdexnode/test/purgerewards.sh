n=1
while [ $n -le 5 ]
do
#    echo "Uptime_____________________________________"
#    PAYLOAD='{"account":"v11111111111","job_ids":[1,2],"node_id":to_change,"memo":"1"}'
#    PAYLOAD=$(echo "$PAYLOAD" | sed "s/$MATCH/$WORD/g")
#    echo "$PAYLOAD"
#    cleos --url  http://140.82.56.143:8888 push action vistribution uptime $PAYLOAD -p v11111111111@active
#    sleep 1
#    PAYLOAD='{"account":"v22222222222","job_ids":[1],"node_id":to_change,"memo":"2"}'
#    PAYLOAD=$(echo "$PAYLOAD" | sed "s/$MATCH/$WORD/g")
#    echo "$PAYLOAD"
#
    # cleos --url  http://140.82.56.143:8888 push action vistribution getreward '{"node": "berthonytha2"}' -p vistribution@active
    cleos --url  http://140.82.56.143:8888 push action vistribution getreward '{"node": "berthonytha1"}' -p vistribution@active
    # cleos --url  http://140.82.56.143:8888 push action vistribution getreward '{"node": "v11111111111"}' -p vistribution@active
    # cleos --url  http://140.82.56.143:8888 push action vistribution getreward '{"node": "v22222222222"}' -p vistribution@active
    # cleos --url  http://140.82.56.143:8888 push action vistribution getreward '{"node": "v3333333333"}' -p vistribution@active
done
