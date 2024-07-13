require('dotenv').config();
require("@nomiclabs/hardhat-ethers");
require("@nomiclabs/hardhat-etherscan");

module.exports = {
  defaultNetwork: "laTestnet",
  networks: {
    hardhat: {},
    lachain: {
      url: "https://rpc1.mainnet.lachain.network",
      accounts: [process.env.PRIVATE_KEY]
    },
    laTestnet: {
      url: "https://rpc.testnet.lachain.network",
      chainId: 418,
      accounts: [process.env.PRIVATE_KEY]
    }
  },
  solidity: {
    version: "0.8.19",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts"
  },
  mocha: {
    timeout: 40000
  },
  etherscan: {
    apiKey: {
      laTestnet: process.env.LACHAIN_API_KEY
    },
    customChains: [
      {
        network: "laTestnet",
        chainId: 418,
        urls: {
          apiURL: "https://explorer.testnet.lachain.network/api",
          browserURL: "https://explorer.testnet.lachain.network"
        }
      }
    ]
  },
  sourcify: {
    enabled: true,
    apiUrl: "https://sourcify.dev/server",
    browserUrl: "https://repo.sourcify.dev"
  }
};
