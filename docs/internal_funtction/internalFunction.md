# solidity 内置函数转换
提供了一些内置函数的直接访问接口，主要包括block,tx相关

## API列表

编号 | API | API描述
---|---|---
1 | *getBlockhash(uint256 blockNumber) view public returns(bytes32)* | 根据指定的区块号获取hash(仅支持最近256个区块，且不包含当前区块)
2 | *getMiner() view public returns(address)* |获取当前区块的矿工地址
3 | *getDifficulty() view public returns(uint256) |获取当前区块的难度系数
4 | *igetGaslimit() view public returns(uint256)* | 获取当前区块的区块高度
5 | *getTimestamp() view public returns(uint256)* | 获取当前区块的时间戳
6 | *getGasprice() view public returns(uint256)* | 获取当前区块的gasPrice
7 | *getEthBalance(address payable account) view public returns(uint256)* | 获取某个账户的eth余额

