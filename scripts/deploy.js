// scripts/deploy.js
//
// Minimal deploy script for JakoverseLands on Base Sepolia

const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();

  console.log("Deploying JakoverseLands with account:", deployer.address);
  console.log("Network:", hre.network.name);

  const name = "Jakoverse Lands - Pack 1";
  const symbol = "JVL1";
  const maxSupply = 500;
  const baseURI = "ipfs://JAKOVERSE_LANDS_PACK1_PLACEHOLDER/"; // same as in Remix

  const lands = await hre.ethers.deployContract("JakoverseLands", [
    name,
    symbol,
    maxSupply,
    baseURI,
  ]);

  await lands.waitForDeployment();

  const addr = await lands.getAddress();
  console.log("JakoverseLands deployed to:", addr);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
