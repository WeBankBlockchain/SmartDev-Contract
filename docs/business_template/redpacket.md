## 土豪发红包背景说明



发红包是现实中常见的一种生活方式，本方案是将原本发红包使用的现金，替换成了ERC20标准的积分。



## 场景说明



具体业务场景也可以是商家发放的优惠券，代金券等等。



## 接口



提供了3+2个合约：其中3个合约为目前标准化合约，分别是IERC20接口，mypoints（积分的一个模拟实现），SafeMath（安全计算库），另外2个合约是主要逻辑合约，redpacket合约和proxy合约。其中proxy合约是对外接受统一的积分授权服务，为辅助合约，redpacket为发红包合约。



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

