pragma solidity ^0.6.10;
pragma experimental ABIEncoderV2;

/**
 * @title 时间银行主合约 
 * @notice 
 */

import "./ServiceInfo.sol";

contract TimeBankManager {

    // 时间银行管理地址
    address _timeBank;

    uint256 serviceCount;
    uint256 recordCount;

    // 用户结构体
    struct User {
        string name;
        address userAddress;
        uint256[] timeservices;
        uint256[] exchanges;

    }

    // 交换记录
    struct ExchangeRecord {
        uint256 recordId;
        address from;
        address to;
        address fromServiceAddress;
        address toServiceAddress;
        uint256 time;
    }

    // 所有时间服务的地址
    address[] services;

    // 服务的ID映射时间服务的合约地址
    mapping (uint256=>address) serviceIdToAddress;

    // 用户地址映射用户信息
    mapping (address=>User) userMap;

    // 记录ID映射记录信息
    mapping (uint256=>ExchangeRecord) recordMap;

    
    // 用户注册事件
    event Registered(address indexed,uint256 indexed);
    // 时间服务交换
    event TradeForService(address indexed,address indexed,uint256 indexed);


    constructor() public {
        _timeBank = msg.sender;
    }


    /**
     * 用户注册
     * @param _username 用户名称
     * @param _userAddress  用户地址
     */
    function register(
        string memory _username,
        address _userAddress
    ) public {
        require(userMap[_userAddress].userAddress == address(0),"This user already register");
        User memory _user = User(_username,_userAddress,new uint256[](0),new uint256[](0));
        userMap[_userAddress] = _user; 
        emit Registered(_userAddress,block.timestamp);
    }


    /**
     * 时间存储
     * @param name 时间服务名称
     * @param content 时间服务内容
     * @param owner 时间服务所属者
     * @param time 时间
     */
    function timeStore(
        string memory name,
        string memory content,
        address owner,uint8 time
    ) public {
        serviceCount++;
        uint256 timestamp = time * 1 days;
        // 用户添加服务信息时间进行时间存储
        User storage _user = userMap[owner];
        ServiceInfo serviceInfo = new ServiceInfo(name,content,owner,timestamp);
        
        _user.timeservices.push(serviceCount);
        services.push(address(serviceInfo));

        serviceIdToAddress[serviceCount] = address(serviceInfo);
        
    }

    /**
     * 查询当前的时间服务信息
     * @return _name 时间服务名称
     * @return _content 时间服务内容
     * @return _owner 时间服务所有者
     * @return _timestamp 服务时间
     * @return _status 服务状态
     */
    function getTimeService(uint256 _id) public view returns(
        string memory,
        string memory,
        address,
        uint256,
        ServiceInfo.TimeStatus) 
    {
        return ServiceInfo(serviceIdToAddress[_id]).getServiceInfo();
    }


    /**
     * 查询用户的所有时间服务信息
     * @param _userAddress 用户的地址
     * @return nameList 所有时间服务名称
     * @return contentList 所有时间服务内容
     * @return timeList 所有时间
     */
    function getUserAllService(address _userAddress) public view returns(
        string[] memory,
        string[] memory,
        uint256[] memory
        ){
        require(_userAddress != address(0),"当前的用户地址不能为空");
        uint256[] memory serviceArr = userMap[_userAddress].timeservices;

        address[] memory serviceList = new address[](serviceArr.length);

        string[] memory nameList = new string[](serviceList.length);
        string[] memory contentList = new string[](serviceList.length);
        uint256[] memory timeList = new uint256[](serviceList.length);

        for (uint256 i = 0; i < serviceArr.length; i++) {
            serviceList[i] = serviceIdToAddress[serviceArr[i]];
        }
        for (uint256 j = 0; j < serviceList.length; j++) {
            (
            string memory name,
            string memory content,
            address owner,
            uint256 time,
            ServiceInfo.TimeStatus status) =  ServiceInfo(serviceList[j]).getServiceInfo();
            nameList[j] = name;
            contentList[j] = content;
            timeList[j] = time;
        }
        return (nameList,contentList,timeList);

    }


    /**
     * 服务交换
     * @param _ownerAddress 时间服务所属人地址
     * @param _toAddress  交换的用户地址
     * @param _fromServiceId 所属的时间服务ID
     * @param _toServiceId  交换的用户的时间服务ID
     */
    function tradeForService(
        address _ownerAddress,
        address _toAddress,
        uint256 _fromServiceId,
        uint256 _toServiceId
    ) public  {
        if (userMap[_ownerAddress].userAddress == address(0) || userMap[_toAddress].userAddress == address(0)) {
            revert("当前用户未注册");
        }
        // 初始化记录值
        recordCount++;
        ExchangeRecord storage _ExchangeRecord = recordMap[recordCount];
        _ExchangeRecord.from = _ownerAddress;
        _ExchangeRecord.to = _toAddress;
        _ExchangeRecord.fromServiceAddress = serviceIdToAddress[_fromServiceId];
        _ExchangeRecord.toServiceAddress = serviceIdToAddress[_toServiceId];

        ServiceInfo(serviceIdToAddress[_fromServiceId]).exchangeService(_ownerAddress,_toAddress);
        ServiceInfo(serviceIdToAddress[_toServiceId]).exchangeService(_toAddress, _ownerAddress);

        userMap[_ownerAddress].exchanges.push(recordCount);
        userMap[_toAddress].exchanges.push(recordCount);

        uint256[] memory oservicesList = userMap[_ownerAddress].timeservices;
        uint256[] memory tservicesList = userMap[_toAddress].timeservices;

        for (uint256 i = 0; i < oservicesList.length;i++) {
            if (oservicesList[i] == _fromServiceId) {
                userMap[_ownerAddress].timeservices[i] = _toServiceId;
            }
        }
        for (uint256 j = 0; j < tservicesList.length;j++) {
            if (tservicesList[j] == _toServiceId) {
                userMap[_toAddress].timeservices[j] = _toServiceId;
            }
        }
        emit TradeForService(_ownerAddress,_toAddress,block.timestamp);
    }


    /**
     * 查询服务交换记录
     * @param _recordId 记录ID
     * @return recordId 记录ID
     * @return from 发起交换的用户地址
     * @return to 被交换的用户地址
     * @return fromServiceAddress 发起交换的用户时间服务ID
     * @return toServiceAddress 被交换的用户时间服务ID
     * @return time 交换时间
     */
    function getExchangeRecord(uint256 _recordId) public view returns(
        uint256,
        address,
        address,
        address,
        address,
        uint256
    ) {
        return (recordMap[_recordId].recordId,
                recordMap[_recordId].from,
                recordMap[_recordId].to,
                recordMap[_recordId].fromServiceAddress,
                recordMap[_recordId].toServiceAddress,
                recordMap[_recordId].time
        );
    }

    /**
     * 时间消费
     * @param _userAddress 用户地址
     * @param _serviceId 用户的时间服务ID
     */
    function timeUsage(address _userAddress,uint256 _serviceId) public {
        require(userMap[_userAddress].userAddress != address(0),"当前用户未注册");
        ServiceInfo(serviceIdToAddress[_serviceId]).timeUsage();
    }

    /**
     * 判断当前的时间服务ID是否存在
     * @param _id 时间服务ID
     */
    function checkServiceExit(uint256 _id) public view returns(bool) {
        for (uint i = 0; i < serviceCount; i++) {
            if (_id == i) {
                return true;
            }
        }
        return false;
    }
    
}