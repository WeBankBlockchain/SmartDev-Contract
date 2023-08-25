# 囚徒困境的智能合约实现

## 背景说明

“囚徒困境”是1950年美国兰德公司的梅里尔·弗勒德（MerrillFlood）和梅尔文·德雷希尔（MelvinDresher）拟定出相关困境的理论，后来由顾问艾伯特·塔克（AlbertTucker）以囚徒方式阐述，并命名为“囚徒困境”。两个共谋犯罪的人被关入监狱，不能互相沟通情况。如果两个人都不揭发对方，则由于证据不确定，每个人都坐牢一年；若一人揭发，而另一人沉默，则揭发者因为立功而立即获释，沉默者因不合作而入狱十年；若互相揭发，则因证据确凿，二者都判刑八年。由于囚徒无法信任对方，因此倾向于互相揭发，而不是同守沉默。最终导致纳什均衡仅落在非合作点上的博弈模型。

## 场景说明

本例是博弈论中囚徒困境的一种表现形式。2个“囚徒”被要求在一个固定的时间内来决策，决策的选项是平分或独享。根据“囚徒”们的不同选择，可以产生如下几种分配方案：
- 双方都决定平分，那么平分奖金；
- 一方决定平分，一方决定独享，那么选择独享的“囚徒”获取全部奖金；
- 双方都选择独享，那么奖金归“警察”所有；
- 如果只有一方及时提交决定，那么该“囚徒”获得全部奖金。


## 合约实现介绍

### 实现思路

我们把这个场景换成游戏的模式，2个玩家一起决定分配固定的奖金，玩家们可以选择平分或独享。保密工作是游戏进行的关键，因此玩家的选择不能提前公开，可以借助哈希值的方式分2次提交，这样能够避免提前泄密。

上述业务场景通过SplitOrSteal合约来实现。该合约提供的功能包括：
- getHash 计算哈希值
- getResult 获取分配方案
- submitHash 提交哈希
- submitVerify 提交哈希验证


### 方法介绍


***1. getHash方法：计算哈希值***
```js
function getHash(uint8 _opt, bytes memory _salt) public pure returns (bytes32)
```
参数说明：
- _opt 玩家的选项，2代表平分，4代表独享；
- _salt 计算哈希所用的盐
  
返回值说明：
- 哈希值


***2. submitHash方法：提交哈希值***
```js
function submitHash(bytes32 _hash) public 
```
参数说明：
- _hash 玩家自己计算的哈希值（通过gethHash方法计算）

***3. submitVerify方法：提交哈希验证***
```js
function submitVerify(uint8 _opt, bytes memory _salt) public 
```
参数说明：
- _opt 玩家的选项，2代表平分，4代表独享；
- _salt 计算哈希所用的盐

***4. getResult方法：获得分配方案***

```js
function getResult() public view returns (uint, uint, uint)
```

返回值说明：
- 返回值1 玩家1的奖励
- 返回值2 玩家2的奖励
- 返回值3 平台方的奖励





## 使用示例

由于并未实现该游戏的图形界面，因此通过管理台演示合约的使用。

### 步骤1 添加合约代码
首先，要将合约代码文件SplitOrSteal.sol存放到管理台合约路径下，默认情况下管理台的合约路径位于管理台根目录的contracts/solidity目录下。

### 步骤2 部署合约

测试时至少需要3个账户，包括一个平台账户，2个玩家账户。如果缺乏账户，可以使用newAccount命令来创建。

先使用listAccount命令来查看账户列表。

```sh
[group0]: /apps> listAccount
0xe2213fd8b50f504f246ec85db9d115cc95aa4709(current account) <=
0x86603e2657fdebcf9c16b8113fafc9edac87efa8
0x2a8920145639cc7fa8dbb1eeaeaaebd62ffd5272

```
根据账户列表情况，可以指定游戏相关账户：
- 平台方 0xe2213fd8b50f504f246ec85db9d115cc95aa4709
- 玩家1 0x86603e2657fdebcf9c16b8113fafc9edac87efa8
- 玩家2 0x2a8920145639cc7fa8dbb1eeaeaaebd62ffd5272

部署合约时，需要指定2个玩家的地址，操作如下：
```sh
[group0]: /apps> deploy contracts/solidity/SplitOrSteal 0x86603e2657fdebcf9c16b8113fafc9edac87efa8 0x2a8920145639cc7fa8dbb1eeaeaaebd62ffd5272
transaction hash: 0x71ff4b227ae711ae8c8e3f4b9f56ca02839de25a6d6b03b3ad14358c512d85d7
contract address: 0x3ef0869bd03f7d160e7fd94e594998a2e45ca3ae
currentAccount: 0xe2213fd8b50f504f246ec85db9d115cc95aa4709

```
得到部署后的合约地址：0x3ef0869bd03f7d160e7fd94e594998a2e45ca3ae

### 步骤3 计算哈希

玩家输入opt和salt来计算哈希，salt要绝对保密。由于我们测试时站在了上帝视角，因此可以先计算2个哈希值作为备选。


```sh
[group0]: /apps> call contracts/solidity/SplitOrSteal 0x3ef0869bd03f7d160e7fd94e594998a2e45ca3ae getHash 2 0x1234
transaction hash: 0xf95421ba23e6e7089e3966d84543e8142deee0015e60b8462d1652a91a06a566
---------------------------------------------------------------------------------------------
transaction status: 0
description: transaction executed successfully
---------------------------------------------------------------------------------------------
Receipt message: Success
Return message: Success
Return value size:1
Return types: (bytes32)
Return values:(hex://0x44697336231d9372703ddf5503f7fc373443d7bfbe787d1171e9cbc82a624014)
---------------------------------------------------------------------------------------------
Event logs
Event: {}
```
***哈希1***：opt = 2, salt = 0x1234, hash = 0x44697336231d9372703ddf5503f7fc373443d7bfbe787d1171e9cbc82a624014

```sh
[group0]: /apps> call contracts/solidity/SplitOrSteal 0x3ef0869bd03f7d160e7fd94e594998a2e45ca3ae getHash 4 0x2234
transaction hash: 0xbc456af156139baa21dd39a80a8fd7e709d5987da15bced21fd40b56f138e9b3
---------------------------------------------------------------------------------------------
transaction status: 0
description: transaction executed successfully
---------------------------------------------------------------------------------------------
Receipt message: Success
Return message: Success
Return value size:1
Return types: (bytes32)
Return values:(hex://0xbfe750b15f936c57dd818e38ac48753c0ab1656d94cbbc2c17156026f368ff65)
---------------------------------------------------------------------------------------------
Event logs
Event: {}

```
***哈希2***：opt = 4, salt = 0x2234, hash = 0xbfe750b15f936c57dd818e38ac48753c0ab1656d94cbbc2c17156026f368ff65


### 步骤4：玩家提交哈希

玩家1使用哈希值1，首先要切换到玩家1的账户。
```sh
[group0]: /apps> loadAccount 0x86603e2657fdebcf9c16b8113fafc9edac87efa8
Load account 0x86603e2657fdebcf9c16b8113fafc9edac87efa8 success!

```
玩家1提交哈希
```sh
[group0]: /apps> call contracts/solidity/SplitOrSteal 0x3ef0869bd03f7d160e7fd94e594998a2e45ca3ae submitHash hex://0x44697336231d9372703ddf5503f7fc373443d7bfbe787d1171e9cbc82a624014
transaction hash: 0x92a4a5509453589e4c3a7c2e84f8d8233e3ffa36ba619f1936aa90947ad19236
---------------------------------------------------------------------------------------------
transaction status: 0
description: transaction executed successfully
---------------------------------------------------------------------------------------------
Receipt message: Success
Return message: Success
Return value size:0
Return types: ()
Return values:()
---------------------------------------------------------------------------------------------
Event logs
Event: {}

```
玩家2使用哈希值2，首先要切换到玩家2的账户。

```sh
[group0]: /apps> loadAccount 0x2a8920145639cc7fa8dbb1eeaeaaebd62ffd5272
Load account 0x2a8920145639cc7fa8dbb1eeaeaaebd62ffd5272 success!

```
玩家2提交哈希
```sh
[group0]: /apps> call contracts/solidity/SplitOrSteal 0x3ef0869bd03f7d160e7fd94e594998a2e45ca3ae submitHash hex://0xbfe750b15f936c57dd818e38ac48753c0ab1656d94cbbc2c17156026f368ff65
transaction hash: 0x1c78fb21e193a02aee26c79431c6f988848a765f4d33c51c157771cc3dd54941
---------------------------------------------------------------------------------------------
transaction status: 0
description: transaction executed successfully
---------------------------------------------------------------------------------------------
Receipt message: Success
Return message: Success
Return value size:0
Return types: ()
Return values:()
---------------------------------------------------------------------------------------------
Event logs
Event: {}


```


### 步骤5 提交证明(超时了)

提交证明时，要判断对方玩家已经提交了哈希值，否则不可以提交。因为我们前面已经都提交过过哈希值了，因此本步骤不会有上述问题。

玩家2提交哈希证明(之所以用玩家2是因为当前账户是玩家2)
```sh
[group0]: /apps> call contracts/solidity/SplitOrSteal 0x3ef0869bd03f7d160e7fd94e594998a2e45ca3ae submitVerify 4 0x2234
transaction hash: 0xc38bc88d067d7037ca7fbc83ff2c4c94f48d6c31fdd84baed6b8c930e3e045d2
---------------------------------------------------------------------------------------------
transaction status: 16
---------------------------------------------------------------------------------------------
Receipt message: timeout!!
Return message: timeout!!
---------------------------------------------------------------------------------------------

```
很遗憾的是笔者操作超时了（600秒），此时刚好检测一下分配方案，平台方应该拿走全部，结果符合预期。
```sh
[group0]: /apps> call contracts/solidity/SplitOrSteal 0x3ef0869bd03f7d160e7fd94e594998a2e45ca3ae getResult
---------------------------------------------------------------------------------------------
Return code: 0
description: transaction executed successfully
Return message: Success
---------------------------------------------------------------------------------------------
Return value size:3
Return types: (uint256, uint256, uint256)
Return values:(0, 0, 100)
---------------------------------------------------------------------------------------------
```


### 步骤6 重新部署合约

修改超时时间，fisco-bcos的时间精度是毫秒，大家测试的时候可以根据自己的手速来决定超时时长。
```sol
expireTime = block.timestamp + 6000 * 1000;
```

将当前账户切换到平台方账户，然后再次部署合约
```sh
[group0]: /apps> loadAccount 0xe2213fd8b50f504f246ec85db9d115cc95aa4709
Load account 0xe2213fd8b50f504f246ec85db9d115cc95aa4709 success!

[group0]: /apps> deploy contracts/solidity/SplitOrSteal 0x86603e2657fdebcf9c16b8113fafc9edac87efa8 0x2a8920145639cc7fa8dbb1eeaeaaebd62ffd5272
transaction hash: 0x29b3e16d2ed385b49885818c4ed1bf854845554242dc8adef9c5a51503ff760e
contract address: 0x08fc1a1af6ec1dbfbe7809aab3208aec7ebfcde7
currentAccount: 0xe2213fd8b50f504f246ec85db9d115cc95aa4709

```
得到新得合约地址为：0x08fc1a1af6ec1dbfbe7809aab3208aec7ebfcde7

### 步骤7 重新提交哈希

玩家1使用哈希值1，首先要切换到玩家1的账户。
```sh
[group0]: /apps> loadAccount 0x86603e2657fdebcf9c16b8113fafc9edac87efa8
Load account 0x86603e2657fdebcf9c16b8113fafc9edac87efa8 success!

```
玩家1提交哈希
```sh
[group0]: /apps> call contracts/solidity/SplitOrSteal 0x08fc1a1af6ec1dbfbe7809aab3208aec7ebfcde7 submitHash hex://0x44697336231d9372703ddf5503f7fc373443d7bfbe787d1171e9cbc82a624014
transaction hash: 0x0934ab9179ec5e15ad42d17bbba4041d939bc7d2649694194cbb7fb6a78fdee8
---------------------------------------------------------------------------------------------
transaction status: 0
description: transaction executed successfully
---------------------------------------------------------------------------------------------
Receipt message: Success
Return message: Success
Return value size:0
Return types: ()
Return values:()
---------------------------------------------------------------------------------------------
Event logs
Event: {}

```

玩家2使用哈希值2，首先要切换到玩家2的账户。

```sh
[group0]: /apps> loadAccount 0x2a8920145639cc7fa8dbb1eeaeaaebd62ffd5272
Load account 0x2a8920145639cc7fa8dbb1eeaeaaebd62ffd5272 success!

```
玩家2提交哈希
```sh
[group0]: /apps> call contracts/solidity/SplitOrSteal 0x08fc1a1af6ec1dbfbe7809aab3208aec7ebfcde7 submitHash hex://0xbfe750b15f936c57dd818e38ac48753c0ab1656d94cbbc2c17156026f368ff65
transaction hash: 0x081a0bec485162caa7be51437edc69d3eb40290d682471595e16b9953916c2a0
---------------------------------------------------------------------------------------------
transaction status: 0
description: transaction executed successfully
---------------------------------------------------------------------------------------------
Receipt message: Success
Return message: Success
Return value size:0
Return types: ()
Return values:()
---------------------------------------------------------------------------------------------
Event logs
Event: {}


```

### 步骤8 提交哈希验证

玩家2先提交哈希验证

```sh
[group0]: /apps> call contracts/solidity/SplitOrSteal 0x08fc1a1af6ec1dbfbe7809aab3208aec7ebfcde7 submitVerify 4 0x2234
transaction hash: 0x024681c2330d5d017204e40a69e43fc3a59894325d0db300d8b33fb7db1ced0d
---------------------------------------------------------------------------------------------
transaction status: 0
description: transaction executed successfully
---------------------------------------------------------------------------------------------
Receipt message: Success
Return message: Success
Return value size:0
Return types: ()
Return values:()
---------------------------------------------------------------------------------------------
Event logs
Event: {}


```

玩家1使用哈希值1，首先要切换到玩家1的账户。
```sh
[group0]: /apps> loadAccount 0x86603e2657fdebcf9c16b8113fafc9edac87efa8
Load account 0x86603e2657fdebcf9c16b8113fafc9edac87efa8 success!

```
玩家1提交哈希验证。
```sh
[group0]: /apps> call contracts/solidity/SplitOrSteal 0x08fc1a1af6ec1dbfbe7809aab3208aec7ebfcde7 submitVerify 2 0x1234
transaction hash: 0x3e8f5dbb64daf947f2075c7b308a3bab9e1d5853fcb77946f30c5a9df936a178
---------------------------------------------------------------------------------------------
transaction status: 0
description: transaction executed successfully
---------------------------------------------------------------------------------------------
Receipt message: Success
Return message: Success
Return value size:0
Return types: ()
Return values:()
---------------------------------------------------------------------------------------------
Event logs
Event: {}
```

### 步骤9 查看游戏结果

根据之前玩家的选项，可以预测结果为玩家2获得全部奖励。

```sh
[group0]: /apps> call contracts/solidity/SplitOrSteal 0x08fc1a1af6ec1dbfbe7809aab3208aec7ebfcde7 getResult
---------------------------------------------------------------------------------------------
Return code: 0
description: transaction executed successfully
Return message: Success
---------------------------------------------------------------------------------------------
Return value size:3
Return types: (uint256, uint256, uint256)
Return values:(0, 100, 0)
---------------------------------------------------------------------------------------------

```

本游戏的奖励仅用一个数字代替，在实际使用时可以使用数字资产来代表奖励。