// SPDX-License-Identifier: MIT
pragma solidity ^0.4.25;
pragma experimental ABIEncoderV2;


import "./RegulatoryAgency.sol";
import "./LibCryptoHash.sol";
import "./TypeConvertUtil.sol";
import "./RolesAuth.sol";

// 食品结构体，记录食品信息
contract FoodTraceability is RegulatoryAgency {
    
    RolesAuth rolesAuth;
    
    using LibCryptoHash for *;
    using TypeConvertUtil for *;
    
    struct Food {
        uint256 foodId;               // 食品id
        string  foodName;             // 食品名称
        uint256 foodProductionDate;   // 生产日期
        uint256 foodExpirationDate;   // 过期日期
        bytes32 foodTraceabilityCode; // 溯源码
        Status  foodStatus;           // 当前食物状态
        address[] foodTraceabilityHistory; // 食品溯源追溯
    }
    
    // 物流结构体，记录物流信息
    struct Logistics {
        uint256 logisticsId;            // 物流id
        address logisticsAddress;       // 物流公司地址
        uint256 foodId;                 // 食品id
        address logisticsFrom;          // 发货地点   生产厂家的地址
        address logisticsTo;            // 收货地点   收获地址为超市
        uint256 logisticsTransportDate; // 运输日期
        bool    verfalid;               // 确认收货或者拒绝收货
    }
    
    // 生产公司结构体，记录生产公司信息
    struct ProductionCompany {
        uint256 companyId;          // 生产公司id
        string  companyName;        // 生产公司名称
        address companyAddress;     // 生产公司地址
        Food[]  companyfoods;       // 企业生产的食品
    }
    // 物流公司结构体，记录物流公司信息
    struct LogisticCompany {
        uint256 companyId;          // 物流公司id
        string  companyName;        // 物流公司名称
        address companyAddress;     // 物流公司地址
        uint256[] orders;           // 物流订单id
    }
    
    // 超市结构体，记录超市信息
    struct Supermarket {
        uint256 supermarketId;       // 超市id
        string  supermarketName;     // 超市名称
        address supermarketLocation; // 超市地址
        Food[]  foodList;            // 超市出售的食物
    }
    
    
    // 分别定义: 0生产中，1运输中，2已收货，3出售中
    enum Status {PRODUCTION,INTRANSIT,RECEIPT,UNDERSALE}
    
    // 所有的ID
    uint256 private foodCount;
    uint256 private logisticsCount;
    uint256 private productionCompanyCount;
    uint256 private supermarketCount;
    uint256 private logisticCompanyCount;
    uint256 public  reportCount;
    
    Levels L3 = Levels.TWO_LEVEL;
    Levels L4 = Levels.THREE_LEVEL;
    Levels L5 = Levels.FOUR_LEVEL;
    
    
    // 食物集合
    Food[] private foodList;
    // 物流订单信息
    Logistics[] private logisticsList;
    // 生产公司集合
    ProductionCompany[] private productionCompanyList;
    // 超市集合
    Supermarket[] private supermarketList;
    // 物流公司集合
    LogisticCompany[] private LogisticCompanyList;
    
    
    // 定义一个 mapping 存储食品信息
    mapping(uint256 => Food) private foodMap;
    // 定义一个 mapping 存储食品报告信息
    mapping(uint256 => Report) private foodIdToReportMap;
    // 定义一个 mapping 存储食物Id对应的报告 
    mapping(bytes32 => address[]) private foodTraceabilityHistoryMap;
    // 定义一个 mapping 存储物流信息
    mapping(uint256 => Logistics) private logisticsMap;
    // 定义一个 mapping 存储生产公司信息
    mapping(address => ProductionCompany) private productionCompaniesMap;
    // 定义一个 mapping 存储物流公司信息
    mapping(address => LogisticCompany) private logisticCompanyMap;
    // 定义一个 mapping 存储超市信息
    mapping(address => Supermarket) private supermarketsMap;

    
    
    // 初始化一个食品监管机构
    constructor(){
        registerRegulator("食品安全监管机构");
        rolesAuth = new RolesAuth();
    }
    
    // 修饰符函数
    modifier AuthPCompany {
        require(rolesAuth.hasPCompanyRole(msg.sender),"没有权限");
        _;
    }
    // 修饰符函数    
    modifier AuthLCompany {
        require(rolesAuth.hasLCompanyRole(msg.sender),"没有权限");
        _;
    }
    // 修饰符函数    
    modifier AuthSupermaket {
        require(rolesAuth.hasSupermaketRole(msg.sender),"没有权限");
        _;
    }
    
    // 定义一个函数用于注册生产公司
    function registerCompany(string memory _companyName) public {
        require(productionCompaniesMap[msg.sender].companyId == 0,"当前企业已经注册");
        productionCompanyCount++;
        uint256 _companyId = productionCompanyCount;
        ProductionCompany storage _company = productionCompaniesMap[msg.sender];
        _company.companyId = _companyId;
        _company.companyName = _companyName;
        _company.companyAddress = msg.sender;
        productionCompanyList.push(_company);
        // 添加默认角色权限
        rolesAuth.addPCompanyRole(msg.sender);
        emit Registered(msg.sender,_companyName);
    }
    
    
    // 定义一个函数用于注册物流公司
    function registerLogisticsCompany(string memory _companyName) public {
        logisticCompanyCount++;
        uint256 logisticId = logisticCompanyCount;
        LogisticCompany storage _company = logisticCompanyMap[msg.sender];
        _company.companyId = logisticId;
        _company.companyName = _companyName;
        _company.companyAddress = msg.sender;
        LogisticCompanyList.push(_company);
        // 添加默认角色权限
        rolesAuth.addLCompanyRole(msg.sender);
        emit Registered(msg.sender,_companyName);
    }
    
    
    // 定义一个函数用于注册超市
    function registerSupermarket(string memory _supermarketName) public {
        require(supermarketsMap[msg.sender].supermarketId == 0,"当前的超市已经注册");
        supermarketCount++;
        uint256 supermarketId = supermarketCount;
        Supermarket storage _supermarket = supermarketsMap[msg.sender];
        _supermarket.supermarketId = supermarketId;
        _supermarket.supermarketName = _supermarketName;
        _supermarket.supermarketLocation = msg.sender;
        supermarketList.push(_supermarket);
        // 添加角色默认权限
        rolesAuth.addSupermaketRole(msg.sender);
        emit Registered(msg.sender,_supermarketName);
    }

    /*
     * @dev 定义一个函数用于添加新的食品信息
     */ 
    function productFood(address _companyAddress,string memory _foodName) public AuthPCompany {
        foodCount++;
        uint256 foodId = foodCount;
        bytes32 result = generateTraceabilityCode(foodId);
        Food storage _food = foodMap[foodId];
        _food.foodId = foodId;
        _food.foodName = _foodName;
        _food.foodProductionDate = block.timestamp;
        _food.foodExpirationDate = block.timestamp + 6 * 1 weeks;
        _food.foodTraceabilityCode = result;
        _food.foodStatus = Status.PRODUCTION;
        _food.foodTraceabilityHistory.push(_companyAddress);
        foodList.push(_food);
        
        ProductionCompany storage product = productionCompaniesMap[_companyAddress];
        product.companyfoods.push(_food);
        foodTraceabilityHistoryMap[result].push(_companyAddress);
        emit AddFood(_companyAddress,foodId);
    }
    
    
    // 监管部门需要确认食品是否合格 3级以下不给出售 // 只有监管部门能操作
    function healthReport(uint256 _foodId,string memory _reportName,Levels _reportLevel) public returns(int){
        reportCount++;
        uint256 reportId = reportCount;
        Regulator storage _regulator = regulatorMap[msg.sender];
        Report storage _report = reportMap[reportId];
        Food storage _food = foodMap[_foodId]; 
        if (_food.foodId == _foodId){
            _report.reportId = reportId;
            _report.reportName = _reportName;                                                         
            _report.healthLevel = _reportLevel;
            _report.foodName = _food.foodName;
            _regulator.reportList.push(_report);
            foodIdToReportMap[_foodId] = _report;
            emit MakeReport(msg.sender,reportId);
            return 0;
        }
        return -1;
        
    }

    // 定义一个函数用于食品的物流信息
    function addLogistics(address _logisticsAddress,uint256 foodId, address _from, address _to) public AuthLCompany{
        Food storage _food = foodMap[foodId];
        Report memory report = queryFoodReport(foodId);
        // 判断食品是否状态正常 食品是否合格
	    require(_food.foodStatus == Status.PRODUCTION,"当前的食品状态异常");
	    require(report.healthLevel == L3 || report.healthLevel == L4 || report.healthLevel == L5,"当前的食品不合格");
	    logisticsCount++;
	    uint256 _logisticsId = logisticsCount;
	    // 新建物流订单
	    Logistics storage _logistics = logisticsMap[_logisticsId];
	    _logistics.logisticsId = _logisticsId;
	    _logistics.foodId = foodId;
	    _logistics.logisticsAddress = _logisticsAddress;
	    _logistics.logisticsFrom = _from;
	    _logistics.logisticsTo = _to;
	    _logistics.logisticsTransportDate = block.timestamp;
	    _logistics.verfalid = false;
	    
	    // 修改食品的状态
	    _food.foodStatus = Status.INTRANSIT;
	    _food.foodTraceabilityHistory.push(_logisticsAddress);
	    // 添加物流信息
	    logisticCompanyMap[_logisticsAddress].orders.push(_logisticsId);
	    logisticsList.push(_logistics);
	    
	    emit AddLogistic(_logisticsAddress,_logisticsId);
    }
    
    // 超市收货签收
    // 超市收获需要确认订单的Id，是否拒收等
    function signature(uint256 _logisticsId,bool _isApporve) public AuthSupermaket returns(int){
        // 确认签收
        if (_isApporve){
            Logistics storage _logisticOrder = logisticsMap[_logisticsId];
            Supermarket storage _supermarket = supermarketsMap[msg.sender];
            Food storage _food = foodMap[_logisticOrder.foodId];
            require(_supermarket.supermarketId != 0,"当前超市未注册");
            require(_logisticOrder.verfalid == false,"当前订单已签收，无需再签收");
            require(_food.foodStatus == Status.INTRANSIT,"当前物流异常");
            if (_logisticOrder.logisticsTo == msg.sender){
                _food.foodStatus = Status.RECEIPT;
                _food.foodTraceabilityHistory.push(msg.sender);
                _logisticOrder.verfalid = true;
                emit Receipt(msg.sender,_logisticsId);
            }
            // 这么返回是用来后端接收的
            return 0;
        }
        return -1;
    }
    
    
    // 超市出售当前的食物
    function sellFood(uint256 _foodId) public AuthSupermaket {
        Supermarket storage _supermarket = supermarketsMap[msg.sender];
        Food storage _food = foodMap[_foodId];
        require(_food.foodStatus == Status.RECEIPT,"当前的食品还未签收");
        _food.foodStatus = Status.UNDERSALE;
        _supermarket.foodList.push(foodMap[_foodId]);
    }
    
    
    // 查询物流公司的所有订单详细
    function queryLogisticCompanyOrdersInfo(address _LogisticsAddress) public returns(Logistics[] memory){
        LogisticCompany memory _logisticCompany = logisticCompanyMap[_LogisticsAddress];
        Logistics[] memory logisticsList = new Logistics[](_logisticCompany.orders.length);
        for (uint i = 0;i < _logisticCompany.orders.length; ++i){
            logisticsList[i] = logisticsMap[_logisticCompany.orders[i]];
        }
        return logisticsList;
    }
    
	
	// 查询生产公司的详细信息
    function queryProductionCompanyInfo(address _companyAddress) public returns(ProductionCompany memory){
        return productionCompaniesMap[_companyAddress];
    }
    
    // 查询物流公司的详细信息
    function queryLogisticCompanyInfo(address _companyAddress) public returns(LogisticCompany memory){
        return logisticCompanyMap[_companyAddress];
    }
    
    // 定义一个函数用于记录食品的流通环节信息
    function queryLogisticsInfo(uint256 _logisticsId) public returns(Logistics memory) {
        return logisticsMap[_logisticsId];
    }
    
    
        // 查询食品的报告
    function queryFoodReport(uint256 _foodId) public view returns(Report memory){
        return foodIdToReportMap[_foodId];
    }
    
    // 定义一个函数用于生成食品的溯源码
    function generateTraceabilityCode(uint256 foodId) public returns(bytes32) {
        return LibCryptoHash.getSha256(TypeConvertUtil.uintToString(foodId));
    }
    
    // 定义一个函数用于查询食品的溯源信息
    function queryFoodTraceabilityInfo(uint256 _foodId) public returns(address[] memory){
        return foodMap[_foodId].foodTraceabilityHistory;
    }
    
    // 查询食品的详细信息
    function queryFoodInfo(uint256 _foodId) public view returns(Food memory){
        return foodMap[_foodId];
    }
    
    // 查询食品的溯源码
    function queryFoodTraceabilityCode(uint256 _foodId) public view returns(bytes32){
        return foodMap[_foodId].foodTraceabilityCode;
    }
    
    // 查询超市的详细信息
    function querySupermarketInfo(address _supermarketAddress) public returns(Supermarket memory){
        return supermarketsMap[_supermarketAddress];
    }
}
