# TypeUtils

> 广东工业大学 陈汛

## 合约简介

一个提供solidity中类型(bytes32、bytes、string、uint256、address)转换的工具合约，适用于0.4.25及以上版本。

## 使用方法

import该合约(TypeUtils.sol)即可。下面是一个例子：

```
// SPDX-License-Identifier: MIT
pragma solidity >=0.4.25;

import "./TypeUtils.sol";

/**
 * @dev TypeUtils测试demo
 * @author ashinnotfound
 */
contract TypeUtilsDemo{

    function stringToBytes32Test() public pure returns (bytes32) {
        string memory word = "ni hao";
        return TypeUtils.stringToBytes32(word);
        // result: 0x6e692068616f0000000000000000000000000000000000000000000000000000
    }
}
```

## API列表

| 编号 | API                                                          | 描述             |
| ---- | ------------------------------------------------------------ | ---------------- |
| 1    | bytes32ToString(bytes32 _origin) public pure returns (string memory result) | bytes32转string  |
| 2    | stringToBytes32(string memory _origin) public pure returns (bytes32 result) | string转bytes32  |
| 3    | stringToBytes(string memory _origin) public pure returns (bytes memory result) | string转bytes    |
| 4    | bytesToString(bytes memory _origin) public pure returns (string memory result) | bytes转string    |
| 5    | bytesToBytes32(bytes memory _origin) public pure returns (bytes32 result) | bytes转bytes32   |
| 6    | bytes32ToBytes(bytes32 _origin) public pure returns (bytes memory result) | bytes32转bytes   |
| 7    | addressToString(address _origin) public pure returns (string memory result) | address转string  |
| 8    | stringToAddress(string memory _origin) public pure returns (address result) | string转address  |
| 9    | bytesToAddress(bytes memory _origin) public pure returns (address result) | bytes转address   |
| 10   | addressTobytes(address _origin) public pure returns (bytes memory result) | address转bytes   |
| 11   | uint256ToString(uint256 _origin) public pure returns (string memory result) | uint256转string  |
| 12   | stringToUint256(string memory _origin) public pure returns(uint256 result) | string转uint256  |
| 13   | uint256ToBytes32(uint256 _origin) public pure returns (bytes32 result) | uint256转bytes32 |
| 14   | bytes32ToUint256(bytes32 _origin) public pure returns (uint256 result) | bytes32转uint256 |
| 15   | bytesToUint256(bytes memory _origin) public pure returns (uint256 result) | bytes转uint256   |
| 16   | uint256ToBytes(uint256 _origin) public pure returns (bytes memory result) | uint256转bytes   |

## API详情

### 1. ***bytes32ToString***

bytes32转string

#### 参数

- _origin: 待转换的值

#### 返回值

- result：转换后的值

#### 实例

```
function stringToBytes32Test() public pure returns (bytes32) {
        string memory word = "ni hao";
        return TypeUtils.stringToBytes32(word);
        // result: 0x6e692068616f0000000000000000000000000000000000000000000000000000
    }
```

### 2. ***stringToBytes32***

string转bytes32

#### 参数

- _origin: 待转换的值

#### 返回值

- result：转换后的值

#### 实例

```
function bytes32ToStringTest() public pure returns (string memory) {
        bytes32 word = 0x6e692068616f0000000000000000000000000000000000000000000000000000;
        return TypeUtils.bytes32ToString(word);
        // result: "ni hao"
    }
```

### 3. ***stringToBytes***

string转bytes

#### 参数

- _origin: 待转换的值

#### 返回值

- result：转换后的值

#### 实例

```
function stringToBytesTest() public pure returns (bytes memory) {
        string memory word = "ni hao";
        return TypeUtils.stringToBytes(word);
        // result: 0x6e692068616f
    }
```

### 4. ***bytesToString***

bytes转string

#### 参数

- _origin: 待转换的值

#### 返回值

- result：转换后的值

#### 实例

```
function bytesToStringTest() public pure returns (string memory, string memory) {
        bytes memory word1 = "0x6e692068616f";
        bytes memory word2 = "0x6e692068616f0000000000000000000000000000000000000000000000000000";
        return (TypeUtils.bytesToString(word1), TypeUtils.bytesToString(word2));
        // result: "ni hao", "ni hao\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000"
    }
```

### 5. bytesToBytes32

bytes转bytes32

#### 参数

- _origin: 待转换的值

#### 返回值

- result：转换后的值

#### 实例

```
function bytesToBytes32Test() public pure returns (bytes32) {
        bytes memory word = "0x6e692068616f";
        return TypeUtils.bytesToBytes32(word);
        // result: 0x6e692068616f0000000000000000000000000000000000000000000000000000
    }
```

### 6. ***bytes32ToBytes***

bytes32转bytes

#### 参数

- _origin: 待转换的值

#### 返回值

- result：转换后的值

#### 实例

```
function bytes32ToBytesTest() public pure returns (bytes memory){
        bytes32 word = 0x6e692068616f0000000000000000000000000000000000000000000000000000;
        return TypeUtils.bytes32ToBytes(word);
        // result: 0x6e692068616f
    }
```

### 7. ***addressToString***

address转string

#### 参数

- _origin: 待转换的值

#### 返回值

- result：转换后的值

#### 实例

```
function addressToStringTest() public pure returns (string memory) {
        address addr = 0x86cA07C6D491Ad7A535c26c5e35442f3e26e8497;
        return TypeUtils.addressToString(addr);
        // result: "0x86cA07C6D491Ad7A535c26c5e35442f3e26e8497"
    }
```

### 8. ***stringToAddress***

string转address

#### 参数

- _origin: 待转换的值

#### 返回值

- result：转换后的值

#### 实例

```
function stringToAddressTest() public pure returns (address) {
        string memory addr = "0x86cA07C6D491Ad7A535c26c5e35442f3e26e8497";
        return TypeUtils.stringToAddress(addr);
        // result: 0x86cA07C6D491Ad7A535c26c5e35442f3e26e8497
    }
```

### 9. ***bytesToAddress***

bytes转address

#### 参数

- _origin: 待转换的值

#### 返回值

- result：转换后的值

#### 实例

```
function bytesToAddressTest() public pure returns (address) {
        bytes memory addr = "0x86cA07C6D491Ad7A535c26c5e35442f3e26e8497";
        return TypeUtils.bytesToAddress(addr);
        // result: 0x86cA07C6D491Ad7A535c26c5e35442f3e26e8497

        // bytes memory addr = "0x86cA07C6D491Ad7A535c26c5e35442f3e26e849700";
        // return TypeUtils.bytesToAddress(addr);
        // // result: TypeUtils::bytesToAddressException: Invalid input length
    }
```

### 10. ***addressTobytes***

address转bytes

#### 参数

- _origin: 待转换的值

#### 返回值

- result：转换后的值

#### 实例

```
function addressTobytesTest() public pure returns (bytes memory) {
        address addr = 0x86cA07C6D491Ad7A535c26c5e35442f3e26e8497;
        return TypeUtils.addressTobytes(addr);
        // result: "0x86cA07C6D491Ad7A535c26c5e35442f3e26e8497"
    }
```

### 11. ***uint256ToString***

uint256转string

#### 参数

- _origin: 待转换的值

#### 返回值

- result：转换后的值

#### 实例

```
function uint256ToStringTest() public pure returns (string memory) {
        uint256 num = 17666;
        return TypeUtils.uint256ToString(num);
        // result: "17666"
    }
```

### 12. ***stringToUint256***

string转uint256

#### 参数

- _origin: 待转换的值

#### 返回值

- result：转换后的值

#### 实例

```
function stringToUint256Test() public pure returns (uint256) {
        string memory num = "17666";
        return TypeUtils.stringToUint256(num);
        // result: 17666

        // string memory num = "17666hhh";
        // return TypeUtils.stringToUint256(num);
        // // result: TypeUtils::stringToUint256Exception: Invalid number in string
    }
```

### 13. ***uint256ToBytes32***

uint256转bytes32

#### 参数

- _origin: 待转换的值

#### 返回值

- result：转换后的值

#### 实例

```
function uint256ToBytes32Test() public pure returns (bytes32) {
        uint256 num = 17666;
        return TypeUtils.uint256ToBytes32(num);
        // result: 0x0000000000000000000000000000000000000000000000000000000000004502
    }
```

### 14. ***bytes32ToUint256***

bytes32转uint256

#### 参数

- _origin: 待转换的值

#### 返回值

- result：转换后的值

#### 实例

```
function bytes32ToUint256Test() public pure returns (uint256) {
        bytes32 num = 0x0000000000000000000000000000000000000000000000000000000000004502;
        return TypeUtils.bytes32ToUint256(num);
        // result: 17666
    }
```

### 15. ***bytesToUint256***

bytes转uint256

#### 参数

- _origin: 待转换的值

#### 返回值

- result：转换后的值

#### 实例

```
function bytesToUint256Test() public pure returns (uint256) {
        bytes memory num = "0x0000000000000000000000000000000000000000000000000000000000004502";
        return TypeUtils.bytesToUint256(num);
        // result: 17666
    }
```

### 16. ***uint256ToBytes***

uint256转bytes

#### 参数

- _origin: 待转换的值

#### 返回值

- result：转换后的值

#### 实例

```
function uint256ToBytesTest() public pure returns (bytes memory) {
        uint256 num = 17666;
        return TypeUtils.uint256ToBytes(num);
        // result: 0x0000000000000000000000000000000000000000000000000000000000004502
    }
```

