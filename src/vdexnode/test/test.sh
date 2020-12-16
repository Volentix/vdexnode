OWNER_ACCOUNT=511bfda122bfff8df03bcfa6fca082e341f06ee6
CONTRACT_ADDRESS=0xf5B719378261d911a788E1498fCE36308EB9caff

# Remove first 2 characteres
#OWNER_ACCOUNT=${OWNER_ACCOUNT:2}

# Create TX data: FUNCTION SELECTOR + OWNER_ACCOUNT
TX_DATA="0x70a08231000000000000000000000000$OWNER_ACCOUNT"

curl localhost:8540 \
  -H "Content-Type: application/json" \
  -X POST \
  --data '{
    "id": 1,
    "jsonrpc":"2.0",
    "method": "eth_call",
    "params": [{
      "to": "'$CONTRACT_ADDRESS'",
      "data": "'$TX_DATA'"
    }]
  }'
