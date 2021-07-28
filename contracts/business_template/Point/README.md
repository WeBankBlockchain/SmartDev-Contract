## 功能说明
本合约为积分合约demo，挖矿和转账功能。

## 接口
提供了PointDemo合约,主要是挖矿和转账功能
- mint(address receiver,uint amount):挖矿
- send(address receiver,uint amount): 转账


## 使用示例
积分合约挖矿和转账，整个过程如下：

合约初始化：

    - 部署PointDemo合约

合约调用：

    - 调用PointDemo.mint 挖矿
    - 调用PointDemo.send 转账
