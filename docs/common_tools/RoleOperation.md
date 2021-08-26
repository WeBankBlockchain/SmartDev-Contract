## 功能说明

本合约支持角色操作。包含角色的增丶删丶改丶查：

## 接口

提供了两个合约：Roles合约，Character合约。其中Character合约是对外服务合约，Roles合约是库合约，用于数据和逻辑抽象化。

Character合约：对外服务的唯一接口。包含：
- addCharacter(address amount,string _summary): 管理员进行添加角色操作。amount是添加角色的地址，_ _summary添加角色的基本信息
- removeCharacter(address amount): 管理员进行删除角色操作。amount是删除角色的地址
- reviseCharacter(address amount,string _summary)：管理员进行修改角色信息操作。amount是修改角色的地址， _summary修改角色的基本信息
- seekCharacter(address amount): 任何人都可以进行查询角色信息操作。amount是查询角色的地址
- getAllCharater()：任何人都可以进行查看当前存在的所有角色操作。
- isCharacter(address amount): 任何人都可以进行查看当前地址是否已经被添加为角色。amount是查询的地址

## 使用示例

角色的增删改查，整个过程如下：

合约初始化：

    - 以管理员地址部署Character合约

合约调用：

    - 管理员调用Character.addCharacter提交添加角色请求，参数传入添加角色的地址，角色的基本信息
    - 任何人调用Character.getAllCharater提交查看角色请求
    - 任何人调用Character.isCharacter提交查询当前地址是否已经被添加成功
    - 管理员调用Character.reviseCharacter提交修改角色信息请求，参数传入修改角色的地址，修改角色的基本信息
    - 任何人调用Character.seekCharacter提交查询角色信息请求，参数传入查询角色的地址
    - 管理员调用Character.removeCharacter提交删除角色的请求，参数传入删除角色的地址
    - 任何人调用Character.isCharacter提交查询角色是否还存在请求，参数传入查询角色的地址
    - 任何人调用Character.getAllCharater提交查看角色请求






