# 企业碳排放解决方案合约案例 助力双碳

## 1.区块链为“双碳”带来了什么？ | 研讨会回顾

原文介绍：

6月22日，由微众区块链、金链盟、FISCO BCOS开源社区联合举办的“‘链’筑可持续”ESG系列研讨会第一期在线举行。本期研讨会以“区块链助推‘双碳’战略”为主题，邀请权威专家和代表企业共话“双碳”工作推进中存在的难点痛点，以及区块链技术如何助推“双碳”战略。

研讨会由微众银行区块链CMO李贺主持，邀请了广州碳排放权交易所总经理助理李原、微众银行区块链首席架构师兼金链盟FISCO BCOS首席架构师张开翔、零数科技双碳事业部总经理沈文昌、碳抵科技副总经理耿振博、万物数创CTO黄一分别做主题演讲。

随着碳达峰碳中和各项政策纷纷部署落地，碳排放数据的采集、碳普惠机制的激励等实操性痛点问题亟待解决。对此，区块链技术作为可信基础设施，不仅为上述问题提供了可行的解决方案，更与金融、绿色建筑等行业结合，诞生出一系列实践案例。

区块链作为一种分布式账本技术，`具有去中心化、不可篡改、透明等特点，可以为“双碳”（即低碳经济）`发展带来一些潜在的好处。

1. **碳交易和碳信用积分**：区块链可以为碳交易和碳信用积分提供一个安全的、透明的、不可篡改的记录和管理方式。通过将碳排放权分割成数字资产，可以方便地进行转移、交易和跟踪。
2. **资源管理和监控**：区块链可以用于跟踪能源、水资源和土地等资源的使用情况，并对资源的使用进行监控。这可以帮助促进资源的高效利用和减少浪费。
3. **能源交易和分布**：区块链可以用于管理去中心化的能源市场，使个人和企业可以直接进行能源交易和分享。这可以促进可再生能源的使用和减少对传统能源的依赖。
4. **碳足迹追溯**：区块链可以用于记录产品的生产和运输过程，并追溯产品的碳足迹。这可以帮助消费者更好地了解产品的环境影响，从而做出更环保的选择。

总之，区块链可以为“双碳”发展提供一些有益的支持。通过利用区块链的技术特点，可以实现更加透明、高效和安全的碳交易和碳管理，促进可持续发展和低碳经济的建设。



## 2.碳排放资产管理设计

基于区块链的碳资产管理可以通过以下设计来实现：

1. **碳资产登记**：碳资产应该被注册到区块链上，以确保其真实性和合法性。可以使用智能合约来记录碳资产的属性，例如产生碳排放的方式、数量和时间等。此外，为了防止双重计数，应该为每个碳资产分配唯一的标识符。
2. **碳交易**：碳交易应该通过区块链进行。买卖双方应该通过数字签名来确认交易，并将交易记录在区块链上。区块链的智能合约可以自动化交易，以确保快速、安全和低成本的交易。
3. **碳资产追踪**：区块链可以记录每个碳资产的交易历史和归属权，以确保其可追溯性。可以将交易信息记录在区块链上，使每个参与方都可以查看碳资产的交易历史。此外，可以使用区块链的权限控制功能来确保只有授权人员可以访问特定的交易记录。
5. **碳资产溯源**：区块链可以记录碳资产的溯源信息，以追踪其来源和流向。可以使用智能合约来记录碳资产的生产过程、运输过程和交易过程等信息。这些信息可以用于证明碳资产的真实性和合法性，也可以用于监管和审计。

总之，基于区块链的碳资产管理应该包括`碳资产登记、碳交易、碳资产追踪、碳资产溯源等方面`，以实现快速、安全和低成本的碳交易，并确保碳交易市场的透明度和可信度。



## 3.合约设计思路

### 3.1 基本的业务流程

![161bcfbd44a27f57d1051f530a6f9e1](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202304020138651.webp)



### 3.2 具体的设计思路

CarbonAsset 合约 CarbonAsset 合约是管理碳排放额度和碳交易的核心合约。该合约包含以下功能：

- **分配碳排放额度**：CarbonCertification 合约审核通过后，将为企业在 CarbonAsset 合约中分配碳排放额度。
- **挂单出售**：企业可以将其碳排放额度挂单出售到 CarbonAsset 合约中。
- **直接购买**：企业可以直接在 CarbonAsset 合约中购买其他企业挂单出售的碳排放额度。
- **检查余额**：企业可以随时查询其在 CarbonAsset 合约中的碳排放额度余额。
- **转移额度**：企业可以将其在 CarbonAsset 合约中的碳排放额度转移给其他企业。
- **支付奖励积分**：企业在完成某些减少碳排放量的行为后，可以获得奖励积分。CarbonAsset 合约可以用来支付奖励积分。

1. CarbonCertification 合约用于管理企业的资质信息和审核状态。企业可以将其资质信息上传到 CarbonCertification 合约中，并等待监管统计部门进行审核。审核通过后，CarbonAsset 合约将分配相应的碳排放额度。
2. CarbonExcitation合约 CarbonExcitation合约用于管理企业的碳排放量和奖励积分。该合约可以追踪企业的碳排放量，并计算其应该获得的奖励积分。企业可以在 CarbonAsset 合约中收到奖励积分，或在 CarbonExcitation合约中查看其奖励积分余额。
3. SafeMath 合约 SafeMath 合约是一个安全数学库，用于处理合约中的数学运算。它可以避免整数溢出和下溢等问题，确保合约中的数学计算是安全和可靠的。在 CarbonAsset 合约中，SafeMath 合约可以用来处理碳排放额度的加减操作，以避免可能的数学错误和安全问题。

通过以上合约的设计和实现，我们可以构建一个完整的碳资产管理系统，其中企业和监管统计部门可以使用区块链来实现碳资产的管理和交易，确保碳排放量的准确计量和碳市场的透明和公正。该系统可以提高碳交易的效率和安全性，减少人为错误和舞弊行为的发生，同时也可以为企业提供更多的碳减排激励，促进全社会对低碳经济的转型和发展。



## 4.具体开发步骤

### 4.1 CarbonCertificationV2合约业务介绍

CarbonCertification的主要业务：

- 拥有两个角色，分别是企业和监管部门
- 基本业务是注册企业和监管部门的个人信息
- 企业需要上传资质，等待审核
- 监管部门需要查看进行审批，如果审批通过则发放1000的额度，未通过审核的企业无法进行下一步操作
- 企业审核完之后可以对自己的信息进行更新上传，包括余额、总排放量
- 企业之间的交易会记录下交易的信息体，所有需要存放交易的历史记录
- 我定义了四个个主要的结构体，分别是：`Enterprise`，`Regulator`，`Qualification`，`Transaction`。



**这里我自己定义了Ownable合约，就是可公共拥有的变量或者函数以及事件**

```solidity
pragma solidity ^0.4.25;

contract Ownable {
    // 定义角色枚举类型
    enum Role { Enterprise, Regulator }
    // 默认发放的额度
    uint256 internal constant TOTAL_EMISSION = 1000;
    // 进行审核的变量
    bool internal constant AUDIT_SUCCESS = true;
    bool internal constant AUDIT_FAILED = false;

    // 企业账户的事件
    event RegisterAccount(address indexed _acount,string indexed _name);
    // 上传审核的事件
    event UploadQualification(address indexed _acount,string indexed _name,string indexed _content);
    // 审批企业申请的事件
    event VerifyQualification(address indexed _enterpriseAddr,uint256 indexed _emissionLimit);
    // 交易碳额度
    event TransferEmissionLimit(address indexed _from,address indexed _to,uint256 indexed _amount);
    // 出售碳额度
    event SellEmissionLimit(uint256 indexed _emissionLimitCount,uint256 indexed _amount);
    // 更新企业账户的余额
    event UpdateBalnce(address indexed _enterpriseAddr,uint256 indexed _amount);
    // 更新企业账户的碳排放额度
    event UpdateEmissionLimit(address indexed _enterpriseAddr,uint256 indexed _emissionLimit);
}
```



### 4.2 CarbonCertificationV2合约

**CarbonCertificationV2的合约详细**

主要的函数方法有如下：

- `registerEnterprise()`	:  注册企业函数，初始化一个新的企业
- `registerRegulator()`  ：注册监管机构函数，初始化一个监管机构
- `qualificationUpload()`  ：企业上传资质函数，等待监管机构审批资质
- `verifyQualification()`   ：监管机构审批企业的资质函数，用于审批
- `updateBalance() `  ：更新企业余额函数，企业的账户余额用于交易
- `queryEnterpriseInfo()`  ：查询企业信息函数，返回企业的结构体信息
- `queryRegulatorInfo()`  ：查询监管机构信息函数，返回监管机构的结构体信息
- `queryAllEnterprises()`   ：分页查询所有企业的函数，避免返回整个数组
- `queryAllTransactions() `   ：分页查询所有企业的交易历史记录函数，避免返回整个数组

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.4.25;
pragma experimental ABIEncoderV2;

import "./Ownable.sol";

contract CarbonCertificationV2 is Ownable {
    address public Owner;

    // 定义一个结构体来表示企业账户信息
    struct Enterprise {
        uint256 enterpriseId;                   // 账户ID
        address enterpriseAddress;              // 账户地址
        string  enterpriseName;                 // 企业名称
        uint256 enterpriseBalance;              // 账户余额
        uint256 enterpriseTotalEmission;        // 总需排放的量
        uint256 enterpriseOverEmission;         // 已完成的排放量
        uint256 enterpriseCarbonCredits;        // 奖励积分
        bool enterpriseVerified;                // 是否通过审核
        Role userType;                          // 账户角色
        Qualification qualification;            // 资质信息
    }

    // 定义一个结构体来表示企业的资质信息
    struct Qualification {
        string  qualificationName;                    // 资质名称
        string  qualificationContent;                 // 资质内容
        uint256 qualificationUploadTime;              // 上传时间
        uint256 qualificationAuditTime;               // 审核时间
        uint256 qualificationEmissionLimit;           // 碳排放额度
    }


    // 定义一个结构体来表示监管部门账户信息
    struct Regulator {
        uint256 regulatorId;            // 账户ID
        address regulatorAddress;       // 账户地址
        string  regulatorName;          // 部门名称
        Role userType;                  // 账户类型
    }

    // 定义一个结构体来表示交易订单信息
    struct Transaction {
        uint256 transactionId;               // 订单的交易ID
        string  transactionOrderName;        // 订单的名字
        address transactionBuyAddress;       // 买家地址
        address transactionSellAddress;      // 卖家地址
        uint256 transactionTime;             // 订单创建时间
        uint256 transactionQuantity;         // 购买碳额度的数量
    }

    // 定义交易的记录
    uint256 public enterpriseCount;
    uint256 public regulatorCount;
    uint256 public transactionCount;


    // 定义存储企业的数据集合
    Enterprise[] public enterpriseList;
    // 定义存储监管部门的数据集合
    Regulator[] public regulatorList;
    // 定义存储交易订单的数据集合
    Transaction[] public transactionList;


    address[] public enterprisesAddress;
    address[] public regulatorsAddress;


    // 通过地址映射企业的详细信息
    mapping(address => Enterprise) public enterpriseMap;
    // 通过地址映射监管部门的详细信息
    mapping(address => Regulator) public regulatorMap;
    
    mapping(uint256 => Transaction) public transactionMap;

    mapping(address => Transaction[]) public enterpriseToTransactions;


    // 企业
    modifier OnlyEnterprice(address _account) {
        require(
            enterpriseMap[_account].enterpriseAddress == msg.sender &&
            enterpriseMap[_account].userType == Role.Enterprise,"当前没有企业的权限"
        );
        _;
    }
    // 监管
    modifier OnlyRegulator(address _account) {
        require(
            regulatorMap[_account].regulatorAddress == msg.sender &&
            regulatorMap[_account].userType == Role.Regulator,"当前没有监管机构权限"
        );
        _;
    }

    // 检查是否注册
    modifier CheckRegistered(address _enterpriseAddress) {
        require(!selectHasRegulator(_enterpriseAddress),"当前企业未注册");
        _;
    }

    /*
    * @dev 注册一个企业
    * @param _account 企业账户地址
    * @param _name 企业名称
    */
    function registerEnterprise(address _enterpriseAddress,string memory _enterpriseName) public {
        // 判断当前是否存在
        require(!selectHasEnterprise(_enterpriseAddress),"当前企业已经注册");
        enterpriseCount++;
        uint256 _accountId = enterpriseCount;

        Enterprise storage _newEnterprise = enterpriseMap[_enterpriseAddress];
        _newEnterprise.enterpriseId = _accountId;
        _newEnterprise.enterpriseAddress = _enterpriseAddress;
        _newEnterprise.enterpriseName = _enterpriseName;
        _newEnterprise.enterpriseBalance = 0;
        _newEnterprise.enterpriseTotalEmission = 0;
        _newEnterprise.enterpriseOverEmission = 0;
        _newEnterprise.enterpriseCarbonCredits = 0;
        _newEnterprise.enterpriseVerified = false;
        _newEnterprise.userType = Role.Enterprise;
        _newEnterprise.qualification = Qualification("","",0,0,0);
        // enterpriseNameToAddressMap[_enterpriseName] = _enterpriseAddress;
        enterprisesAddress.push(_enterpriseAddress);
        enterpriseList.push(_newEnterprise);
        // 触发企业注册的事件
        emit RegisterAccount(_enterpriseAddress,_enterpriseName);
    }


    // 查询企业是否注册
    function selectHasEnterprise(address _enterpriseAddr) public returns(bool) {
        if (enterpriseMap[_enterpriseAddr].enterpriseAddress == _enterpriseAddr){
            return true;
        }else {
            return false;
        }
    }


    /*
    * @dev 注册一个监管部门
    * @param _regulator 监管部门的地址
    * @param _name 监管部门的名称
    */
    function registerRegulator(address _regulatorAddress,string memory _regulatorName) public {
        require(!selectHasRegulator(_regulatorAddress),"当前监管机构已经注册");
        regulatorCount++;
        uint256 regulatorId = regulatorCount;

        Regulator storage _newRegulator = regulatorMap[_regulatorAddress];
        _newRegulator.regulatorId = regulatorId;
        _newRegulator.regulatorAddress = _regulatorAddress;
        _newRegulator.regulatorName = _regulatorName;
        _newRegulator.userType = Role.Regulator;

        // regulatorNameToAddressMap[_regulatorName] = _regulatorAddress;
        regulatorsAddress.push(_regulatorAddress);
        regulatorList.push(_newRegulator);
        emit RegisterAccount(_regulatorAddress,_regulatorName);
    }

    // 查询企业是否注册
    function selectHasRegulator(address _regulatorAddr) public view returns(bool) {
        if (regulatorMap[_regulatorAddr].regulatorAddress == _regulatorAddr){
            return true;
        }else {
            return false;
        }
    }

    // 注销企业
    function deleteEnterprise(address _enterpriseAddress) public returns(bool) {
        if (selectHasRegulator(_enterpriseAddress)){
            return false;
        }else {
            delete enterpriseMap[_enterpriseAddress];
            for (uint i = 0; i < enterprisesAddress.length; i++){
                if (enterprisesAddress[i] == _enterpriseAddress){
                    delete enterprisesAddress[i];
                }
            }
            return true;
        }
    }

    /*
    * @dev 企业上传审核
    * @param _qualificationName 审核的资质名称
    * @param _qualificationContent 审核资质的内容
    */
    function qualificationUpload(string memory _qualificationName,string memory _qualificationContent) public OnlyEnterprice(msg.sender) CheckRegistered(msg.sender) {
        // 该企业不能存在已经上传资质的情况
        require(enterpriseMap[msg.sender].enterpriseVerified == false,"已经上传过资质,当前无法上传审核资质");
        Qualification storage _qualification = enterpriseMap[msg.sender].qualification;
        // 上传审核的资料
        _qualification.qualificationName = _qualificationName;
        _qualification.qualificationContent = _qualificationContent;
        _qualification.qualificationUploadTime = block.timestamp;
        // 触发上传审核资料的事件
        emit UploadQualification(msg.sender,_qualificationName,_qualificationContent);
    }


    /*
    * @dev 监管部门审核企业上传的资质
    * @param _enterpriseAddr 企业的账户地址
    * @param _flag 企业是否通过审核
    */
    function verifyQualification(address _enterpriseAddress,bool _flag) public OnlyRegulator(msg.sender) returns(Enterprise memory) {
        // 这部分代码是主要业务
        Enterprise storage _enterprise = enterpriseMap[_enterpriseAddress];
        _enterprise.qualification.qualificationAuditTime = block.timestamp;
        if (_flag) {
            _enterprise.enterpriseVerified = AUDIT_SUCCESS;
            _enterprise.qualification.qualificationEmissionLimit = TOTAL_EMISSION;
        }else {
            return;
        }
        emit VerifyQualification(_enterpriseAddress,TOTAL_EMISSION);
        return _enterprise;
    }


    /*
    * @dev 更新企业的余额
    * @param _enterpriseAddr 企业的账户地址
    */
    function updateBalance(address _enterpriseAddress,uint256 _amount) public OnlyEnterprice(msg.sender) CheckRegistered(msg.sender) returns(bool) {
        Enterprise storage _enterprise = enterpriseMap[_enterpriseAddress];
        _enterprise.enterpriseBalance += _amount;
        emit UpdateBalnce(msg.sender,_amount);
        return true;
    }

    /*
    * @dev 查看企业的详细信息
    * @param _enterpriseAddr 企业的账户地址
    */
    function queryEnterpriseInfo(address _enterpriseAddress) public view returns(Enterprise memory) {
        Enterprise memory enterprise = enterpriseMap[_enterpriseAddress];
        return enterprise;
    }

    /*
    * @dev 查看监管部门的详细信息
    * @param _regulatorAddr 监控部门的账户地址
    */
    function queryRegulatorInfo(address _regulatorAddress) public view returns(uint256,address,string memory,Role) {
        Regulator memory regulator =  regulatorMap[_regulatorAddress];
        return (regulator.regulatorId,regulator.regulatorAddress,regulator.regulatorName,regulator.userType);
    }


    /*
    * @dev 查看企业购买的交易历史信息
    * @param _enterpriseAddr 企业的账户地址
    */
    function queryEnterpriseTransactionInfo(address _enterpriseAddress) public view returns(Transaction[] memory){
        Transaction[] memory transactions = enterpriseToTransactions[_enterpriseAddress];
        return transactions;
    }

    /*
    * @dev 查看当前企业是否通过认证
    */
    function checkEnterpriseVerified(address _enterpriseAddr) public view returns(bool){
        return enterpriseMap[_enterpriseAddr].enterpriseVerified;
    }

    /*
    * @dev 分页拆查询企业的公司信息
    * @param page       查询的页数
    * @param pageSize   查询的每页的数量
    */
    function queryAllEnterprises(uint256 page,uint256 pageSize) public returns(Enterprise[] memory) {
        require(page > 0, "页数不能为0");
        uint256 startIndex = (page - 1) * pageSize; // 计算起始索引
        uint256 endIndex = startIndex + pageSize > enterprisesAddress.length ? enterprisesAddress.length : startIndex + pageSize; // 计算结束索引
        Enterprise[] memory enterpriseArr = new Enterprise[](endIndex - startIndex); // 创建每页大小的 Enterprise 数组
        for (uint i = startIndex; i < endIndex; i++){
            if (enterprisesAddress[i] == address(0)){
                continue;
            }
            enterpriseArr[i - startIndex] = enterpriseMap[enterprisesAddress[i]];
        }
        return enterpriseArr;
    }

    /*
    * @dev 分页拆查询企业的交易历史订单信息
    * @param page       查询的页数
    * @param pageSize   查询的每页的数量
    */
    function queryAllTransactions(uint256 page,uint256 pageSize) public returns(Transaction[] memory) {
        require(transactionList.length != 0,"当前没有任何交易历史记录");
        require(page > 0, "页数不能为0");
        uint256 startIndex = (page - 1) * pageSize; // 计算起始索引
        uint256 endIndex = startIndex + pageSize > transactionList.length ? transactionList.length : startIndex + pageSize; // 计算结束索引
        Transaction[] memory transactionArr = new Transaction[](endIndex - startIndex); // 创建每页大小的 Enterprise 数组
        for (uint i = startIndex; i < endIndex; i++){
            transactionArr[i - startIndex] = transactionList[i];
        }
        return transactionArr;
    }
}
```

------



### 4.3 CarbonAssetV2合约业务介绍

CarbonAsset的主要业务：

- 需要检查当前的企业是否认证
- 通过认证之后可以进行碳资产的出售和购买 
- 企业需要申请排放额度，审批排放额度之后即可排放
- 企业排放资源之后会加入到计算积分排行中
- 对企业的排放量进行排序，在后端进行相应的排序，不要在链上排序，避免消耗极大的GAS
- 可以进行统计排名前三奖励可以自行调整



### 4.4 CarbonAssetV2合约

**这里我使用了SafeMath合约，防止计算数字溢出**

```solidity
pragma solidity ^0.4.25;

library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, "SafeMath: division by zero");
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        uint256 c = a - b;

        return c;
    }
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0, "SafeMath: modulo by zero");
        return a % b;
    }
}
```



**CarbonAssetV2的合约详细**

主要的函数方法有如下：

- `buyEmissionLimit()`   : 购买碳额度函数
- `sellEmissionLimit()`   ： 出售碳额度函数
- `enterpriseEmissionUpload()`    ：企业碳排放量申请函数
- `verifyEnterpriseEmission()`   ：监管机构审批企业申请函数
- `updateEnterpriseEmission()`    ：企业更新总排放量函数
- `enterpriseEmission()`   ： 企业碳排放函数
- `selectAllEnterpriseAssets()`   ：查询所有企业出售的信息函数
- `queryAllEmissionResources()`  ：查询所有企业申请碳排放信息函数
- `selectTransactionInfo()`  ： 查询企业的交易信息函数
- `queryEnterpriseCredit()`   ：查询企业的积分函数
- `queryEnterpriseTotalEmission()`    ：查询企业的总排放量函数
- `queryEnterpriseAssetInfo()`  ：查询企业碳资产信息函数
- `queryEnterpriseEmissionInfo()`   ：查询企业碳排放信息
- `clearOverEmissions()`  ： 清楚所有企业已完成的排放量函数
- `initEmissionLimit()`  ：初始化每个额度函数

```solidity
pragma solidity ^0.4.25;
pragma experimental ABIEncoderV2;

import "./CarbonExcitationV2.sol";
import "./SafeMath.sol";

contract CarbonAssetV2 is CarbonExcitationV2 {
    
    using SafeMath for *;


    // 排放碳资源的结构体
    struct EmissionResource {
        uint256 emissionId;          // 排放资源的ID 
        address enterpriseAddress;   // 排放的企业
        uint256 emissions;           // 排放的量
        string  description;         // 排放的资源描述
        bool    isApprove;           // 是否批准排放
        uint256 time;                // 排放时间
    }
    
    // 企业出售碳资产的结构体
    struct EAsset {
        uint assetId;                   // 企业出售碳资产的列表Id
        address assetAddress;           // 企业出售碳资产的账户地址
        uint256 assetQuantity;          // 企业出售碳资产的数量 
        uint256 assetAmount;            // 企业出售碳资产的价钱
        uint256 time;                   // 企业出售碳资产的时间
    }

    // 定义出售的资产记录
    uint256 public eassetCount;
    uint256 public emissionResourceCount;
    
    // 通过Id映射企业出售的详细信息
    mapping(uint256 => EAsset) public  eassetMap;
    
    // 存储企业出售碳资产的账户地址映射索引
    mapping(address => uint256) public eassetIndex;
        
    // 存储排放资源申请对应企业账户地址的映射
    // mapping(address => EmissionResource) public emissionToEnterpriseMap;
    mapping(uint256 => EmissionResource) public idToEmissionMap;
    
    constructor() {
        registerRegulator(msg.sender,"监管机构");
    }
    
    // 所有企业出售谈额度的数据集合
    EAsset[] public eassets;
    
    EmissionResource[] public emissionResources;

    
    // 查看当前的企业是否认证审核通过 
    modifier CheckVerify(address _enterpriseAddr) {
        require(checkEnterpriseVerified(_enterpriseAddr),"当前的企业未进行认证");
        _;
    }
    
    event EnterpriseEmissionUpload(address indexed _enterpriseAddr,uint256 indexed _emissionEmission);
    
    event VerifyEnterpriseEmission(address indexed _enterpriseAddr);
    
    event UpdateEnterpriseEmission(address indexed _enterpriseAddr,uint256 indexed _totalEmissions); 
    
    event EnterpriseEmission(address indexed _enterpriseAddr,uint256 indexed _emissionEmission,bool indexed _isCompulsion);
    
    
    /*
    * @dev 企业购买碳排放额度
    * @param _enterpriseAddr 购买碳排放额度的地址
    * @param _quantity 购买碳排放额度的数量
    */
    function buyEmissionLimit(address _enterpriseAddr,uint256 eassetId,uint256 _quantity) public OnlyEnterprice(msg.sender) CheckVerify(msg.sender) returns(Transaction memory) {
        // 查看当前的企业余额是否为满足购买的条件
        // require(enterpriseMap[msg.sender].enterpriseBalance > eassetMap[eassetIndex[_enterpriseAddr]].assetAmount,"当前的余额不足,购买失败");
        // 对企业的碳余额进行计算   
        Enterprise storage buyer = enterpriseMap[msg.sender];
        Enterprise storage seller = enterpriseMap[_enterpriseAddr];
        EAsset storage easset = eassetMap[eassetId];
        require(_enterpriseAddr != msg.sender,"自己不能购买");
        require(easset.assetQuantity > 0,"当前的额度已售完");
        require(SafeMath.sub(easset.assetQuantity,_quantity) >= 0,"超过当前的数量");
        
        buyer.enterpriseBalance -= SafeMath.mul(_quantity,easset.assetAmount);
        buyer.qualification.qualificationEmissionLimit += _quantity;
        seller.enterpriseBalance += SafeMath.mul(_quantity,easset.assetAmount);
        
        transactionCount++;
        uint256 transactionId = transactionCount;
        Transaction storage _transaction = transactionMap[transactionId];
        _transaction.transactionId = transactionId;
        _transaction.transactionOrderName = "碳额度企业交易";
        _transaction.transactionBuyAddress = buyer.enterpriseAddress;
        _transaction.transactionSellAddress = seller.enterpriseAddress;
        _transaction.transactionTime = block.timestamp;
        _transaction.transactionQuantity =  _quantity;
        
        enterpriseToTransactions[msg.sender].push(_transaction);
        transactionList.push(_transaction);
        easset.assetQuantity -= _quantity;
        uint length = eassets.length;
        for (uint i = 0 ;i < length; ++i) {
            if (eassets[i].assetId == eassetId) {
                eassets[i].assetQuantity -= _quantity; 
            }
        }
        emit TransferEmissionLimit(_enterpriseAddr,buyer.enterpriseAddress,_quantity);
        return _transaction;
    }

    /*
    * @dev 企业出售碳额度
    * @param _emissionLimitCount 企业的碳额度数量
    * @param _amount 企业出售的单价
    */
    function sellEmissionLimit(uint256 _emissionLimitCount,uint256 _amount) public OnlyEnterprice(msg.sender) CheckVerify(msg.sender) returns(EAsset memory) {
        // 判断当前企业的碳额度是否足够
        require(enterpriseMap[msg.sender].qualification.qualificationEmissionLimit >= _emissionLimitCount,"当前的企业碳排放额度低于售卖的碳排放额度");
        Enterprise storage _enterprise = enterpriseMap[msg.sender];
        _enterprise.qualification.qualificationEmissionLimit -= _emissionLimitCount; 
        
        eassetCount++;
        uint256 eassetId = eassetCount;
        EAsset storage _newEasset = eassetMap[eassetCount];
        _newEasset.assetId = eassetId;
        _newEasset.assetAddress = msg.sender;
        _newEasset.assetQuantity = _emissionLimitCount;
        _newEasset.assetAmount = _amount;
        _newEasset.time = block.timestamp;
        eassets.push(_newEasset);
        eassetIndex[msg.sender] = eassetId;
        emit SellEmissionLimit(_emissionLimitCount,_amount);
        return _newEasset;
    }
    
    
    function updateSellEmissionLimit(uint256 _eassetId,uint256 _emissionLimitCount,uint256 _amount) public {
        EAsset storage _easset = eassetMap[_eassetId];
        _easset.assetQuantity = _emissionLimitCount;
        _easset.assetAmount = _amount;
    }
    
    
    
    /*
    * @dev 企业的碳排放审批  
    * @param _enterpriseAddr 企业的账户地址
    * @param _emissionEmission 企业排放的量
    * @param _description  企业排放的描述
    */
    function enterpriseEmissionUpload(address _enterpriseAddr,uint256 _emissionEmission,string memory _description) public CheckVerify(msg.sender) returns(EmissionResource memory) {
        require(_emissionEmission <= enterpriseMap[_enterpriseAddr].qualification.qualificationEmissionLimit,"当前申请排放的量大于申请的额度");
        
        emissionResourceCount++;
        uint256 emissionResouceId = emissionResourceCount;
        EmissionResource storage emissionResource = idToEmissionMap[emissionResouceId];
        emissionResource.emissionId = emissionResouceId;
        emissionResource.enterpriseAddress = _enterpriseAddr;
        emissionResource.emissions = _emissionEmission;
        emissionResource.description = _description;
        emissionResource.isApprove = false;
        emissionResource.time = 0;
        emissionResources.push(emissionResource);
        
        emit EnterpriseEmissionUpload(msg.sender,_emissionEmission);
        return emissionResource;
    }
    

    /*
    * @dev 审批企业的碳排放量
    * @param _enterpriseAddr 企业的账户地址
    * @param _isApprove 是否批准
    */
    function verifyEnterpriseEmission(address _enterpriseAddr,uint256 _emmissionid,bool _isApprove) public returns(bool){
        EmissionResource storage emissionResource = idToEmissionMap[_emmissionid];
        emissionResource.isApprove = _isApprove;
        for (uint i = 0; i < emissionResources.length; ++i){
            if (emissionResources[i].enterpriseAddress == _enterpriseAddr) {
                emissionResources[i] = emissionResource;
            }
        }
        emit VerifyEnterpriseEmission(_enterpriseAddr);
        return _isApprove;
    }
    
    /*
    * @dev 更新企业的总排放量
    * @param  _enterpriseAddr 企业的账户地址 
    * @param  _totalEmissions 企业的总排放量
    */
    function updateEnterpriseEmission(address _enterpriseAddr,uint256 _totalEmissions) public CheckVerify(msg.sender) returns(bool) {
        Enterprise storage enterprise = enterpriseMap[_enterpriseAddr];
        enterprise.enterpriseTotalEmission += _totalEmissions;
        
        emit UpdateEnterpriseEmission(_enterpriseAddr,_totalEmissions);
        return true;
    }

    
    /*
    * @dev 企业的碳排放
    * @param _emissionEmission 企业的实际碳排放量
    */
    function enterpriseEmission(uint256 _emmissionid,uint256 _emissionEmission,bool _isCompulsion) public CheckVerify(msg.sender) returns(EmissionResource memory) {
        require(enterpriseMap[msg.sender].enterpriseTotalEmission != 0,"请更新当前的总排放量");
        Enterprise storage enterprise = enterpriseMap[msg.sender];
        EmissionResource storage emissionResource = idToEmissionMap[_emmissionid];
        
        require(emissionResource.emissions != 0,"当前申请排放量已用完");
        require(
            idToEmissionMap[_emmissionid].isApprove == true || 
            _emissionEmission <= idToEmissionMap[_emmissionid].emissions,"请确定是否审批或是否大于审批的排放量"
        );
        
        // 超额罚款
        if (_isCompulsion){
            uint256 excessTotal = SafeMath.sub(_emissionEmission,enterprise.qualification.qualificationEmissionLimit);
            enterprise.enterpriseBalance -= SafeMath.mul(excessTotal,EXCESS_BALANCE);
            enterprise.qualification.qualificationEmissionLimit = 0;
            emissionResource.emissions = 0;
        }else {
            // 扣款额度
            enterprise.enterpriseTotalEmission -= _emissionEmission;
            enterprise.qualification.qualificationEmissionLimit -= _emissionEmission;
            emissionResource.emissions -= _emissionEmission;
        }
        enterprise.enterpriseOverEmission += _emissionEmission;
        emissionResource.time = block.timestamp;
        for (uint i = 0; i < emissionResources.length; ++i){
            if (emissionResources[i].enterpriseAddress == msg.sender) {
                emissionResources[i] = emissionResource;
            }
        }
        emit EnterpriseEmission(msg.sender,_emissionEmission,_isCompulsion); 
        return emissionResource;
    }

    
    /*
    * @dev 分页拆查询企业出售信息
    * @param page       查询的页数
    * @param pageSize   查询的每页的数量
    */
    function selectAllEnterpriseAssets(uint256 page,uint256 pageSize) public returns(EAsset[] memory) {
        require(eassets.length != 0,"当前没有企业出售碳资产");
        require(page > 0, "页数不能为0");
        uint256 startIndex = (page - 1) * pageSize; // 计算起始索引
        uint256 endIndex = startIndex + pageSize > eassets.length ? eassets.length : startIndex + pageSize; // 计算结束索引
        EAsset[] memory eAssetArr = new EAsset[](endIndex - startIndex); // 创建每页大小的 Enterprise 数组
        for (uint i = startIndex; i < endIndex; i++){
            eAssetArr[i - startIndex] = eassets[i];
        }
        return eAssetArr;
    }
    
    
    /*
    * @dev 分页拆查询所有企业排放资源的信息
    * @param page       查询的页数
    * @param pageSize   查询的每页的数量
    */
    function queryAllEmissionResources(uint256 page,uint256 pageSize) public returns(EmissionResource[] memory) {
        require(emissionResources.length != 0,"当前没有企业排放资产信息");
        require(page > 0, "页数不能为0");
        uint256 startIndex = (page - 1) * pageSize; // 计算起始索引
        uint256 endIndex = startIndex + pageSize > emissionResources.length ? emissionResources.length : startIndex + pageSize; // 计算结束索引
        EmissionResource[] memory emissionResourceArr = new EmissionResource[](endIndex - startIndex); // 创建每页大小的 Enterprise 数组
        for (uint i = startIndex; i < endIndex; i++){
            emissionResourceArr[i - startIndex] = emissionResources[i];
        }
        return emissionResourceArr;
    }
    

    /*
    * @dev 查看交易详细信息
    *
    */
    function selectTransactionInfo(uint256 _transactionId) public returns(Transaction memory){
        Transaction memory transaction = transactionMap[_transactionId];
        return transaction;
    }

    
    /*
    * @dev 查看企业的积分余额
    */
    function queryEnterpriseCredit() public CheckVerify(msg.sender) view returns(uint256) {
        return enterpriseMap[msg.sender].enterpriseCarbonCredits;
    }
    
    
    /*
    * @dev 查看企业已完成的排放量
    */
    function queryEnterpriseTotalEmission(address _enterpriseAddr) public view returns(uint256) {
        return enterpriseMap[_enterpriseAddr].enterpriseOverEmission;
    }
    
    /*
    * @dev 查看企业的碳额度出售信息情况
    * @param _eassetId 企业出售额度列表的ID
    */
    function queryEnterpriseAssetInfo(uint256 _eassetId) public view returns(EAsset memory) {
        EAsset memory easset = eassetMap[_eassetId];
        return easset;
    } 
    
    /*
    * @dev 查看企业的碳排放信息情况
    * @param _enterpriseAddr 企业的地址
    */
    function queryEnterpriseEmissionInfo(uint256 _emmissionid) public view returns(EmissionResource memory) {
        EmissionResource memory emissionResource = idToEmissionMap[_emmissionid];
        return emissionResource;
    } 
    
    /*
    * @dev 清空所有企业的每个月的已完成的排放量
    *
    */
    function clearOverEmissions() public {
        for (uint256 i = 0; i < enterprisesAddress.length; i++) {
            if (enterprisesAddress[i] != address(0)) {
                enterpriseMap[enterprisesAddress[i]].enterpriseOverEmission = 0;
            } 
        }
        
    }
    
    /*
    * @dev 每个月发放额度1000
    *
    */
    function initEmissionLimit(uint256 _qualificationEmissionLimit) public{
        for (uint256 i = 0; i < enterprisesAddress.length; i++) {
            if (enterprisesAddress[i] != address(0)) {
                enterpriseMap[enterprisesAddress[i]].qualification.qualificationEmissionLimit += _qualificationEmissionLimit;
            } 
        }
        
    }
}
```

------



### 4.5 CarbonExcitationV2合约业务介绍

CarbonExcitationV2的主要业务：

- 负责根据所有企业的名称地址以及排放量和积分进行统计

- 在后端进行将统计完的企业排序，按照排放量底的排序

- 根据基本的情况进行积分的奖励

  

### 4.6 CarbonExcitationV2合约

CarbonExcitationV2主要的函数： 

- `selectWinnerOfCompute()`  ： 统计所有企业的函数
- `winersCredit()`  : 积分奖励函数

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.4.25;
pragma experimental ABIEncoderV2;

import "./CarbonCertificationV2.sol";

// 用于计算企业排名 对企业的排名做积分奖励
contract CarbonExcitationV2 is CarbonCertificationV2 {
    
    // 所有企业的地址
    struct Credit {
        string  enterpriseName;
        address enterpriseAddr;
        uint256 overEmission;
        uint256 enterpriseCredit;
    }
    
    Credit[] public credits;
    
    address[] public winers;
    
    // 这里是返回所有的address
    function selectWinnerOfCompute() public returns(Credit[] memory){
        Credit[] memory credits = new Credit[](enterprisesAddress.length);
        uint256 enterpriseLength = enterprisesAddress.length;
        for (uint i = 0; i < enterpriseLength; ++i){
            credits[i].enterpriseName = enterpriseMap[enterprisesAddress[i]].enterpriseName;
            credits[i].enterpriseAddr = enterpriseMap[enterprisesAddress[i]].enterpriseAddress;
            credits[i].overEmission = enterpriseMap[enterprisesAddress[i]].enterpriseOverEmission;
            credits[i].enterpriseCredit = enterpriseMap[enterprisesAddress[i]].enterpriseCarbonCredits;
        }
        return credits;
    }
    
    function winersCredit(address[] memory queryWinners,uint256 _credits) public {
        uint256 _5Credits = _credits * 5;
        uint256 _4Credits = _credits * 4;
        uint256 _3Credits = _credits * 3;
        uint256 _2Credits = _credits * 2;
        for (uint i = 0; i < queryWinners.length; i++) {
            if (i == 0) {
                enterpriseMap[queryWinners[i]].enterpriseCarbonCredits += _5Credits;
                enterpriseMap[queryWinners[i]].qualification.qualificationEmissionLimit += _credits;
            }else if (i == 1) {
                enterpriseMap[queryWinners[i]].enterpriseCarbonCredits += _4Credits;
                enterpriseMap[queryWinners[i]].qualification.qualificationEmissionLimit += _credits;
            }else if(i == 2) {
                enterpriseMap[queryWinners[i]].enterpriseCarbonCredits += _3Credits;
                enterpriseMap[queryWinners[i]].qualification.qualificationEmissionLimit += _credits;
            }else if (i == 3){
                enterpriseMap[queryWinners[i]].enterpriseCarbonCredits += _2Credits;
            }else if (i == 4){
                enterpriseMap[queryWinners[i]].enterpriseCarbonCredits += _credits;
            }
        }
    }
}
```



## 5.编译部署合约

这里我使用的是WeBASE部署编译合约。

部署WeBASE的教程：

- 官网： https://webasedoc.readthedocs.io/zh_CN/latest/docs/WeBASE-Install/developer.html
- 我的CSDN：https://blog.csdn.net/weixin_46532941/article/details/129888194?spm=1001.2014.3001.5502
- 我的博客：https://iskcount.gitee.io/docs/zh/web3/fisco/01.%E6%90%AD%E5%BB%BAFisco%E7%9A%84%E8%81%94%E7%9B%9F%E9%93%BE(WeBase%E7%89%88).html



### 5.1 创建测试用户

>  注册和调用合约切换账户的时候，需要选择指定的用户地址。

创建一个regulator用户，作为监管部门，use1-user3是测试企业。

![image-20230402023328942](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202304020233156.webp)



### 5.2 部署合约

使用Admin用户部署`CarbonAssetV2`合约即可，合约之间我使用了集成的方式，所有需要用到一些公用的方法或者变量。

![image-20230402022715839](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202304020227118.webp)



### 5.3 企业审核资质完整业务测试

1.注册企业和监管部门，分别注册user1-user3这三个企业，regulator注册为监管部门。

![image-20230402022927638](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202304020229567.webp)

返回正确的交易回执。同样的方式注册user2-user3企业。

![image-20230402022958543](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202304020229430.webp)





2.注册监管部门，使用regulator用户。

![image-20230402023411082](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202304020234418.webp)

返回正确的交易回执。

![image-20230402023520229](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202304020235208.webp)



3.三个测试企业上传资质。

![image-20230402023712802](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202304020237933.webp)

返回正确的交易回执。

![image-20230402023735361](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202304020237430.webp)



4.分页查询所有企业，查看是否都为待审核资质，未认证状态。

![image-20230402023949047](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202304020239143.webp)

如下状态为未认证状态。

![image-20230402024011779](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202304020240896.webp)



5.监管机构进行审批企业的上传的资质。

测试数据：

```solidity
[1,0x2139148946600b07fC1E15CAE7a6B9152e35C4a4,测试企业1,0,0,0,0,false,0,企业认证,认证编码 AAAA,1680374216290,0,0]

[2,0xD2BA8A504a844dfa5d08b99A728aFa41aea0CdF8,测试企业2,0,0,0,0,false,0,企业认证,认证编码 BBBB,1680374280332,0,0]

[3,0x10bb01703e57B0644E80026E35fBd29564b1F9Ca,测试企业3,0,0,0,0,false,0,企业认证,认证编码 CCCC,1680374301184,0,0]
```

![image-20230402024300758](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202304020243884.webp)

正确的返回交易回执。

![image-20230402024327851](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202304020243715.webp)



6.查看所有已通过审批的企业。

![image-20230402024528072](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202304020245206.webp)

如上就是完整的企业上传资质，审核企业资质的业务流程。然后就可以对企业的信息进行更新。所有数据更新完毕可以申请碳排放量的申请。



### 5.4 企业碳排放量审批完整业务测试

这是我更新完企业的余额和总排放量的数据：

余额分别是`500`和总排放量分别是`25000,18000,15000`

```solidity
[1,0x2139148946600b07fC1E15CAE7a6B9152e35C4a4,测试企业1,500,25000,0,0,true,0,企业认证,认证编码 AAAA,1680374216290,1680374567774,1000]

[2,0xD2BA8A504a844dfa5d08b99A728aFa41aea0CdF8,测试企业2,500,18000,0,0,true,0,企业认证,认证编码 BBBB,1680374280332,1680374620494,1000]

[3,0x10bb01703e57B0644E80026E35fBd29564b1F9Ca,测试企业3,500,15000,0,0,true,0,企业认证,认证编码 CCCC,1680374301184,1680374633060,1000]
```



1.企业申请单次排放量

![image-20230402025310939](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202304020253974.webp)

正确的返回交易回执。

![image-20230402025344828](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202304020253624.webp)



2.监管机构审核进行审批。

企业提交申请会推送到所有的审批订单中，可以进行分页查询

![image-20230402025717931](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202304020257923.webp)

![image-20230402025738012](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202304020257166.webp)



对需要审核的进行审批。

![image-20230402025535943](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202304020255018.webp)

正确的返回交易回执。

![image-20230402025656053](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202304020256947.webp)



查询到的数据，当前`0x2139148946600b07fC1E15CAE7a6B9152e35C4a4`的企业已经审批，可以进行排放。

```solidity
1,0x2139148946600b07fC1E15CAE7a6B9152e35C4a4,800,污水排放,true,0
2,0xD2BA8A504a844dfa5d08b99A728aFa41aea0CdF8,800,超市排放,false,0
3,0x10bb01703e57B0644E80026E35fBd29564b1F9Ca,800,工厂排放,false,0
```



3.企业正式碳排放，选择`false`，不强制排放。

![image-20230402030028305](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202304020300283.webp)

正确的返回交易回执。

![image-20230402030118242](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202304020301202.webp)

可以看到数据订单1是`0x2139148946600b07fC1E15CAE7a6B9152e35C4a4`企业的，订单已经排放减少了300



### 5.5 企业交易碳额度完整业务测试

企业交易需要保证自身已有额度，不能为0。

1.user1的企业出售100个碳额度，单价为20。

![image-20230402030539326](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202304020305276.webp)

正确的返回交易回执。

![image-20230402030602619](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202304020306357.webp)

2.user2企业去购买企业1的碳额度，购买数量为2。

![image-20230402030723049](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202304020307117.webp)

![image-20230402030740143](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202304020307297.webp)



3.查看当前user2和user1的交易信息。

![image-20230402030857667](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202304020308609.webp)

![image-20230402030917329](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202304020309443.webp)



4.查看user1和user2企业的信息。

![image-20230402030957980](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202304020309020.webp)

返回最终测试数据：

```solidity
[1,0x2139148946600b07fC1E15CAE7a6B9152e35C4a4,测试企业1,540,24500,500,0,true,0,企业认证,认证编码 AAAA,1680374216290,1680374567774,400]

[2,0xD2BA8A504a844dfa5d08b99A728aFa41aea0CdF8,测试企业2,460,18000,0,0,true,0,企业认证,认证编码 BBBB,1680374280332,1680374620494,1002]

[3,0x10bb01703e57B0644E80026E35fBd29564b1F9Ca,测试企业3,500,15000,0,0,true,0,企业认证,认证编码 CCCC,1680374301184,1680374633060,1000]
```

以上就是完整的合约案例+测试流程。
