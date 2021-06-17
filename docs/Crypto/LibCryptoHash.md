# LibCryptoHash.sol

LibCryptoHash 提供了solidity内置函数keccak256、sha3、ripemd160等计算摘要。

## 使用方法
```shell script
 pragma solidity ^0.4.25;
 import "./LibCryptoHash.sol";

 contract test {
    function t_keccak(string memory s1) public view returns (bytes32 result) {
        return LibCryptoHash.getKeccak256(s1);
    } 
    function t_sha3(string memory s1) public view returns (bytes32 result) {
        return LibCryptoHash.getSha3(s1);
    } 
    function t_sha256(string memory s1) public view returns (bytes32 result) {
        return LibCryptoHash.getSha256(s1);
    } 
    function t_ripemd160(string memory s1) public view returns (bytes20 result) {
         return LibCryptoHash.getRipemd160(s1);
    } 
}
```

## API列表

编号 | API | API描述
---|---|---
1 | *getKeccak256(string memory s1) public returns(bytes32 result)* | keccak256算法
2 | *getSha3(string memory s1) public returns(bytes32 result)* | sha3算法等同于keccak256。
3 | *getSha256(string memory s1) public returns(bytes32 result)* | sha256算法。
4 | *getRipemd160(string memory s1) public returns(bytes20 result)* | ripemd160算法。

## API详情

### ***1. getKeccak256 函数***

keccak256算法

#### 参数

- s1: 字符串

#### 返回值
- result: byte32

## API详情

### ***1. getSha3 函数***

sha3算法等同于keccak256

#### 参数

- s1: 字符串

#### 返回值
- result: byte32
## API详情

### ***1. getSha256 函数***

sha256算法

#### 参数

- s1: 字符串

#### 返回值
- result: byte32
## API详情

### ***1. getRipemd160 函数***

ripemd160算法

#### 参数

- s1: 字符串

#### 返回值
- result: byte20