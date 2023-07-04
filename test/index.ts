import { expect } from "chai";
import { Contract, ContractTransactionReceipt } from "ethers";
import { ethers } from "hardhat"


describe("NFTMarket ",() => {
    
        let nftMarket : Contract;
        
        before(async () =>{ 
        const NFTMarket = await ethers.getContractFactory("NFTMarket");
        const nftMarket = await NFTMarket.deploy();
      return {
        nftMarket
      }
    })
    describe("createNFT", () =>{
        it("Should do something" ,async () => {
            const tokenURI = "https://some-token.uri/";
            const transaction = await nftMarket.createNFT(tokenURI);
            const receipt = await transaction.wait();
        })
    })
        
});
