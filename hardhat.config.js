require("dotenv").config();

/**
 * Jakoverse Contracts – Hardhat config (minimal)
 */

module.exports = {
  solidity: "0.8.24",

  networks: {
    baseSepolia: {
      // You can fill these later when you want CLI deploys instead of Remix
      url: process.env.BASE_RPC_URL || "",
      accounts: process.env.BASE_PRIVATE_KEY
        ? [process.env.BASE_PRIVATE_KEY]
        : [],
    },
  },
};
