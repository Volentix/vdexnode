const Web3 =  require('web3')
const fs = require('fs');
const oe = "http://localhost:8540";
var web3 = new Web3(oe);
var jsonFile = "build/contracts/VTX.json";
var truffleFile = JSON.parse(fs.readFileSync(jsonFile));
abi = truffleFile['abi']
bytecode = truffleFile['bytecode']
let code = '0x' + bytecode;
async function deploy_contract(){
    const myContract = new web3.eth.Contract(abi);
    myContract.deploy({data:bytecode}).send({
      from:"0xb269c357ce08dbbc80b021d9024b07bd66585885",
        gas: 4600000
    },(err,res) => {
        if(err){
            console.log(err);
		console.log("error!!!!!!!");
        }
        if(res){
            console.log(res);
		console.log("Great success!!!!");
        }
   })
	.on('error', function(error){ console.log("error")})
.on('transactionHash', function(transactionHash){ console.log(transactionHash)})
.on('receipt', function(receipt){
   console.log(receipt.contractAddress) // contains the new contract address
})
.on('confirmation', function(confirmationNumber, receipt){ consoel.log(confirmationNumber) })
.then(function(myContract){
    console.log(myContract.options.address) // instance with the new contract address
});
	

	
	//await sleep(2000);	
 //web3.eth.getCode("0xb269c357ce08dbbc80b021d9024b07bd66585885").then(console.log);	
 //web3.eth.getBalance("0xb269c357ce08dbbc80b021d9024b07bd66585885").then(console.log);	
    
}
deploy_contract();

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}
