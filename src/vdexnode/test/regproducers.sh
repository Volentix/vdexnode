WORD="$ID"
MATCH="to_change"
# echo "|____________________________________________________________________________________________________________________________________________|"
PAYLOAD='{"producer":"v11111111111","producer_name":"v11111111111","url":"","key":"EOS6p2vZXiRpzz7FKhMtxFpKVKNZfnNb27coTJgSUZE4KzeSDdoCZ","node_id":1234,"job_ids":[1,2]}'
PAYLOAD=$(echo "$PAYLOAD" | sed "s/$MATCH/$WORD/g")
cleos --url  http://140.82.56.143:8888 push action volentixvote regproducer $PAYLOAD -p v11111111111@active
PAYLOAD='{"producer":"v22222222222","producer_name":"v22222222222","url":"https://www.facebook.com/weirdal/","key":"EOS5ygr9wmVQbUmQBCLMebHx5hCkjs1vLEnUzYVp6nDiTFvP2uVfM","node_id":"1a2b3bc4d5e6f7g8h9i1j0k1l1m1n2o1p3q","job_ids":[1]}'
cleos --url  http://140.82.56.143:8888 push action volentixvote regproducer $PAYLOAD -p v22222222222@active
PAYLOAD='{"producer":"v33333333333","producer_name":"v33333333333","url":"https://www.investopedia.com/terms/s/satoshi-nakamoto.asp","key":"EOS5EYGEkiKUXRQ21eCcKgjv1uhtyVsx88njnR6urPYHGEZbkKmk1","node_id":"1a2b3bc4d5e6f7g8h9i1j0k1l1m1n2o1p3q","job_ids":[1,2]}'
PAYLOAD=$(echo "$PAYLOAD" | sed "s/$MATCH/$WORD/g")
