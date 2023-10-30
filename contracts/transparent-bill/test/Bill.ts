import {
  time,
  loadFixture,
} from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";
import hre from "hardhat";

describe("Bill", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  async function deployBillFixture() {

    // Contracts are deployed using the first signer/account by default
    const [user1, user2] = await ethers.getSigners()
    // const signer = new ethers.Wallet("0x8da4ef21b864d2cc526dbdb2a120bd2874c36c9d0a1fb7f8c63d7f7a8b41de8f");
    
    const Bill = await ethers.getContractFactory("Bill");
    const bill = await Bill.deploy();
    await bill.setSigner(user1.address)
    
    return { bill, user1, user2 };
  }

    describe("Deployment", function () {
      it("Should set the right signer address", async function () {
        const { bill,user1 } = await loadFixture(deployBillFixture);
        const d = await bill.signer();
        expect(await bill.signer()).to.equal(user1.address);
      });

    });
    
    describe("verify", function () {
      it("Should equal the signer address", async function () {
        const { bill, user1, user2 } = await loadFixture(deployBillFixture);
        
        const add1 = await user1.getAddress()
        const add2 = await user2.getAddress()
        console.log(add1, add2)

        // customerB sign
        const encodeRes =  (new ethers.AbiCoder).encode(["address", "uint128"],[add2,"10000"])
        const shaRes = ethers.keccak256(encodeRes)
        
        const signature = await user1.signMessage(shaRes);
        const ethSigner = ethers.verifyMessage(shaRes, signature);
        console.log("signer:",ethSigner);
       
        const rawSignature = (new ethers.SigningKey(hre.network.config.accounts[0].privateKey)).sign(shaRes).serialized
        // const rawSignature = signer.signingKey.sign(shaRes).serialized;
        const rawAdd = ethers.recoverAddress(shaRes,rawSignature);
        console.log("raw:",rawSignature, rawAdd)

        // customerA verify
        const add = await bill.connect(user2).verify("10000", rawSignature);
        console.log("recoverSignerAddr:", add)
        expect(add).to.equal(add1);
      });

    });


});