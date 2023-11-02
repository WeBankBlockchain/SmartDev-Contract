pragma solidity ^0.6.10;


/**
 * @title 服务信息
 * @notice 提供时间服务的信息
 */
contract ServiceInfo {
    
    // 提供的
    string _name;

    // 服务内容
    string _content;

    // 服务所属人地址
    address _owner;

    // 服务时间
    uint256 _timestamp;

    // 服务状态
    TimeStatus _status;

    // 当前服务状态
    enum TimeStatus {
        AVAILABLE,
        USING,
        CONSUMED,
        ERROR
    }

    // 初始化时间服务的事件
    event InitTimeService(string indexed,uint256 indexed);

    /**
     * 初始化时间服务的信息内容
     * @param name 时间服务名称
     * @param content 时间服务的内容
     * @param owner 时间服务的所有者
     * @param timestamp 提供的时间
     */
    constructor(string memory name,string memory content,address owner,uint256 timestamp) public {
        _name = name;
        _content = content;
        _owner = owner;
        _timestamp = timestamp;
        _status = TimeStatus.AVAILABLE;

        emit InitTimeService(name,block.timestamp);
    }

    /**
     * 查询当前的时间服务信息
     * @return _name 时间服务名称
     * @return _content 时间服务内容
     * @return _owner 时间服务所有者
     * @return _timestamp 服务时间
     * @return _status 服务状态
     */
    function getServiceInfo() public view returns(
        string memory,
        string memory,
        address,
        uint256,
        TimeStatus) 
    {
        return (_name,_content,_owner,_timestamp,_status);
    }


    /**
     * 服务交换
     * @param _from 当前服务提供的用户地址
     * @param _to  交换后所属的用户地址
     */
    function exchangeService(address _from,address _to) public  {
        require(_status != TimeStatus.ERROR,"当前状态异常,无法交换服务");
        require(_owner == _from,"当前不是你提供的时间服务");
        _status = TimeStatus.USING;
        _owner = _to;        
    }

    /**
     * 时间消费
     */
    function timeUsage() public {
        require(_status != TimeStatus.ERROR,"当前状态异常,无法交换服务");
        _status = TimeStatus.CONSUMED;
    }



}