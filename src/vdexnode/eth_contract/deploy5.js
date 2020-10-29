const Web3 =  require('web3')
const fs = require('fs');
const oe = "http://localhost:8540";
const options = {
  transactionConfirmationBlocks: 1
};
var web3 = new Web3(oe, null, options);
var jsonFile = "build/contracts/VTX.json";
var truffleFile = JSON.parse(fs.readFileSync(jsonFile));
abi = truffleFile['abi']
bytecode = truffleFile['bytecode']
let code = bytecode;
const myContract = new web3.eth.Contract(abi);
var test;


async function deploy_contract(){
    var test = await myContract.deploy({data:bytecode}).send({
      //from:"0xb269c357ce08dbbc80b021d9024b07bd66585885",
      from:"0x867bc02711e94b7d848b8423f07ac99e0db5b735",
        gas: 0
    },async function(error, transactionHash){
	var address = await web3.eth.getTransaction(transactionHash);
	  console.log(address.creates);
	  web3.eth.getBalance(address.creates)
	   .then(console.log);
	    var handleReceipt = (error, receipt) => {
  		if (error) console.error(error);
  		else {
    		//console.log(receipt);
    		res.json(receipt);
  		}
	   }
	   //web3.eth.sendTransaction({
 	   //from: '0xb269c357ce08dbbc80b021d9024b07bd66585885',
 	   //to: address.from,
 	   //value: web3.utils.toWei("0.5", "ether")
	  //}, handleReceipt);
	  //web3.eth.getBalance(address.to)
          //.then(console.log);  
	  //  var testContract = new web3.eth.Contract(abi, address.from);
	 //   web3.eth.getCode(address.from)
	  //  .then(console.log);
	  //  web3.eth.isSyncing().then(console.log);
	  //  web3.eth.getAccounts()
	  //  .then(console.log);
	  //  var receipt = web3.eth.getTransactionReceipt(transactionHash)
	  //  .then(console.log);
	   // console.log("Methods", Object.keys(testContract.methods));
	   // console.log("Value of a: ", await testContract.methods.name().call());

    }).on('transactionHash', async function(transactionHash){ 
    	//var address = await web3.eth.getTransaction(transactionHash);
          //console.log(address.to);
    });
}

async function main(){
	var th = await deploy_contract();
//	console.log(th, 'here');
}
main();
function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}
