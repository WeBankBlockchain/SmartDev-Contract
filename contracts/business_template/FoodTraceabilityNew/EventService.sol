pragma solidity ^0.4.25;

// 所有事件
contract EventService {
    
    // 注册事件 
    event Registered(address indexed _userAddress,string _userName);
    
    // 添加食品
    event AddFood(address indexed _companyAddress,uint256 indexed _foodId);
    
    // 检查食品生成报告
    event MakeReport(address indexed _regulatorAddress,uint256 indexed _reportId);
    
    // 添加物流
    event AddLogistic(address indexed _logisticCompanyAddr,uint256 indexed _orderId);
    
    // 超市签收
    event Receipt(address indexed _supermaketAddress,uint256 indexed _orderId);
    
}