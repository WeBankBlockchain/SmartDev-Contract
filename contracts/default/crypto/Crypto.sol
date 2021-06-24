contract Crypto
{
    function sm3(bytes memory data) public view returns(bytes32){}
    function keccak256Hash(bytes memory data) public view returns(bytes32){}
    function sm2Verify(bytes32  message, bytes memory publicKey, bytes32 r, bytes32 s) public view returns(bool, address){}
    function curve25519VRFVerify(string memory input, string memory vrfPublicKey, string memory vrfProof) public view returns(bool,uint256){}
}