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
//let deploy_contract = new Contract(JSON.parse(abi));
const deploy = async () => {
   console.log('Attempting to deploy from account:', address);
   const incrementer = new web3.eth.Contract(abi);
   const incrementerTx = incrementer.deploy({
      data: bytecode,
    //  arguments: [5],
   });

   const createTransaction = await web3.eth.accounts.signTransaction(
      {
         from: address,
         data: incrementerTx.encodeABI(),
         gas: '1017414',
      },
      privKey
   );

  const createReceipt = web3.eth.sendSignedTransaction(
      createTransaction.rawTransaction
   );
   console.log('Contract deployed at address', createReceipt.contractAddress);
};

// deploy();



//let account = '0xb269c357ce08dbbc80b021d9024b07bd66585885';
//Function Parameter
 let payload = {
    data: bytecode
 }
let parameter = {
    from: account,
    gas: web3.utils.toHex(800000),
    gasPrice: web3.utils.toHex(web3.utils.toWei('30', 'gwei'))
}
//Function Call
deploy_contract.deploy(payload).send(parameter, (err, transactionHash) => {
   console.log('Transaction Hash :', transactionHash);
}).on('confirmation', () => {}).then((newContractInstance) => {
   console.log('Deployed Contract Address : ', newContractInstance.options.address);
})

