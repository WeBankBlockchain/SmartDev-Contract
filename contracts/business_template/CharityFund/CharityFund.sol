pragma solidity ^0.4.25;
pragma experimental ABIEncoderV2;

import "./CharityOrg.sol";
import "./CharityLogistics.sol";
import "./PublicData.sol";
import "./RolesAuth.sol";
import "./SafeMath.sol";

contract CharityFund is PublicData,CharityOrg,CharityLogistics{
    
    RolesAuth rolesAuth;
    using SafeMath for *;

    // 用户的结构体
    struct User {
        uint256 userId;          // 用户ID
        string  userName;        // 用户名称
        address userAddress;     // 用户地址
        uint256 userAmount;      // 用户的余额
        Level userLevel;         // 用户的等级
        uint256 userCount;       // 用户的捐献次数
        int     status;          // 用户的状态
        uint256[] donorList;     // 捐赠的历史记录ID
        uint256[] materialList;  // 捐赠物资交易记录ID
        uint256[] recordList;    // 集资历史记录ID
    }
    

    // 捐赠人结构体
    struct Donor {
        uint256 donorId;         // 捐赠ID
        uint256 donorAmount;     // 捐赠的金额
        address donorAddress;    // 捐赠人地址
        address donorToAddress;  // 捐赠的对方地址
        address donorToOrg;      // 捐赠的机构
        uint256 donorTime;       // 捐赠的时间
    }

    
    
    // 用户的ID
    uint256 userCount;
    
    // 捐赠记录ID
    uint256 donorCount;

    // 所有用户的地址记录
    address[] users;
    
    // 所有捐赠人的记录ID
    uint256[] dornors;
    
    
    // 地址映射用户详细信息
    mapping(address => User) userMap;
    // ID映射捐赠人的详细信息
    mapping(uint256 => Donor) donorMap;

    
    // 用户的等级枚举 注册默认为等级一 一级可发起公益最高5W 二级10W 三级 20W
    enum Level {LEVEL_ONE,LEVEL_TWO,LEVEL_THREE}

    // 修饰符函数
    modifier _AuthUser {
        require(rolesAuth.hasUser(msg.sender),"没有权限");
        _;
    }
   
    constructor() public {
        registerOrg("慈善机构");
        rolesAuth = new RolesAuth();
    }
    
    // 注册用户
    function registerUser(string memory _userName) public returns(User memory){
        require(userMap[msg.sender].status == 0,"当前用户已经注册");
        userCount++;
        uint256 _userId = userCount;
        User storage _user = userMap[msg.sender];
        _user.userId = _userId;
        _user.userName = _userName;
        _user.userAddress = msg.sender;
        _user.userAmount = 0;
        _user.userLevel = Level.LEVEL_ONE;
        _user.userCount = 0;
        _user.status = 1;
        
        rolesAuth.addUser(msg.sender);
        emit Registered(msg.sender);
        return _user;
    }
    
    /**
     * @dev 通过用户自发进行物资捐赠，向指定机构筹集公益物资
     * @param _orgAddress 指定机构的地址
     * @param _materDesc 捐赠物资的描述信息
     * @return 申请物资记录信息
    **/
    function raiseFunds(address _orgAddress,string memory _materDesc) public _AuthUser returns(Material){
        
        materialCount++;
        uint256 _materialId = materialCount;
        Material storage _material = meterialMap[_materialId];
        _material.meteriaId = _materialId;
        _material.meterialdesc  = _materDesc;
        _material.srcAddress = msg.sender;
        _material.orgAddress = _orgAddress;
        
        meterials.push(_materialId);
        userMap[msg.sender].materialList.push(_materialId);
        orgMap[_orgAddress].meterials.push(_materialId);
        emit RaiseFunds(msg.sender,_materDesc);
        return _material;
    }
    
    /**
     * 
     * @dev 用户签收指定交易下的捐赠物资，并更新相关的物流状态
     * @param _transactionId 待签收物资所属的交易ID
     * @param _meterialId 待签收的物资ID
     * 
    **/
    function signedGoods(uint256 _transactionId,uint256 _meterialId) public _AuthUser {
        Transaction storage _transaction = transactionMap[_transactionId];
        require(_transaction.transacStatus == TransacStatus.LOGISTICS,"当前物资未更新物流状态");
        _transaction.transacStatus = TransacStatus.SIGNFOR;
        _transaction.sources.push(msg.sender);
        // 更新当前的用户的物资
        meterialMap[_meterialId].meterialNames.push(_transaction.meterialName);
        emit SigneFor(msg.sender,_transactionId);
    }
    
    
    /**
     * @dev 用户进行个人物资捐赠，并创建对应的物资捐赠交易记录
     * @param _orgAddress 捐赠的物资所属机构的地址
     * @param _toAddress 捐赠的物资目标地址
     * @param _meterName 捐赠物资名称
     * @param _isTransaport 是否需要运输：true-需要；false-不需要
     * @return 捐赠记录信息
    **/
    function donatedMaterial(address _orgAddress,address _toAddress,string memory _meterName,bool _isTransaport) public _AuthUser returns(Transaction){
        transactionCount++;
        uint256 _transactionId = transactionCount;
        Transaction storage _transaction = transactionMap[_transactionId];
        _transaction.transactionId = _transactionId;
        _transaction.transactionTitle = "物资捐赠";
        _transaction.orgAddress = _orgAddress;
        _transaction.descAddress = _toAddress;
        _transaction.meterialName = _meterName;
        _transaction.isTransport = _isTransaport;
        _transaction.transacStatus = TransacStatus.SHIPMENT;
        _transaction.sources.push(msg.sender);
        _transaction.sources.push(_orgAddress);
        
        userMap[msg.sender].userCount++;
        transactions.push(_transactionId);
        orgMap[_orgAddress].transactions.push(_transactionId);
        emit DonatedMaterial(msg.sender,_toAddress,_meterName);
        return _transaction;
    }
    
    
    /**
     * @dev 用户进行个人金额捐赠，并创建对应的捐赠记录
     * @param _orgAddress 捐赠的公益慈善所属机构的地址
     * @param _toAddress 捐赠目标地址
     * @param _recordId 公益慈善记录 ID
     * @param _toAmount 捐赠的金额
     * @return 捐赠人的信息信息
    **/
    function donate(address _orgAddress ,address _toAddress,uint256 _recordId,uint256 _toAmount) public _AuthUser returns(Donor){
        // 判断当前的用户是否存在 
        require(userMap[msg.sender].status != 0,"当前用户未注册");
        // 判断当前的用户是否有足够的金额捐赠
        require(userMap[msg.sender].userAmount >= _toAmount,"当前账户余额不足");
        // 对用户的账户进行计算
        require(recordMap[_recordId].recordStatus == CharityStatus.CROWDFUNDING,"暂无公益捐赠");
        CharityRecord storage _charityRecord = recordMap[_recordId];
        uint256 finishAmount = SafeMath.add(_charityRecord.overAmount,_toAmount);
        if (_charityRecord.overAmount == _charityRecord.recordAmount || finishAmount > _charityRecord.recordAmount){
            revert("当前公益慈善已完成");
        }
        if (checkOrgIsIn(_orgAddress)){
            donorCount++;
            uint256 _donorId = donorCount;
            Donor storage _donor = donorMap[_donorId];
            _donor.donorId = _donorId;
            _donor.donorAmount = _toAmount;
            _donor.donorAddress = msg.sender;
            _donor.donorToAddress = _toAddress;
            _donor.donorToOrg = _orgAddress;
            _donor.donorTime = block.timestamp;
            // 更新用户的捐赠记录 
            userMap[msg.sender].donorList.push(_donorId);
            userMap[msg.sender].userCount++;
            if (_charityRecord.recordStatus == CharityStatus.CROWDFUNDING) {
                _charityRecord.overAmount = SafeMath.add(_charityRecord.overAmount,_toAmount);
                _charityRecord.users.push(msg.sender);
                // 更新机构的金额
                orgMap[_orgAddress].orgAmount = SafeMath.add(orgMap[_orgAddress].orgAmount,_toAmount);
            }
            
            emit Donate(msg.sender,_toAddress,_toAmount);
            return _donor;
        }
    }
    
    
    /**
     * @dev 用户发起公益慈善项目，并新增该项目的记录信息到平台
     * @param _orgAddress 公益慈善所属机构的地址
     * @param _amount 公益慈善筹款目标金额
     * @param _desc 公益慈善项目的描述信息
     * @return 发起公益慈善记录信息
    **/
    function initiate(address _orgAddress,uint256 _amount,string _desc) public _AuthUser returns(CharityRecord) {
        // 判断当前的用户是否存在 
        require(userMap[msg.sender].status != 0,"当前用户未注册");
        // 确认是否达到用户捐款等级的限制
        checkLimitForInitiate(_amount);
        // 新增公益记录，并设置其属性
        recordCount++;
        uint256 _recordId = recordCount;  
        CharityRecord storage _charityRecord = recordMap[_recordId];
        _charityRecord.recordId = _recordId;
        _charityRecord.recordAmount = _amount;
        _charityRecord.overAmount = 0;
        _charityRecord.srcUser = msg.sender;
        _charityRecord.descCharitable = _desc;
        _charityRecord.recordOrg =_orgAddress;
        _charityRecord.recordTime = block.timestamp;
        _charityRecord.recordStatus = CharityStatus.CROWDFUNDING;
        
        chatityRecords.push(_recordId);
        userMap[msg.sender].recordList.push(_recordId);
        orgMap[_orgAddress].recordIds.push(_recordId);
        emit Initiate(msg.sender,_recordId);
        return _charityRecord;
    }
    
    /**
     * @dev 确认发起公益时是否达到用户捐款等级的限制
     * @param _amount 用户在本次发起公益捐赠时选择的筹资金额
    **/
    function checkLimitForInitiate(uint256 _amount) private view {
        Level _level = queryUserLevel(msg.sender);
        uint256 _levelLimit;
        if (_level == Level.LEVEL_ONE) {
            _levelLimit = LEVEL_ONE_LIMIT;
        } else if (_level == Level.LEVEL_TWO) {
            _levelLimit = LEVEL_TWO_LIMIT;
        } else if (_level == Level.LEVEL_THREE) {
            _levelLimit = LEVEL_THREE_LIMIT;
        }
        require(_amount <= _levelLimit, "发起公益捐款金额超过等级限制");
    }
    
    
    /**
     * @dev 用户通过查询指定机构的公益项目情况，然后进行取款操作
     * @param _orgAddress 机构所属地址
     * @param _recordId 需要提取资金的公益慈善记录 ID
     * @param _amount 需要提取的资金数量
     * @return (int256, address) 若成功提取资金，则返回状态码 0 及用户地址；否则返回错误状态码 -1 和空地址
    **/
    function withdraw(address _orgAddress,uint256 _recordId,uint256 _amount) public _AuthUser returns(int256,address){
        require(checkOrgIsIn(_orgAddress) == true,"当前的机构不存在");
        // 查询当前的Record记录是否存在当前的地址
        CharityRecord memory _charityRecord = recordMap[_recordId];
        if (_charityRecord.recordStatus == CharityStatus.ERROR){
            revert("当前的公益状态异常");
        }
        if (_charityRecord.srcUser == msg.sender && _charityRecord.recordOrg == _orgAddress){
            userMap[msg.sender].userAmount = SafeMath.add(userMap[msg.sender].userAmount,_amount);
            orgMap[_orgAddress].orgAmount = SafeMath.sub(orgMap[_orgAddress].orgAmount,_amount);
            emit Withdraw(msg.sender,_amount);
            return (0,msg.sender);
        }else {
            return (-1,address(0));
        }

    }
    
    
    // 用户查看当前的进度 更新所有的公益溯源变为已完成  后端使用定时器进行自动流
    function updateRecordPage() public {
        User memory _user = userMap[msg.sender];
        uint256[] memory recordListArr = new uint256[](_user.recordList.length);
        for (uint i = 0; i < chatityRecords.length; ++i){
            require(_user.recordList.length > 0,"当前用户没有公益记录");
            if (recordMap[chatityRecords[i]].recordId == _user.recordList[i]){
                recordListArr[i] = _user.recordList[i];
            }
        }
        for(uint j = 0; j < recordListArr.length;++j){
            if (recordMap[recordListArr[j]].overAmount == recordMap[recordListArr[j]].recordAmount){
                recordMap[recordListArr[j]].recordStatus = CharityStatus.FINISHED;
            }
        }
        emit UpdateRecordPage(msg.sender);
    }
        
    
    
    // 用户刷新自己的等级
    function refreshLevel() public _AuthUser {
        require(userMap[msg.sender].status != 0,"当前的用户不存在");
        User storage _user = userMap[msg.sender];
        if (queryUserCount(msg.sender) == COUNT_TO_TWO){
            _user.userLevel = Level.LEVEL_TWO;
        }
        if (queryUserCount(msg.sender) == COUNT_TO_THREE){
            _user.userLevel = Level.LEVEL_THREE;
        }
    }
    
    
    /**
     * @dev 分页查询当前用户的捐赠记录
     * @param _page 需要查询的页数，从 1 开始计数
     * @param _pageSize 每页需要返回的记录数量
     * @return Donor[] 返回指定页码及每页数量的捐赠记录数组
    **/
    function queryUserDonorPage(uint256 _page,uint256 _pageSize) public  returns(Donor[]){
        User memory _user = userMap[msg.sender];
        require(_user.donorList.length != 0,"当前没有捐赠记录");
        require(_page > 0, "页数不能为0");
        uint256 startIndex = (_page - 1) * _pageSize; // 计算起始索引
        uint256 endIndex = startIndex + _pageSize > _user.donorList.length ?  _user.donorList.length : startIndex + _pageSize; // 计算结束索引
        Donor[] memory donorArr = new Donor[](endIndex - startIndex);
        for (uint i = startIndex; i < endIndex; i++){
            donorArr[i - startIndex] = donorMap[_user.donorList[i]];
        }
        return donorArr;
    }
    
    
    /**
     * @dev 分页查询当前用户的公益记录
     * @param _page 需要查询的页数，从 1 开始计数
     * @param _pageSize 每页需要返回的记录数量
     * @return CharityRecord[] 返回指定页码及每页数量的公益记录数组
    **/
    function queryUserRecordPage(uint256 _page,uint256 _pageSize) public  returns(CharityRecord[]){
        User memory _user = userMap[msg.sender];
        require(_user.recordList.length != 0,"当前没有公益记录");
        require(_page > 0, "页数不能为0");        
        uint256 startIndex = (_page -1) * _pageSize;
        uint256 endIndex = startIndex + _pageSize > _user.recordList.length ? _user.recordList.length : startIndex + _pageSize;
        CharityRecord[] memory chatityRecordsArr = new CharityRecord[](endIndex - startIndex);
        for (uint i = startIndex; i < endIndex; i++){
            chatityRecordsArr[i - startIndex] = recordMap[_user.recordList[i]];
        }
        return chatityRecordsArr;
        
    }


    /**
     * @dev 分页查询当前用户的公益物资申请记录
     * @param _page 需要查询的页数，从 1 开始计数
     * @param _pageSize 每页需要返回的记录数量
     * @return Material[] 返回指定页码及每页数量的公益物资申请记录数组
    **/
    function queryUserMeterialPage(uint256 _page,uint256 _pageSize) public returns(Material[]){
        User memory _user = userMap[msg.sender];
        require(_user.materialList.length != 0,"当前没有物资申请记录");
        require(_page > 0, "页数不能为0");        
        uint256 startIndex = (_page -1) * _pageSize;
        uint256 endIndex = startIndex + _pageSize > _user.materialList.length ? _user.materialList.length : startIndex + _pageSize;
        Material[] memory meterialArr = new Material[](endIndex - startIndex);
        for (uint i = startIndex; i < endIndex; i++){
            meterialArr[i - startIndex] = meterialMap[_user.materialList[i]];
        }
        return meterialArr;
        
    }
    

    // 更新用户的余额
    function updateBlance(uint256 _balance) public {
        userMap[msg.sender].userAmount += _balance;
    }
    
    // 查询用户的公益记录
    function queryUserRecordInfo(uint256 _recordId) public view returns(CharityRecord memory){
        return recordMap[_recordId];
        
    }
    
    function queryUserDonorInfo(uint256 _donorId) public view returns(Donor memory){
        return donorMap[_donorId];
    }
    
    // 查看用户的捐赠次数
    function queryUserCount(address _userAddress) internal view returns(uint256){
        return userMap[_userAddress].userCount;
    }
    
    // 查看用户的等级
    function queryUserLevel(address _userAddress) internal view returns(Level){
        return userMap[_userAddress].userLevel;
    }
    // 查询用户的详细信息
    function queryUserInfo() public returns(User memory){
        return userMap[msg.sender];
    }
    
}