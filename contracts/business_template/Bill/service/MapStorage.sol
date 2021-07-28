pragma solidity ^0.4.25;
pragma experimental ABIEncoderV2;

import "../utils/Ownable.sol";
import "../utils/LibString.sol";
import "../utils/Table.sol";

contract MapStorage is Ownable {

    using LibString for string;
    
    event PutResult(int count);

    TableFactory tf;
    string constant TABLE_NAME = "tx_map";

    /**
    * @notice map表
    * +----------------------+------------------------+-------------------------+
    * | Field                | Type                   | Desc                    |
    * +----------------------+------------------------+-------------------------+
    * | key                  | string                 | key                     |
    * | value                | string                 | value                   |
    * +----------------------+------------------------+-------------------------+
    */
    constructor() public {
        tf = TableFactory(0x1001);
        tf.createTable(TABLE_NAME, "key", "value");
    }

    /**
    * @notice 插入数据，已有数据不添加
    */
    function put(string memory _key, string memory _value) public onlyOwner returns(int) {
        int count = int(0);
        Table table = tf.openTable(TABLE_NAME);
        if(!_key.empty() && !_value.empty() && !_isExist(table, _key, _value)){
            Entry entry = table.newEntry();
            entry.set("value", _value);
            count = table.insert(_key, entry);
        }
        emit PutResult(count);
        return count;
    }

    /**
    * @notice 通过key获取value，可以存在多个value
    */
    function get(string memory _key) public view returns(string[] memory){
        Table table = tf.openTable(TABLE_NAME);
        Condition condition = table.newCondition();
        Entries entries = table.select(_key, condition);
        string[] memory value_list = new string[](uint256(entries.size()));
        for (int256 i = 0; i < entries.size(); ++i) {
            Entry entry = entries.get(i);
            value_list[uint256(i)] = entry.getString("value");
        }
        return value_list;

    }

    function _isExist(Table _table, string memory _key, string memory _value) internal view returns(bool) {
        Condition condition = _table.newCondition();
        condition.EQ("value", _value);
        return _table.select(_key, condition).size() > int(0);
    }    
}