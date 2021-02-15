const Web3 =  require('web3')
const fs = require('fs');
const oe = "http://localhost:8540";
var web3 = new Web3(oe);
const address = '0xb269c357ce08dbbc80b021d9024b07bd66585885';
var jsonFile = "build/contracts/VTX.json";
var truffleFile = JSON.parse(fs.readFileSync(jsonFile));
abi = truffleFile['abi']
bytecode = truffleFile['bytecode']
var MyContract = new web3.eth.Contract(abi, address);
MyContract.methods.symbol().call()
.then(console.log);
