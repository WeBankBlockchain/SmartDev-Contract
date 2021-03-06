## 共享充电积分能量存证合约 场景说明

在共享充电场景中，需要用户完成充电后，对本次充电进行存证记录，并兑现相应的能量积分，该能量积分可以在对应的平台进行兑换、转售等。

联盟中存在 积分能量交易平台、共享充电服务商、供电方等不同的参与机构。

## 细分业务模块说明

> 业务角色说明

 业务角色| 工作职能
---|---
积分能量交易平台 | 主要作为合约管理者，负责用户认证、充电设备授权、积分兑换等工作。
充电设备端 | 将经过用户签名的充电交易打包上链。
用户端    | 在支付充电订单过程，对自己的订单进行签名。


>基础使用流程

- 积分交易平台部署`CarbonFrugalEvidence` 合约，默认操作人为最高权限者和权限管理者。
- 最高权限者调用`changePermitManager`添加具体业务权限管理者`manager`。
- `manager`通过平台业务系统接收共享充电服务商提交的充电设备基础信息及区块链账户地址，调用`setAuthDevice`方法进行合约设备授权。
- 业务系统在用户完成注册，并且完成实名制后，平台为用户生成区块链公私钥及账户地址，由`manager`管理者通过调用`addAuthUser`方法，将用户基础信息注册到合约中。
- 在实际场景中，用户在充电设备端提供的二维码进行扫码充电；完成充电后，进行付款，此时用户app会自动为该笔交易订单进行一次签名并同步平台，
而充电设备会得到本次交易订单和用户签名，由充电设备调用`addEvidence`方法进行存证【合约会自动交易上链设备是否授权、指定的用户是否注册、以及对应的数据签名等】，
同时用户获得对应的能量积分`积分比例由业务端设定，授权充电设备通过对应比例将积分数值存入交易`。

>其他流程
- 用户可以给其他用户进行积分转账。
- 用户也可以在平台上进行积分兑换，平台负责对积分进行销毁等。

## 合约结构说明

- `CarbonFrugalEvidence` 业务合约，只需要部署它即可。
- `AuthUsersRepository` 注册用户的仓储合约库。
- `EvidencesRepository` 存证记录的仓储合约库。
- `Address` 地址校验工具合约类库。
- `ECDSA`   keccak256 用户数据签名校验工具合约库.
- `SafeMath` 基础数学计算加减乘除 工具合约库。

