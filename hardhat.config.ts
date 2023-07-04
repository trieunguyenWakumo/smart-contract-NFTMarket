import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "dotenv/config"


const PRIVATE_kEY = "0x387f11eB47b0D7dcB20B9A2CA255d3B3C492a584"
const config: HardhatUserConfig = {
  solidity: "0.8.18",
  networks: {
    mumbai: {
      chainId: 80001,
      url: 'https://rpc.ankr.com/polygon_mumbai',
      accounts: [PRIVATE_kEY]
    },}
};

export default config;
