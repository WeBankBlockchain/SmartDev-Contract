import { ethers } from "hardhat";

async function signatureTest(){

    const signer = new ethers.Wallet("0x8da4ef21b864d2cc526dbdb2a120bd2874c36c9d0a1fb7f8c63d7f7a8b41de8f")
    var s = await signer.signMessage("helloworlcccd");
    console.log('Signature:', s);
    console.log(await signer.getAddress())
    
    console.log("r")
     var result = ethers.verifyMessage("helloworlcccd", s)
    
    console.log(result)
    
    const coder = new ethers.AbiCoder;
     var result2 = ethers.verifyMessage(
        //ethers.utils.defaultAbiCoder.encode(["address", "address", "uint128"],["", "","1681896291067604606"]),
        ""+""+"1681896291067604606",
        "0x2efa516bd84b8b84f5782c1dce4e8cf6decf67f9d016b702255dfa603df76aa4351dd91b75464df10410e721c158c16ea27bca38bf05211805f73bfc6a26de2d1b")
    console.log(result2)
    
    }
    
async function main(){
    await signatureTest();

   const encodeRes =  (new ethers.AbiCoder).encode(["address", "address", "uint128"],["", "","1681896291067604606"])
   console.log(encodeRes)
   const shaRes = ethers.keccak256(encodeRes);
   console.log("shaRes=", shaRes);
   const bytesRes = ethers.getBytes(shaRes);
   console.log("bytesRes=", bytesRes);

}
    
main()