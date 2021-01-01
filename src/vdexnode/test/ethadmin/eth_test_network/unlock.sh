#["0x1957ce2d67aeeefd47fbaea5bc37faa7a0a537a8","0x867bc02711e94b7d848b8423f07ac99e0db5b735"]
curl --data '{"method":"personal_unlockAccount","params":["0x1957ce2d67aeeefd47fbaea5bc37faa7a0a537a8","hunter2",null],"id":1,"jsonrpc":"2.0"}' -H "Content-Type: application/json" -X POST localhost:8540
#curl --data '{"method":"personal_unlockAccount","params":["0x867bc02711e94b7d848b8423f07ac99e0db5b735","hunter2",null],"id":1,"jsonrpc":"2.0"}' -H "Content-Type: application/json" -X POST localhost:8540
