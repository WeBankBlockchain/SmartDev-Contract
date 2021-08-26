## 功能说明
本合约为积分合约demo，获取积分和转账积分功能。

## 接口
提供了PointDemo合约,主要是获取积分和转账积分功能
- mint(address receiver,uint amount):获取积分
- send(address receiver,uint amount): 转账积分


## 使用示例
积分合约获取积分和转账积分，整个过程如下：

合约初始化：

    - 部署PointDemo合约

合约调用：

    - 调用PointDemo.mint 获取积分
    - 调用PointDemo.send 转账积分
