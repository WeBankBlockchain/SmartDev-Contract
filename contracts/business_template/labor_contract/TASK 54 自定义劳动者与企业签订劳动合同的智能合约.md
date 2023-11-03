# 劳动者与企业签订劳动合同的智能合约

## 工作流程
详细解释一下这个合约的工作流程:

1. 合约部署:企业或一个协调方将LaborContract合约部署到区块链上,并得到合约地址。

2. 劳动者调用signContract: 当劳动者与企业达成劳动协议后,劳动者可以调用signContract方法,与企业签订劳动合同。调用时需要传入企业地址、合同开始/结束时间、薪水等信息。

3. 存储合同信息:signContract方法会生成一个Contract数据结构,存储合同信息,并保存到mapping中,与调用者(劳动者)地址关联。 

4. 获取劳动者合同:企业或其他相关方可以通过调用getContracts方法,传入劳动者地址,获取该劳动者在该合约中签订的所有劳动合同信息。

5. 合同执行:在合同有效期内,企业需要按照协议给劳动者支付薪水等。期满时,合同自动终止。

6. 争议解决:如果出现争议,可以直接查询链上合同信息作为证据。

7. 合同更新:可添加新的方法支持合同更新,如改变薪水、延长结束时间等。

以上就是这个简单智能合约的全流程。可以继续扩展,如加入支付功能、法定节假日、绩效管理等,使合约逻辑更加完备。
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