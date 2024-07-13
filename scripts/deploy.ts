import { ethers, run } from "hardhat";
import { config as dotenvConfig } from "dotenv";
dotenvConfig();

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying with the account:", deployer.address);

  // Get the contract factory
  const EnhancedConsorcioManager = await ethers.getContractFactory("EnhancedConsorcioManager");

  // Deploy the contract
  const enhancedConsorcioManager = await EnhancedConsorcioManager.deploy();

  // Wait for the contract to be deployed
  await enhancedConsorcioManager.deployed();

  console.log("EnhancedConsorcioManager deployed to:", enhancedConsorcioManager.address);

  // Verify the contract on Etherscan
  console.log("Verifying contract on LAChain Explorer...");
  await run("verify:verify", {
    address: enhancedConsorcioManager.address,
    constructorArguments: [],
    network: "laTestnet"
  });
}

// Run the deployment
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
