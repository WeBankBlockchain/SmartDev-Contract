# 合约说明

经验证，本合约能够在fiscobcos上进行运行。

## 场景说明

本合约用于金融票据上的操作，可以发布票据、对票据进行背书、验证背书、拒绝背书等操作；也可以针对特定条件（当前持票人）查询票据信息等。

## BillController 控制合约

本合约用于操作票据。比如发布票据、背书签名等。

```
/**发布票据 */
function issue(string _s) external onlyOwner returns(int256)

/**批量查询当前持票人的票据 */
function queryBills(string _holdrCmID) external returns(string[] memory)

/**根据票据号码查询票据详情 */
function queryBillByNo(string _infoID) external returns(string)

/**发起背书请求 */
function endorse(string _infoID, string _waitEndorseCmID, string _waitEndorseAcct) external onlyOwner returns(bool)

/**查询待背书票据列表 */
function queryWaitBills(string _waitEndorseCmID) external returns(string[] memory)

/**背书签收 */
function accept(string _infoID, string _holdrCmID, string _holdrAcct) external onlyOwner returns(bool)

/**拒绝背书 */
function reject(string _infoID, string _rejectEndorseCmID, string _rejectEndorseAcct) external onlyOwner returns(bool)
```

## BillStorage 存储合约

本合约用于票据数据存储到Table中。

```
// 插入数据
function insert(string memory _s) public onlyOwner returns(int)

// 通过infoID查询数据
function getDetail(string memory _infoID) public view returns(string memory _json)

// 通过infoID获取HoldrCmID
function getHoldrCmID(string memory _infoID) public view returns(string memory _holdrCmID)

// 更新背书人信息
function updateEndorse(string memory _infoID, string memory _waitEndorseCmID, string memory _waitEndorseAcct) public onlyOwner returns(int256)

// 更新持票人信息
function updateEccept(string memory _infoID, string memory _holdrCmID, string memory _holdrAcct) public onlyOwner returns(int256)

// 更新待背书人信息
function updateReject(string memory _infoID, string memory _rejectEndorseCmID, string memory _rejectEndorseAcct) public onlyOwner returns(int256)

// 通过holdrCmID查询数据
function selectListByHoldrCmID(string memory _holdrCmID) public view returns(string[])

// 通过waitEndorseCmID查询数据
function selectListByWaitEndorseCmID(string memory _waitEndorseCmID) public view returns(string[])
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
deploy Bill/BillController
```

## 调用合约

```
// 发布票据
call Bill/BillController 0x9ae09665525be7affa51bac3e3cd0aa7ddefa27e issue "BOC104,4000,12,20110102,20110106,11,11,11,11,11,11,BBB,BID"

// 根据票据号码查询票据详情
call Bill/BillController 0x9ae09665525be7affa51bac3e3cd0aa7ddefa27e queryBillByNo "BOC104"

// 发起背书请求
call Bill/BillController 0x9ae09665525be7affa51bac3e3cd0aa7ddefa27e endorse "BOC104" "13" "AAA"

// 批量查询当前持票人的票据
call Bill/BillController 0x9ae09665525be7affa51bac3e3cd0aa7ddefa27e queryBills "BID"
```

## 控制台测试

### 部署合约
```
[group:1]> deploy BillController
transaction hash: 0x9436796448c65803c06ae15ffbbffeb34804684fea076d28390597449bec15fa
contract address: 0x37949ce7937696dafffeac91411acbbf9ed7e86b
currentAccount: 0x22fec9d7e121960e7972402789868962238d8037
```

### 函数调用
```
[group:1]>  call BillController 0x37949ce7937696dafffeac91411acbbf9ed7e86b issue "BOC104,4000,12,20110102,20110106,11,11
,11,11,11,11,BBB,BID"
transaction hash: 0x355b9aea0e9f7c931d2de941f58930380a1912c662aa9a3929e3ac7ae1b41c3b
---------------------------------------------------------------------------------------------
transaction status: 0x0
description: transaction executed successfully
---------------------------------------------------------------------------------------------
Receipt message: Success
Return message: Success
Return value size:1
Return types: (INT)
Return values:(1)
---------------------------------------------------------------------------------------------
Event logs
Event: {"IssueResult":[[1]]}

[group:1]>  call BillController 0x37949ce7937696dafffeac91411acbbf9ed7e86b queryBillByNo "BOC104"
transaction hash: 0xc2b2b1432aafa847df481ebaf36752124fed56c595e4fef42e2817b5059a282b
---------------------------------------------------------------------------------------------
transaction status: 0x0
description: transaction executed successfully
---------------------------------------------------------------------------------------------
Receipt message: Success
Return message: Success
Return value size:1
Return types: (STRING)
Return values:({'infoID':'BOC104','infoAmt':'4000','infoType':'12','infoIsseDate':'20110102','infoDueDate':'20110106','drwrAcct':'11','drwrCmID':'11','accptrAcct':'11','accptrCmID':'11','pyeeAcct':'11','pyeeCmID':'11','holdrAcct':'BBB','holdrCmID':'BID','waitEndorseAcct':'','waitEndorseCmID':'','rejectEndorseAcct':'','rejectEndorseCmID':'','state':'NewPublish'})
---------------------------------------------------------------------------------------------
Event logs
Event: {}

[group:1]> call BillController 0x37949ce7937696dafffeac91411acbbf9ed7e86b endorse "BOC104" "13" "AAA"
transaction hash: 0xcef2d7c74bc363b5bc7b81bbd15ba34aab5df5614f0ee47a249cfd53211796af
---------------------------------------------------------------------------------------------
transaction status: 0x0
description: transaction executed successfully
---------------------------------------------------------------------------------------------
Receipt message: Success
Return message: Success
Return value size:1
Return types: (BOOL)
Return values:(true)
---------------------------------------------------------------------------------------------
Event logs
Event: {"EndorseResult":[[true]]}

[group:1]>  call BillController 0x37949ce7937696dafffeac91411acbbf9ed7e86b queryBills "BID"
transaction hash: 0x809ba2db31f8da04b53532b26430385cfd58276fe4d28c891270cbb7ba4c1ede
---------------------------------------------------------------------------------------------
transaction status: 0x0
description: transaction executed successfully
---------------------------------------------------------------------------------------------
Receipt message: Success
Return message: Success
Return value size:1
Return types: ([STRING] )
Return values:([{'infoID':'BOC104','infoAmt':'4000','infoType':'12','infoIsseDate':'20110102','infoDueDate':'20110106','drwrAcct':'11','drwrCmID':'11','accptrAcct':'11','accptrCmID':'11','pyeeAcct':'11','pyeeCmID':'11','holdrAcct':'BBB','holdrCmID':'BID','waitEndorseAcct':'AAA','waitEndorseCmID':'13','rejectEndorseAcct':'','rejectEndorseCmID':'','state':'EndorseWaitSign'}] )
---------------------------------------------------------------------------------------------
Event logs
Event: {}
```

## 附 开发心得

开发过程中，最主要是对整个票据流程的梳理，针对各个方法的开发，其实并不是很难，只是对过程的一种描述。

因此，整个开发流程，先确立了先梳理需求，然后针对solidity语言开发出一个可用的版本。

