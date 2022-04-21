## 背景说明

人们在现实生活中解决分歧时有时候会采使用一种”剪刀石头布“的玩法。改玩法可以解决分歧，但却在出拳时存在争议，在《非诚勿扰》电影中，葛优曾经将一个分歧终端机的设计理念卖给范伟，收获200万英镑。
有了区块链和智能合约这两个利器后，我们也可以将这个分歧终端的理念移植到智能合约中。也就是用智能合约去支持”剪刀石头布“的游戏玩法。



## 场景说明

当2个人或双方因为某些市场出现分歧时，一方无法理性的说服另一方时，在双方认可的情况下，可以通过该合约解决分歧。



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
- a 玩家1的出拳数据，取值范围为0-2，0-剪刀，1-石头，2-布
- b 对手的出拳数据，取值范围同a
  
返回值说明：
- 0 相等（打平）
- 1 大于（当前玩家获胜）
- 2 小于（对手获胜）


### Divergence合约：


1. register方法：参与游戏的玩家注册。
```js
function register(string memory _name)  external; 
```
参数说明：
- name 玩家昵称，前2名不同地址用户可以注册成功

2. punch方法：参与游戏的玩家出拳。
```js
function punch(bytes32 _hash)  external; 
```
参数说明：
- _hash 为避免信息泄露，玩家并不直接提供出拳内容，而是提供一共出拳的哈希值，可由后面的helper方法生成。

3. proofing方法：出拳哈希证明。

```js
function proofing(string memory _salt, uint8 _opt) override external;
```

proxy合约：接受外部积分授权的唯一接口。包含：

- setPointAddr(address _addr): 设置积分合约地址，_addr为一个已经部署的积分合约地址

- transfer(address _from, address _to, uint256 _value): 转账合约，完成抢红包动作时的转账操作

- addr()：返回本合约地址

- balanceOf(address _who): 获取用户的积分余额

- allowance(address _from): 获取_from授权给本合约的额度



redpacket合约：红包合约。包含：

- getProxy(): 获取proxy地址

- transfer(address _from, address _to, uint256 _value): 转账合约，完成抢红包动作时的转账操作

- sendRedPacket(uint256 c, bool ok, address addr, uint256 amount)：发红包动作，c代表数量，ok代表是否等额，addr为要发送的红包积分地址，amount代表红包数量

- grabRedpacket(): 抢红包动作





## 使用示例



当前控制台视图下，可以看到redpacket目录内文件如下：

```sh
parallels@parallels-vm:~/fisco/newconcole/console-0.6$ tree contracts/solidity/redpacket/
contracts/solidity/redpacket/
├── IERC20.sol
├── mypoints.sol
├── proxy.sol
├── redpacket.sol
└── SafeMath.sol
```



假如现在要执行一个发红包、抢红包动作，整个过程如下：



### 1. 合约初始化：

需要先部署积分合约，再部署redpacket合约。



#### 1.1   需要先部署积分合约，并且给“土豪”发一点积分

部署积分合约

```sh
[group:1]> deploy contracts/solidity/redpacket/mypoints.sol ykc ykc
transaction hash: 0x8c7914c8023955690b2519e3b571d6bba7a47ca7a54c499f065a3161876aea08
contract address: 0xdc9f277d4b706f0e8e4ce4c3b94a726ee716368f
currentAccount: 0x126235d39382170c8aafacfd1f430610190d8de9
```

给“土豪”发一点积分

```sh
[group:1]> listAccount 
0x126235d39382170c8aafacfd1f430610190d8de9(current account) <=
0xf6e254e6bd8c7d6799dd72d30fa440a8bf06a39f

[group:1]> call contracts/solidity/redpacket/mypoints.sol 0xdc9f277d4b706f0e8e4ce4c3b94a726ee716368f mint 0x126235d39382170c8aafacfd1f430610190d8de9 100000
transaction hash: 0x80838424fdfe33d69bafc6d67f185b2a7a754f8697b567f373697e1274e6d365
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
Event: {"Transfer":[[100000]]}
```





#### 1.2 部署redpacket合约

部署redpacket合约

```sh
[group:1]> deploy contracts/solidity/redpacket/redpacket.sol 
transaction hash: 0x6df39b0423a48b9cf89518b90623a796be1d36bb36c559ad9045af55e7106310
contract address: 0x8f671f69efab33437123b02701560ee80546b9e8
currentAccount: 0x126235d39382170c8aafacfd1f430610190d8de9
```



### 2. 合约调用



#### 2.1 获取proxy地址

```sh
[group:1]> call contracts/solidity/redpacket/redpacket.sol 0x8f671f69efab33437123b02701560ee80546b9e8 getProxy
---------------------------------------------------------------------------------------------
Return code: 0
description: transaction executed successfully
Return message: Success
---------------------------------------------------------------------------------------------
Return value size:1
Return types: (ADDRESS)
Return values:(0x66e6fbb2cf7bf635653db398de624c09c2cd52cf)
---------------------------------------------------------------------------------------------
```

#### 2.2 土豪调用积分授权合约

在这里要用到前一步获得的proxy合约地址，土豪将自己的积分授权给proxy合约。

```sh
[group:1]> call contracts/solidity/redpacket/mypoints.sol 0xdc9f277d4b706f0e8e4ce4c3b94a726ee716368f approve 0x66e6fbb2cf7bf635653db398de624c09c2cd52cf 1000
transaction hash: 0xc8b0e6b93630751e68f6ae7a20e61ae0df1b22b8548944ea9e0806950b7a2deb
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
Event: {"Approval":[[1000]]}
```



#### 2.3 土豪执行发红包动作

这里说的“土豪”实际上是控制台的默认账户。

这一步，需要调用redpacket合约中的sendRedPacket，需要传给它的参数是：红包数量，是否等值红包，积分合约地址，红包总金额

```sh
[group:1]> call contracts/solidity/redpacket/redpacket.sol 0x8f671f69efab33437123b02701560ee80546b9e8 sendRedPacket 4 true 0xdc9f277d4b706f0e8e4ce4c3b94a726ee716368f 1000
transaction hash: 0x0416c14b18fac4b3cebbf07d4e85b2146002f97e95d16eb7411cc1a92ba540c2
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

#### 2.4 切换另外一个用户抢红包

先切换一下调用用户，使用loadAccount可以完成此操作。

```sh
[group:1]> listAccount 
0x126235d39382170c8aafacfd1f430610190d8de9(current account) <=
0xf6e254e6bd8c7d6799dd72d30fa440a8bf06a39f

[group:1]> loadAccount 0xf6e254e6bd8c7d6799dd72d30fa440a8bf06a39f
Load account 0xf6e254e6bd8c7d6799dd72d30fa440a8bf06a39f success!

[group:1]> listAccount 
0xf6e254e6bd8c7d6799dd72d30fa440a8bf06a39f(current account) <=
0x126235d39382170c8aafacfd1f430610190d8de9
```

查询当前账户的余额

```sh
[group:1]> call contracts/solidity/redpacket/mypoints.sol 0xdc9f277d4b706f0e8e4ce4c3b94a726ee716368f balanceOf 0xf6e254e6bd8c7d6799dd72d30fa440a8bf06a39f
---------------------------------------------------------------------------------------------
Return code: 0
description: transaction executed successfully
Return message: Success
---------------------------------------------------------------------------------------------
Return value size:1
Return types: (UINT)
Return values:(0)
---------------------------------------------------------------------------------------------

```

此时，可以调用抢红包方法grabRedpacket

```sh
[group:1]> call contracts/solidity/redpacket/redpacket.sol 0x8f671f69efab33437123b02701560ee80546b9e8 grabRedpacket
transaction hash: 0x856ee929442b6b7eb6e0d884df63330db59a2ccbcd37ccf3ea15c53821205225
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

再次查看当前账户的余额，发现变为了250。

```sh
[group:1]> call contracts/solidity/redpacket/mypoints.sol 0xdc9f277d4b706f0e8e4ce4c3b94a726ee716368f balanceOf 0xf6e254e6bd8c7d6799dd72d30fa440a8bf06a39f
---------------------------------------------------------------------------------------------
Return code: 0
description: transaction executed successfully
Return message: Success
---------------------------------------------------------------------------------------------
Return value size:1
Return types: (UINT)
Return values:(250)
---------------------------------------------------------------------------------------------

```

