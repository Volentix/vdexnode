const Web3 =  require('web3')
const fs = require('fs');
const oe = "http://localhost:8540";
var web3 = new Web3(oe);
var jsonFile = "build/contracts/VTX.json";
var truffleFile = JSON.parse(fs.readFileSync(jsonFile));
abi = truffleFile['abi']
bytecode = truffleFile['bytecode']
const privKey = '0x1db2c0cf57505d0f4a3d589414f0a0025ca97421d2cd596a9486bc7e2cd2bf8b'; // Genesis private key
const address = '0x511bfda122bfff8df03bcfa6fca082e341f06ee6';
const account = '0x511bfda122bfff8df03bcfa6fca082e341f06ee6';

function deploy_contract(){
    const myContract = new web3.eth.Contract(abi);
    myContract.deploy({data:bytecode}).send({
      from:"0x87a8ad840b5787c8033979b0d67ed40c6952a719",
        gas: 4700000
    },(err,res) => {
        if(err){
            console.log(err);
        }
        if(res){
            console.log(res);
        }
   })
    
}
deploy_contract();
