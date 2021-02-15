//["0x511bfda122bfff8df03bcfa6fca082e341f06ee6","0x867bc02711e94b7d848b8423f07ac99e0db5b735","0xb269c357ce08dbbc80b021d9024b07bd66585885"]
curl --data '{"method":"personal_unlockAccount","params":["0x511bfda122bfff8df03bcfa6fca082e341f06ee6","hunter2",null],"id":1,"jsonrpc":"2.0"}' -H "Content-Type: application/json" -X POST localhost:8540
curl --data '{"method":"personal_unlockAccount","params":["0x867bc02711e94b7d848b8423f07ac99e0db5b735","hunter2",null],"id":1,"jsonrpc":"2.0"}' -H "Content-Type: application/json" -X POST localhost:8540
curl --data '{"method":"personal_unlockAccount","params":["0xb269c357ce08dbbc80b021d9024b07bd66585885","hunter0",null],"id":1,"jsonrpc":"2.0"}' -H "Content-Type: application/json" -X POST localhost:8540
