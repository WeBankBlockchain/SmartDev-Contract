pragma solidity ^0.4.25;
pragma experimental ABIEncoderV2;

import "./CrowdfundingStorage.sol";
import "./CrowdfundingData.sol";
import "./AddressToString.sol";

contract CrowdfundingController is CrowdfundingData{
    
    using AddressToString for address;
    CrowdfundingStorage private crowdfunding;
    
    constructor() public{
        crowdfunding = new CrowdfundingStorage();
    }
    
    // 用户注册
    function register(
        string memory _userId,
        string memory _address,
        string memory _name
    ) public returns(int) {
        return crowdfunding.insertUser(_userId,_address,_name);
    }
    
    // 查询用户详细信息
    function queryUserInfo(string memory _userId) public view returns(int,User){
        return crowdfunding.selectUserInfo(_userId);
    }
    
    
    //发起众筹
    function Initiate(
        string memory _recordId,
        string memory _userId,
        string memory _address,
        string memory _title,
        string memory _desc,
        uint256 _needAmount
    ) public returns(int){
        return crowdfunding.insertHistoryRecord(_recordId,_userId,_address,_title,_desc,_needAmount);
    }
    
    
    
    // 捐款
    function Donation(string memory _recordId,string memory _userId,string memory _donationId,uint256 _amount) public returns(int256,DonationRecord){
        (int user_count,User memory user) = crowdfunding.selectUserInfo(_userId);
        (int record_count,HistoryRecord memory historyRecord) = crowdfunding.selectHistoryRecord(_recordId);
        require(user_count == 0 && record_count == 0,"捐款异常");
        
        // 交易操作
        uint256 userBalance = user.balance - _amount;
        uint256 userHistoryDonationBalance = user.historyBalance + _amount;
        uint256 overAmount = historyRecord.overAmount + _amount;
        
        // 更新用户信息
        crowdfunding.updateUser(_userId,userBalance,userHistoryDonationBalance);
        // 更新历史记录信息
        crowdfunding.updateHistoryRecord(_recordId,2,overAmount,0);
        
        // 生成捐款记录
        return crowdfunding.insertDonationRecord(_donationId,_recordId,_userId,user.userAddress.addressToString(),_amount);
    }
    
    
    // 查询捐款详细
    function queryRecordInfo(string memory _historyRecordId) public view returns(int,HistoryRecord){
        return crowdfunding.selectHistoryRecord(_historyRecordId);
    }
    
    // 查询众筹详细
    function queryDonationInfo(string memory _donationId) public view returns(int,DonationRecord){
        return crowdfunding.selectDonationRecord(_donationId);
    }
}