FROM_ACCOUNT=0x511bfda122bfff8df03bcfa6fca082e341f06ee6
TO_ACCOUNT=1957ce2d67aeeefd47fbaea5bc37faa7a0a537a8
CONTRACT_ADDRESS=0xf5B719378261d911a788E1498fCE36308EB9caff
AMOUNT=100

# Convert amount to 256bit hexdecimal
AMOUNT=$(printf "%064x" $AMOUNT)

# Create TX data: FUNCTION SELECTOR + TO_ACCOUNT + AMOUNT
TX_DATA="0xa9059cbb000000000000000000000000$TO_ACCOUNT$AMOUNT"

curl localhost:8540 \
  -H "Content-Type: application/json" \
  -X POST \
  --data '{
    "id": 1,
    "jsonrpc":"2.0",
    "method": "eth_sendTransaction",
    "params": [{
      "from": "'$FROM_ACCOUNT'",
      "to": "'$CONTRACT_ADDRESS'",
      "gas": "0xfffff",
      "gasPrice": "0x9184e72a000",
      "value": "0x0",
      "data": "'$TX_DATA'"
    }]
  }'
