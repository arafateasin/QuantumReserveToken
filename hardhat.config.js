require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config(); // <-- Load .env

module.exports = {
  solidity: "0.8.25",
  networks: {
    sepolia: {
      url: `https://sepolia.infura.io/v3/${process.env.INFURA_KEY}`,
      accounts: [process.env.PRIVATE_KEY],
    },
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY,
  },
};
