// scripts/deploy.js
const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying contract with account:", deployer.address);

  const name = "QuantumReserveToken";
  const symbol = "QRT";
  const cap = hre.ethers.parseUnits("1000000", 18); // 1 million QRT

  const Token = await hre.ethers.getContractFactory("QuantumReserveToken");
  const token = await Token.deploy(name, symbol, cap);

  await token.waitForDeployment(); // replaces `token.deployed()` in Ethers v6+

  console.log(`Token deployed to: ${token.target}`);
}

main().catch((error) => {
  console.error(" Deployment error:", error);
  process.exitCode = 1;
});
