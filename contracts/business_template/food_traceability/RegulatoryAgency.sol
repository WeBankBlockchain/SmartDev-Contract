pragma solidity ^0.4.25;
pragma experimental ABIEncoderV2;

import "./EventService.sol";

contract RegulatoryAgency is EventService{
    
    // 监管报告结构，记录食物的健康报告
    struct Report {
        uint256 reportId;       // 报告ID
        string  reportName;     // 报告名字
        Levels  healthLevel;    // 健康等级
        string  foodName;       // 食品名称
    }
    
    // 监管机构结构体
    struct Regulator {
        address regulatorAddress;   // 监管机构地址
        string  regulatorName;      // 监管机构名称
        Report[] reportList;        // 监管机构所有报告
    }
    
    // 食品健康等级
    enum  Levels {ONE_LEVEL,TWO_LEVEL,THREE_LEVEL,FOUR_LEVEL,FIVE_LEVEL}
    
    // 地址映射监管机构
    mapping(address => Regulator) public regulatorMap;
    // 食品ID映射报告
    mapping(uint256 => Report) public reportMap;
    
    // 注册监管机构
    function registerRegulator(string memory _regulatorName) public {
        Regulator storage _regulator = regulatorMap[msg.sender];
        _regulator.regulatorAddress = msg.sender;
        _regulator.regulatorName = _regulatorName;
        emit Registered(msg.sender,_regulatorName);
    }
    
    
    // 查询监管机构
    function queryRegulator(address _regulatorAddress) public view returns(Regulator memory) {
        Regulator memory regulator = regulatorMap[_regulatorAddress];
        return regulator;
    }
    
}
