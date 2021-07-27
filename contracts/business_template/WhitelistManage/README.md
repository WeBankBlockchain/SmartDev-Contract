## 功能说明
本合约支持白名单管理，包含增删改查相关操作。

## 接口
提供了三个合约：SafeRole 合约，WhitelistAdminRole 合约，WhitelistedRole 合约。其中SafeRole是库合约，WhitelistedRole合约是对外服务合约，用于数据和逻辑抽象化。
WhitelistedRole合约：对外服务的唯一接口。包含：
- addWhitelistAdmin(address account):添加白名单管理员账户，amount是角色的地址
- addWhitelisted(address account): 添加白名单账户，amount是角色的地址
- isWhitelistAdmin(address account): 判断是否是白名单管理员，amount是角色的地址
- isWhitelisted(address account): 判断账户是否在白名单里，amount是角色的地址
- removeWhitelisted(address account): 移除白名单管理员账户，amount是角色的地址
- renounceWhitelisted(): 清空白名单列表
- renounceWhitelistAdmin(): 清空白名单管理员列表


## 使用示例
白名单管理的增删改查，整个过程如下：

合约初始化：

    - 部署WhitelistedRole合约

合约调用：

    - 调用WhitelistedRole.addWhitelistAdmin 提交添加白名单管理员
    - 调用WhitelistedRole.addWhitelisted 提交添加用户到白名单列表
    - 调用WhitelistedRole.isWhitelistAdmin 判断是否是白名单管理员
    - 调用WhitelistedRole.isWhitelisted 判断是否在白名单列表
    - 调用WhitelistedRole.removeWhitelisted 移除白名单
    - 调用WhitelistedRole.renounceWhitelisted 清空白名单列表
    - 调用WhitelistedRole.renounceWhitelistAdmin 清空白名单管理员列表
    