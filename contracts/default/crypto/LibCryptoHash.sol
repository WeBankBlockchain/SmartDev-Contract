pragma solidity ^0.4.25;

library LibCryptoHash {
    event TestLog(bytes32 value);

    function getKeccak256(string memory s1) internal  returns(bytes32 result){
        bytes32 a =  keccak256(abi.encodePacked(s1));
        emit TestLog(a);

        return a;
    }

    function getSha3(string memory s1) internal returns(bytes32 result){
        bytes32 a =  sha3(bytes(s1));
        emit TestLog(a);
        return a;

    }

    function getSha256(string memory s1) internal returns(bytes32 result){
        bytes32 a =  sha256(bytes(s1));
        emit TestLog(a);
        return a;

    }

    function getRipemd160(string memory s1) internal returns(bytes20 result){
        bytes20 a =  ripemd160(bytes(s1));
        emit TestLog(a);
        return a;
    }

}