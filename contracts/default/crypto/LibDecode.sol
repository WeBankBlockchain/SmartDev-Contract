pragma solidity ^0.4.25;
library LibDocode {
    function decode(bytes signHash, bytes signedString) internal returns (address){
        bytes32  r = bytesToBytes32(slice(signedString, 0, 32));
        bytes32  s = bytesToBytes32(slice(signedString, 32, 32));
        byte  v = slice(signedString, 64, 1)[0];
        bytes32  hash = bytesToBytes32(slice(signHash, 0, 32));
        return ecrecoverDecode(hash,r, s, v);
    }
    function slice(bytes memory data, uint start, uint len) internal returns (bytes){
        bytes memory b = new bytes(len);

        for(uint i = 0; i < len; i++){
            b[i] = data[i + start];
        }

        return b;
    }
    function ecrecoverDecode(bytes32 hash, bytes32 r, bytes32 s, byte v1) internal returns (address addr){
        uint8 v = uint8(v1) + 27;
        addr = ecrecover(hash, v, r, s);
    }
    function bytesToBytes32(bytes memory source) internal returns (bytes32 result) {
        assembly {
            result := mload(add(source, 32))
        }
    }
}