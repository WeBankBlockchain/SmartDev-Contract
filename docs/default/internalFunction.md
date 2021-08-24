# solidity 内置函数转换
提供了一些内置函数的直接访问接口，主要包括block,tx相关

## API列表

编号 | API | API描述
---|---|---
1 | *getBlockhash(uint256 blockNumber) view public returns(bytes32)* | 根据指定的区块号获取hash(仅支持最近256个区块，且不包含当前区块)
2 | *getBlockNumber() view public returns(address)* |获取当前区块的高度
3 | *getTimestamp() view public returns(uint256)* | 获取当前区块的时间戳
4 | *isContract(address addr) view public returns(bool)* | 判断一个地址是否是合约地址
5 | *getCodeByAddress(address addr) view public returns(bytes)* | 根据合约地址获取合约代码
6 | *computeAddress(bytes32 salt, bytes32 bytecodeHash) view public returns(address)* | 根据字节码计算合约的地址

## API 详情

### ***1. getBlockhash 函数***
根据指定的区块号获取hash
#### 参数
- blockNumber: 区块高度
#### 返回值
- 区块的hash

### ***2. getBlockNumber 函数***
获取当前区块的高度
#### 参数
- 无
#### 返回值
- 区块高度

### ***3. getTimestamp 函数***
获取当前区块的时间戳
#### 参数
- 无
#### 返回值
- 当前区块的时间戳


### ***4. isContract 函数***
验证一个地址是否是合约地址
#### 参数
- address: 待验证的地址
#### 返回值
- bool


### ***5. getCodeByAddress 函数***
根据合约地址获取合约代码
#### 参数
- address: 合约地址
#### 返回值
- bytes: 字节码


### ***6. computeAddress 函数***
根据字节码计算合约的地址, 对应一些通过creat2方法创建的合约，如果有其字节码和盐，那么可以得到其部署的合约地址
#### 参数
- bytes32: salt
- bytes32: bytecodeHash
#### 返回值
- address: 合约地址
