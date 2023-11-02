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
    
    
    
    function _isUserExist(Table _table,string _userId) private view returns(bool){
        Condition condition = _table.newCondition();
        return _table.select(_userId,condition).size() != int(0);
    }
    
    function _isHistoryRecordExist(Table _table,string _historyRecordId) private view returns(bool){
        Condition condition = _table.newCondition();
        return _table.select(_historyRecordId,condition).size() != int(0);
    }
    
    function _isDonationRecordExist(Table _table,string _donationRecordId) private view returns(bool){
        Condition condition = _table.newCondition();
        return _table.select(_donationRecordId,condition).size() != int(0);
    }
}