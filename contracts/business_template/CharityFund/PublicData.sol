pragma solidity ^0.4.25;
pragma experimental ABIEncoderV2;

contract PublicData {
    
    // 公益溯源结构体 
    struct CharityRecord {
        uint256       recordId;        // 公益历史ID
        uint256       recordAmount;    // 公益金额
        uint256       overAmount;      // 已完成金额
        address       srcUser;         // 公益发起人
        string        descCharitable;  // 公益去向
        address       recordOrg;       // 公益机构
        CharityStatus recordStatus;    // 公益状态
        uint256       recordTime;      // 公益时间
        address[]     users;           // 所有捐赠人地址
    }

    // 链上交易历史记录
    struct Transaction {
        uint256     transactionId;      // 交易ID
        string      transactionTitle;   // 交易订单名称
        address     orgAddress;         // 机构名称
        address     descAddress;        // 目的地址
        string      meterialName;       // 物资名称
        bool        isTransport;        // 是否物流
        TransacStatus  transacStatus;   // 溯源状态
        address[]   sources;            // 所有的溯源地址
    }
    
    
    // 申请集资
    struct Material{
        uint256 meteriaId;          // 申请物资ID
        string  meterialdesc;       // 申请物资描述
        address srcAddress;         // 申请地址
        address orgAddress;         // 代理机构地址
        string[] meterialNames;     // 所有物资
    }

    // 公益溯源记录ID
    uint256 recordCount;   
    
    // 交易历史记录ID
    uint256 transactionCount;
    
    // 物资订单ID
    uint256 materialCount;
    
    // 链上所有的交易记录集合
    uint256[] transactions;
    
    // 所有的公益溯源记录集合
    uint256[] chatityRecords;

    // 所有物资清单的详细ID
    uint256[] meterials;
    
    // ID映射公益溯源的详细信息
    mapping(uint256 => CharityRecord) public recordMap;    
    
    // ID映射交易记录的详细信息
    mapping(uint256 => Transaction) public transactionMap;
 
    // ID映射物资清单详细信息
    mapping(uint256 => Material) public meterialMap;  
    
    // 公益溯源的状态
    // CROWDFUNDING 募资中
    // FINISHED     已完成
    // ERROR        异常
    enum CharityStatus {CROWDFUNDING,FINISHED,ERROR}
    
    // 供应链交易状态 
    // SHIPMENT  出货
    // LOGISTICS 物流 
    // SIGNFOR   签收
    enum TransacStatus {SHIPMENT,LOGISTICS,SIGNFOR}

    // 一级限额
    uint256 constant LEVEL_ONE_LIMIT = 50000;
    // 二级限额
    uint256 constant LEVEL_TWO_LIMIT = 100000;
    // 三级限额
    uint256 constant LEVEL_THREE_LIMIT = 200000;
    
    // 用户提升等级的要求  
    // 公益慈善捐赠次数为50次
    uint256 constant COUNT_TO_TWO = 20;
    // 公益慈善捐赠次数为100次
    uint256 constant COUNT_TO_THREE = 50;
    // 用户注册事件
    event Registered(address indexed _address);
    // 用户申请公益
    event RaiseFunds(address indexed _address,string _meterial);
    // 用户签收事件
    event SigneFor(address indexed _address,uint256 indexed _transaionId);
    // 用户捐赠物资事件
    event DonatedMaterial(address indexed _src,address indexed _desc,string _material);
    // 用户公益捐款事件
    event Donate(address indexed _src,address indexed _desc,uint256 indexed _amount);
    // 用户发起公益捐款事件
    event Initiate(address indexed _address,uint256 _recordId);
    // 用户取钱事件
    event Withdraw(address indexed _address,uint256 _amount);
    // 用户更新公益活动记录
    event UpdateRecordPage(address indexed _address);
    // 物流运输事件
    event Dispathed(address indexed _address,uint256 indexed _transaionId);
    
    // 查询用户的公益记录
    function queryUserRecordInfo(uint256 _recordId) public view returns(CharityRecord memory){
        return recordMap[_recordId];
    }
    
    
    // 查询所有的交易记录 
    function queryTransactionsList() public view returns(uint256[]){
        return transactions;
    }
    
    // 查询交易的的详细记录
    function queryTransactionsInfo(uint256 _transaionId) public view returns(Transaction memory){
        return transactionMap[_transaionId];
    }
    
    // 查询所有申请物资的清单
    function queryMeterialList() public returns(Material[] memory){
        Material[] memory meterialArr = new Material[](meterials.length);
        for (uint i = 0; i < meterials.length; ++i){
            meterialArr[i] = meterialMap[meterials[i]];
        }
        return meterialArr;
    }   
}