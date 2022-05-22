# LibBase64.sol

LibBase64 提供Base64编解码


## 接口说明
1. function encode(string memory data) returns(string memory)：Base64编码
- data：要编码的数据

2. function decode(string memory data) returns(string memory)：Base64解码
- data：要解码的数据

## 使用方法

```
pragma solidity ^0.4.25;
import "./LibBase64.sol";

contract LibBase64 {
    function test_encode() public pure returns (string memory) {
        string memory _str = "hello world";
        return LibBase64.encode(_str);
    }

    function test_decode() public pure returns (string memory) {
        string memory _str = "aGVsbG8gd29ybGQ=";
        return LibBase64.decode(_str);
    }
}

```