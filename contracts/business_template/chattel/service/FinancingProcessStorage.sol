/**
 * 融资流程存储器
 */
pragma solidity ^0.4.25;
pragma experimental ABIEncoderV2;

import "../utils/Table.sol";
import "../utils/LibString.sol";
import "../utils/Ownable.sol";
import "./MapStorage.sol";
import "./FinancingDetailStorage.sol";
import "./PledgeGoodsStorage.sol";

contract FinancingProcessStorage is Ownable {

    using LibString for string;

    MapStorage private mapStorage;
    FinancingDetailStorage private financingDetailStorage;
    PledgeGoodsStorage private pledgeGoodsStorage;

    event InsertResult(int256);
    event UpdateDebtorStatusResult(int256);
    event UpdateCreditSideStatusResult(int256);
    event UpdateSupervisorStatusResult(int256);

    TableFactory tf;
    string constant TABLE_NAME = "tf_process";

    /**
    * 创建融资流程表
    * +---------------------------+----------------+-----------------------------------------+
    * | Field                     |     Type       |      Desc                               |
    * +---------------------------+----------------+-----------------------------------------+
    * |id                         |     string     |      流程ID
    * |debtor_id                  |     string     |      借款方、融资方用户ID
    * |debtor_name                |     string     |      融资方
    * |debtor_status              |     string     |      融资发起流程状态
    * |credit_side_id             |     string     |      贷款方、出资方、资金方用户ID
    * |credit_side_name           |     string     |      资金方
    * |credit_side_status         |     string     |      资金方审批状态
    * |supervisor_id              |     string     |      监管方ID
    * |supervisor_name            |     string     |      监管方
    * |supervisor_status          |     string     |      监管方审批状态
    * |status                     |     string     |      整个流程状态
    * +---------------------------+----------------+-----------------------------------------+
    */
    constructor() public {
        tf = TableFactory(0x1001);
        tf.createTable(TABLE_NAME, "id", "process_id,debtor_id,debtor_name,debtor_status,credit_side_id,credit_side_name,credit_side_status,supervisor_id,supervisor_name,supervisor_status,status");

        mapStorage = new MapStorage();
        financingDetailStorage = new FinancingDetailStorage();
        pledgeGoodsStorage = new PledgeGoodsStorage();
    }

    /**
    * "11,2c91808e7b29b7a0017b29f2fc970005,dk01,0,2c91808e7b29b7a0017b29c809770000,zj01,0,8a81ffaa7af4df03017af66070a0000b,jg01,0,0"
    * "11,1629939590223,1555500,14500,,CD-001,HT141600002,,1,益盟股份有限公司,zjf02,2021-08-26 00:00:00,2021-09-06 00:00:00,12,0,验证资料产品2,666,0,1,1,233652000000001,中国银行,"
    * "11,ZW2108239960,畜牧-牛,吨,100000,6800,110000,701,200000,奶牛养殖场"
    * 插入数据
    */
    function insert(string memory _processStr, string memory _detailStr, string memory _goodsStr) public onlyOwner returns(int) {
        FinancingProcess memory _process = convertFinancingProcess(_processStr);
        Table table = tf.openTable(TABLE_NAME);
        require(!_isIDExist(table, _process.processId), "FinancingProcessStorage insert: current id has already exist");
        Entry entry = table.newEntry();
        convertEntry(_process, entry);
        int256 count = table.insert(_process.processId, entry);
        if(count > int256(0)){
            financingDetailStorage.insert(_detailStr);
            pledgeGoodsStorage.insert(_goodsStr);
        }
        emit InsertResult(count);
        return count;
    }

    /**
    * 资金方融资审批（确认后到出质审批）
    */
    function updateDebtorStatus(string memory _processId, string memory _debtorStatus) public onlyOwner returns(int) {
        Table table = tf.openTable(TABLE_NAME);
        Entry entry = table.newEntry();
        entry.set("debtor_status", _debtorStatus);
        Condition condition = table.newCondition();
        int256 count = table.update(_processId, entry, condition);
        emit UpdateDebtorStatusResult(count);
        return count;
    }

    /**
    * 资金方确认融资审批（确认后走放款流程）
    */
    function updateCreditSideStatus(string memory _processId, string memory _creditSideStatus) public onlyOwner returns(int) {
        Table table = tf.openTable(TABLE_NAME);
        Entry entry = table.newEntry();
        entry.set("credit_side_status", _creditSideStatus);
        Condition condition = table.newCondition();
        int256 count = table.update(_processId, entry, condition);
        emit UpdateCreditSideStatusResult(count);
        return count;
    }

    /**
    * 监管方出质审批（确认后到资金方确认审批）
    */
    function updateSupervisorStatus(string memory _processId, string memory _supervisorStatus) public onlyOwner returns(int) {
        Table table = tf.openTable(TABLE_NAME);
        Entry entry = table.newEntry();
        entry.set("supervisor_status", _supervisorStatus);
        Condition condition = table.newCondition();
        int256 count = table.update(_processId, entry, condition);
        emit UpdateSupervisorStatusResult(count);
        return count;
    }

    /**
    * 通过id查询数据
    */
    function getDetail(string memory _id) public view returns(string memory _json){
        Entry entry = select(_id);
        _json = _returnData(entry);
    }

    function convertFinancingProcess(string memory _str) private returns(FinancingProcess){
        string[] memory ss = _str.split(",");
        return FinancingProcess(ss[0],ss[1],ss[2],ss[3],ss[4],ss[5],ss[6],ss[7],ss[8],ss[9],ss[10]);
    }

    function convertEntry(FinancingProcess memory _process, Entry entry) private {
        entry.set("process_id",_process.processId);//流程ID
        entry.set("debtor_id",_process.debtorId);//借款方、融资方用户ID
        entry.set("debtor_name",_process.debtorName);//融资方
        entry.set("debtor_status",_process.debtorStatus);//融资发起流程状态
        entry.set("credit_side_id",_process.creditSideId);//贷款方、出资方、资金方用户ID
        entry.set("credit_side_name",_process.creditSideName);//资金方
        entry.set("credit_side_status",_process.creditSideStatus);//资金方审批状态
        entry.set("supervisor_id",_process.supervisorId);//监管方ID
        entry.set("supervisor_name",_process.supervisorName);//监管方
        entry.set("supervisor_status",_process.supervisorStatus);//监管方审批状态
        entry.set("status",_process.status);//整个流程状态
    }

    /**
    *  通过id获取实体
    */
    function select(string memory _id) private view returns(Entry _entry){
        Table table = tf.openTable(TABLE_NAME);
        require(_isIDExist(table, _id), "FinancingProcessStorage select: current id not exist");

        Condition condition = table.newCondition();
        _entry = table.select(_id, condition).get(int(0));
    }

    function _isIDExist(Table _table, string memory _id) internal view returns(bool) {
        Condition condition = _table.newCondition();
        return _table.select(_id, condition).size() != int(0);
    }

    //拼接成json数据
    function _returnData(Entry _entry) internal view returns(string){
        string memory _json = "{";

        _json = _json.concat("'processId':'");
        _json = _json.concat(_entry.getString("process_id"));
        _json = _json.concat("',");

        _json = _json.concat("'debtorId':'");
        _json = _json.concat(_entry.getString("debtor_id"));
        _json = _json.concat("',");

        _json = _json.concat("'debtorName':'");
        _json = _json.concat(_entry.getString("debtor_name"));
        _json = _json.concat("',");

        _json = _json.concat("'debtorStatus':'");
        _json = _json.concat(_entry.getString("debtor_status"));
        _json = _json.concat("',");

        _json = _json.concat("'creditSideId':'");
        _json = _json.concat(_entry.getString("credit_side_id"));
        _json = _json.concat("',");

        _json = _json.concat("'creditSideName':'");
        _json = _json.concat(_entry.getString("credit_side_name"));
        _json = _json.concat("',");

        _json = _json.concat("'creditSideStatus':'");
        _json = _json.concat(_entry.getString("credit_side_status"));
        _json = _json.concat("',");

        _json = _json.concat("'supervisorId':'");
        _json = _json.concat(_entry.getString("supervisor_id"));
        _json = _json.concat("',");

        _json = _json.concat("'supervisorName':'");
        _json = _json.concat(_entry.getString("supervisor_name"));
        _json = _json.concat("',");

        _json = _json.concat("'supervisorStatus':'");
        _json = _json.concat(_entry.getString("supervisor_status"));
        _json = _json.concat("',");

        _json = _json.concat("'status':'");
        _json = _json.concat(_entry.getString("status"));
        _json = _json.concat("'");

        _json = _json.concat("}");

        return _json;
    }

    struct FinancingProcess {
        string processId;//流程ID
        string debtorId;//借款方、融资方用户ID
        string debtorName;//融资方
        string debtorStatus;//融资发起流程状态
        string creditSideId;//贷款方、出资方、资金方用户ID
        string creditSideName;//资金方
        string creditSideStatus;//资金方审批状态
        string supervisorId;//监管方ID
        string supervisorName;//监管方
        string supervisorStatus;//监管方审批状态
        string status;//整个流程状态
    }

}
