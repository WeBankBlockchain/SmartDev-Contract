## 积分模板背景说明

在区块链的业务方案中，积分系统是非常常见的一种场景。

基于智能合约的积分系统，支持多家机构发行、用户注册、积分消费、积分销户、用户销户等多种功能。


## 场景说明

典型的积分场景包括了以下角色：

    - 发行者：发行积分。
    - 用户：获得和消费积分，还可实现积分的转账。
    - 管理者：积分系统的管理者。

积分系统中包括了以下功能：

    - 创建积分系统
    - 注册：用户注册会员，只有经过注册的用户才能获得和消费积分。
    - 销户： 用户销户。只有积分为0的用户才能正常销户。
    - 添加发行者： 发行者具有发行积分的权利。
    - 发行积分： 支持定向发送到某个积分账户。
    - 删除发行者： 发行者可以注销自身的发行积分的权利。
    - 转账： 支持用户积分的互转和消费等。
    - 积分销毁： 用户可以销毁自己的积分。


## 接口

主体为3个合约： Admin、RewardPointController、RewardPointData。

其中Admin为管理合约，提供合约部署和管理的接口：

    - 构造函数： 部署合约。默认部署合约的外部账户为资产发行者。
    - upgradeVersion(address newVersion)  更新数据的controller最新地址
    - _dataAddress() 查询数据合约的地址
    - _controllerAddress() 查询控制合约的地址

RewardPointController 提供了合约控制相关的接口：

    - addIssuer(address account) 添加资产发行者。只有资产发行者可以添加新的资产发行者。
    - issue(address account, uint256 value) 发行积分
    - isIssuer(address account) 判断是否是资产发行者。
    - addIssuer(address account) 添加发行者,只能由发行者添加。
    - renounceIssuer() 撤销发行者，只能撤销自己。
    - register() 普通用户账户注册。
    - unregister() 普通用户账户注销。
    - isRegistered(address addr) 判断普通用户是否注册。
    - balance(address addr) 查询普通用户的积分。
    - transfer(address toAddress, uint256 value) 往目标账户转积分
    - destroy(uint256 value) 销毁自己账户中的指定数量的积分

RewardPointData提供了底层的数据存储，不对外暴露直接访问的接口。

其他的合约为工具或辅助合约。

## 使用示例

整体流程如下：

合约初始化：

    - 管理员部署Admin合约， 管理员在控制台中输入『deploy Admin』部署合约。
    - 管理员调用Admin合约的_controllerAddress()函数，获得RewardPointController合约的地址。

资产发行者维护：
    
    - 管理员使用 RewardPointController 合约的地址，加载RewardPointController合约。
    - 管理员默认为资产发行者，可以通过addIssuer添加其他发行者，通过renounceIssuer接口撤销自己发行者的权限。
    - 通过isIssuer接口查询某个用户是否为资产发行者。
    
账户注册：

    - 用户使用管理员发放的 RewardPointController 合约的地址，加载RewardPointController合约。
    - 用户使用RewardPointController合约中的register()接口注册账户。
    - 通过isRegistered判断是否已注册。

积分发行：

    - 用户使用RewardPointController的isIssuer函数判断自己是否为积分发行者。
    - 如果为是，用户通过issue接口定向发现积分。

积分操作：

    - 用户通过transfer接口实现积分转账。
    - 用户通过balance接口查询积分余额。
    - 用户通过destroy接口实现指定数额的账户积分的注销。

账户销户：
    
    - 用户通过unregister接口销户，只有积分余额为0的账户可以直接销户。





