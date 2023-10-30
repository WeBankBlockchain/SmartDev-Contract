pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract Bill{
    using ECDSA for bytes32;
    event SignatureVerified(address signer, bool valid);

     address public signer;

    constructor() {
        // signer = 0x63FaC9201494f0bd17B9892B9fae4d52fe3BD377 ;
    }

// function getSigner() public view returns (address){
//     return signer;
// }

function setSigner(address addr) public {
    signer = addr;
}

function verify(uint128  info, bytes calldata signature) public view returns (address) {

        bytes32 message = keccak256(abi.encode(address(msg.sender), info));
        address signer2 = message.recover(signature);

        // 检查签名者是否是 customerA
        bool valid = signer2 == signer;

        // 触发事件，记录验证结果
        // emit SignatureVerified(signer2, valid);
        
        require(valid, "invalid signature");

        //TODO: transfer token from TokenContract

        return (signer2);
    }
}