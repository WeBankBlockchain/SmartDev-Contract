## 引言

针对2023年8月24日，日本单方面强行启动福岛核污染水排海。我国海关高度关注日方此举对日本输华食品农产品带来的放射性污染风险。为防范受到放射性污染的日本食品输华，保护人民群众生命健康，海关总署持续开展对日本食品放射性污染风险的评估，在严格确保安全的基础上，对从日本进口食品采取了强化监管措施。


我们可以使用商品溯源追踪海水类产品，确保数据不可篡改，从而达到高度可信。系统允许生产商创建商品并跟踪其生产、流转和消费过程。每个商品都有一个溯源链，记录了商品的历史操作和状态变化。流转和验证操作需要按照特定的规则进行，以确保商品溯源的准确性和可追溯性。这种合约可以用于建立透明的供应链管理系统，确保商品的质量和来源可信。此系统可结合海洋监测数据一起使用，根据海水监测值评估当时出产的海类产品是否安全，若海水监测值超出正常值，可以提示预警，关注当时出产的海类产品是否安全。


### 1. 概述

系统采用中心化与去中心化结合实现，去中心化是基于FISCO BCOS联盟链上实现商品溯源系统，由三个主要层次组成：应用层、服务层和区块链层，如下图所示：

![image](https://github.com/WeBankBlockchain/SmartDev-Contract/assets/90448845/e3a42c05-f33e-4263-8b73-419a42bf4af7)

系统允许生产商、分销商、零售商、消费者等角色跟踪商品的供应链信息，包括生产、流通和消费的过程，数据流程如下图所示：

![image](https://github.com/WeBankBlockchain/SmartDev-Contract/assets/90448845/3890ce81-3c9e-4bcc-afaf-e9a5b77ebf37)

### 2. 应用层

在应用层，通过用户界面便于用户可以交互式地访问和管理商品信息。这可以是一个Web应用程序、移动应用程序、桌面应用程序或小程序等，具体取决于实际需求。

#### 2.1 用户功能

用户可以使用界面进行以下操作：

- 创建商品
- 流转商品
- 确认验收商品
- 查询商品信息
- 查看商品的溯源历史

#### 2.2 用户角色

维护不同的用户角色，包括生产商、分销商、零售商与消费者。每个角色都有特定的权限和操作能力。

#### 2.3 海水监测数据

维护不同地点海水的监测数据，日本核污水排海水，尤其是海水中放射性物质数据监测。商品若是海鲜类，重点参考放射性物质监测数据值。

### 3. 服务层

服务层是应用层与区块链层之间的中间层，用于处理业务逻辑和与区块链进行交互。它包括以下组件：

#### 3.1 业务逻辑

服务层中的业务逻辑将用户界面的操作映射到智能合约的调用。例如，当生产商使用界面创建新商品时，服务层将调用智能合约的创建新商品函数。

#### 3.2 区块链交互

服务层负责与区块链节点进行通信，将业务逻辑转化为区块链上的交易。它需要处理加密、身份验证和交易签名等安全性问题。

### 4. 区块链层

区块链层是FISCO BCOS联盟链本身，用于存储商品溯源的数据和智能合约。它包括以下组件：

#### 4.1 区块链节点

联盟链中的多个节点，每个节点都存储了完整的区块链数据，并参与共识算法。节点之间通过P2P网络通信。

#### 4.2 区块链数据

区块链存储了商品信息、交易记录和智能合约的状态。每个商品都有一个唯一的标识符，可以通过智能合约进行添加和查询相关数据。

#### 4.3 共识算法

FISCO BCOS使用共识算法来确保区块链的安全性和一致性。联盟链的成员必须达成一致才能添加新的区块。

#### 4.4 智能合约

智能合约是区块链层的核心组件，包含了商品溯源系统的业务逻辑。智能合约通过交易来维护商品链路数据，并且数据是不可篡改的。智能合约部分代码可参考下面Solidity代码片段。

### 5. 部署和维护

部署商品溯源系统需要在FISCO BCOS联盟链上部署智能合约，并确保节点的稳定性和安全性。维护包括监控系统性能、更新智能合约和升级系统以适应新的需求。

### 6. 智能合约代码片段

```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

/*
 * @dev 商品工厂合约，创建商品合约使用
*/
contract TraceFactory {

    /* ==================== Events ==================== */

    /* 
     * @dev 创建商品事件
     * @param _userAddr 操作者账户地址
     * @param _productAddr 商品合约地址
    */
    event CreateProductContract(address _userAddr, address _productAddr);

    /* ==================== State Variables ==================== */

    mapping(uint256 => address) products; // 商品ID对应商品合约地址

    /* ==================== External Functions ==================== */

    /* 
     * @dev 生产商创建商品
     * @param _id 商品编号
     * @param _date 生产日期
     * @param _name 商品名称
     * @param _location 生产地点
     * @param _batchNo 生产批次编号
     * @param _remark 商品备注
    */
    function createProduct(
        uint256 _id, 
        uint256 _date, 
        string memory _name, 
        string memory _location, 
        string memory _batchNo, 
        string memory _remark
    ) external {
        require(products[_id] == address(0), "The product already exists.");
        Product product = new Product(_id, _date, msg.sender, _name, _location, _batchNo, _remark);
        products[_id] = address(product);

        emit CreateProductContract(msg.sender, address(product));
    }
}

/*
 * @dev 商品合约，一个商品对应一个合约
*/
contract Product {

    /* ==================== Events ==================== */

    /* 
     * @dev 商品拥有者变更事件
     * @param _oldUserAddr 原商品拥有者账户地址
     * @param _newUserAddr 新商品拥有者账户地址
     * @param _status 商品状态
    */
    event UpdateTraceChian(address _oldUserAddr, address _newUserAddr, uint8 _status);
 
    /* 
     * @dev 验收商品事件
     * @param _userAddr 操作者账户地址
     * @param _index 商品溯源链中索引值
    */
    event VerifyProduct(address _userAddr, uint256 _index);

    /* ==================== Stucts ==================== */
  
    /*
    * @dev 商品链路追踪信息结构体
    */
    struct TraceChain {
        address userAddr;   // 操作人账户地址
        uint256 transDate;  // 交易时间
        bool isVerified;    // 是否验证: 0 否，1 是
        uint8 status;       // 商品状态：0 生产 1 流转 2 消费
    }

    /* ==================== State Variables ==================== */

    address public traceFactory; // 商品工厂合约地址

    uint256 id;            // 商品编号（全平台唯一）
    uint256 date;          // 生产日期
    address productor;     // 生产商
    string name;           // 商品名称
    string location;       // 生产地点
    string batchNo;        // 生产批次编号
    string remark;         // 商品备注，如商品介绍，商品成分，使用说明等

    TraceChain[] traceChainList; // 商品溯源链

    /* ==================== Modifiers ==================== */

    /* 
     * @dev 仅工厂合约可以调用
    */
    modifier onlyFactory() {
        require(msg.sender == traceFactory, "No permission without trace factory contract address.");
        _;
    }

    /* ==================== Constructor ==================== */

    /* 
     * @dev 生产商创建商品
     * @param _id 商品编号
     * @param _date 生产日期
     * @param _productor 生产商
     * @param _name 商品名称
     * @param _location 生产地点
     * @param _batchNo 生产批次编号
     * @param _remark 商品备注
    */
    constructor(
        uint256 _id, 
        uint256 _date, 
        address _productor, 
        string memory _name, 
        string memory _location, 
        string memory _batchNo, 
        string memory _remark
    ) {
        id = _id;
        date = _date;
        productor = _productor;
        name = _name;
        location = _location;
        batchNo = _batchNo;
        remark = _remark;

        traceFactory = msg.sender; //工厂合约地址

        // 商品源头
        traceChainList.push( TraceChain(productor, block.timestamp, true, 0) );
    }

    /* ==================== External Functions ==================== */

    /* 
     * @dev 商品流转
     * @notice 商品状态为流转或消费，当前商品溯源链中最后商品状态为生产或流转时可以操作
     * @param _newUserAddr 流转商或消费者账户地址
     * @param _status 商品状态：1 流转， 2 消费
    */
    function updateTraceChian(address _newUserAddr, uint8 _status) external {
        // 验证参数商品状态为流转或消费
        require(_status == 1 || _status == 2, "Invalid status.");

        TraceChain memory _traceChain = traceChainList[traceChainList.length - 1];
        // 验证当前商品溯源链中最后商品状态为生产或流转时可以操作
        require(_traceChain.status == 0 || _traceChain.status == 1, 
            "Can`t update trace chain because the status is not right.");
        // 验证当前商品溯源链中最后验证为已验证，即用户已确认接收商品，才能流转或消费
        require(_traceChain.isVerified, 
            "Can`t update trace chain because the procduct is not verified.");
        // 验证商品是否属于操作人
        require(_traceChain.userAddr == msg.sender, "The product is not yourself.");

        traceChainList.push( TraceChain(_newUserAddr, block.timestamp, false, _status) );

        emit UpdateTraceChian(msg.sender, _newUserAddr, _status);
    }

    /* 
     * @dev 商品确认接收
     * @notice 商品流转给流转商或消费者，需要流转商或消费者确认接收商品
    */
    function verifyProduct() external {
        TraceChain memory _traceChain = traceChainList[traceChainList.length - 1];
        // 验证商品已流转给操作人
        require(_traceChain.userAddr == msg.sender && !_traceChain.isVerified, "No permission or verified.");
        
        traceChainList.push( TraceChain(msg.sender, block.timestamp, true, _traceChain.status) );

        emit VerifyProduct(msg.sender, traceChainList.length - 1);
    }

    /* 
     * @dev 获取商品溯源链
     * @return TraceChain[]  // 商品溯源链
    */
    function getTraceChainList() external view returns (TraceChain[] memory) {
        return traceChainList;
    }

    /* 
     * @dev 获取商品溯源链
     * @return uint256  // 生产日期
     * @return address  // 生产商
     * @return string   // 商品名称
     * @return string   // 生产地点
     * @return string   // 生产批次编号
     * @return string   // 商品备注
    */
    function getProductInfo() external view returns (
        uint256,        
        address,
        string memory,
        string memory,     
        string memory,
        string memory
    ) {
        return (date, productor, name, location, batchNo, remark);
    }
}
```

通过整合应用层、服务层和区块链层，可以实现一个安全、可信和可追溯的商品溯源系统。这个系统可以用于跟踪商品的供应链信息，确保质量和来源可靠。在实际部署之前，请根据特定的需求和业务场景进行详细的规划和测试。

