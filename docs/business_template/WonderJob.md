# WonderJob

## Introduction
WonderJob为web3远程工作平台解决方案，意为填补web3招聘类板块的最后一个缺口。可以借助web3的去中心化、自动托管机制的优势创作一个全新于web2的解决方案。

---

## Features
### 用户管理
实际上用户分为派发任务的托管者与任务委托者，用户注册的时候必须强绑定其中一个身份或者是可以兼任两个身份属性，也就是即是任务的托管者与任务的委托者。

---
### 订单履行
订单系统部分由任务派发者实施，创建一个任务需求后，`OrderExecutor`实际上会帮助任务派发者生成一个订单结构，也就是struct `Order`，其中创建前需要派发者对订单的Nonce，价格和过期时间等重要数据进行签名操作，签名数据将在合约中校验并存入为`OrderId`，`OrderId`只有任务派发者可见。

订单创建包含了任务委托者, 订单状态, 过期时间和ipfs包含的任务描述内容链接等重要信息, 订单创建时请确保钱包有足够的资产用于支付任务报酬的资金，托管到`WonderJobFundEscrowPool`合约。最后当委托者完成任务上传并且审核无误后，由任务派发者完成订单，托管的资金会被下发到任务委托者地址中，至此完成了整个任务的流程。

---

### 平台费用
当完成所有任务流程后，如果开启费用，例如：平台开启1%的费用，实际上任务委托者实际收到的报酬为(reward - reward * 1%)

---
### 信用分系统
`WonderJobArbitration` 为独立的仲裁合约，`orderValidatorCallWithFallback(address user, Order calldata params)` 接口负责信用分回调，其中为了提升用户感知，运用了大量的Gas optimized进行设计，在任务委托者和任务派发者中间操作(取消订单，完成订单，提交订单)时评估用户操作，可以理解为订单超时，纠纷次数太多，新用户第一次完成订单等给予信用分奖励和惩罚。

对于信用分低于预期的50分，介于0～10之间，将无法参与任何任务委托操作，直到分数达到要求。不满足的用户可以向其他用户买分或者是转移信用分，直到达到最低信用分阀值。

--- 
### 代理升级
使用Beacon代理模式实现可升级合约，所有一切调用方式将由`beaconProxy` 进行`delegateCall`调用到`WonderJob`合约。

---
### 接下来实现的V2方案
- V2版本增加广告激励部分，把广告激励(10%-50%)流入到用户中，实现流动性激励方案，这根据用户的等级或者分数来决定，具体来讲可能是`CreditScore`或者根据`UserEstimate`来评估。
- 纠纷订单：
    - 链下纠纷，复杂的链下纠纷问题，交由Role组来介入解决，会双向收取介入费用(1%-5%)，`Role`组管理成员增添删减。
    - 链上纠纷，某些用户像刚刚提到的`CreditScore`或者根据`UserEstimate`来决定哪些用户拥有投票权，双向收取费用(1-5%)并下放到所有投票用户地址中。

- 更多的优化设计：
    - 可调度的任务押金，针对每一个任务设定一个合理的押金惩罚手段，任务委托者需要满足押金的最小金额
    - ERC721A Minima优化设计，实际上每一笔订单的Nonce都可以铸造为一个NFT，减少用户gas成本，需要自定义Minima设计，将gas压缩到极致。假设Alince拥有1和2的NFT`tokenId`,那么Bob接下来的NFT`tokenId`就是3.... , NFT的设计也可以打通流动性，设计更多的奖励机制
    - 委托订单锁，假设Alice是任务委托者，如果存在订单进行中，则无法进行委托其他任务订单操作
    - 当用户违规操作，也就是主动取消任务订单达到一定的数量后，禁止任务委托者和任务派发者进行发布和委托订单的操作，也就是冷静期

- 😈恶意用户：
    
    恶意用户作恶行为和成本十分的简单和低廉，其中包括可能的重入、绕过、MEV和构造signature等等
    - 增加一个回调行为检查，惩罚恶意用户
    - 增加区分机器人和普通用户黑名单的设计，扫描同Block[1,2,3...]提交的异常行为进行链下EOA提交，某些关键操作时自动回调惩罚

## Test
```solidity
forge test [-v] [-vv] [-vvv] [-vvvv]
```


## Contract Functions

### 创建用户
通过User结构体进行用户注册, 使用位图将所有信息存储在uint256不同的字节位上。注册过程必须绑定其中之一或者同时两个的角色(任务派发者和任务委托者)
```
    /*
     *-------------------------------------------+
     * Bit Location      | Struct                |
     *-------------------------------------------|
     * 0~159 bits        | User Address          |
     * 160 bits          | Customer              |
     * 161 bits          | Service Provider      |
     * 162 bits          | Status(registered)    |
     * 163~193 bits      | Creation time         |
     * 194 bits          | Take Order            |
     *-------------------------------------------+
     */
```

```solidity
function createUser(User calldata user) public {}
```

#### 覆盖测试
```solidity 
[PASS] testCreateUser() (gas: 74214)
Logs:
  User adddress: 0x62eF26c9C3696Dc6eCB4845972F1C2F2aDA1521f
  User is a customer: true
  User is a serviceProvider: false: 
  User register status: true
  User register time: 1697978418

Traces:
  [74214] WonderJobTest::testCreateUser() 
    ├─ [0] VM::warp(1697978416 [1.697e9]) 
    │   └─ ← ()
    ├─ [51742] WonderJobV2::createUser((0x62eF26c9C3696Dc6eCB4845972F1C2F2aDA1521f, true, false, false, 1697978416 [1.697e9])) 
    │   ├─  emit topic 0: 0x0ad17e9dc2c6686d825217c155508a34c618e491c8584ec8909a829d69b1cf06
    │   │       topic 1: 0x0000000000000000000000000000000000000000000000000000000000000004
    │   │       topic 2: 0x0000000000000000000000000000000000000000000000000000000065351830
    │   │           data: 0x00000000000000000000000062ef26c9c3696dc6ecb4845972f1c2f2ada1521f00000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000080
    │   ├─ [22610] WonderJobArbitration::initializeUserEstimate(userAddress: [0x62eF26c9C3696Dc6eCB4845972F1C2F2aDA1521f]) 
    │   │   └─ ← ()
    │   └─ ← ()
    ├─ [0] VM::startPrank(userAddress: [0x62eF26c9C3696Dc6eCB4845972F1C2F2aDA1521f]) 
    │   └─ ← ()
    ├─ [1719] WonderJobV2::getUserProfile() [staticcall]
    │   └─ ← (0x62eF26c9C3696Dc6eCB4845972F1C2F2aDA1521f, true, false, true, 1697978418 [1.697e9])
    ├─ [0] console::log(User adddress: %s, userAddress: [0x62eF26c9C3696Dc6eCB4845972F1C2F2aDA1521f]) [staticcall]
    │   └─ ← ()
    ├─ [0] console::log(User is a customer: %s, true) [staticcall]
    │   └─ ← ()
    ├─ [0] console::log(User is a serviceProvider: %s: , false) [staticcall]
    │   └─ ← ()
    ├─ [0] console::log(User register status: %s, true) [staticcall]
    │   └─ ← ()
    ├─ [0] console::9710a9d0(000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000653518320000000000000000000000000000000000000000000000000000000000000016557365722072656769737465722074696d653a20257300000000000000000000) [staticcall]
    │   └─ ← ()
    ├─ [0] VM::stopPrank() 
    │   └─ ← ()
    └─ ← ()
```

### 创建订单
订单实际为任务派发者才能实施的操作，也就是发布远程工作的任务需求。
订单创建过程会比创建用户的操作更加相对复杂一些，实际上订单创建时会需要任务派发者需要进行一个签名操作, 这保证了订单一定是没有办法进行重入操作的。`sstore`存储订单的hash时，不仅做了`signatureInProgressLocker`互斥检查，而且会对任务派发者自增一个`nonce`, 结构为`user => nonce => hash => Order`，任务派发者必须缴纳任务的金额至`WonderJobFundEscrowPool`合约进行托管

```solidity
    function createOrder(
        uint32 orderDeadline,
        uint96 orderPrice, 
        bytes32 ipfsLink,
        bytes32 hash,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external payable signatureInProgressLocker {}
```

#### 覆盖测试
```solidity
[PASS] testCreateOrder() (gas: 243597)
Traces:
  [243597] WonderJobTest::testCreateOrder() 
    ├─ [0] VM::addr(<pk>) [staticcall]
    │   └─ ← serviceProvider: [0x0B64812164586A1F5581afD1e7743f0681C99f9B]
    ├─ [0] VM::label(serviceProvider: [0x0B64812164586A1F5581afD1e7743f0681C99f9B], createOrderUser) 
    │   └─ ← ()
    ├─ [0] VM::label(serviceProvider: [0x0B64812164586A1F5581afD1e7743f0681C99f9B], serviceProvider) 
    │   └─ ← ()
    ├─ [0] VM::deal(serviceProvider: [0x0B64812164586A1F5581afD1e7743f0681C99f9B], 1000000000000000000 [1e18]) 
    │   └─ ← ()
    ├─ [51738] WonderJobV2::createUser((0x0B64812164586A1F5581afD1e7743f0681C99f9B, true, true, true, 1697978416 [1.697e9])) 
    │   ├─  emit topic 0: 0x0ad17e9dc2c6686d825217c155508a34c618e491c8584ec8909a829d69b1cf06
    │   │       topic 1: 0x0000000000000000000000000000000000000000000000000000000000000004
    │   │       topic 2: 0x0000000000000000000000000000000000000000000000000000000000000001
    │   │           data: 0x0000000000000000000000000b64812164586a1f5581afd1e7743f0681c99f9b00000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000080
    │   ├─ [22610] WonderJobArbitration::initializeUserEstimate(serviceProvider: [0x0B64812164586A1F5581afD1e7743f0681C99f9B]) 
    │   │   └─ ← ()
    │   └─ ← ()
    ├─ [2605] WonderJobV2::getOrderNonce(serviceProvider: [0x0B64812164586A1F5581afD1e7743f0681C99f9B]) [staticcall]
    │   └─ ← 0
    ├─ [0] VM::sign(<pk>, 0x653669b000000000016345785d8a000068747470733a2f2f697066732e696f2f) [staticcall]
    │   └─ ← 27, 0x09f400170e76d670be399e98345acb27856c02693e70e485ad62cfa9afcbc514, 0x28df0f153e6e6d168ea4e8146875d145a7f87e73dd6eb8eee72a03e13a501372
    ├─ [0] VM::startPrank(serviceProvider: [0x0B64812164586A1F5581afD1e7743f0681C99f9B]) 
    │   └─ ← ()
    ├─ [167063] WonderJobV2::createOrder{value: 100000000000000000}(1698064816 [1.698e9], 100000000000000000 [1e17], 0x68747470733a2f2f697066732e696f2f697066732f516d4e5a69506b39373476, 0x653669b000000000016345785d8a000068747470733a2f2f697066732e696f2f, 27, 0x09f400170e76d670be399e98345acb27856c02693e70e485ad62cfa9afcbc514, 0x28df0f153e6e6d168ea4e8146875d145a7f87e73dd6eb8eee72a03e13a501372) 
    │   ├─ [3000] PRECOMPILE::ecrecover(0x653669b000000000016345785d8a000068747470733a2f2f697066732e696f2f, 27, 4501926942657355676484904585337943665251806415728617827294198886031512290580 [4.501e75], 18486624937705105865667854888968412069177256964556634432921964128978942825330 [1.848e76]) [staticcall]
    │   │   └─ ← serviceProvider: [0x0B64812164586A1F5581afD1e7743f0681C99f9B]
    │   ├─ emit CreateOrder(publisher: serviceProvider: [0x0B64812164586A1F5581afD1e7743f0681C99f9B], orderDeadline: 1698064816 [1.698e9], orderStatus: 1, orderNonce: 0)
    │   ├─ emit DepositEscrowFund(sender: serviceProvider: [0x0B64812164586A1F5581afD1e7743f0681C99f9B], depositAmount: 100000000000000000 [1e17])
    │   └─ ← ()
    └─ ← ()
```
---

### 查询订单
考虑到数据处理，如果数据大小 > Max Functions gas limit大概率会出现`out of gas`，可以直接通过事件读取去filter， 通过`publisher`和`orderStatus`读取出来
```typescript
event CreateOrder(address indexed publisher, uint256 indexed orderDeadline, uint256 indexed orderStatus, uint256 orderNonce);
```


---
### 委托订单
任务委托者可以接受发布的订单并进行委托操作，传入任务派发者地址和订单nonce，链下通过事件或者接口获取。任务委托者委托订单时，必须缴纳押金至`Wonder`, 这里存在一个争议的设计`_clientEscrowFundBalanceof`的deposit和withdraw操作实际上都是覆盖操作，如果Attack可以控制min escrowFundBalanceof的余额，可以实现重入攻击比如个位数的押金进行作恶。

```
require(getClientEscrowFundBalanceof() > 0, "The user escrow fund balance is zero");
```

```solidity
function acceptOrder(address serviceProvider, uint256 orderNonce) external {}
```

#### 覆盖测试
```
[PASS] testAcceptOrder() (gas: 331340)
Logs:
  1

Traces:
  [331340] WonderJobTest::testAcceptOrder() 
    ├─ [0] VM::addr(<pk>) [staticcall]
    │   └─ ← serviceProvider: [0xCe6c11dDc81C10B05678dA2DA034ebD0E5414107]
    ├─ [0] VM::label(serviceProvider: [0xCe6c11dDc81C10B05678dA2DA034ebD0E5414107], userA) 
    │   └─ ← ()
    ├─ [0] VM::label(serviceProvider: [0xCe6c11dDc81C10B05678dA2DA034ebD0E5414107], serviceProvider) 
    │   └─ ← ()
    ├─ [0] VM::deal(serviceProvider: [0xCe6c11dDc81C10B05678dA2DA034ebD0E5414107], 1000000000000000000 [1e18]) 
    │   └─ ← ()
    ├─ [51738] WonderJobV2::createUser((0xCe6c11dDc81C10B05678dA2DA034ebD0E5414107, true, true, true, 1697978416 [1.697e9])) 
    │   ├─  emit topic 0: 0x0ad17e9dc2c6686d825217c155508a34c618e491c8584ec8909a829d69b1cf06
    │   │       topic 1: 0x0000000000000000000000000000000000000000000000000000000000000004
    │   │       topic 2: 0x0000000000000000000000000000000000000000000000000000000000000001
    │   │           data: 0x000000000000000000000000ce6c11ddc81c10b05678da2da034ebd0e541410700000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000080
    │   ├─ [22610] WonderJobArbitration::initializeUserEstimate(serviceProvider: [0xCe6c11dDc81C10B05678dA2DA034ebD0E5414107]) 
    │   │   └─ ← ()
    │   └─ ← ()
    ├─ [2605] WonderJobV2::getOrderNonce(serviceProvider: [0xCe6c11dDc81C10B05678dA2DA034ebD0E5414107]) [staticcall]
    │   └─ ← 0
    ├─ [0] VM::sign(<pk>, 0x653669b000000000016345785d8a000068747470733a2f2f697066732e696f2f) [staticcall]
    │   └─ ← 27, 0x2d6c9760a1b23f20de7d19c0987fb601493ddede369194d2597dbb594f623367, 0x4a9de57b4cc98eecf05df1ff254d6973af77ea2bc402d27621c62d9f9107fbc0
    ├─ [0] VM::startPrank(serviceProvider: [0xCe6c11dDc81C10B05678dA2DA034ebD0E5414107]) 
    │   └─ ← ()
    ├─ [167063] WonderJobV2::createOrder{value: 100000000000000000}(1698064816 [1.698e9], 100000000000000000 [1e17], 0x68747470733a2f2f697066732e696f2f697066732f516d4e5a69506b39373476, 0x653669b000000000016345785d8a000068747470733a2f2f697066732e696f2f, 27, 0x2d6c9760a1b23f20de7d19c0987fb601493ddede369194d2597dbb594f623367, 0x4a9de57b4cc98eecf05df1ff254d6973af77ea2bc402d27621c62d9f9107fbc0) 
    │   ├─ [3000] PRECOMPILE::ecrecover(0x653669b000000000016345785d8a000068747470733a2f2f697066732e696f2f, 27, 20545942438124903760845857268467210772407592139680795947592896505994333533031 [2.054e76], 33750129608405424621314395034318837726218277712838593240524249851505523817408 [3.375e76]) [staticcall]
    │   │   └─ ← serviceProvider: [0xCe6c11dDc81C10B05678dA2DA034ebD0E5414107]
    │   ├─ emit CreateOrder(publisher: serviceProvider: [0xCe6c11dDc81C10B05678dA2DA034ebD0E5414107], orderDeadline: 1698064816 [1.698e9], orderStatus: 1, orderNonce: 0)
    │   ├─ emit DepositEscrowFund(sender: serviceProvider: [0xCe6c11dDc81C10B05678dA2DA034ebD0E5414107], depositAmount: 100000000000000000 [1e17])
    │   └─ ← ()
    ├─ [605] WonderJobV2::getOrderNonce(serviceProvider: [0xCe6c11dDc81C10B05678dA2DA034ebD0E5414107]) [staticcall]
    │   └─ ← 1
    ├─ [0] console::f5b1bba9(0000000000000000000000000000000000000000000000000000000000000001) [staticcall]
    │   └─ ← ()
    ├─ [0] VM::stopPrank() 
    │   └─ ← ()
    ├─ [0] VM::addr(<pk>) [staticcall]
    │   └─ ← client: [0xc150499dda64693c6b39dBE263D8F2Df391Db71B]
    ├─ [0] VM::label(client: [0xc150499dda64693c6b39dBE263D8F2Df391Db71B], userB) 
    │   └─ ← ()
    ├─ [0] VM::label(client: [0xc150499dda64693c6b39dBE263D8F2Df391Db71B], client) 
    │   └─ ← ()
    ├─ [0] VM::deal(client: [0xc150499dda64693c6b39dBE263D8F2Df391Db71B], 1000000000000000000 [1e18]) 
    │   └─ ← ()
    ├─ [49238] WonderJobV2::createUser((0xc150499dda64693c6b39dBE263D8F2Df391Db71B, true, true, true, 1697978416 [1.697e9])) 
    │   ├─  emit topic 0: 0x0ad17e9dc2c6686d825217c155508a34c618e491c8584ec8909a829d69b1cf06
    │   │       topic 1: 0x0000000000000000000000000000000000000000000000000000000000000004
    │   │       topic 2: 0x0000000000000000000000000000000000000000000000000000000000000001
    │   │           data: 0x000000000000000000000000c150499dda64693c6b39dbe263d8f2df391db71b00000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000080
    │   ├─ [22610] WonderJobArbitration::initializeUserEstimate(client: [0xc150499dda64693c6b39dBE263D8F2Df391Db71B]) 
    │   │   └─ ← ()
    │   └─ ← ()
    ├─ [0] VM::startPrank(client: [0xc150499dda64693c6b39dBE263D8F2Df391Db71B]) 
    │   └─ ← ()
    ├─ [0] VM::label(client: [0xc150499dda64693c6b39dBE263D8F2Df391Db71B], client) 
    │   └─ ← ()
    ├─ [0] VM::deal(client: [0xc150499dda64693c6b39dBE263D8F2Df391Db71B], 1000000000000000000 [1e18]) 
    │   └─ ← ()
    ├─ [24310] WonderJobV2::depositEscrowFundWithClient(1000000000000000000 [1e18]) 
    │   ├─ emit DepositEscrowFund(sender: client: [0xc150499dda64693c6b39dBE263D8F2Df391Db71B], depositAmount: 1000000000000000000 [1e18])
    │   └─ ← ()
    ├─ [3437] WonderJobV2::acceptOrder(serviceProvider: [0xCe6c11dDc81C10B05678dA2DA034ebD0E5414107], 0) 
    │   └─ ← ()
    ├─ [0] VM::stopPrank() 
    │   └─ ← ()
    └─ ← ()
```
---
### 提交订单
传入任务派发者的地址和订单nonce进行提交订单的操作，如果超时完成，回调操作的时候会进行信用值扣除。成功完成后，将更改订单状态，等待任务派发者完成订单


```solidity
function submitOrder(address serviceProvider, uint256 orderNonce) external {}
```

#### 覆盖测试
```
Traces:
  [334605] WonderJobTest::testSubmitOrder() 
    ├─ [0] VM::addr(<pk>) [staticcall]
    │   └─ ← serviceProvider: [0x6A67FE542E1D0E36353aa9D85EA5e0C1cDE0f764]
    ├─ [0] VM::label(serviceProvider: [0x6A67FE542E1D0E36353aa9D85EA5e0C1cDE0f764], acceptOrder) 
    │   └─ ← ()
    ├─ [0] VM::label(serviceProvider: [0x6A67FE542E1D0E36353aa9D85EA5e0C1cDE0f764], serviceProvider) 
    │   └─ ← ()
    ├─ [0] VM::deal(serviceProvider: [0x6A67FE542E1D0E36353aa9D85EA5e0C1cDE0f764], 1000000000000000000 [1e18]) 
    │   └─ ← ()
    ├─ [51738] WonderJobV2::createUser((0x6A67FE542E1D0E36353aa9D85EA5e0C1cDE0f764, true, true, true, 1697978416 [1.697e9])) 
    │   ├─  emit topic 0: 0x0ad17e9dc2c6686d825217c155508a34c618e491c8584ec8909a829d69b1cf06
    │   │       topic 1: 0x0000000000000000000000000000000000000000000000000000000000000004
    │   │       topic 2: 0x0000000000000000000000000000000000000000000000000000000000000001
    │   │           data: 0x0000000000000000000000006a67fe542e1d0e36353aa9d85ea5e0c1cde0f76400000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000080
    │   ├─ [22610] WonderJobArbitration::initializeUserEstimate(serviceProvider: [0x6A67FE542E1D0E36353aa9D85EA5e0C1cDE0f764]) 
    │   │   └─ ← ()
    │   └─ ← ()
    ├─ [2605] WonderJobV2::getOrderNonce(serviceProvider: [0x6A67FE542E1D0E36353aa9D85EA5e0C1cDE0f764]) [staticcall]
    │   └─ ← 0
    ├─ [0] VM::sign(<pk>, 0x653669b000000000016345785d8a000068747470733a2f2f697066732e696f2f) [staticcall]
    │   └─ ← 28, 0x0ffc306d0083efb844bfe53bcea5d9361f74be881b75ab8330fe4296379c11b2, 0x12f0c293cc13c774ed7f87574b32cb8d4c9171eae766f472d6c0ad9c20891965
    ├─ [0] VM::startPrank(serviceProvider: [0x6A67FE542E1D0E36353aa9D85EA5e0C1cDE0f764]) 
    │   └─ ← ()
    ├─ [167063] WonderJobV2::createOrder{value: 100000000000000000}(1698064816 [1.698e9], 100000000000000000 [1e17], 0x68747470733a2f2f697066732e696f2f697066732f516d4e5a69506b39373476, 0x653669b000000000016345785d8a000068747470733a2f2f697066732e696f2f, 28, 0x0ffc306d0083efb844bfe53bcea5d9361f74be881b75ab8330fe4296379c11b2, 0x12f0c293cc13c774ed7f87574b32cb8d4c9171eae766f472d6c0ad9c20891965) 
    │   ├─ [3000] PRECOMPILE::ecrecover(0x653669b000000000016345785d8a000068747470733a2f2f697066732e696f2f, 28, 7230272411586256832253689648193254423628660842079284432454999206115340456370 [7.23e75], 8567017493440888832009627012681092930497818272709069734394685551157545867621 [8.567e75]) [staticcall]
    │   │   └─ ← serviceProvider: [0x6A67FE542E1D0E36353aa9D85EA5e0C1cDE0f764]
    │   ├─ emit CreateOrder(publisher: serviceProvider: [0x6A67FE542E1D0E36353aa9D85EA5e0C1cDE0f764], orderDeadline: 1698064816 [1.698e9], orderStatus: 1, orderNonce: 0)
    │   ├─ emit DepositEscrowFund(sender: serviceProvider: [0x6A67FE542E1D0E36353aa9D85EA5e0C1cDE0f764], depositAmount: 100000000000000000 [1e17])
    │   └─ ← ()
    ├─ [605] WonderJobV2::getOrderNonce(serviceProvider: [0x6A67FE542E1D0E36353aa9D85EA5e0C1cDE0f764]) [staticcall]
    │   └─ ← 1
    ├─ [0] console::f5b1bba9(0000000000000000000000000000000000000000000000000000000000000001) [staticcall]
    │   └─ ← ()
    ├─ [0] VM::stopPrank() 
    │   └─ ← ()
    ├─ [0] VM::addr(<pk>) [staticcall]
    │   └─ ← client: [0xD5e069BC58dedb2a3A348995ee753Eef0274004F]
    ├─ [0] VM::label(client: [0xD5e069BC58dedb2a3A348995ee753Eef0274004F], client) 
    │   └─ ← ()
    ├─ [0] VM::label(client: [0xD5e069BC58dedb2a3A348995ee753Eef0274004F], client) 
    │   └─ ← ()
    ├─ [0] VM::deal(client: [0xD5e069BC58dedb2a3A348995ee753Eef0274004F], 1000000000000000000 [1e18]) 
    │   └─ ← ()
    ├─ [0] VM::startPrank(client: [0xD5e069BC58dedb2a3A348995ee753Eef0274004F]) 
    │   └─ ← ()
    ├─ [49238] WonderJobV2::createUser((0xD5e069BC58dedb2a3A348995ee753Eef0274004F, true, true, true, 1697978416 [1.697e9])) 
    │   ├─  emit topic 0: 0x0ad17e9dc2c6686d825217c155508a34c618e491c8584ec8909a829d69b1cf06
    │   │       topic 1: 0x0000000000000000000000000000000000000000000000000000000000000004
    │   │       topic 2: 0x0000000000000000000000000000000000000000000000000000000000000001
    │   │           data: 0x000000000000000000000000d5e069bc58dedb2a3a348995ee753eef0274004f00000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000080
    │   ├─ [22610] WonderJobArbitration::initializeUserEstimate(client: [0xD5e069BC58dedb2a3A348995ee753Eef0274004F]) 
    │   │   └─ ← ()
    │   └─ ← ()
    ├─ [24310] WonderJobV2::depositEscrowFundWithClient(1000000000000000000 [1e18]) 
    │   ├─ emit DepositEscrowFund(sender: client: [0xD5e069BC58dedb2a3A348995ee753Eef0274004F], depositAmount: 1000000000000000000 [1e18])
    │   └─ ← ()
    ├─ [3437] WonderJobV2::acceptOrder(serviceProvider: [0x6A67FE542E1D0E36353aa9D85EA5e0C1cDE0f764], 0) 
    │   └─ ← ()
    ├─ [3770] WonderJobV2::submitOrder(serviceProvider: [0x6A67FE542E1D0E36353aa9D85EA5e0C1cDE0f764], 0) 
    │   └─ ← ()
    ├─ [0] VM::stopPrank() 
    │   └─ ← ()
    └─ ← ()
```

---
### 取消订单
取消订单双方都可以操作，但要注意的是这会影响信用值，哪一方取消回调都会进行信用分的扣除，完成取消订单后，订单状态变为无效，无法继续任何的操作。如果订单是由任务派发者进行取消，则退回任务金额的托管金额

```solidity
if (
    msg.sender == serviceProvider
    && msg.sender == _userOrders.getOrderServiceProvider(
        serviceProvider,
        orderNonce,
        orderId
    )
    /// @dev 返还任务派发者任务托管金额 
) _withdrowEscrowFund(orderId);

    /// @dev 扣除信用值
    ├─ [1474] WonderJobArbitration::getUserEstimate(client: [0x28833Cd485f82Bc8b0D401A070246E7C55Bdfe83]) [staticcall]
    │   └─ ← (48, 0, 0, 0, 0, 0, false, true)

    /// @dev 退回任务派发者托管金额
    ├─ [12065] WonderJobV2::cancelOrder(serviceProvider: [0xeD6164366241614B991E9aA60E1aB3dd59109203], 0) 
    │   ├─ emit WithdrowEscrowFund(sender: serviceProvider: [0xeD6164366241614B991E9aA60E1aB3dd59109203], orderId: 0x653669b000000000016345785d8a000068747470733a2f2f697066732e696f2f, depositAmount: 100000000000000000 [1e17])
```

```solidity
function cancelOrder(address serviceProvider, uint256 orderNonce) external {}
```

#### 覆盖测试(任务委托者)
```
[PASS] testCancelOrder() (gas: 344703)
Logs:
  1

Traces:
  [344703] WonderJobTest::testCancelOrder() 
    ├─ [0] VM::addr(<pk>) [staticcall]
    │   └─ ← serviceProvider: [0xeD6164366241614B991E9aA60E1aB3dd59109203]
    ├─ [0] VM::label(serviceProvider: [0xeD6164366241614B991E9aA60E1aB3dd59109203], cancelOrderUser) 
    │   └─ ← ()
    ├─ [0] VM::label(serviceProvider: [0xeD6164366241614B991E9aA60E1aB3dd59109203], serviceProvider) 
    │   └─ ← ()
    ├─ [0] VM::deal(serviceProvider: [0xeD6164366241614B991E9aA60E1aB3dd59109203], 1000000000000000000 [1e18]) 
    │   └─ ← ()
    ├─ [51738] WonderJobV2::createUser((0xeD6164366241614B991E9aA60E1aB3dd59109203, true, true, true, 1697978416 [1.697e9])) 
    │   ├─  emit topic 0: 0x0ad17e9dc2c6686d825217c155508a34c618e491c8584ec8909a829d69b1cf06
    │   │       topic 1: 0x0000000000000000000000000000000000000000000000000000000000000004
    │   │       topic 2: 0x0000000000000000000000000000000000000000000000000000000000000001
    │   │           data: 0x000000000000000000000000ed6164366241614b991e9aa60e1ab3dd5910920300000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000080
    │   ├─ [22610] WonderJobArbitration::initializeUserEstimate(serviceProvider: [0xeD6164366241614B991E9aA60E1aB3dd59109203]) 
    │   │   └─ ← ()
    │   └─ ← ()
    ├─ [2605] WonderJobV2::getOrderNonce(serviceProvider: [0xeD6164366241614B991E9aA60E1aB3dd59109203]) [staticcall]
    │   └─ ← 0
    ├─ [0] VM::sign(<pk>, 0x653669b000000000016345785d8a000068747470733a2f2f697066732e696f2f) [staticcall]
    │   └─ ← 28, 0x6c47f8e60bdccc90d0b20feaa15c25f2689d406eb723848d10c0cb5c1a141770, 0x6117829cbac49b5fd64397579715eab5800955cec6270c6bd4ac386c6a4c8bc0
    ├─ [0] VM::startPrank(serviceProvider: [0xeD6164366241614B991E9aA60E1aB3dd59109203]) 
    │   └─ ← ()
    ├─ [167063] WonderJobV2::createOrder{value: 100000000000000000}(1698064816 [1.698e9], 100000000000000000 [1e17], 0x68747470733a2f2f697066732e696f2f697066732f516d4e5a69506b39373476, 0x653669b000000000016345785d8a000068747470733a2f2f697066732e696f2f, 28, 0x6c47f8e60bdccc90d0b20feaa15c25f2689d406eb723848d10c0cb5c1a141770, 0x6117829cbac49b5fd64397579715eab5800955cec6270c6bd4ac386c6a4c8bc0) 
    │   ├─ [3000] PRECOMPILE::ecrecover(0x653669b000000000016345785d8a000068747470733a2f2f697066732e696f2f, 28, 48976951623723039419573534259626819327798008260006860907202621512412193625968 [4.897e76], 43915885247512471011220673375210078346760525434247181279884387995111702432704 [4.391e76]) [staticcall]
    │   │   └─ ← serviceProvider: [0xeD6164366241614B991E9aA60E1aB3dd59109203]
    │   ├─ emit CreateOrder(publisher: serviceProvider: [0xeD6164366241614B991E9aA60E1aB3dd59109203], orderDeadline: 1698064816 [1.698e9], orderStatus: 1, orderNonce: 0)
    │   ├─ emit DepositEscrowFund(sender: serviceProvider: [0xeD6164366241614B991E9aA60E1aB3dd59109203], depositAmount: 100000000000000000 [1e17])
    │   └─ ← ()
    ├─ [605] WonderJobV2::getOrderNonce(serviceProvider: [0xeD6164366241614B991E9aA60E1aB3dd59109203]) [staticcall]
    │   └─ ← 1
    ├─ [0] console::f5b1bba9(0000000000000000000000000000000000000000000000000000000000000001) [staticcall]
    │   └─ ← ()
    ├─ [0] VM::stopPrank() 
    │   └─ ← ()
    ├─ [0] VM::addr(<pk>) [staticcall]
    │   └─ ← client: [0x28833Cd485f82Bc8b0D401A070246E7C55Bdfe83]
    ├─ [0] VM::label(client: [0x28833Cd485f82Bc8b0D401A070246E7C55Bdfe83], cancelOrderClient) 
    │   └─ ← ()
    ├─ [0] VM::label(client: [0x28833Cd485f82Bc8b0D401A070246E7C55Bdfe83], client) 
    │   └─ ← ()
    ├─ [0] VM::deal(client: [0x28833Cd485f82Bc8b0D401A070246E7C55Bdfe83], 1000000000000000000 [1e18]) 
    │   └─ ← ()
    ├─ [0] VM::startPrank(client: [0x28833Cd485f82Bc8b0D401A070246E7C55Bdfe83]) 
    │   └─ ← ()
    ├─ [49238] WonderJobV2::createUser((0x28833Cd485f82Bc8b0D401A070246E7C55Bdfe83, true, true, true, 1697978416 [1.697e9])) 
    │   ├─  emit topic 0: 0x0ad17e9dc2c6686d825217c155508a34c618e491c8584ec8909a829d69b1cf06
    │   │       topic 1: 0x0000000000000000000000000000000000000000000000000000000000000004
    │   │       topic 2: 0x0000000000000000000000000000000000000000000000000000000000000001
    │   │           data: 0x00000000000000000000000028833cd485f82bc8b0d401a070246e7c55bdfe8300000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000080
    │   ├─ [22610] WonderJobArbitration::initializeUserEstimate(client: [0x28833Cd485f82Bc8b0D401A070246E7C55Bdfe83]) 
    │   │   └─ ← ()
    │   └─ ← ()
    ├─ [24310] WonderJobV2::depositEscrowFundWithClient(1000000000000000000 [1e18]) 
    │   ├─ emit DepositEscrowFund(sender: client: [0x28833Cd485f82Bc8b0D401A070246E7C55Bdfe83], depositAmount: 1000000000000000000 [1e18])
    │   └─ ← ()
    ├─ [3437] WonderJobV2::acceptOrder(serviceProvider: [0xeD6164366241614B991E9aA60E1aB3dd59109203], 0) 
    │   └─ ← ()
    ├─ [6318] WonderJobV2::cancelOrder(serviceProvider: [0xeD6164366241614B991E9aA60E1aB3dd59109203], 0) 
    │   ├─ [2536] WonderJobArbitration::orderValidatorCallWithFallback(client: [0x28833Cd485f82Bc8b0D401A070246E7C55Bdfe83], (0x28833Cd485f82Bc8b0D401A070246E7C55Bdfe83, 0, 2, 1, 1698064816 [1.698e9], 0xeD6164366241614B991E9aA60E1aB3dd59109203, 0x68747470733a2f2f697066732e696f2f697066732f516d4e5a69506b39373476, 100000000000000000 [1e17], 0x28833Cd485f82Bc8b0D401A070246E7C55Bdfe83)) 
    │   │   └─ ← ()
    │   └─ ← ()
    ├─ [1474] WonderJobArbitration::getUserEstimate(client: [0x28833Cd485f82Bc8b0D401A070246E7C55Bdfe83]) [staticcall]
    │   └─ ← (48, 0, 0, 0, 0, 0, false, true)
    ├─ [1474] WonderJobArbitration::getUserEstimate(serviceProvider: [0xeD6164366241614B991E9aA60E1aB3dd59109203]) [staticcall]
    │   └─ ← (50, 0, 0, 0, 0, 0, false, true)
    ├─ [0] VM::stopPrank() 
    │   └─ ← ()
    └─ ← ()
```
---
### 完成订单
如果任务委托者完成订单，那么任务派发者就可以审核提交的订单情况，如果没有问题，则进行完成订单操作，平台开启费用后，会扣除一部分费用到`feeTo`账户，其余任务金额会转移到任务委托者地址中，回调增加委托者的信用值，最后完成订单状态


```solidity
function completeOrder(address serviceProvider, bytes32 orderId) external payable {}
```

#### 覆盖测试
```
[PASS] testCompleteOrder() (gas: 342082)
Logs:
  1

Traces:
  [342082] WonderJobTest::testCompleteOrder() 
    ├─ [0] VM::addr(<pk>) [staticcall]
    │   └─ ← serviceProvider: [0xeD6164366241614B991E9aA60E1aB3dd59109203]
    ├─ [0] VM::label(serviceProvider: [0xeD6164366241614B991E9aA60E1aB3dd59109203], cancelOrderUser) 
    │   └─ ← ()
    ├─ [0] VM::label(serviceProvider: [0xeD6164366241614B991E9aA60E1aB3dd59109203], serviceProvider) 
    │   └─ ← ()
    ├─ [0] VM::deal(serviceProvider: [0xeD6164366241614B991E9aA60E1aB3dd59109203], 1000000000000000000 [1e18]) 
    │   └─ ← ()
    ├─ [51738] WonderJobV2::createUser((0xeD6164366241614B991E9aA60E1aB3dd59109203, true, true, true, 1697978416 [1.697e9])) 
    │   ├─  emit topic 0: 0x0ad17e9dc2c6686d825217c155508a34c618e491c8584ec8909a829d69b1cf06
    │   │       topic 1: 0x0000000000000000000000000000000000000000000000000000000000000004
    │   │       topic 2: 0x0000000000000000000000000000000000000000000000000000000000000001
    │   │           data: 0x000000000000000000000000ed6164366241614b991e9aa60e1ab3dd5910920300000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000080
    │   ├─ [22610] WonderJobArbitration::initializeUserEstimate(serviceProvider: [0xeD6164366241614B991E9aA60E1aB3dd59109203]) 
    │   │   └─ ← ()
    │   └─ ← ()
    ├─ [2605] WonderJobV2::getOrderNonce(serviceProvider: [0xeD6164366241614B991E9aA60E1aB3dd59109203]) [staticcall]
    │   └─ ← 0
    ├─ [0] VM::sign(<pk>, 0x653669b000000000016345785d8a000068747470733a2f2f697066732e696f2f) [staticcall]
    │   └─ ← 28, 0x6c47f8e60bdccc90d0b20feaa15c25f2689d406eb723848d10c0cb5c1a141770, 0x6117829cbac49b5fd64397579715eab5800955cec6270c6bd4ac386c6a4c8bc0
    ├─ [0] VM::startPrank(serviceProvider: [0xeD6164366241614B991E9aA60E1aB3dd59109203]) 
    │   └─ ← ()
    ├─ [167063] WonderJobV2::createOrder{value: 100000000000000000}(1698064816 [1.698e9], 100000000000000000 [1e17], 0x68747470733a2f2f697066732e696f2f697066732f516d4e5a69506b39373476, 0x653669b000000000016345785d8a000068747470733a2f2f697066732e696f2f, 28, 0x6c47f8e60bdccc90d0b20feaa15c25f2689d406eb723848d10c0cb5c1a141770, 0x6117829cbac49b5fd64397579715eab5800955cec6270c6bd4ac386c6a4c8bc0) 
    │   ├─ [3000] PRECOMPILE::ecrecover(0x653669b000000000016345785d8a000068747470733a2f2f697066732e696f2f, 28, 48976951623723039419573534259626819327798008260006860907202621512412193625968 [4.897e76], 43915885247512471011220673375210078346760525434247181279884387995111702432704 [4.391e76]) [staticcall]
    │   │   └─ ← serviceProvider: [0xeD6164366241614B991E9aA60E1aB3dd59109203]
    │   ├─ emit CreateOrder(publisher: serviceProvider: [0xeD6164366241614B991E9aA60E1aB3dd59109203], orderDeadline: 1698064816 [1.698e9], orderStatus: 1, orderNonce: 0)
    │   ├─ emit DepositEscrowFund(sender: serviceProvider: [0xeD6164366241614B991E9aA60E1aB3dd59109203], depositAmount: 100000000000000000 [1e17])
    │   └─ ← ()
    ├─ [605] WonderJobV2::getOrderNonce(serviceProvider: [0xeD6164366241614B991E9aA60E1aB3dd59109203]) [staticcall]
    │   └─ ← 1
    ├─ [0] console::f5b1bba9(0000000000000000000000000000000000000000000000000000000000000001) [staticcall]
    │   └─ ← ()
    ├─ [0] VM::stopPrank() 
    │   └─ ← ()
    ├─ [0] VM::addr(<pk>) [staticcall]
    │   └─ ← client: [0x28833Cd485f82Bc8b0D401A070246E7C55Bdfe83]
    ├─ [0] VM::label(client: [0x28833Cd485f82Bc8b0D401A070246E7C55Bdfe83], cancelOrderClient) 
    │   └─ ← ()
    ├─ [0] VM::label(client: [0x28833Cd485f82Bc8b0D401A070246E7C55Bdfe83], client) 
    │   └─ ← ()
    ├─ [0] VM::deal(client: [0x28833Cd485f82Bc8b0D401A070246E7C55Bdfe83], 1000000000000000000 [1e18]) 
    │   └─ ← ()
    ├─ [0] VM::startPrank(client: [0x28833Cd485f82Bc8b0D401A070246E7C55Bdfe83]) 
    │   └─ ← ()
    ├─ [49238] WonderJobV2::createUser((0x28833Cd485f82Bc8b0D401A070246E7C55Bdfe83, true, true, true, 1697978416 [1.697e9])) 
    │   ├─  emit topic 0: 0x0ad17e9dc2c6686d825217c155508a34c618e491c8584ec8909a829d69b1cf06
    │   │       topic 1: 0x0000000000000000000000000000000000000000000000000000000000000004
    │   │       topic 2: 0x0000000000000000000000000000000000000000000000000000000000000001
    │   │           data: 0x00000000000000000000000028833cd485f82bc8b0d401a070246e7c55bdfe8300000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000080
    │   ├─ [22610] WonderJobArbitration::initializeUserEstimate(client: [0x28833Cd485f82Bc8b0D401A070246E7C55Bdfe83]) 
    │   │   └─ ← ()
    │   └─ ← ()
    ├─ [24310] WonderJobV2::depositEscrowFundWithClient(1000000000000000000 [1e18]) 
    │   ├─ emit DepositEscrowFund(sender: client: [0x28833Cd485f82Bc8b0D401A070246E7C55Bdfe83], depositAmount: 1000000000000000000 [1e18])
    │   └─ ← ()
    ├─ [3437] WonderJobV2::acceptOrder(serviceProvider: [0xeD6164366241614B991E9aA60E1aB3dd59109203], 0) 
    │   └─ ← ()
    ├─ [0] VM::stopPrank() 
    │   └─ ← ()
    ├─ [0] VM::startPrank(serviceProvider: [0xeD6164366241614B991E9aA60E1aB3dd59109203]) 
    │   └─ ← ()
    ├─ [644] WonderJobV2::getOrderId(0) [staticcall]
    │   └─ ← 0x653669b000000000016345785d8a000068747470733a2f2f697066732e696f2f
    ├─ [19612] WonderJobV2::completeOrder(serviceProvider: [0xeD6164366241614B991E9aA60E1aB3dd59109203], 0x653669b000000000016345785d8a000068747470733a2f2f697066732e696f2f) 
    │   ├─ emit WithdrowEscrowFund(sender: serviceProvider: [0xeD6164366241614B991E9aA60E1aB3dd59109203], orderId: 0x653669b000000000016345785d8a000068747470733a2f2f697066732e696f2f, depositAmount: 100000000000000000 [1e17])
    │   ├─ [0] client::fallback{value: 100000000000000000}() 
    │   │   └─ ← ()
    │   ├─ [2348] WonderJobArbitration::orderValidatorCallWithFallback(serviceProvider: [0xeD6164366241614B991E9aA60E1aB3dd59109203], (0x28833Cd485f82Bc8b0D401A070246E7C55Bdfe83, 0, 2, 1, 1698064816 [1.698e9], 0xeD6164366241614B991E9aA60E1aB3dd59109203, 0x68747470733a2f2f697066732e696f2f697066732f516d4e5a69506b39373476, 100000000000000000 [1e17], 0x0000000000000000000000000000000000000000)) 
    │   │   └─ ← ()
    │   └─ ← ()
    ├─ [1474] WonderJobArbitration::getUserEstimate(client: [0x28833Cd485f82Bc8b0D401A070246E7C55Bdfe83]) [staticcall]
    │   └─ ← (55, 0, 0, 0, 0, 0, false, true)
    ├─ [1474] WonderJobArbitration::getUserEstimate(serviceProvider: [0xeD6164366241614B991E9aA60E1aB3dd59109203]) [staticcall]
    │   └─ ← (50, 0, 0, 0, 0, 0, false, true)
    ├─ [0] VM::stopPrank() 
    │   └─ ← ()
    └─ ← ()
```

### 转账积分
当任务委托者积分太低的情况下，假设目前是0~10，可以通过求助其他用户进行积分补偿，当大于最低分数区间时，就可以进行委托订单等操作

```solidity
function tryTransferCreditScore(address to, uint256 amount) public returns (bool) {}
```

#### 覆盖测试(转账50积分)
```
[PASS] testTryTransferCreditScore() (gas: 68302)
Traces:
  [68302] WonderJobArbitrationTest::testTryTransferCreditScore() 
    ├─ [0] VM::addr(<pk>) [staticcall]
    │   └─ ← from: [0xa94f5374Fce5edBC8E2a8697C15331677e6EbF0B]
    ├─ [0] VM::label(from: [0xa94f5374Fce5edBC8E2a8697C15331677e6EbF0B], from) 
    │   └─ ← ()
    ├─ [0] VM::label(from: [0xa94f5374Fce5edBC8E2a8697C15331677e6EbF0B], from) 
    │   └─ ← ()
    ├─ [0] VM::addr(<pk>) [staticcall]
    │   └─ ← to: [0x095E7BAea6a6c7c4c2DfeB977eFac326aF552d87]
    ├─ [0] VM::label(to: [0x095E7BAea6a6c7c4c2DfeB977eFac326aF552d87], to) 
    │   └─ ← ()
    ├─ [0] VM::label(to: [0x095E7BAea6a6c7c4c2DfeB977eFac326aF552d87], to) 
    │   └─ ← ()
    ├─ [22610] WonderJobArbitration::initializeUserEstimate(from: [0xa94f5374Fce5edBC8E2a8697C15331677e6EbF0B]) 
    │   └─ ← ()
    ├─ [22610] WonderJobArbitration::initializeUserEstimate(to: [0x095E7BAea6a6c7c4c2DfeB977eFac326aF552d87]) 
    │   └─ ← ()
    ├─ [0] VM::startPrank(from: [0xa94f5374Fce5edBC8E2a8697C15331677e6EbF0B]) 
    │   └─ ← ()
    ├─ [2938] WonderJobArbitration::tryTransferCreditScore(to: [0x095E7BAea6a6c7c4c2DfeB977eFac326aF552d87], 50) 
    │   ├─ emit Transfer(param0: from: [0xa94f5374Fce5edBC8E2a8697C15331677e6EbF0B], param1: to: [0x095E7BAea6a6c7c4c2DfeB977eFac326aF552d87], param2: 0)
    │   └─ ← true
    ├─ [1474] WonderJobArbitration::getUserEstimate(from: [0xa94f5374Fce5edBC8E2a8697C15331677e6EbF0B]) [staticcall]
    │   └─ ← (0, 0, 0, 0, 0, 0, false, true)
    ├─ [0] VM::stopPrank() 
    │   └─ ← ()
    ├─ [0] VM::startPrank(to: [0x095E7BAea6a6c7c4c2DfeB977eFac326aF552d87]) 
    │   └─ ← ()
    ├─ [1474] WonderJobArbitration::getUserEstimate(to: [0x095E7BAea6a6c7c4c2DfeB977eFac326aF552d87]) [staticcall]
    │   └─ ← (100, 0, 0, 0, 0, 0, false, true)
    ├─ [0] VM::stopPrank() 
    │   └─ ← ()
    └─ ← ()
```
