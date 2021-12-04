/**
* 角色存储器
*/
pragma solidity ^0.4.25;
pragma experimental ABIEncoderV2;

import "../utils/LibString.sol";
import "../utils/Table.sol";

contract RoleStorage {

    using LibString for string;
    
    event AddRoleResult(int count);
    event RemoveRoleResult(int count);

    TableFactory tf;
    string constant TABLE_NAME = "tx_role";

    /**
    *  角色表
    * +----------------------+------------------------+-------------------------+
    * | Field                | Type                   | Desc                    |
    * +----------------------+------------------------+-------------------------+
    * | role                 | string                 | 角色                     |
    * | user_id              | string                 | 用户标识，（id或address） |
    * +----------------------+------------------------+-------------------------+
    */
    constructor() public {
        tf = TableFactory(0x1001);
        tf.createTable(TABLE_NAME, "role", "user_id");
    }

    function addRole(string memory _role, string memory _user_id) public returns(int) {
        int count = int(0);
        Table table = tf.openTable(TABLE_NAME);
        if(!_role.empty() && !_user_id.empty() && !_isExist(table, _role, _user_id)){
            Entry entry = table.newEntry();
            entry.set("user_id", _user_id);
            count = table.insert(_role, entry);
        }
        emit AddRoleResult(count);
        return count;
    }

    function removeRole(string memory _role, string memory _user_id) public returns(int) {
        int count = int(0);
        Table table = tf.openTable(TABLE_NAME);
        if(!_role.empty() && !_user_id.empty() && !_isExist(table, _role, _user_id)){
            Condition condition = table.newCondition();
            condition.EQ("user_id", _user_id);
            count = table.remove(_role, condition);
        }
        emit RemoveRoleResult(count);
        return count;
    }

    function hasRole(string memory _role, string memory _user_id) public view returns(bool){
        Table table = tf.openTable(TABLE_NAME);
        return _isExist(table, _role, _user_id);
    }

    function checkRole(string memory _role, string memory _user_id) public view{
        require(hasRole(_role, _user_id), "not have permission");
    }

    function _isExist(Table _table, string memory _role, string memory _user_id) internal view returns(bool) {
        Condition condition = _table.newCondition();
        condition.EQ("user_id", _user_id);
        return _table.select(_role, condition).size() > int(0);
    }    
}