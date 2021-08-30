## 功能说明

本合约结合角色合约与存证合约打造结婚证书合约实例。也可根据需求开发毕业证书，参会，活动证明等，更多玩法可自由修改。

## 接口

提供了五个合约：Roles合约，Character合约，Evidence合约，EvidenceFactory合约，MarriageEvidence合约。其中Character合约是对外服务合约，Roles合约是库合约，用于数据和逻辑抽象化。其中Evidence合约是存证基合约，EvidenceFactory合约是存证工厂合约。

**Character合约**：主要使用接口。包含：

- addCharacter(address amount,string _summary): 管理员进行添加角色操作。amount是添加角色的地址，_ _summary添加角色的基本信息
- getAllCharater()：任何人都可以进行查看当前存在的所有角色操作。返回值：address[]

**EvidenceFactory合约**：主要使用接口。包含：

- constructor(address[] evidenceSigners) ：构造函数。evidenceSigners是签名者地址数组，传入地址数组进行初始化授权
- verify(address addr)：验证addr地址是否为授权签名地址。返回值：bool
- newEvidence(string evi)：创建新证书功能。evi是存证信息。返回值：address   （证书地址）
- addSignatures(address addr) ：进行签名。addr地址者签名。返回值：bool
- getEvidence(address addr) ：获取证书信息。addr是证书地址。返回值：存证信息string,授权地址address[],已签名地址address[]

**MarriageEvidence**：继承Character合约，部署使用EvidenceFactory合约，主要对外接口。包含：

- deployEvi()：部署EvidenceFactory合约，导入夫妻地址
- newEvi(string _evi)：发布结婚存证
- sign()：夫妻签字
- getEvi()：查看证书



## 使用示例

角色的增删改查，整个过程如下：

合约初始化：

    - 以民政局管理员地址部署MarriageEvidence合约（继承于Character合约）

合约调用：

    - 管理员调用Character.addCharacter提交添加角色请求，参数传入添加夫妻的地址，夫妻的基本信息(json格式传入)
    - 管理员调用MarriageEvidence.deployEvi()提交部署EvidenceFactory合约请求，参数自动以Character.getAllCharater的返回值参入，为夫妻地址在证书中签名授权。
    - 管理员调用MarriageEvidence.newEvi提交创建结婚证书请求
    - 夫妻各自调用MarriageEvidence.sign提交对结婚证书进行签名请求
    - 任何人调用MarriageEvidence.getEvi提交查看结婚证书