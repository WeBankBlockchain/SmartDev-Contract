## 背景说明

人们在现实生活中解决分歧时有时候会采使用一种”剪刀石头布“的玩法。该玩法可以解决分歧，但却在出拳时的出手快慢上存在争议，在《非诚勿扰》电影中，葛优曾经将一个分歧终端机的设计理念卖给范伟，收获200万英镑。
有了区块链和智能合约这两个利器后，我们也可以将这个分歧终端的理念移植到智能合约中，也就是利用智能合约去支持”剪刀石头布“的游戏玩法。



## 场景说明

当2个人或双方因为某些事情出现分歧，一方无法理性的说服另一方时，在双方认可的情况下，可以通过该合约功能解决分歧。



## 接口

本例一共包含3个合约文件，具体说明如下：
- IDivergence.sol 接口定义合约，定义合约要支持的主要方法
- Divergence.sol 功能实现合约，用于实现接口内的方法
- LibGameCompare.sol 库合约，用于计算出拳的获胜方

接下来，我们再来说一下合约的主要方法。

### LibGameCompare合约：


max方法：计算获胜方
```js
function max(uint8 a, uint8 b) internal pure returns (uint8); 
```
参数说明：
- a 玩家的出拳数据，取值范围为0~2，0-剪刀，1-石头，2-布
- b 对手的出拳数据，取值范围同a
  
返回值说明：
- 0 相等（打平）
- 1 大于（当前玩家获胜）
- 2 小于（对手获胜）


### Divergence合约：


1. register方法：参与游戏的玩家注册
```js
function register(string memory _name)  external; 
```
参数说明：
- name 玩家昵称，前2名不同地址用户可以注册成功

2. punch方法：参与游戏的玩家出拳
```js
function punch(bytes32 _hash)  external; 
```
参数说明：
- _hash 为避免信息泄露，玩家并不直接提供出拳内容，而是提供一个出拳的哈希值，可由后面的helper方法生成。

3. proofing方法：出拳哈希证明

```js
function proofing(string memory _salt, uint8 _opt)  external;
```

参数说明：
- _salt 计算哈希的元素之一，避免彩虹表攻击
- _opt  玩家出拳值，取值范围0~2，参考LibGameCompare库的max方法中的参数取值

4. helper方法：游戏辅助方法，用于生成哈希值

```js
function helper(string memory _salt, uint8 _opt) public view returns (bytes32)
```

参数说明：
- _salt 计算哈希的元素之一，避免彩虹表攻击
- _opt  玩家出拳值，取值范围0~2，参考LibGameCompare库的max方法

返回值：返回玩家要出拳的哈希值

5. winner方法：返回获胜玩家及出手情况

```js
function winner() external view returns (string memory, string memory, string memory, uint256)
```

返回值说明：
- 返回值1 获胜玩家昵称
- 返回值2 获胜玩家出手内容
- 返回值3 对手出手内容
- 返回值4 分出胜负轮次



## 使用示例

由于并未实现该游戏的图形界面，因此通过管理台演示合约的使用。

### 步骤1 添加合约代码
首先，要将合约代码存放到管理台合约路径下，默认情况下管理台的合约路径位于管理台根目录的contracts/solidity目录下，为了便于管理，我们可以单独创建一个divergence的目录，呈现效果如下：

```sh
$ tree contracts/solidity/divergence/
contracts/solidity/divergence/
├── Divergence.sol
├── IDivergence.sol
└── LibGameCompare.sol

```

### 步骤2 部署合约

合约部署可以在管理台直接部署，对账户没有要求。

```sh
[group:1]> deploy contracts/solidity/divergence/Divergence.sol
transaction hash: 0x0525b563658183880b2616015f367b223d5cf431bf789fa6f36dfb00c461e090
contract address: 0x4f56b07c7d1fbf979c238be84e30a72faf901b73
currentAccount: 0x84e6ab1e7e09355d324b825171a861a3c7ed3c7d

```
部署合约后，可以通过回显看到部署的合约地址为：0x4f56b07c7d1fbf979c238be84e30a72faf901b73

### 步骤3 玩家注册

玩家操作时，需要明确操作的账户信息，可以通过listAccount命令查看，效果如下：
```sh
[group:1]> listAccount
0x84e6ab1e7e09355d324b825171a861a3c7ed3c7d(current account) <=
0x4b0444233271616d77a9f2123c59b73001098bfd
```
(current account)提示`0x84e6ab1e7e09355d324b825171a861a3c7ed3c7d`为当前默认账户。


本游戏需要2个玩家，因此需要2个账户，当listAccount显示的账户只有1个时，需要再创建1个，可通过newAccount命令创建账户，效果如下。

```sh
[group:1]> newAccount
AccountPath: account/ecdsa/0xe8eafa9f9c328f6e7469a35a98c69eb633568e87.pem
Note: This operation does not create an account in the blockchain, but only creates a local account, and deploying a contract through this account will create an account in the blockchain
newAccount: 0xe8eafa9f9c328f6e7469a35a98c69eb633568e87
AccountType: ecdsa

```
输出信息中也提示了新创建的账户文件保存位置，后面切换账户时会用到。


接下来，按照笔者的显示，使用`0x84e6ab1e7e09355d324b825171a861a3c7ed3c7d`地址来注册第1个玩家。
使用call命令调用合约，传入参数依次为合约名称 合约地址 方法名称 调用参数。

```sh
[group:1]> call Divergence 0x4f56b07c7d1fbf979c238be84e30a72faf901b73 register yekai
transaction hash: 0x020271b45adba6e0ac77aab80aef5d6d145c73b27b4777d48705ab3e8a278327
---------------------------------------------------------------------------------------------
transaction status: 0x0
description: transaction executed successfully
---------------------------------------------------------------------------------------------
Receipt message: Success
Return message: Success
Return values:[]
---------------------------------------------------------------------------------------------
Event logs
Event: {}

```

第1个账户已经注册完成，接下来注册第2个账户。
第2个账户注册时，需要先切换默认账户地址，可以使用loadAccount命令，演示如下。

```sh
[group:1]> loadAccount account/ecdsa/0xe8eafa9f9c328f6e7469a35a98c69eb633568e87.pem pem
Load account account/ecdsa/0xe8eafa9f9c328f6e7469a35a98c69eb633568e87.pem success!


```

执行完成后，当前账户地址已经变更为`0xe8eafa9f9c328f6e7469a35a98c69eb633568e87`，
接下来，注册另一个玩家fuhongxue。

```sh
[group:1]> call Divergence 0x4f56b07c7d1fbf979c238be84e30a72faf901b73 register fuhongxue
transaction hash: 0xc9c6efc2cc0d80d79aa62f91da816ab46365f94fecca6eaf115bc925e655af16
---------------------------------------------------------------------------------------------
transaction status: 0x0
description: transaction executed successfully
---------------------------------------------------------------------------------------------
Receipt message: Success
Return message: Success
Return values:[]
---------------------------------------------------------------------------------------------
Event logs
Event: {}

```

### 步骤4 游戏准备

因为玩家出拳时需要给出哈希值，需要借助helper方法来生成哈希值，我们可以先提前生成几个哈希值，方便之后使用（也可以每次玩家出拳时，自己提前计算哈希值）。

玩家可以根据实际情况输入salt和opt参数来得到自己的哈希值，笔者演示的是salt=fisco，opt=1时哈希值为`0xe8e2570ea600aa591b4a981438ecc16a5dfd7051830771e96f5412eb29ac1ed6`。

```sh
[group:1]> call Divergence 0x4f56b07c7d1fbf979c238be84e30a72faf901b73 helper fisco 1
---------------------------------------------------------------------------------------------
Return code: 0
description: transaction executed successfully
Return message: Success
---------------------------------------------------------------------------------------------
Return value size:1
Return types: (BYTES)
Return values:(hex://0xe8e2570ea600aa591b4a981438ecc16a5dfd7051830771e96f5412eb29ac1ed6)
---------------------------------------------------------------------------------------------

```


计算salt=bcos，opt=1哈希值为`0x37f06fb5392b53e9c6873eea22c001256b879831246fe56906f8edb8b1372df7`。
```sh
[group:1]> call Divergence 0x4f56b07c7d1fbf979c238be84e30a72faf901b73 helper bcos 1
---------------------------------------------------------------------------------------------
Return code: 0
description: transaction executed successfully
Return message: Success
---------------------------------------------------------------------------------------------
Return value size:1
Return types: (BYTES)
Return values:(hex://0x37f06fb5392b53e9c6873eea22c001256b879831246fe56906f8edb8b1372df7)
---------------------------------------------------------------------------------------------

```

计算salt=yekai，opt=2哈希值为`0xcb53dc98f299d0dbd3881b48a7803b65878d0f60c85284f82d968a57c64dfc3a`。
```sh
[group:1]> call Divergence 0x4f56b07c7d1fbf979c238be84e30a72faf901b73 helper yekai 2
---------------------------------------------------------------------------------------------
Return code: 0
description: transaction executed successfully
Return message: Success
---------------------------------------------------------------------------------------------
Return value size:1
Return types: (BYTES)
Return values:(hex://0xcb53dc98f299d0dbd3881b48a7803b65878d0f60c85284f82d968a57c64dfc3a)
---------------------------------------------------------------------------------------------

```

### 步骤5 玩家fuhongxue出拳

谁先出拳没有要求，只是因为当前默认账户是fuhongxue，因此选择让其先出拳。

fuhongxue选择opt=1，salt=fisco的一个哈希值出拳。
```sh
[group:1]> call Divergence 0x4f56b07c7d1fbf979c238be84e30a72faf901b73 punch hex://0xe8e2570ea600aa591b4a981438ecc16a5dfd7051830771e96f5412eb29ac1ed6
transaction hash: 0xb6493ccfe3e596ce8ddc3f478828732fb5b76f3fe122b350f5fe4d5a8a96aaf8
---------------------------------------------------------------------------------------------
transaction status: 0x0
description: transaction executed successfully
---------------------------------------------------------------------------------------------
Receipt message: Success
Return message: Success
Return values:[]
---------------------------------------------------------------------------------------------
Event logs
Event: {"Punch":[["��W\u000E�\u0000�Y\u001BJ�\u00148��j]�pQ�\u0007q�oT\u0012�)�\u001E�"]]}

```

### 步骤5 玩家yekai出拳

出拳之前需要先切换到yekai对应的账户，演示效果如下：

```sh
[group:1]> loadAccount account/ecdsa/0x84e6ab1e7e09355d324b825171a861a3c7ed3c7d.pem pem
Load account account/ecdsa/0x84e6ab1e7e09355d324b825171a861a3c7ed3c7d.pem success!

```

yekai选择opt=1，salt=bcos的一个哈希值出拳，演示效果如下：
```sh
[group:1]> call Divergence 0x4f56b07c7d1fbf979c238be84e30a72faf901b73 punch hex://0x37f06fb5392b53e9c6873eea22c001256b879831246fe56906f8edb8b1372df7
transaction hash: 0x20e30b03df556cf53bea05e0f152aa803cd62083a917b388f2948459405a95a3
---------------------------------------------------------------------------------------------
transaction status: 0x0
description: transaction executed successfully
---------------------------------------------------------------------------------------------
Receipt message: Success
Return message: Success
Return values:[]
---------------------------------------------------------------------------------------------
Event logs
Event: {"Punch":[["7�o�9+S�Ƈ>�\"�\u0001%k��1$o�i\u0006��7-�"]]}


```

### 步骤6 双方提交证明

先由yekai提交证明，演示效果如下：
```sh
[group:1]> call Divergence 0x4f56b07c7d1fbf979c238be84e30a72faf901b73 proofing bcos 1
transaction hash: 0x5cbf344e3587b47046b561094bfe71005846aabc663d6c12b4b78b2f6d0e433b
---------------------------------------------------------------------------------------------
transaction status: 0x0
description: transaction executed successfully
---------------------------------------------------------------------------------------------
Receipt message: Success
Return message: Success
Return values:[]
---------------------------------------------------------------------------------------------
Event logs
Event: {"Proof":[[1,"bcos"]]}


```

接下来切换至fuhongxue对应的账户，演示效果如下：

```sh
[group:1]> loadAccount account/ecdsa/0xe8eafa9f9c328f6e7469a35a98c69eb633568e87.pem pem
Load account account/ecdsa/0xe8eafa9f9c328f6e7469a35a98c69eb633568e87.pem success!

```
fuhongxue提交出拳证明，演示效果如下：

```sh
[group:1]> call Divergence 0x4f56b07c7d1fbf979c238be84e30a72faf901b73 proofing fisco 1
transaction hash: 0x3f03c56339545c1ea26ef8ca0ae3314a85d5f777a64af22bf16fa60277e17d9e
---------------------------------------------------------------------------------------------
transaction status: 0x0
description: transaction executed successfully
---------------------------------------------------------------------------------------------
Receipt message: Success
Return message: Success
Return values:[]
---------------------------------------------------------------------------------------------
Event logs
Event: {"Proof":[[1,"fisco"]]}

```

### 步骤7 查看游戏结果

在刻意安排下，两个人将会打平，操作演示如下：

```sh
[group:1]> call Divergence 0x4f56b07c7d1fbf979c238be84e30a72faf901b73 winner
---------------------------------------------------------------------------------------------
Return code: 0
description: transaction executed successfully
Return message: Success
---------------------------------------------------------------------------------------------
Return value size:4
Return types: (STRING, STRING, STRING, UINT)
Return values:(none, none, none, 88888)
---------------------------------------------------------------------------------------------

```

### 步骤8 重复步骤5~7，直到分出胜负

接下来，可以安排yekai赢得游戏，由于步骤和之前雷同，只是提交数据不同，想办法在这一步直接让对方分出胜负。

fuhongxue再次出拳，选择opt=1，salt=fisco的一个哈希值出拳。
```sh
[group:1]> call Divergence 0x4f56b07c7d1fbf979c238be84e30a72faf901b73 punch hex://0xe8e2570ea600aa591b4a981438ecc16a5dfd7051830771e96f5412eb29ac1ed6
transaction hash: 0xb6493ccfe3e596ce8ddc3f478828732fb5b76f3fe122b350f5fe4d5a8a96aaf8
---------------------------------------------------------------------------------------------
transaction status: 0x0
description: transaction executed successfully
---------------------------------------------------------------------------------------------
Receipt message: Success
Return message: Success
Return values:[]
---------------------------------------------------------------------------------------------
Event logs
Event: {"Punch":[["��W\u000E�\u0000�Y\u001BJ�\u00148��j]�pQ�\u0007q�oT\u0012�)�\u001E�"]]}

```

切换到yekai账户，并使用opt=2的哈希值出拳。

```sh
[group:1]> loadAccount account/ecdsa/0x84e6ab1e7e09355d324b825171a861a3c7ed3c7d.pem pem
Load account account/ecdsa/0x84e6ab1e7e09355d324b825171a861a3c7ed3c7d.pem success!

[group:1]> call Divergence 0x4f56b07c7d1fbf979c238be84e30a72faf901b73 punch hex://0xcb53dc98f299d0dbd3881b48a7803b65878d0f60c85284f82d968a57c64dfc3a
transaction hash: 0x2bb06e3503428ba791e2e33c18bce15584328d890d16d2533f277d924b10e035
---------------------------------------------------------------------------------------------
transaction status: 0x0
description: transaction executed successfully
---------------------------------------------------------------------------------------------
Receipt message: Success
Return message: Success
Return values:[]
---------------------------------------------------------------------------------------------
Event logs
Event: {"Punch":[["�Sܘ���ӈ\u001BH��;e��\u000F`�R��-��W�M�:"]]}

```

yekai提交证明

```sh
[group:1]> call Divergence 0x4f56b07c7d1fbf979c238be84e30a72faf901b73 proofing yekai 2
transaction hash: 0x845332cdc6642a7efa886b7e996e5294300ddeef6548dbdaaa8f2187462797b7
---------------------------------------------------------------------------------------------
transaction status: 0x0
description: transaction executed successfully
---------------------------------------------------------------------------------------------
Receipt message: Success
Return message: Success
Return values:[]
---------------------------------------------------------------------------------------------
Event logs
Event: {"Proof":[[2,"yekai"]]}

```

切换到fuhongxue账户，并提交证明
```sh
[group:1]> loadAccount account/ecdsa/0xe8eafa9f9c328f6e7469a35a98c69eb633568e87.pem
Load account account/ecdsa/0xe8eafa9f9c328f6e7469a35a98c69eb633568e87.pem success!

[group:1]> call Divergence 0x4f56b07c7d1fbf979c238be84e30a72faf901b73 proofing fisco 1
transaction hash: 0x797636f014e8354d43d100f9dad1a4fac7d6fddcd6afdfb2643b3ad0a5546e0b
---------------------------------------------------------------------------------------------
transaction status: 0x0
description: transaction executed successfully
---------------------------------------------------------------------------------------------
Receipt message: Success
Return message: Success
Return values:[]
---------------------------------------------------------------------------------------------
Event logs
Event: {"Proof":[[1,"fisco"]],"WinnerBorn":[["yekai",2,2]]}

```

再次查看游戏结果：
```sh
[group:1]> call Divergence 0x4f56b07c7d1fbf979c238be84e30a72faf901b73 winner
---------------------------------------------------------------------------------------------
Return code: 0
description: transaction executed successfully
Return message: Success
---------------------------------------------------------------------------------------------
Return value size:4
Return types: (STRING, STRING, STRING, UINT)
Return values:(yekai, paper, rock, 2)
---------------------------------------------------------------------------------------------


```

最终，经过测试，yekai在游戏的第二轮获得了胜利。