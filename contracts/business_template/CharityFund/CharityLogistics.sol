pragma solidity ^0.4.25;
pragma experimental ABIEncoderV2;

import "./PublicData.sol";
import "./RolesAuth.sol";

contract CharityLogistics is PublicData{
    
    RolesAuth private rolesAuth;
    
    // 物流公司的结构体
    struct Logistics {
        uint256 logisticsId;        // 物流公司ID
        string  logisticsName;      // 物流公司名称 
        address logisticsAddress;   // 物流公司的地址
        int     status;             // 物流公司的状态
    }
    
    // 物流公司的ID
    uint256 logisticsCount;
    // 所有物流公司的地址
    address[] logisticsAddress;
    // 地址映射物流公司的详细信息
    mapping(address => Logistics) logisticsMap;
    // 修饰符函数
    modifier _AuthLogistic {
        require(rolesAuth.hasLogistic(msg.sender),"没有权限");
        _;
    }
    

   
    constructor() public {
        rolesAuth = new RolesAuth();
    }
    
    // 注册物流公司
    function registerLogistics(string memory _logisticsName) public returns(Logistics) {
        require(logisticsMap[msg.sender].status == 0,"当前的物流公司已经注册");
        logisticsCount++;
        uint256 _logisticsId = logisticsCount;
        Logistics storage _logistic = logisticsMap[msg.sender];
        _logistic.logisticsId = _logisticsId;
        _logistic.logisticsName = _logisticsName;
        _logistic.logisticsAddress = msg.sender;
        _logistic.status = 1;
        rolesAuth.addLogistic(msg.sender);
        
        logisticsAddress.push(msg.sender);
        
        return _logistic;
    }
    
    
    /**
     * @dev 物流公司进行物资发货操作
     * @param _transacionId 待发送的公益捐助交易 ID
     * @return 发送后的公益捐助交易信息
     *
     **/
    function dispatch(uint256 _transacionId) public _AuthLogistic  returns(Transaction){
        require(transactionMap[_transacionId].transacStatus == TransacStatus.SHIPMENT,"当前物流未出货");
        if (transactionMap[_transacionId].isTransport){
            Transaction storage _transacion = transactionMap[_transacionId]; 
            _transacion.transacStatus = TransacStatus.LOGISTICS;
            _transacion.sources.push(msg.sender);
            emit Dispathed(msg.sender,_transacionId);
            return _transacion;
        }
        return;
    }
}