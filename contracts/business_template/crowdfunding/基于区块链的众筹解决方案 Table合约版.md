# 基于区块链的众筹解决方案 Table合约版

## 解决方案

基于区块链的众筹方案是利用区块链技术来实现众筹活动的一种方式。它的核心思想是通过智能合约和去中心化的特性，实现众筹的透明、公正和安全。

下面是一个基于区块链的众筹方案的详细介绍：

1. 透明性：区块链上的众筹活动是公开可见的，所有参与者都可以查看众筹项目的信息、捐款记录和资金流动情况。这种透明性消除了信任问题，确保资金使用的公正性。
2. 去中心化：基于区块链的众筹方案不依赖于传统的中心化平台，而是通过智能合约在区块链上执行。这意味着没有中介机构，参与者可以直接与项目方进行交互，减少了手续费和交易时间。
3. 安全性：区块链上的众筹活动采用了密码学技术，确保了交易的安全性和防篡改性。所有的交易记录都被记录在区块链上，无法被篡改。这样可以防止资金被滥用或挪用。
4. 智能合约：基于区块链的众筹方案使用智能合约来实现众筹的逻辑和规则。智能合约是一段自动执行的代码，它定义了众筹的条件、资金的使用规则和捐款的流程。智能合约确保了众筹的公正性和透明性。



## 智能合约

### CrowdfundingStorage合约

CrowdfundingStorage合约用于存储用户表和众筹记录的智能合约。它包含了三张表，分别是用户表、众筹历史记录表和捐款历史记录表。

在合约的构造函数中，使用TableFactory创建了三张表，并定义了它们的名称和字段。

合约提供了以下函数：

1. `insertUser`：用于向用户表中插入一条记录，需要传入用户ID、地址和姓名。
2. `updateUser`：用于更新用户表中某个用户的余额，需要传入用户ID、余额和历史捐款余额。
3. `insertHistoryRecord`：用于向众筹历史记录表中插入一条记录，需要传入众筹记录ID、用户ID、用户地址、众筹标题、众筹描述和需要的金额。
4. `updateHistoryRecord`：用于更新众筹历史记录表中某个记录的状态、已筹金额和结束时间，需要传入众筹记录ID、状态、已筹金额和结束时间。
5. `insertDonationRecord`：用于向捐款历史记录表中插入一条记录，需要传入捐款记录ID、众筹历史记录ID、用户ID、用户地址和捐款金额。
6. `selectUserInfo`：用于查询用户信息，需要传入用户ID，返回用户信息。
7. `selectHistoryRecord`：用于查询众筹历史记录，需要传入众筹记录ID，返回众筹历史记录信息。
8. `selectDonationRecord`：用于查询捐款历史记录，需要传入捐款记录ID，返回捐款历史记录信息。

```solidity
pragma solidity ^0.4.25;
pragma experimental ABIEncoderV2;

import "./Table.sol";
import "./CrowdfundingData.sol";

// 这个合约主要是用于存储用户的表以及众筹的记录
contract CrowdfundingStorage is CrowdfundingData {
    
    TableFactory tf;
    
    string constant internal TABLE_USER_NAME = "c_user";
    string constant internal TABLE_HISTORYRECORD_NAME = "c_history_record";
    string constant internal TABLE_DONATIONRECORD_NAME = "c_donation_record";
    
    constructor() public {
        tf = TableFactory(0x1001);
        // 初始化创建三张表
        tf.createTable(TABLE_USER_NAME,"user_id","address,name,balance,donation_balance");
        tf.createTable(TABLE_HISTORYRECORD_NAME,"record_id","user_id,user_address,title,desc,status,need_amount,over_amount,create_time,end_time");
        tf.createTable(TABLE_DONATIONRECORD_NAME,"donation_id","record_id,user_id,user_address,donation_amount");
    }
    
    // 注册用户
    function insertUser(string _userId,string memory _address,string memory _name) public returns(int){
        Table table = tf.openTable(TABLE_USER_NAME);
        require(!_isUserExist(table,_userId),"当前用户已经存在");
        
        Entry entry = table.newEntry();
        entry.set("user_id",_userId);
        entry.set("address",_address);
        entry.set("name",_name);
        entry.set("balance",uint256(0));
        entry.set("donation_balance",uint256(0));

        int256 count = table.insert(_userId,entry);
        return count;
    }
    
    // 更新用户的余额
    function updateUser(string _userId,uint256 _balance,uint256 _donationBalance) public returns(int){
        Table table = tf.openTable(TABLE_USER_NAME);
        require(_isUserExist(table,_userId),"当前用户不存在");
        
        Entry entry = table.newEntry();
        entry.set("balance",uint256(_balance));
        entry.set("donation_balance",uint256(_donationBalance));

        int256 count = table.update(_userId,entry,table.newCondition());
        return count;
    }
    
    // 添加众筹记录
    function insertHistoryRecord(
        string memory _recordId,
        string memory _userId,
        string memory _recordAddress,
        string memory _title,
        string memory _desc,
        uint256 _needAmount
    ) 
    public returns(int){
        Table table = tf.openTable(TABLE_HISTORYRECORD_NAME);
        require(!_isHistoryRecordExist(table,_recordId),"当前众筹历史记录已经存在");
        
        Entry entry = table.newEntry();
        entry.set("record_id",_recordId);
        entry.set("user_id",_userId);
        entry.set("user_address",_recordAddress);
        entry.set("title",_title);
        entry.set("desc",_desc);
        entry.set("status",uint256(1));
        entry.set("need_amount",uint256(_needAmount));
        entry.set("over_amount",uint256(0));
        entry.set("create_time",uint256(block.timestamp));
        entry.set("end_time",uint256(0));
        
        int256 count = table.insert(_recordId,entry);
        return count;
    }
    
    
    // 更新众筹记录
    function updateHistoryRecord(
        string memory _recordId,
        uint256 _status,
        uint256 _over_amount,
        uint256 _end_time
    ) 
    public returns(int){
        Table table = tf.openTable(TABLE_HISTORYRECORD_NAME);
        require(_isHistoryRecordExist(table,_recordId),"当前众筹历史记录不存在");
        Entry entry = table.newEntry();
        entry.set("status",uint256(_status));
        entry.set("over_amount",uint256(_over_amount));
        entry.set("end_time",uint256(_end_time));
        
        int256 count = table.update(_recordId,entry,table.newCondition());
        return count;
    }
    
    
    // 添加捐赠信息
    function insertDonationRecord(
        string memory _donationId,
        string memory _historyRecordId,
        string memory _userId,
        string memory _userAddress,
        uint256 _donationAmount
    ) 
    public returns(int,DonationRecord){
        Table table = tf.openTable(TABLE_DONATIONRECORD_NAME);
        require(!_isDonationRecordExist(table,_donationId),"当前捐款历史记录已经存在"); 
        
        Entry entry = table.newEntry();
        entry.set("donation_id",_donationId);
        entry.set("record_id",_historyRecordId);
        entry.set("user_id",_userId);
        entry.set("user_address",_userAddress);
        entry.set("donation_amount",uint256(_donationAmount));
        
        int256 count = table.insert(_donationId,entry);
        (int _,DonationRecord memory donationRecord) = selectDonationRecord(_donationId);
        return (count,donationRecord);
    }
    
    
    // 查询用户信息
    function selectUserInfo(string memory _userId) public returns(int,User){
        int res_code = 0;
        
        Table table = tf.openTable(TABLE_USER_NAME);
        User memory user;
        Entries entries = table.select(_userId,table.newCondition());
        if (entries.size() == 0){
            res_code = -1;
            return(res_code,user);
        }
        Entry entry = entries.get(0);
        user = User({
            userId: entry.getString("user_id"),
            userAddress: entry.getAddress("address"),
            userName: entry.getString("name"),
            balance: entry.getUInt("balance"),
            historyBalance: entry.getUInt("donation_balance")
        });
        return (res_code,user);
    }
    
    // 查询历史记录
    function selectHistoryRecord(string memory _historyRecordId) public returns(int,HistoryRecord){
        int res_code = 0;
        
        Table table = tf.openTable(TABLE_HISTORYRECORD_NAME);
        HistoryRecord memory historyRecord;
        Entries entries = table.select(_historyRecordId,table.newCondition());
        if (entries.size() == 0){
            res_code = -1;
            return(res_code,historyRecord);
        }
        Entry entry = entries.get(0);
        historyRecord = HistoryRecord({
            recordId: entry.getString("record_id"),
            userId: entry.getString("user_id"),
            recordAddress: entry.getAddress("user_address"),
            recordTitle: entry.getString("title"),
            recotdDesc: entry.getString("desc"),
            recordStatus: entry.getInt("status"),
            needAmount: entry.getUInt("need_amount"),
            overAmount: entry.getUInt("over_amount"),
            crateTime: entry.getUInt("create_time"),
            endTime: entry.getUInt("end_time")
        });
        return (res_code,historyRecord);
    }    
    
    // 查询捐赠记录
    function selectDonationRecord(string memory _donationRecordId) public returns(int,DonationRecord){
        int res_code = 0;
        
        Table table = tf.openTable(TABLE_DONATIONRECORD_NAME);
        DonationRecord memory donationRecord;
        Entries entries = table.select(_donationRecordId,table.newCondition());
        if (entries.size() == 0){
            res_code = -1;
            return(res_code,donationRecord);
        }
        Entry entry = entries.get(0);
        donationRecord = DonationRecord({
            donationId: entry.getUInt("donation_id"),
            recordId: entry.getUInt("record_id"),
            userId: entry.getUInt("user_id"),
            userAddr: entry.getAddress("user_address"),
            donationAmount: entry.getUInt("donation_amount")
        });
        return (res_code,donationRecord);
    }    
    
    
    // 查看用户是否存在
    function _isUserExist(Table _table,string _userId) private view returns(bool){
        Condition condition = _table.newCondition();
        return _table.select(_userId,condition).size() != int(0);
    }
    
    // 查询历史记录是否存在
    function _isHistoryRecordExist(Table _table,string _historyRecordId) private view returns(bool){
        Condition condition = _table.newCondition();
        return _table.select(_historyRecordId,condition).size() != int(0);
    }
    
    // 查询捐赠记录是否存在
    function _isDonationRecordExist(Table _table,string _donationRecordId) private view returns(bool){
        Condition condition = _table.newCondition();
        return _table.select(_donationRecordId,condition).size() != int(0);
    }
}
```





### CrowdfundingController合约

CrowdfundingController合约实现了用户注册、发起众筹、捐款和查询众筹、捐款详细信息的功能。它通过调用存储合约来实现数据的存储和查询，并使用其他库合约来辅助实现一些功能。

1. 用户注册：用户可以通过调用`register`函数来注册账号。用户需要提供用户ID、地址和姓名作为参数，合约将在内部存储用户信息。
2. 查询用户详细信息：用户可以通过调用`queryUserInfo`函数来查询某个用户的详细信息。用户需要提供用户ID作为参数，合约将返回该用户的信息。
3. 发起众筹：用户可以调用`Initiate`函数来发起一个众筹项目。用户需要提供记录ID、用户ID、地址、标题、描述和所需金额作为参数，合约将在内部存储众筹项目的信息。
4. 捐款：用户可以调用`Donation`函数来向某个众筹项目捐款。用户需要提供记录ID、用户ID、捐款ID和捐款金额作为参数，合约将在内部执行捐款操作，并更新用户和众筹项目的信息。
5. 查询捐款详细：用户可以调用`queryRecordInfo`函数来查询某个众筹项目的详细信息。用户需要提供记录ID作为参数，合约将返回该项目的信息。
6. 查询众筹详细：用户可以调用`queryDonationInfo`函数来查询某个捐款记录的详细信息。用户需要提供捐款ID作为参数，合约将返回该记录的信息。

```solidity
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
```

