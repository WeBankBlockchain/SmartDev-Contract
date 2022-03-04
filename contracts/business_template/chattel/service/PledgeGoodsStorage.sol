/**
 * 质押物品存储器
 */
pragma solidity ^0.4.25;
pragma experimental ABIEncoderV2;

import "../utils/Table.sol";
import "../utils/LibString.sol";
import "../utils/Ownable.sol";
import "./MapStorage.sol";

contract PledgeGoodsStorage is Ownable {

    using LibString for string;

    MapStorage private mapStorage;

    event InsertResult(int256);
    event UpdateResult(int256);

    TableFactory tf;
    string constant TABLE_NAME = "tp_goods";

    /**
    * 创建质押物品表
    * +---------------------------+----------------+-----------------------------------------+
    * | Field                     |     Type       |      Desc                               |
    * +---------------------------+----------------+-----------------------------------------+
    * | process_id            | string                 | 流程id
    * | pledge_no             | string                 | 质物商品编号
    * | goods_type            | string                 | 质物商品类型
    * | goods_unit            | string                 | 质物商品计量单位
    * | repo_price            | string                 | 回购价格（单位：分）
    * | market_price          | string                 | 当前市价（单位：分）
    * | pledge_rate           | string                 | 质押率(百分比 6.32% == 632)
    * | goods_amount          | string                 | 质物数量
    * | goods_total_price     | string                 | 质物总价值
    * | goods_productor       | string                 | 生产厂家
    * +---------------------------+----------------+-----------------------------------------+
    */
    constructor() public {
        tf = TableFactory(0x1001);
        tf.createTable(TABLE_NAME, "id", "process_id,pledge_no,goods_type,goods_unit,repo_price,market_price,pledge_rate,goods_amount,goods_total_price,goods_productor");

        mapStorage = new MapStorage();
    }

    /**
    * "11,ZW2108239960,畜牧-牛,吨,100000,6800,110000,701,200000,奶牛养殖场"
    * 插入数据
    */
    function insert(string memory _goodsStr) public onlyOwner returns(int) {
        PledgeGoods memory _goods = convertPledgeGoods(_goodsStr);
        Table table = tf.openTable(TABLE_NAME);
        require(!_isProcessIdExist(table, _goods.processId), "PledgeGoodsStorage insert: current processId has already exist");
        Entry entry = table.newEntry();
        convertEntry(_goods, entry);
        int256 count = table.insert(_goods.processId, entry);
        emit InsertResult(count);
        return count;
    }

    /**
    *  "11,ZW2108239960,畜牧-牛,吨,100000,6800,110000,701,200000,奶牛养殖场"
    * 更新数据
    */
    function update(string memory _processId, string memory _goodsStr) public onlyOwner returns(int256) {
        PledgeGoods memory _goods = convertPledgeGoods(_goodsStr);
        Table table = tf.openTable(TABLE_NAME);
        require(_isProcessIdExist(table, _goods.processId), "PledgeGoodsStorage update: current processId not exist");
        Entry entry = table.newEntry();
        convertEntry(_goods, entry);
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

    function convertPledgeGoods(string memory _str) private returns(PledgeGoods){
        string[] memory ss = _str.split(",");
        return PledgeGoods(ss[0],ss[1],ss[2],ss[3],ss[4],ss[5],ss[6],ss[7],ss[8],ss[9]);
    }

    function convertEntry(PledgeGoods memory _goods, Entry entry) private {
        entry.set("process_id",_goods.processId);
        entry.set("pledge_no",_goods.pledgeNo);
        entry.set("goods_type",_goods.goodsType);
        entry.set("goods_unit",_goods.goodsUnit);
        entry.set("repo_price",_goods.repoPrice);
        entry.set("market_price",_goods.marketPrice);
        entry.set("pledge_rate",_goods.pledgeRate);
        entry.set("goods_amount",_goods.goodsAmount);
        entry.set("goods_total_price",_goods.goodsTotalPrice);
        entry.set("goods_productor",_goods.goodsProductor);
    }

    /**
    *  通过processId获取实体
    */
    function select(string memory _processId) private view returns(Entry _entry){
        Table table = tf.openTable(TABLE_NAME);
        require(_isProcessIdExist(table, _processId), "PledgeGoodsStorage select: current processId not exist");

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

        _json = _json.concat("'goodsType':'");
        _json = _json.concat(_entry.getString("goods_type"));
        _json = _json.concat("',");

        _json = _json.concat("'goodsUnit':'");
        _json = _json.concat(_entry.getString("goods_unit"));
        _json = _json.concat("',");

        _json = _json.concat("'repoPrice':'");
        _json = _json.concat(_entry.getString("repo_price"));
        _json = _json.concat("',");

        _json = _json.concat("'marketPrice':'");
        _json = _json.concat(_entry.getString("market_price"));
        _json = _json.concat("',");

        _json = _json.concat("'pledgeRate':'");
        _json = _json.concat(_entry.getString("pledge_rate"));
        _json = _json.concat("',");

        _json = _json.concat("'goodsAmount':'");
        _json = _json.concat(_entry.getString("goods_amount"));
        _json = _json.concat("',");

        _json = _json.concat("'goodsTotalPrice':'");
        _json = _json.concat(_entry.getString("goods_total_price"));
        _json = _json.concat("',");

        _json = _json.concat("'goodsProductor':'");
        _json = _json.concat(_entry.getString("goods_productor"));
        _json = _json.concat("'");

        _json = _json.concat("}");

        return _json;
    }

    struct PledgeGoods {
        string processId;//流程id
        string pledgeNo;//质物商品编号
        string goodsType;//质物商品类型
        string goodsUnit;//质物商品计量单位
        string repoPrice;//回购价格（单位：分）
        string marketPrice;//当前市价（单位：分）
        string pledgeRate;//质押率(百分比6.32%==632)
        string goodsAmount;//质物数量
        string goodsTotalPrice;//质物总价值
        string goodsProductor;//生产厂家
    }

}
