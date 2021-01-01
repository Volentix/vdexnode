require('dotenv').config();
var Web3 = require('web3');
// var Tx = require('ethereumjs-tx');
var Tx = require("ethereumjs-tx").Transaction;
const json  = require("../oracle/VTX.json");
var EthUtil = require('ethereumjs-util');
var Wallet = require('ethereumjs-wallet');
// const web3= new Web3('http://127.0.0.1:8545');
const web3 = new Web3('https://ropsten.infura.io/v3/c3436ae558954d85ae242a2ea517475c')
// var web3 = new Web3(new Web3.providers.HttpProvider('http://127.0.0.1:8545/'))
// const web3 = new Web3(new Web3.providers.HttpProvider("https://ropsten-rpc.linkpool.io/"));
const main = async () => {
    var myAddress = "0x7D5592066FAE5cC14a62477EEb5074036610415c";
    var destAddress = "0x0f36bE29953148490CFc3C8150100Ae94C10A9eF";
    // var transferAmount = 10000000000; //.00000001
    var transferAmount = 1000000000000000000; //1
    // transferAmount = transferAmount.toString();
    var contractAddress = "0x71c5a83193399b15417ffda7f9406cd72f311d8a";//ropsten
    const contract = new web3.eth.Contract(json.abi, contractAddress);
    new_vtx_balance = contract.methods.balanceOf(myAddress).call((err, result) => {}); 
    new_vtx_balance = await new_vtx_balance;
    console.log(new_vtx_balance);
    var balance = await contract.methods.balanceOf(myAddress).call();
    console.log(balance);
    var count = await web3.eth.getTransactionCount(myAddress);
    console.log(`num transactions so far: ${count}`);
    count = count+1;
        
    var gasPriceGwei = 60;
    var gasLimit = 4000000;
    // Chain ID of Ropsten Test Net is 3, replace it to 1 for Main Net
    var chainId = 3;
    var rawTransaction = {
        "from": myAddress,
        "nonce": "0x" + count.toString(16),
        "gasPrice": web3.utils.toHex(gasPriceGwei * 1e9),
        "gasLimit": web3.utils.toHex(gasLimit),
        "to": contractAddress,
        "value": "0x0",
        "data": contract.methods.transfer(destAddress, transferAmount.toString()).encodeABI(),
        "chainId": chainId
    };
    console.log(`Raw of Transaction: \n${JSON.stringify(rawTransaction, null, '\t')}\n------------------------`);
    var privKey = '0x27c4cd052d31bc4006a8d2f51580cd06117933b2e0dea81c4cb35efad88dc3f0';
    // privateKeyBuffer = EthUtil.toBuffer(privKey);
    privateKeyBuffer = Buffer.from(privKey.slice(2), "hex")
    // var tx = new Tx(rawTransaction);
    var tx = new Tx(rawTransaction, {'chain':'ropsten'});
    tx.sign(privateKeyBuffer);
    var serializedTx = tx.serialize();
    console.log(`Attempting to send signed tx:  ${serializedTx.toString('hex')}\n------------------------`);
    var receipt = await web3.eth.sendSignedTransaction('0x' + serializedTx.toString('hex'));
    console.log(`Receipt info: \n${JSON.stringify(receipt, null, '\t')}\n------------------------`);
    // The balance may not be updated yet, but let's check
    balance = await contract.methods.balanceOf(myAddress).call();
    console.log(balance);
}
main();