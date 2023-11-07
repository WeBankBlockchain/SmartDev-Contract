[![GitHub All Releases](https://img.shields.io/github/downloads/WeBankBlockchain/SmartDev-Contract/total.svg)](https://github.com/WeBankBlockchain/SmartDev-Contract)


# 组件介绍

智能合约库模板，涵盖了从基础类型到上层业务的常见代码，用户可根据实际需要进行参考、复用。


## 环境要求

| 依赖软件 | 说明 |
| --- | --- |
| Solidity | 0.4.25-0.8.11.0 | 
| Git | 下载需要使用Git | 

## 功能列表
### 基础类型

| 库 | 功能 | 说明 | 文档 | 代码|
| --- | --- | --- | --- | --- |
|LibSafeMathForUint256Utils|数学运算|加减乘除、幂、最大值最小值、平均值等| [API](https://smartdev-doc.readthedocs.io/zh-cn/latest/docs/WeBankBlockchain-SmartDev-Contract/api/base_type/LibSafeMathForUint256Utils.html) | [代码](./contracts/base_type/LibSafeMathForUint256Utils.sol) |
|LibSafeMathForFloatUtils|浮点数运算|提供了浮点型的相关计算操作，且保证数据的正确性和安全性，包括加法、减法、乘法、除法等操作| [API](https://smartdev-doc.readthedocs.io/zh-cn/latest/docs/WeBankBlockchain-SmartDev-Contract/api/base_type/LibSafeMathForFloatUtils.html) | [代码](./contracts/base_type/LibSafeMathForFloatUtils.sol)|
|LibConverter|整型转换操作|和各数据类型之间的转换等| [API](https://smartdev-doc.readthedocs.io/zh-cn/latest/docs/WeBankBlockchain-SmartDev-Contract/api/base_type/LibConverter.html)| [代码](./contracts/base_type/LibConverter.sol)|
|LibString|字符串操作|取长度、判断起始终止、查找子父、求子串、拼接、比较、大小写转换等|[API](https://smartdev-doc.readthedocs.io/zh-cn/latest/docs/WeBankBlockchain-SmartDev-Contract/api/base_type/LibString.html) | [代码](./contracts/base_type/string/LibString.sol)|
|LibAddress|地址操作|和各数据类型之间的转换；合约地址判断等|[API](https://smartdev-doc.readthedocs.io/zh-cn/latest/docs/WeBankBlockchain-SmartDev-Contract/api/base_type/LibAddress.html)| [代码](./contracts/base_type/LibAddress.sol)|
|LibArrayForUint256Utils|数组操作|排序、查找、去重、拼接等|[API](https://smartdev-doc.readthedocs.io/zh-cn/latest/docs/WeBankBlockchain-SmartDev-Contract/api/base_type/LibArrayForUint256Utils.html) |[代码](./contracts/base_type/array/LibArrayForUint256Utils.sol) |
|Lib2DArrayForUint256|数组操作|提供了Uint256二维数组的相关操作，包括增加新元素，删除元素，修改值，查找值，合并扩展数组等操作|[API](https://smartdev-doc.readthedocs.io/zh-cn/latest/docs/WeBankBlockchain-SmartDev-Contract/api/base_type/Lib2DArrayForUint256.html) | [代码](./contracts/base_type/array/Lib2DArrayForUint256.sol)|
|LibBits|位操作|提供了位操作方法，例如按位非、移位、取前/后n位等方法|[API](https://smartdev-doc.readthedocs.io/zh-cn/latest/docs/WeBankBlockchain-SmartDev-Contract/api/base_type/LibBits.html) |[代码](./contracts/base_type/bits/LibBits.sol) |


### 数据结构

| 库 | 功能 | 说明 | 文档 | 代码|
| --- | --- | --- | --- | --- |
|LibMaxHeapUint256|堆|最大堆相关操作，取最值、插入、删除等| [API](https://smartdev-doc.readthedocs.io/zh-cn/latest/docs/WeBankBlockchain-SmartDev-Contract/api/data_structure/LibMaxHeapUint256.html)| |
|LibMinHeapUint256|堆|最小堆相关操作，取最值、插入、删除等| [API](https://smartdev-doc.readthedocs.io/zh-cn/latest/docs/WeBankBlockchain-SmartDev-Contract/api/data_structure/LibMinHeapUint256.html)| |
|LibStack|栈|提供栈相关操作，如进栈、出栈等|[API](https://smartdev-doc.readthedocs.io/zh-cn/latest/docs/WeBankBlockchain-SmartDev-Contract/api/data_structure/LibStack.html) | |
|LibQueue|队列|单向队列相关操作，入队、出队等|[API](https://smartdev-doc.readthedocs.io/zh-cn/latest/docs/WeBankBlockchain-SmartDev-Contract/api/data_structure/LibQueue.html)| |
|LibDeque|队列|双向队列相关操作，入队、出队等|[API](https://smartdev-doc.readthedocs.io/zh-cn/latest/docs/WeBankBlockchain-SmartDev-Contract/api/data_structure/LibDeque.html)| |
|LibAddressSet|address类型集合|集合操作，增删改查等| [API](https://smartdev-doc.readthedocs.io/zh-cn/latest/docs/WeBankBlockchain-SmartDev-Contract/api/data_structure/LibAddressSet.html)| |
|LibBytes32Set|bytes32类型集合|提供了存储Bytes32类型的Set数据结构，支持包括add, remove, contains, getAll等| [API](https://smartdev-doc.readthedocs.io/zh-cn/latest/docs/WeBankBlockchain-SmartDev-Contract/api/data_structure/LibBytes32Set.html)| |
|LibBytesMap|映射|映射操作，存、取、移除等|[API](https://smartdev-doc.readthedocs.io/zh-cn/latest/docs/WeBankBlockchain-SmartDev-Contract/api/data_structure/LibBytesMap.html)| |
|LibLinkedList|双向链表|链表相关操作|[API](https://smartdev-doc.readthedocs.io/zh-cn/latest/docs/WeBankBlockchain-SmartDev-Contract/api/data_structure/LibLinkedList.html)| |
|LibSingleList|单向链表|包括链表更新、查询、迭代等|[API](https://smartdev-doc.readthedocs.io/zh-cn/latest/docs/WeBankBlockchain-SmartDev-Contract/api/data_structure/LibSingleList.html)| |
|DataTable|模拟数据库表的实现|提供了模拟row、table等实现|[API](https://smartdev-doc.readthedocs.io/zh-cn/latest/docs/WeBankBlockchain-SmartDev-Contract/api/data_structure/DataTable.html)| |
|Map|模拟映射的实现|提供了基于bytes32主键、自定义类型值的可迭代、可查询的映射|[API](https://smartdev-doc.readthedocs.io/zh-cn/latest/docs/WeBankBlockchain-SmartDev-Contract/api/data_structure/Map.html)| |
|LibMerkleTree|默克尔树实现|提供了默克尔树的生成和验证方法|[API](https://smartdev-doc.readthedocs.io/zh-cn/latest/docs/WeBankBlockchain-SmartDev-Contract/api/data_structure/LibMerkleTree.html)| |

### 通用功能

| 库 | 功能 | 说明 | 文档 | 代码|
| --- | --- | --- | --- | --- |
|Table|CRUD合约|提供CRUD体验| [API](https://fisco-bcos-documentation.readthedocs.io/zh_CN/latest/docs/articles/3_features/33_storage/crud_guidance.html)| |
|Crypto|密码学|国密哈希、验签、VRF等| [API](https://smartdev-doc.readthedocs.io/zh-cn/latest/docs/WeBankBlockchain-SmartDev-Contract/api/default/crypto/Crypto.html)| |
|LibCryptoHash|内置密码相关的函数|keccak256、sha3、ripemd160等| [API](https://smartdev-doc.readthedocs.io/zh-cn/latest/docs/WeBankBlockchain-SmartDev-Contract/api/default/crypto/LibCryptoHash.html)| |
|LibDecode|验签|验证签名等功能等| [API](https://smartdev-doc.readthedocs.io/zh-cn/latest/docs/WeBankBlockchain-SmartDev-Contract/api/default/crypto/LibDecode.html)| |
|proxy|代理模式|代理执行即代理模式的实现| [API](https://smartdev-doc.readthedocs.io/zh-cn/latest/docs/WeBankBlockchain-SmartDev-Contract/api/default/proxy/proxy.html)| |
|internalFunction|内置相关的函数|包括block,tx相关等| [API](https://smartdev-doc.readthedocs.io/zh-cn/latest/docs/WeBankBlockchain-SmartDev-Contract/api/default/internalFunction.html)| |


### 常用工具

| 库 | 功能 | 说明 | 文档 | 代码|
| --- | --- | --- | --- | --- |
|DateTimeContract|时间戳解析|基于时间戳计算当前的日期| [API](https://smartdev-doc.readthedocs.io/zh-cn/latest/docs/WeBankBlockchain-SmartDev-Contract/api/common_tools/DateTimeContract.html)| |
|DGHV|同态加密|一种基于智能合约的全同态加密方法| [API](https://smartdev-doc.readthedocs.io/zh-cn/latest/docs/WeBankBlockchain-SmartDev-Contract/api/common_tools/DGHV.html)| |
|FiatShamirZK|同态加密|一种零知识证明协议方法| [API](https://smartdev-doc.readthedocs.io/zh-cn/latest/docs/WeBankBlockchain-SmartDev-Contract/api/common_tools/FiatShamirZK.html)| |
|RBAC|基于角色的权限管理|RBAC| [API](https://smartdev-doc.readthedocs.io/zh-cn/latest/docs/WeBankBlockchain-SmartDev-Contract/api/common_tools/RBAC.html)| |
|RoleOperation|角色操作|RoleOperation| [API](https://smartdev-doc.readthedocs.io/zh-cn/latest/docs/WeBankBlockchain-SmartDev-Contract/api/common_tools/RoleOperation.html)| |
|whiteList|白名单操作|白名单管理的实现| [API](https://smartdev-doc.readthedocs.io/zh-cn/latest/docs/WeBankBlockchain-SmartDev-Contract/api/common_tools/white_list_manage.html)| |
|MathAdvance|数学运算|开方，平方，对数，幂| [API](https://smartdev-doc.readthedocs.io/zh-cn/latest/docs/WeBankBlockchain-SmartDev-Contract/api/common_tools/math_advance.html)| |
|LibAscii|asc码转换|asc码转换| [API](https://smartdev-doc.readthedocs.io/zh-cn/latest/docs/WeBankBlockchain-SmartDev-Contract/api/common_tools/LibAscii.html)| |


### 上层业务

| 库 | 功能 | 说明 | 文档 | 代码|
| --- | --- | --- | --- | --- |
|Evidence|存证|存证场景相关操作，上传、审批、修改、删除等|[API](https://smartdev-doc.readthedocs.io/zh-cn/latest/docs/WeBankBlockchain-SmartDev-Contract/api/business_template/Evidence.html)| |
|evidence_plus|存证|存证合约 Plus 版本|[API](https://smartdev-doc.readthedocs.io/zh-cn/latest/docs/WeBankBlockchain-SmartDev-Contract/api/business_template/evidence_plus.html)| |
|MarriageEvidence|婚姻证明|结婚证书合约实例|[API](https://smartdev-doc.readthedocs.io/zh-cn/latest/docs/WeBankBlockchain-SmartDev-Contract/api/business_template/MarriageEvidence.html)| |
|redpacket|发红包|红包发放的场景|[API](https://smartdev-doc.readthedocs.io/zh-cn/latest/docs/WeBankBlockchain-SmartDev-Contract/api/business_template/redpacket.html)| |
|SimplePoint|积分|简单的积分场景|[API](https://smartdev-doc.readthedocs.io/zh-cn/latest/docs/WeBankBlockchain-SmartDev-Contract/api/business_template/SimplePoint.html)| |
|RewardPoint|积分|积分场景相关操作，发行、转移等|[API](https://smartdev-doc.readthedocs.io/zh-cn/latest/docs/WeBankBlockchain-SmartDev-Contract/api/business_template/RewardPoint.html)| |
|bill|金融票据|可以发布票据、对票据进行背书、验证背书、拒绝背书等操作|[API](https://smartdev-doc.readthedocs.io/zh-cn/latest/docs/WeBankBlockchain-SmartDev-Contract/api/business_template/bill.html)| |
|CarbonFrugalEvidence|共享充电积分能量存证合约|积分场景相关操作，发行、转移等|[API](https://smartdev-doc.readthedocs.io/zh-cn/latest/docs/WeBankBlockchain-SmartDev-Contract/api/business_template/CarbonFrugalEvidence.html)| |
|Traceability|商品溯源|实现商品溯源的案例|[API](https://smartdev-doc.readthedocs.io/zh-cn/latest/docs/WeBankBlockchain-SmartDev-Contract/api/business_template/Traceability.html)| |
|BookShares|股权簿记系统|实现公司股权簿记的案例|[API](https://smartdev-doc.readthedocs.io/zh-cn/latest/docs/WeBankBlockchain-SmartDev-Contract/api/business_template/BookShares.html)| |
|Chattel|金融动产|实现金融动产案例|[API](https://smartdev-doc.readthedocs.io/zh-cn/latest/docs/WeBankBlockchain-SmartDev-Contract/api/business_template/chattel.html)| |
|SharedBikes|共享单车|实现共享单车的案例|[API](https://smartdev-doc.readthedocs.io/zh-cn/latest/docs/WeBankBlockchain-SmartDev-Contract/api/business_template/shared_bike.html)| |
|GovOffice|政府办公|实现政府办公的案例|[API](https://smartdev-doc.readthedocs.io/zh-cn/latest/docs/WeBankBlockchain-SmartDev-Contract/api/business_template/gov_office.html)| |

### 全栈应用
| 库 | 功能 | 说明 | 文档 | 代码|
| --- | --- | --- | --- | --- |

### 合约杂谈

| 文章 | 说明 | 链接 | 
| --- | --- | --- |
|SmartBasics|智能合约入门|[链接](./docs/miscs/tutorial/Solidity-basic.md)| |
|ContractTips|合约开发杂谈|[链接](./docs/miscs/tutorial/Contract-tips.md)| |

## 文档
- [**中文**](https://smartdev-doc.readthedocs.io/zh_CN/latest/docs/WeBankBlockchain-SmartDev-Contract/index.html)
- [**快速开始**](https://smartdev-doc.readthedocs.io/zh_CN/latest/docs/WeBankBlockchain-SmartDev-Contract/quick_start.html)
## 贡献代码
欢迎参与本项目的社区建设：
- 如项目对您有帮助，欢迎点亮我们的小星星(点击项目左上方Star按钮)。
- 欢迎提交代码(Pull requests)。
- [提问和提交BUG](https://github.com/WeBankBlockchain/SmartDev-Contract/issues)。
- 如果发现代码存在安全漏洞，请在[这里](https://security.webank.com)上报。


![](https://media.githubusercontent.com/media/FISCO-BCOS/LargeFiles/master/images/QR_image.png)

## 合约征集令
 为了覆盖和满足日益丰富的开发者和行业的诉求，现面向广大爱好区块链开发者、合作伙伴发布智能合约代码征集令。
 
 本次活动基于Solidity语言征集智能合约代码。**版本范围：0.4.25-0.8.11.0** 。

为了便于参与，我们拟定了部分任务列表（如下表所示），每位参与者可以选择自己感兴趣的任务进行领取并开发，也可以基于具体的业务场景作为开发任务，原则上不做代码功能的限定。同时，由于每一个任务为概述性的描述，包含的内容较多，所以每个任务可由多位参与者领取。

|任务ID	| 任务类别| 任务名称	| 任务描述|
| --- | --- | --- | --- |
|1 |   原有合约功能	| 原有合约库优化和增强	|针对智能合约库中现有合约的功能进行补充和增强，如针对不同数据类型，提供数组、字符串、地址、数学计算等操作。|
|2 |   原有合约功能	| 数学运算增强	|提供开方、指数、对数等运算。|
|3 |   新增功能模块	| 计数器操作 | 提供基于solidity的计数器功能|
|4 |   新增功能模块	| 证件号码验证 | 针对大陆18或15位，港、澳8位， 台10位身份证件号码合法性验证|
|5 |   新增功能模块	| 数据实体封装 | 对实体属性封装为合约，并提供get/set等属性操作方法|
|6 |  	新增功能模块	| 匿名投票	|实现匿名投票，在投票期间各票信息以密文形式上链，在投票结束后才公开|
|7 |  	新增功能模块	| 多方签名	|提供一个抽象层面的多方签名功能，可以应用于多方认证的场景|
|8 |  	新增功能模块	| 多方投票	|提供多方投票功能，投票策略可多样化|
|9 |  	新增场景	| 版权保护	|包括但不限于文化、专利、艺术品、数字内容的确权、鉴权等方案。|
|10 |  	新增场景	| 金融	   |对于供应链金融、征信、反洗钱等金融场景，提供相关的智能合约通用化模板。|
|11 |  	新增场景	| 慈善公益	|基于慈善公益，提供但不限于善款追溯、善行激励等场景的使用场景|
|12 |  	新增场景	| 共享经济	|针对共享经济中的痛点，提供区块链的解决方案，例如租房、图书共享等使用场景。|
|13 |  	文档教程	| 智能合约教程	|原创的各类智能合约开发教程、分享。|
|14 |  	文档教程	| 智能合约常见漏洞集	|各类型漏洞合约，帮助增强开发人员漏洞意识，提升智能合约安全性。|
|15 |  	代码修复	| 修复代码仓库中的Issues	|修复代码中的issues，并提交代码。（可优先解决带有“volunteer wanted”标签的问题）|

以上任务仅供参考。

我们欢迎所有Solidity智能合约相关的贡献。

【报名方式】
扫描下方二维码，回复：智能合约，加小助手微信入活动社群，填写在线报名表。

![微众银行小助手二维码](./webank_blockchain_qrcode.png)

## License
![license](http://img.shields.io/badge/license-Apache%20v2-blue.svg)

开源协议为[Apache License 2.0](http://www.apache.org/licenses/). 详情参考[LICENSE](../LICENSE)。




