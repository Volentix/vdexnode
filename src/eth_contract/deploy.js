// scripts/deploy.js
async function main() {
  // We get the contract to deploy
  const VTXToken = await ethers.getContractFactory("VTXToken.sol");
  console.log("Deploying VTX Token...");
  const vtxtoken = await VTXToken.deploy();
  await vtxtoken.deployed();
  console.log("VTX Token deployed to:", vtxtoken.address);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.out("Test @@@@@@@@");
    console.error(error);
    process.exit(1);
  });
