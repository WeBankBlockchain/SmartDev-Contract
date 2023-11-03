
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

/**
* @title 劳动者与企业签订劳动合同的智能合约
* @author LiMing
* @notice 本合约允许劳动者与企业在区块链上签订劳动合同  
* @dev 使用mapping存储每个劳动者的合同记录
*/

contract LaborContract {

  struct Contract {
    address company; // 企业地址    
    address labor; // 劳动者地址
    uint startDate; // 合同开始时间  
    uint endDate; // 合同结束时间
    uint salary; // 薪水  
  }

  mapping(address => Contract[]) public contracts;  

  /**
  * @notice 允许劳动者发起签订合同
  * @param _company 企业地址  
  * @param _startDate 合同开始时间
  * @param _endDate 合同结束时间
  * @param _salary 薪水
  */
  function signContract(address _company, uint _startDate, uint _endDate, uint _salary) public {
    
    Contract memory newContract;

    newContract.company = _company;
    newContract.labor = msg.sender;
    newContract.startDate = _startDate;
    newContract.endDate = _endDate;
    newContract.salary = _salary;

    contracts[msg.sender].push(newContract);
  }

  /**
  * @notice 查询某个劳动者的所有合同记录
  * @param _labor 劳动者地址
  * @return 该劳动者的所有合同记录
  */
  function getContracts(address _labor) view public returns(Contract[] memory) {
    return contracts[_labor];
  }

}