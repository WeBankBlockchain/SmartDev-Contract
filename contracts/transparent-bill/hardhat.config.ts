import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

const config: HardhatUserConfig = {
  solidity: "0.8.20",
  networks:{hardhat:{
    accounts:[
      {
        privateKey: "0x33fd9f168033609f9c977d11facf3f359479445409e7d16612af456bac7417e8",
        balance: "8250000000000000000000000000000000000",
      },
      {
        privateKey: "0x8a512a70e5a608c78f008ed636cc538d70e46ac2098d09aa21d6fe9fb7537993",
        balance: "8250000000000000000000000000000000000",
      },
      {
        balance: "8250000000000000000000000000000000000",
        privateKey: "0x8da4ef21b864d2cc526dbdb2a120bd2874c36c9d0a1fb7f8c63d7f7a8b41de8f"
      },
      {
        balance: "8250000000000000000000000000000000000",
        privateKey: "0x8da4ef21b864d2cc526dbdb2a120bd2874c36c9d0a1fb7f8c63d7f7a8b41de8e"
      },
    ]
  }}
};

export default config;
