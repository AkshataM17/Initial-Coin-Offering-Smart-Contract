const {ethers} = require("hardhat");
const {CRYPTODEVS_CONTRACT_ADDRESS} = require("../constants");

async function main(){

  const cryptoDevsNFTContract = CRYPTODEVS_CONTRACT_ADDRESS;
  const ICOContract = await ethers.getContractFactory("CryptoDevToken");
  const ICOContractDeploy = await ICOContract.deploy(cryptoDevsNFTContract);

  await ICOContractDeploy.deployed();

  console.log("DEloyed contract address is:", ICOContractDeploy.address);
}

main()
.then(() => {
  console.log("contract successfully deploying....")
  process.exit(0);
})
.catch((err) => {
  console.error(err);
  process.exit(1);
})