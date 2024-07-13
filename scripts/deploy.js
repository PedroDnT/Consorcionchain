const hre = require("hardhat");

async function main() {
  // Get the contract factory
  const EnhancedConsorcioManager = await hre.ethers.getContractFactory("EnhancedConsorcioManager");

  // Deploy the contract
  const enhancedConsorcioManager = await EnhancedConsorcioManager.deploy();

  // Wait for the contract to be deployed
  await enhancedConsorcioManager.deployed();

  console.log("EnhancedConsorcioManager deployed to:", enhancedConsorcioManager.address);
}

// Run the deployment
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
