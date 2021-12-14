# LibDecode.sol

LibDecode 提供基于solidity的签名和验证签名等功能

## 使用方法
### 签名
```shell script
// 初始化基本对象
var Web3 = require('web3');
var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));

var account = web3.eth.accounts[0];
var sha3Msg = web3.sha3("abc");
var signedData = web3.eth.sign(account, sha3Msg);

console.log("account: " + account);
console.log("sha3(message): " + sha3Msg);
console.log("Signed data: " + signedData);
```
```shell script
$ node test.js
account: 0x60320b8a71bc314404ef7d194ad8cac0bee1e331
sha3(message): 0x4e03657aea45a94fc7d47ba826c8d667c0d1e6e33a64a036ec44f58fa12d6c45
Signed data: 0xf4128988cbe7df8315440adde412a8955f7f5ff9a5468a791433727f82717a6753bd71882079522207060b681fbd3f5623ee7ed66e33fc8e581f442acbcf6ab800

```
### 验签
```shell script
pragma solidity ^0.4.25;
import "./LibDecode.sol";
contract Test {
    // bytes memory signedString =hex"f4128988cbe7df8315440adde412a8955f7f5ff9a5468a791433727f82717a6753bd71882079522207060b681fbd3f5623ee7ed66e33fc8e581f442acbcf6ab800";
    // bytes memory signhash =hex"4e03657aea45a94fc7d47ba826c8d667c0d1e6e33a64a036ec44f58fa12d6c45";
    function decode(bytes signhash, bytes signedString) public view returns (address result) {
        return LibDecode.decode(signhash, signedString);
    }
}
```

## API列表

编号 | API | API描述
---|---|---
1 | *decode(bytes signhash, bytes signedString) returns (address)* | 解码签名地址

## API详情

### ***1. decode 函数***

解码签名地址

#### 参数

- signhash: sha3(msg)

- signedString: 签名后的数据
#### 返回值
- address
