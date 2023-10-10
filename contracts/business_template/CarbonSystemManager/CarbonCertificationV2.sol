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
    * @dev 
    
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
    * @dev 监控部门审核企业上传的资质
    * @param _enterpriseAddr 企业的账户地址
    * @param _emissionLimit 企业的审批通过下发的额度
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


    // 不确定
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