# Crypto.sol

Crypto提供了密码学操作

## 使用方法

```
pragma solidity >=0.4.24 <0.6.11;

pragma experimental ABIEncoderV2;

import "./Crypto.sol";

contract ShaTest{
    bytes _data = "Hello, ShaTest";
    Crypto crypto;

    constructor() public {
        crypto = Crypto(0x5006);
    }

    function getSha256(bytes memory _memory) public returns(bytes32 result)
    {
        return sha256(_memory);
    }

    function getKeccak256(bytes memory _memory) public returns(bytes32 result)
    {
        return keccak256(_memory);
    }

    function getData() public view returns(bytes memory)
    {
        return _data;
    }
}

```