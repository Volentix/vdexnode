
(async () => {
const Web3 =  require('web3')
const fs = require('fs');
const oe = "http://localhost:8540";
var web3 = new Web3(oe);
var jsonFile = "build/contracts/VTX.json";
var truffleFile = JSON.parse(fs.readFileSync(jsonFile));
abi = truffleFile['abi']
bytecode = truffleFile['bytecode']
let code = bytecode;
const contract = new web3.eth.Contract(abi);
account1 = '0x867Bc02711E94b7D848b8423f07Ac99E0Db5B735e'
privateKey1 = 'd11f9dc2c257e52bdc386a6a950701805bd942c70130b858d97cae91ec00e620'
const params = {
    data: '0x' + bytecode,
    arguments: [account1]
};
const transaction = contract.deploy(params);
const options = {
    data: transaction.encodeABI(),
    gas: await transaction.estimateGas({from: account1})
};
console.log(options)
const signed = await web3.eth.accounts.signTransaction(options, privateKey1);
const receipt = await web3.eth.sendSignedTransaction(signed.rawTransaction).then(console.log);
console.log(`Contract deployed at address: ${receipt.contractAddress}`);
})()
