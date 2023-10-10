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
    
    
    
    function queryEnterprisesLength() public view returns(uint256){
        return enterpriseList.length;
    }
    
    function queryRegulatorsLength() public view returns(uint256){
        return regulatorList.length;
    }
    
    function queryTransactionsLength() public view returns(uint256){
        return transactionList.length;
    }
    
    function queryEmissionResourcesLength() public view returns(uint256){
        return emissionResources.length;
    }
    
    function queryEAssetsLength() public view returns(uint256){
        return eassets.length;
    }

    function initA() public {
        registerEnterprise(0xb33aa9beb22eb99ecf07ccf504c5bb722a6eabd1,"天虹科技");
        qualificationUpload("测试A","测试A");
    }

    function initB() public {
        registerEnterprise(0xe899c3d457196fb9370ddb7f9c7ec197df5d10df,"弘安科技");
        qualificationUpload("测试B","测试B");
    }
    
    function initC() public {
        registerEnterprise(0xff20ff1a1a30b8e07d6cf679166eee8d023b4519,"天湖科技");
        qualificationUpload("测试C","测试C");
    }
    
    function initO() public {
        registerRegulator(msg.sender,"监管机构");
        verifyQualification(0xb33aa9beb22eb99ecf07ccf504c5bb722a6eabd1,true);
        verifyQualification(0xe899c3d457196fb9370ddb7f9c7ec197df5d10df,true);
        verifyQualification(0xff20ff1a1a30b8e07d6cf679166eee8d023b4519,true);
    }
    
    
    // 测试代码
    function initACAS() public  {
        updateEnterpriseEmission(msg.sender,25000);
        updateBalance(msg.sender,10000);
        enterpriseEmissionUpload(msg.sender,1000,"绿色排放");
    }
    
    
    function initBCAS() public {
        updateEnterpriseEmission(msg.sender,20000);
        updateBalance(msg.sender,10000);
        enterpriseEmissionUpload(msg.sender,1000,"绿色排放");
    }
    
    function initCCAS() public {
        updateEnterpriseEmission(msg.sender,18000);
        updateBalance(msg.sender,10000);
        enterpriseEmissionUpload(msg.sender,1000,"绿色排放");
    }
    
    

    
}