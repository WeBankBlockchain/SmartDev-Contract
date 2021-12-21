/**
 * 质物仓单存储器
 */
pragma solidity ^0.4.25;
pragma experimental ABIEncoderV2;

import "../utils/Table.sol";
import "../utils/LibString.sol";
import "../utils/Ownable.sol";
import "./MapStorage.sol";

contract PledgeReceiptStorage is Ownable {

    using LibString for string;

    MapStorage private mapStorage;

    event InsertResult(int256);
    event UpdateResult(int256);

    TableFactory tf;
    string constant TABLE_NAME = "tp_receipt";

    /**
    * 创建质物仓单表
    * +---------------------------+----------------+-----------------------------------------+
    * | Field                     |     Type       |      Desc                               |
    * +---------------------------+----------------+-----------------------------------------+
    * | process_id            | string                 | 流程id
    * | pledge_no             | string                 | 质物商品编号
    * | storage_name          | string                 | 仓库名称
    * | storage_no            | string                 | 仓库编号
    * | cargo_space_no        | string                 | 货位编号
    * | goods_dir             | string                 | 商品（抵押物）目录
    * | goods_name            | string                 | 商品（抵押物）名称
    * +---------------------------+----------------+-----------------------------------------+
    */
    constructor() public {
        tf = TableFactory(0x1001);
        tf.createTable(TABLE_NAME, "id", "process_id,pledge_no,storage_name,storage_no,cargo_space_no,goods_dir,goods_name");

        mapStorage = new MapStorage();
    }

    /**
    * "11"
    * "11,ZW2108239960,仓库11号,UHD799494,N0002,畜牧,畜牧-牛"
    * 插入数据
    */
    function insert(string memory _processId, string memory _receiptStr) public onlyOwner returns(int) {
        PledgeReceipt memory _receipt = convertPledgeReceipt(_receiptStr);
        Table table = tf.openTable(TABLE_NAME);
        require(!_isProcessIdExist(table, _processId), "PledgeReceiptStorage insert: current processId has already exist");
        Entry entry = table.newEntry();
        convertEntry(_receipt, entry);
        int256 count = table.insert(_processId, entry);
        emit InsertResult(count);
        return count;
    }

    /**
    *  "11,ZW2108239960,仓库11号,UHD799494,N0002,畜牧,畜牧-牛"
    * 更新数据
    */
    function update(string memory _processId, string memory _receiptStr) public onlyOwner returns(int256) {
        PledgeReceipt memory _receipt = convertPledgeReceipt(_receiptStr);
        Table table = tf.openTable(TABLE_NAME);
        require(_isProcessIdExist(table, _receipt.processId), "PledgeReceiptStorage update: current processId not exist");
        Entry entry = table.newEntry();
        convertEntry(_receipt, entry);
        Condition condition = table.newCondition();
        int256 count = table.update(_processId, entry, condition);
        emit UpdateResult(count);
        return count;
    }

    /**
    * 通过processId查询数据
    */
    function getDetail(string memory _processId) public view returns(string memory _json){
        Entry entry = select(_processId);
        _json = _returnData(entry);
    }

    function convertPledgeReceipt(string memory _str) private returns(PledgeReceipt){
        string[] memory ss = _str.split(",");
        return PledgeReceipt(ss[0],ss[1],ss[2],ss[3],ss[4],ss[5],ss[6]);
    }

    function convertEntry(PledgeReceipt memory _receipt, Entry entry) private {
        entry.set("process_id",_receipt.processId);
        entry.set("pledge_no",_receipt.pledgeNo);
        entry.set("storage_name",_receipt.storageName);
        entry.set("storage_no",_receipt.storageNo);
        entry.set("cargo_space_no",_receipt.cargoSpaceNo);
        entry.set("goods_dir",_receipt.goodsDir);
        entry.set("goods_name",_receipt.goodsName);
    }

    /**
    *  通过processId获取实体
    */
    function select(string memory _processId) private view returns(Entry _entry){
        Table table = tf.openTable(TABLE_NAME);
        require(_isProcessIdExist(table, _processId), "PledgeReceiptStorage select: current processId not exist");

        Condition condition = table.newCondition();
        _entry = table.select(_processId, condition).get(int(0));
    }

    function _isProcessIdExist(Table _table, string memory _id) internal view returns(bool) {
        Condition condition = _table.newCondition();
        return _table.select(_id, condition).size() != int(0);
    }

    //拼接成json数据
    function _returnData(Entry _entry) internal view returns(string){

        string memory _json = "{";

        _json = _json.concat("'processId':'");
        _json = _json.concat(_entry.getString("process_id"));
        _json = _json.concat("',");

        _json = _json.concat("'pledgeNo':'");
        _json = _json.concat(_entry.getString("pledge_no"));
        _json = _json.concat("',");

        _json = _json.concat("'storageName':'");
        _json = _json.concat(_entry.getString("storage_name"));
        _json = _json.concat("',");

        _json = _json.concat("'storageNo':'");
        _json = _json.concat(_entry.getString("storage_no"));
        _json = _json.concat("',");

        _json = _json.concat("'cargoSpaceNo':'");
        _json = _json.concat(_entry.getString("cargo_space_no"));
        _json = _json.concat("',");

        _json = _json.concat("'goodsDir':'");
        _json = _json.concat(_entry.getString("goods_dir"));
        _json = _json.concat("',");

        _json = _json.concat("'goodsName':'");
        _json = _json.concat(_entry.getString("goods_name"));
        _json = _json.concat("'");

        _json = _json.concat("}");

        return _json;
    }

    struct PledgeReceipt {
        string processId;//流程id
        string pledgeNo;//质物商品编号
        string storageName; //仓库名称
        string storageNo;//仓库编号
        string cargoSpaceNo;// 货位编号
        string goodsDir; //商品（抵押物）目录
        string goodsName;// 商品（抵押物）名称
    }

}
