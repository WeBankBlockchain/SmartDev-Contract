# 合约说明

经验证，本合约能够在fiscobcos上进行运行。

# 场景说明

业务主要围绕：贷前、贷中、贷后三个环节，对业务资料进行线上采集、分析、审批，实现贷前阶段对客户和进件全流程的业务管理。

# 业务流程

```
1、贷款方发起融资申请，填写融资单，提供质押物品信息；

2、资金方收到贷款方发起的融资单后，检验融资单的信息，并进行审核；

3、监管方收到资金方审核同意的融资单后，针对融资单中的质押物品信息创建仓单；

4、监管方选择仓单，更新融资单（添加仓单单号），并进行审核；

5、资金方收到监管方审核同意的融资单（包括仓单信息），进行放款；

6、资金方放贷审核同意后，进行放款登记。
```

注：此流程在审核同意时才会继续流转。如果审核拒绝，则会回转上一流程重新进行操作。

# 合约简介

## 贷款方融资流程控制器(FinancingProcessController)

本合约用于发起融资申请。比如填写融资单等。

```
/**
* 发布融资流程
* _processStr 流程详情
* _detailStr 融资单信息 
* _goodsStr 质押物品信息
* _user_id   操作用户id
*/
function issue(string _processStr, string _detailStr, string _goodsStr, string _user_id) external onlyOwner returns(int256)

/**
* 查询融资流程详情 
* _processId 流程id
*/
function query(string _processId) external returns(string)

```

## 资金方控制器(FinancingFundController)

本合约用于审核融资单、放款登记。比如检验融资单信息，审核融资单等。

```
/** 资金方审核融资单同意
* 资金方融资审批（确认后到出质审批）
* _processId 流程id
* _user_id   操作用户id
*/
function auditAccept(string _processId, string _user_id) external onlyOwner returns(bool)

/** 资金方审核融资单拒绝
* _processId 流程id
* _user_id   操作用户id
*/
function auditReject(string _processId, string _user_id) external onlyOwner returns(bool)

/** 资金方审核放货同意
* 资金方确认融资审批（确认后走放款流程）
* _processId 流程id
* _user_id   操作用户id
*/
function confirmAuditAccept(string _processId, string _user_id) external onlyOwner returns(bool)

/** 资金方审核放货拒绝
* _processId 流程id
* _user_id   操作用户id
*/
function confirmAuditReject(string _processId, string _user_id) external onlyOwner returns(bool)

/** 资金方放款审批同意
* 流程结束
* _processId 流程id
* _user_id   操作用户id
*/
function loanAuditAccept(string _processId, string _user_id) external onlyOwner returns(bool)

/** 资金方放款审批拒绝
* 流程回转到资金方审核融资单
* _processId 流程id
* _user_id   操作用户id
*/
function loanAuditReject(string _processId, string _user_id) external onlyOwner returns(bool)
```

## 监管方控制器(FinancingSupervisorController)

本合约用于创建仓单、审核融资单。比如创建新的仓单、更新融资单、审核融资单等。

```
/** 创建仓单
*  _processId  流程id
*  _receiptStr 仓单信息
* _user_id   操作用户id
*/
function createReceipt(string _processId, string _receiptStr, string _user_id) external onlyOwner returns(int256)

/** 监管方审核同意
* 监管方出质审批（确认后到资金方确认审批）
* _processId 流程id
* _user_id   操作用户id
*/
function supervisorAuditAccept(string _processId, string _user_id) external onlyOwner returns(bool)

/** 监管方审核拒绝
* _processId 流程id
* _user_id   操作用户id
*/
function supervisorAuditReject(string _processId, string _user_id) external onlyOwner returns(bool)

```

## 角色控制器(RoleController)

本合约用于为用户授权角色。

```
/** 授权货款方角色
* _user_id 用户id
*/
function setDKRole(string _user_id) external onlyOwner returns(bool)

/** 授权资金方角色
* _user_id 用户id
*/
function setZJRole(string _user_id) external onlyOwner returns(bool)

/** 授权监管方角色
* _user_id 用户id
*/
function setJGRole(string _user_id) external onlyOwner returns(bool)
```



## 融资流程存储器(FinancingProcessStorage)

本合约用于融资流程数据存储到Table中。

```
// 插入数据
function insert(string memory _processStr, string memory _detailStr, string memory _goodsStr) public returns(int) 

/**
* 资金方融资审批（确认后到出质审批）
*/
function updateDebtorStatus(string memory _processId, string memory _debtorStatus) public returns(int)

/**
* 资金方确认融资审批（确认后走放款流程）
*/
function updateCreditSideStatus(string memory _processId, string memory _creditSideStatus) public returns(int) 

/**
* 监管方出质审批（确认后到资金方确认审批）
*/
function updateSupervisorStatus(string memory _processId, string memory _supervisorStatus) public returns(int) 

```

## 融资详情存储器(FinancingDetailStorage)

本合约用于融资详情数据存储到Table中。

```
// 插入数据
function insert(string memory _detailStr) public returns(int) 

// 更新数据
function update(string memory _processId, string memory _detailStr) public returns(int256)
```

## 质押物品存储器(PledgeGoodsStorage)

本合约用于质押物品数据存储到Table中。

```
// 插入数据
function insert(string memory _goodsStr) public returns(int) 

// 更新数据
function update(string memory _processId, string memory _goodsStr) public returns(int256)

```

## 质物仓单存储器(PledgeReceiptStorage)

本合约用于仓单流程数据存储到Table中。

```
// 插入数据
function insert(string memory _processId, string memory _receiptStr) public returns(int) 
```

## MapStorage 存储合约(KV数据)

本合约与mapping(string=>string)作用是一样的，用来存储KV格式的数据。考虑合约升级时需要控制版本，才将数据存储到Table中。

```
// 插入数据，已有数据不添加
function put(string memory _key, string memory _value) public onlyOwner returns(int)

// 通过key获取value，可以存在多个value
function get(string memory _key) public view returns(string[] memory)
```

## 部署合约

```
角色控制器
deploy chattel/RoleController 
transaction hash: 0x6da2057a515933103ade1fda31cc563ec0b7dd17f0c1dcb930eebb27f0aaf8db
contract address: 0x354f57f527f739bdd6b1de69307ba34c92d44cf1
currentAccount: 0xe806bee863c052fe39ab35dc63e15cab5db09da8
```

```
贷款方融资流程控制器
deploy chattel/FinancingProcessController 
transaction hash: 0xdfef40280c9ecfa20e362a80ea75e237f4e4b334810a61740c55b856632ac37a
contract address: 0x8900dd11f484273d7b960343af14830997f2348e
currentAccount: 0xe806bee863c052fe39ab35dc63e15cab5db09da8
```

```
资金方控制器
deploy chattel/FinancingFundController 
transaction hash: 0xc821f78c20d386345997e064c5f4de4ec5beea705c339a646f68daae28f0ff1d
contract address: 0x5f55bb14dbd23059785d713a546c2bc6989d8ee2
currentAccount: 0xe806bee863c052fe39ab35dc63e15cab5db09da8
```

```
监管方控制器
deploy chattel/FinancingSupervisorController 
transaction hash: 0xa90a2b60efb8a393e7c8663c83f506de6f8106a19dbd77ee1c9654af4fc50840
contract address: 0x0dec0770c2f69fd40ac6b1c40f5e6f75b40e18cd
currentAccount: 0xe806bee863c052fe39ab35dc63e15cab5db09da8
```

## 调用合约

```
为3个操作用户授权角色

贷款方  2c91808e7b29b7a0017b29f2fc970005
资金方  2c91808e7b29b7a0017b29c809770000
监管方  8a81ffaa7af4df03017af66070a0000b

call chattel/RoleController 0x354f57f527f739bdd6b1de69307ba34c92d44cf1 setDKRole "2c91808e7b29b7a0017b29f2fc970005"

call chattel/RoleController 0x354f57f527f739bdd6b1de69307ba34c92d44cf1 setZJRole "2c91808e7b29b7a0017b29c809770000"

call chattel/RoleController 0x354f57f527f739bdd6b1de69307ba34c92d44cf1 setJGRole "8a81ffaa7af4df03017af66070a0000b"
```



```
1、贷款方发起融资申请，填写融资单，提供质押物品信息；
call chattel/FinancingProcessController 0x8900dd11f484273d7b960343af14830997f2348e issue "1,2c91808e7b29b7a0017b29f2fc970005,dk01,1,2c91808e7b29b7a0017b29c809770000,zj01,0,8a81ffaa7af4df03017af66070a0000b,jg01,0,0" "1,1629939590223,1555500,14500,,CD-001,HT141600002,,1,益盟股份有限公司,zjf02,2021-08-26 00:00:00,2021-09-06 00:00:00,12,0,验证资料产品2,666,0,1,1,233652000000001,中国银行," "1,ZW2108239960,畜牧-牛,吨,100000,6800,110000,701,200000,奶牛养殖场" "2c91808e7b29b7a0017b29f2fc970005"

2、资金方收到贷款方发起的融资单后，检验融资单的信息，并进行审核；
call chattel/FinancingFundController 0x5f55bb14dbd23059785d713a546c2bc6989d8ee2 auditAccept "1" "2c91808e7b29b7a0017b29c809770000"

3、监管方收到资金方审核同意的融资单后，针对融资单中的质押物品信息创建仓单；
call chattel/FinancingSupervisorController 0x0dec0770c2f69fd40ac6b1c40f5e6f75b40e18cd supervisorAuditAccept "1" "8a81ffaa7af4df03017af66070a0000b"

4、监管方选择仓单，更新融资单（添加仓单单号），并进行审核；
call chattel/FinancingSupervisorController 0x0dec0770c2f69fd40ac6b1c40f5e6f75b40e18cd createReceipt "1" "1,ZW2108239960,仓库11号,UHD799494,N0002,畜牧,畜牧-牛" "8a81ffaa7af4df03017af66070a0000b"

5、资金方收到监管方审核同意的融资单（包括仓单信息），进行放款；
call chattel/FinancingFundController 0x5f55bb14dbd23059785d713a546c2bc6989d8ee2 confirmAuditAccept "1" "2c91808e7b29b7a0017b29c809770000"

6、资金方放贷审核同意后，进行放款登记。
call chattel/FinancingFundController 0x5f55bb14dbd23059785d713a546c2bc6989d8ee2 loanAuditAccept "1" "2c91808e7b29b7a0017b29c809770000"
```

## 附 开发心得

开发过程中，最主要是对整个动产业务流程的梳理，针对各个方法的开发，其实并不是很难，只是对过程的一种描述。

因此，整个开发流程，先确立了先梳理需求，然后针对solidity语言开发出一个可用的版本。

