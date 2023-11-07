# Task44 日本排核污水监测海洋数据指标

## 引言

针对2023年8月24日，日本单方面强行启动福岛核污染水排海。我国海关高度关注日方此举对日本输华食品农产品带来的放射性污染风险。为防范受到放射性污染的日本食品输华，保护人民群众生命健康，海关总署持续开展对日本食品放射性污染风险的评估，在严格确保安全的基础上，对从日本进口食品采取了强化监管措施。

我们可以监测海洋海水相关检测数据，来辨别是否已被核污水污染了，确保数据不可篡改，从而达到高度可信。可以根据海水监测值判断当地时间海产品是否安全可食用。

### 1. 概述

系统采用中心化与去中心化结合实现，去中心化是基于FISCO BCOS联盟链上实现海水数据监测功能，由三个主要层次组成：应用层、服务层和区块链层，如下图所示：

![image](https://github.com/WeBankBlockchain/SmartDev-Contract/assets/90448845/6fedbe67-5092-491e-96a4-1e319f6ab42d)

### 2. 应用层

在应用层，通过用户界面便于用户可以交互式地访问和记录监测数据。这可以是一个Web应用程序、移动应用程序、桌面应用程序或小程序等，具体取决于实际需求。

#### 2.1 用户功能

用户可以使用界面进行以下操作：

- 添加监测地点
- 添加监测数据
- 验证监测数据是否超标
- 查询监测地点
- 查看监测数据

#### 2.2 海水监测数据

维护不同地点海水的监测数据，日本核污水排海水，尤其是海水中放射性物质数据监测。商品若是海鲜类或是产品成份含海鲜类，可重点参考放射性物质监测数据值。

### 3. 服务层

服务层是应用层与区块链层之间的中间层，用于处理业务逻辑和与区块链进行交互。它包括以下组件：

#### 3.1 业务逻辑

服务层中的业务逻辑将用户界面的操作映射到智能合约的调用。例如，当添加海水监测数据时，服务层将调用智能合约的添加监测数据函数。

#### 3.2 区块链交互

服务层负责与区块链节点进行通信，将业务逻辑转化为区块链上的交易。它需要处理加密、身份验证和交易签名等安全性问题。

### 4. 区块链层

区块链层是FISCO BCOS联盟链本身，用于存储监测数据和智能合约。它包括以下组件：

#### 4.1 区块链节点

联盟链中的多个节点，每个节点都存储了完整的区块链数据，并参与共识算法。节点之间通过P2P网络通信。

#### 4.2 区块链数据

区块链通过调用智能合约存储了监测数据，可以通过智能合约进行添加和查询相关数据。。

#### 4.3 共识算法

FISCO BCOS使用共识算法来确保区块链的安全性和一致性。联盟链的成员必须达成一致才能添加新的区块。

#### 4.4 智能合约

智能合约是区块链层的核心组件，包含了添加监测数据功能。智能合约通过交易来维护监测数据，并且数据是不可篡改的。智能合约部分代码可参考下面Solidity代码片段。

### 5. 部署和维护

部署需要在FISCO BCOS联盟链上部署智能合约，并确保节点的稳定性和安全性。维护包括监控系统性能、更新智能合约和升级系统以适应新的需求。

### 6. 智能合约代码片段

**海洋监测内容海洋监测主要是针对海洋环境的各种物质和能量进行监测，具体内容主要包括：**

1、海洋水体的物理特性：主要指的是海洋水体的温度、温差、温层、温度变化、浊度、溶解氧含量、盐度、潮汐变化等;

2、海洋水体的化学特性：主要指的是海洋水体的氨氮、磷酸盐、亚硝酸盐、氟化物、镁、钙、氯化物、硫酸盐、有机碳和重金属等;

3、海洋水体的生物特性：主要指的是海洋水体中的浮游植物、浮游动物、底栖动物、鱼类等生物种类及其数量的监测;

4、海洋水体的能量特性：主要指的是海洋水体中的大气热量、太阳辐射、波浪能量等的监测。

**针对2023年8月24日，日本核污水排海，着重监测和分析海水中含有的放射性物质，包括氚、碳-14、铯-134和铯-137等数据。**



```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract OceanEnvironmentMonitoring {


    /* ==================== Events ==================== */

    /* 
     * @dev 添加监测数据事件
     * @param _locationId       监测地点ID
     * @param _locationInfo     监测地点信息
    */
    event AddLocation(
        uint256 indexed  _locationId,
        LocationInfo _locationInfo
    );

    /* 
     * @dev 添加监测数据事件
     * @param _locationId       监测地点ID
     * @param _optDate          操作时间
     * @param _datetime         海水监测时间
     * @param _measurementInfo  监测数据
    */
    event AddMeasurement(
        uint256 indexed _locationId,
        uint256 indexed _optDate,
        uint256 indexed _datetime,
        MeasurementInfo _measurementInfo
    );

    /* ==================== Stucts ==================== */
  
    /*
    * @dev 监测海水地点
    */
    struct LocationInfo {
        string name;        // 监测地点
        string description; // 描述，如监测经纬度等
    }
    /*
    * @dev 海水中含有的放射性物质结构体（仅提供极少数据）
    */
    struct RadioactiveMaterialInfo {
        string T;       // 氚
        string C14;     // 碳-14
        string Cs134;   // 铯-134和铯-137
        string Cs137;   // 铯-137
    }

    /*
    * @dev 海洋监测数据信息
    */
    struct MeasurementInfo {
        string physics;             // 物理特性，如温度、温差、温层、温度变化、浊度、溶解氧含量、盐度、潮汐变化等
        string chemical;            // 化学特性，如氨氮、磷酸盐、亚硝酸盐、氟化物、镁、钙、氯化物、有机碳和重金属等
        string biological;          // 生物特性，如浮游植物、浮游动物、底栖动物、鱼类等生物种类及其数量的监测
        string energy;              // 能量特性，主要指的是海洋水体中的大气热量、太阳辐射、波浪能量等
        RadioactiveMaterialInfo rm; // 放射性物质
    }

    /* ==================== State Variables ==================== */

    address public owner;           // 合约管理员账户地址
    uint256[] locationList;         // 监测地点列表
    mapping(uint256 => LocationInfo) locations;         // 监测地点ID对应的地点数据
    mapping(uint256 => uint256[]) datetimes;            // 监测地点ID对应所有的监没时间
    mapping(uint256 => mapping(uint256 => MeasurementInfo)) measurements;   // 监测地点对应监测时间对应的监测值

    /* ==================== Modifiers ==================== */

    /* 
     * @dev 仅合同管理员调用
    */
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function.");
        _;
    }

    /* ==================== Constructor ==================== */

    constructor() {
        owner = msg.sender;
    }

    /* ==================== External Functions ==================== */

    /* 
     * @dev 添加监测地点
     * @notice 仅管理员可以操作
     * @param _locationId     监测地点ID
     * @param _locationInfo   监测地点数据
    */
    function addLocation(
        uint256 _locationId, 
        LocationInfo memory _locationInfo
    ) external onlyOwner {
        locationList.push(_locationId);
        locations[_locationId] = _locationInfo;

        emit AddLocation(_locationId, _locationInfo);
    }

    /* 
     * @dev 添加监测数据
     * @notice 仅管理员可以操作
     * @param _locationId   监测地点ID
     * @param _datetime     监测时间
     * @param _physics      物理特性
     * @param _chemical     化学特性
     * @param _biological   生物特性
     * @param _energy       能量特性
     * @param _rm           放射性物质
    */
    function addMeasurement(
        uint256 _locationId,
        uint256 _datetime,
        string memory _physics,
        string memory _chemical,
        string memory _biological,
        string memory _energy,
        RadioactiveMaterialInfo memory _rm
    ) external onlyOwner {
        
        MeasurementInfo memory _measurement = MeasurementInfo(
            _physics,
            _chemical,
            _biological,
            _energy,
            _rm
        );

        // 记录监测时间及监测数据
        datetimes[_locationId].push(_datetime);
        measurements[_locationId][_datetime] = _measurement;

        emit AddMeasurement(
            _locationId,
            block.timestamp,
            _datetime,
            _measurement
        );
    }

    /* 
     * @dev 获取所有监测地点
     * @return uint256[]  监测地点ID列表
    */
    function getLocationList() external view returns (uint256[] memory) {
        return locationList;
    }

    /* 
     * @dev 获取监测地点信息
     * @param _locationId    监测地点ID
     * @return LocationInfo  监测地点信息
    */
    function getLocationInfo(uint256 _locationId) external view returns (LocationInfo memory) {
        return locations[_locationId];
    }

    /* 
     * @dev 获取某监测地点所有监测时间数据
     * @param _locationId   监测地点ID
     * @return uint256[]    监测时间列表
    */
    function getDataTimeListByLocationId(uint256 _locationId) external view returns (uint256[] memory) {
        return datetimes[_locationId];
    }

    /* 
     * @dev 根据监测日期获取监测数据详情
     * @param _locationId       监测地点ID
     * @param _datetime         监测时间
     * @return MeasurementInfo  监测数据详情
    */
    function getMeasurementInfo(
        uint256 _locationId, 
        uint256 _datetime
    ) external view returns (MeasurementInfo memory) {
        return measurements[_locationId][_datetime];
    }

    /* 
     * @dev 获取监测次数
     * @param _locationId   监测地点ID
     * @return uint256      监测次数
    */
    function getMeasurementCount(uint256 _locationId) external view returns (uint256) {
        return datetimes[_locationId].length;
    }
}
```
