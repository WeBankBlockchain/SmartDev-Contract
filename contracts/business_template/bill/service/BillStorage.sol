pragma solidity ^0.4.25;
pragma experimental ABIEncoderV2;

import "../utils/Ownable.sol";
import "../utils/Table.sol";
import "../utils/LibString.sol";
import "./MapStorage.sol";

contract BillStorage is Ownable {
    
    using LibString for string;
    
    MapStorage private mapStorage;

    event InsertResult(int256);
    event UpdateEndorseResult(int256);
    event UpdateEcceptResult(int256);
    event UpdateRejectResult(int256);

    TableFactory tf;
    string constant TABLE_NAME = "tx_bill";

    string constant BillInfo_State_NewPublish = "NewPublish";	// 票据新发布状态
	string constant BillInfo_State_EndorseWaitSign = "EndorseWaitSign";	// 待背书状态
	string constant BillInfo_State_EndorseSigned = "EndorseSigned";	// 票据背书成功状态
	string constant BillInfo_State_EndorseReject = "EndorseReject";	// 票据背书拒绝状态

    string constant BillInfo_holdrCmID = "holdrCmID_";	// 当前持票人证件号码，票据号码集前缀
    string constant BillInfo_waitEndorseCmID = "waitEndorseCmID_";

    /**
    * 创建票据表
    * +----------------------+------------------------+-------------------------+
    * | Field                | Type                   | Desc                    |
    * +----------------------+------------------------+-------------------------+
    * | info_id              | string                 | 票据号码，全局唯一        |
    * | info_amt             | string                 | 票据金额                 |
    * | info_type            | string                 | 票据类型                 |
    * | info_isse_date       | string                 | 出票日期                 |
    * | info_due_date        | string                 | 到期日期                 |
    * | drwr_acct            | string                 | 出票人名称               |
    * | drwr_cm_id           | string                 | 出票人证件号码            |
    * | accptr_acct          | string                 | 承兑人名称               |
    * | accptr_cm_id         | string                 | 承兑人证件号码            |
    * | pyee_acct            | string                 | 收款人名称               |
    * | pyee_cm_id           | string                 | 收款人证件号码           |
    * | holdr_acct           | string                 | 当前持票人名称           |
    * | holdr_cm_id          | string                 | 当前持票人证件号码        |
    * | wait_endorse_acct    | string                 | 待背书人名称              |
    * | wait_endorse_cm_id   | string                 | 待背书人证件号码          |
    * | reject_endorse_acct  | string                 | 拒绝背书人名称            |
    * | reject_endorse_cm_id | string                 | 拒绝背书人证件号码        |
    * | state                | string                 | 票据状态                 |
    * +----------------------+------------------------+-------------------------+
    */
    constructor() public {
        tf = TableFactory(0x1001);
        tf.createTable(TABLE_NAME, "info_id", "info_amt,info_type,info_isse_date,info_due_date,drwr_acct,drwr_cm_id,accptr_acct,accptr_cm_id,pyee_acct,pyee_cm_id,holdr_acct,holdr_cm_id,wait_endorse_acct,wait_endorse_cm_id,reject_endorse_acct,reject_endorse_cm_id,state");

        mapStorage = new MapStorage();
    }

    /**
    * BOC103,3000,11,20110101,20110105,11,11,11,11,11,11,BBB,BID
    * 插入数据
    */
    function insert(string memory _s) public onlyOwner returns(int) {

        string[] memory ss = _s.split(",");
        //创建空数组
        HistoryItem[] memory historys = new HistoryItem[](0);
        Bill memory _bill = Bill(ss[0],ss[1],ss[2],ss[3],ss[4],ss[5],ss[6],ss[7],ss[8],ss[9],ss[10],ss[11],ss[12],"","","","",BillInfo_State_NewPublish,historys);

        Table table = tf.openTable(TABLE_NAME);
        require(!_isInfoIDExist(table, _bill.infoID), "BillStorage: current info_id has already exist");

        Entry entry = table.newEntry();

        // entry.set("info_id", _bill.infoID);
        entry.set("info_amt", _bill.infoAmt);
        entry.set("info_type", _bill.infoType);
        entry.set("info_isse_date", _bill.infoIsseDate);
        entry.set("info_due_date", _bill.infoDueDate);
        entry.set("drwr_acct", _bill.drwrAcct);
        entry.set("drwr_cm_id", _bill.drwrCmID);
        entry.set("accptr_acct", _bill.accptrAcct);
        entry.set("accptr_cm_id", _bill.accptrCmID);
        entry.set("pyee_acct", _bill.pyeeAcct);
        entry.set("pyee_cm_id", _bill.pyeeCmID);
        entry.set("holdr_acct", _bill.holdrAcct);
        entry.set("holdr_cm_id", _bill.holdrCmID);
        entry.set("wait_endorse_acct", _bill.waitEndorseAcct);
        entry.set("wait_endorse_cm_id", _bill.waitEndorseCmID);
        entry.set("reject_endorse_acct", _bill.rejectEndorseAcct);
        entry.set("reject_endorse_cm_id", _bill.rejectEndorseCmID);
        entry.set("state", _bill.state);

        int256 count = table.insert(_bill.infoID, entry);
        if(count > int256(0)){
            string memory key = BillInfo_holdrCmID;
            key = key.concat(_bill.holdrCmID);
            mapStorage.put(key, _bill.infoID);
        }

        emit InsertResult(count);
        return count;
    }

    /** 通过infoID查询数据 */
    function getDetail(string memory _infoID) public view returns(string memory _json){
        Entry entry = select(_infoID);
        _json = _returnData(entry);
    }

    /** 通过infoID获取HoldrCmID */
    function getHoldrCmID(string memory _infoID) public view returns(string memory _holdrCmID){
        Entry entry = select(_infoID);
        _holdrCmID = entry.getString("holdr_cm_id");
    }

    /** 更新背书人信息 */
    function updateEndorse(string memory _infoID, string memory _waitEndorseCmID, string memory _waitEndorseAcct) public onlyOwner returns(int256) {
        // 更改票据状态, 票据待背书人信息, 删除拒绝背书人信息
        Table table = tf.openTable(TABLE_NAME);
        Entry entry = table.newEntry();
        entry.set("state", BillInfo_State_EndorseWaitSign);
        entry.set("wait_endorse_cm_id", _waitEndorseCmID);
        entry.set("wait_endorse_acct", _waitEndorseAcct);
        entry.set("reject_endorse_cm_id", "");
        entry.set("reject_endorse_acct", "");
        Condition condition = table.newCondition();
        int256 count = table.update(_infoID, entry, condition);
        if(count > int256(0)){
            string memory key = BillInfo_waitEndorseCmID;
            key = key.concat(_waitEndorseCmID);
            mapStorage.put(key, _infoID);
        }
        emit UpdateEndorseResult(count);
        return count;
    }

    /** 更新持票人信息 */
    function updateEccept(string memory _infoID, string memory _holdrCmID, string memory _holdrAcct) public onlyOwner returns(int256) {
        // 更改票据信息: 票据状态, 当前持票人信息, 待背书人信息
        Table table = tf.openTable(TABLE_NAME);
        Entry entry = table.newEntry();
        entry.set("state", BillInfo_State_EndorseSigned);
        entry.set("holdr_cm_id", _holdrCmID);
        entry.set("holdr_acct", _holdrAcct);
        entry.set("wait_endorse_cm_id", "");
        entry.set("wait_endorse_acct", "");
        Condition condition = table.newCondition();
        int256 count = table.update(_infoID, entry, condition);
        emit UpdateEcceptResult(count);
        return count;
    }

    /** 更新待背书人信息 */
    function updateReject(string memory _infoID, string memory _rejectEndorseCmID, string memory _rejectEndorseAcct) public onlyOwner returns(int256) {
        // 修改票据信息: 票据状态, 待背书人信息, 拒绝背书人信息
        Table table = tf.openTable(TABLE_NAME);
        Entry entry = table.newEntry();
        entry.set("state", BillInfo_State_EndorseReject);
        entry.set("reject_endorse_cm_id", _rejectEndorseCmID);
        entry.set("reject_endorse_acct", _rejectEndorseAcct);
        entry.set("wait_endorse_acct", "");
        entry.set("wait_endorse_cm_id", "");
        Condition condition = table.newCondition();
        int256 count = table.update(_infoID, entry, condition);
        emit UpdateRejectResult(count);
        return count;
    }

    /** 通过holdrCmID查询数据 */
    function selectListByHoldrCmID(string memory _holdrCmID) public view returns(string[]){
        string memory key = BillInfo_holdrCmID;
        key = key.concat(_holdrCmID);
        string[] memory infoIDs = mapStorage.get(key);

        Table table = tf.openTable(TABLE_NAME);
        Condition condition = table.newCondition();
        condition.EQ("holdr_cm_id", _holdrCmID);
        string[] memory result = new string[](uint256(infoIDs.length));
        for(uint256 i = uint256(0); i < infoIDs.length; i++){
            Entry entry =  table.select(infoIDs[uint256(i)], condition).get(int(0));
            result[uint256(i)] = _returnData(entry);
        }

        return result;
    }

    /** 通过waitEndorseCmID查询数据 */
    function selectListByWaitEndorseCmID(string memory _waitEndorseCmID) public view returns(string[]){
        string memory key = BillInfo_waitEndorseCmID;
        key = key.concat(_waitEndorseCmID);
        string[] memory infoIDs = mapStorage.get(key);

        Table table = tf.openTable(TABLE_NAME);
        Condition condition = table.newCondition();
        condition.EQ("wait_endorse_cm_id", _waitEndorseCmID);
        string[] memory result = new string[](uint256(infoIDs.length));
        for(uint256 i = uint256(0); i < infoIDs.length; i++){
            Entry entry =  table.select(infoIDs[uint256(i)], condition).get(int(0));
            result[uint256(i)] = _returnData(entry);
        }

        return result;
    }

    /** 通过infoID获取实体 */
    function select(string memory _infoID) private view returns(Entry _entry){
        Table table = tf.openTable(TABLE_NAME);
        require(_isInfoIDExist(table, _infoID), "BillStorage: current infoID not exist");

        Condition condition = table.newCondition();
        _entry = table.select(_infoID, condition).get(int(0));
    }

    function _isInfoIDExist(Table _table, string memory _id) internal view returns(bool) {
        Condition condition = _table.newCondition();
        return _table.select(_id, condition).size() != int(0);
    }

    //拼接成json数据
    function _returnData(Entry _entry) internal view returns(string){

        string memory _json = "{";

        _json = _json.concat("'infoID':'");
        _json = _json.concat(_entry.getString("info_id"));
        _json = _json.concat("',");

        _json = _json.concat("'infoAmt':'");
        _json = _json.concat(_entry.getString("info_amt"));
        _json = _json.concat("',");

        _json = _json.concat("'infoType':'");
        _json = _json.concat(_entry.getString("info_type"));
        _json = _json.concat("',");

        _json = _json.concat("'infoIsseDate':'");
        _json = _json.concat(_entry.getString("info_isse_date"));
        _json = _json.concat("',");

        _json = _json.concat("'infoDueDate':'");
        _json = _json.concat(_entry.getString("info_due_date"));
        _json = _json.concat("',");

        _json = _json.concat("'drwrAcct':'");
        _json = _json.concat(_entry.getString("drwr_acct"));
        _json = _json.concat("',");

        _json = _json.concat("'drwrCmID':'");
        _json = _json.concat(_entry.getString("drwr_cm_id"));
        _json = _json.concat("',");

        _json = _json.concat("'accptrAcct':'");
        _json = _json.concat(_entry.getString("accptr_acct"));
        _json = _json.concat("',");

        _json = _json.concat("'accptrCmID':'");
        _json = _json.concat(_entry.getString("accptr_cm_id"));
        _json = _json.concat("',");

        _json = _json.concat("'pyeeAcct':'");
        _json = _json.concat(_entry.getString("pyee_acct"));
        _json = _json.concat("',");

        _json = _json.concat("'pyeeCmID':'");
        _json = _json.concat(_entry.getString("pyee_cm_id"));
        _json = _json.concat("',");

        _json = _json.concat("'holdrAcct':'");
        _json = _json.concat(_entry.getString("holdr_acct"));
        _json = _json.concat("',");

        _json = _json.concat("'holdrCmID':'");
        _json = _json.concat(_entry.getString("holdr_cm_id"));
        _json = _json.concat("',");

        _json = _json.concat("'waitEndorseAcct':'");
        _json = _json.concat(_entry.getString("wait_endorse_acct"));
        _json = _json.concat("',");

        _json = _json.concat("'waitEndorseCmID':'");
        _json = _json.concat(_entry.getString("wait_endorse_cm_id"));
        _json = _json.concat("',");

        _json = _json.concat("'rejectEndorseAcct':'");
        _json = _json.concat(_entry.getString("reject_endorse_acct"));
        _json = _json.concat("',");

        _json = _json.concat("'rejectEndorseCmID':'");
        _json = _json.concat(_entry.getString("reject_endorse_cm_id"));
        _json = _json.concat("',");

        _json = _json.concat("'state':'");
        _json = _json.concat(_entry.getString("state"));
        _json = _json.concat("'");

        _json = _json.concat("}");

        return _json;

    }
    
    struct Bill {
        string infoID;	// 票据号码
		string infoAmt;		// 票据金额
		string infoType;	// 票据类型

		string infoIsseDate;	// 出票日期
		string infoDueDate;	// 到期日期

		string drwrAcct;	// 出票人名称
		string drwrCmID;	// 出票人证件号码

		string accptrAcct;	// 承兑人名称
		string accptrCmID;	// 承兑人证件号码

		string pyeeAcct;	// 收款人名称
		string pyeeCmID;	// 收款人证件号码

		string holdrAcct;	// 当前持票人名称
		string holdrCmID;	// 当前持票人证件号码

		string waitEndorseAcct;	// 待背书人名称
		string waitEndorseCmID;	// 待背书人证件号码

		string rejectEndorseAcct;	// 拒绝背书人名称
		string rejectEndorseCmID;	// 拒绝背书人证件号码

		string state;	// 票据状态
	    HistoryItem[] historys;	// 当前票据的历史流转记录
    }

    struct HistoryItem {
		string txId;
		Bill bill;
    }

}
