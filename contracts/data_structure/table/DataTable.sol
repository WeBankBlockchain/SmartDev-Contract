pragma solidity ^0.4.25;

import "./Map.sol";

//数据行，定义为list的数据节点
contract DataRow is DataItem, Map{
    
}

//二维数据表
contract DataTable{
    Map _map;
    
    constructor(){
         _map = new Map();
    }
    
    function insertItem(bytes32 rowId, bytes32 colId, DataItem item) public {
        if(!_map.isExists(rowId)){
            _map.insert(rowId, new DataRow());
        }
         DataRow row = DataRow(_map.getValue(rowId));
         row.insert(colId, item);
    }
    function getItem(bytes32 rowId, bytes32 colId) public view returns(DataItem){
        require(_map.isExists(rowId), "the item is not exists");
        DataRow row = DataRow(_map.getValue(rowId));
        return row.getValue(colId);
    }

    function getRow(bytes32 rowId) public view returns(DataRow){
        require(_map.isExists(rowId), "the row is not exists");
        DataRow row = DataRow(_map.getValue(rowId));
        return row;
    }
    
    function isExists(bytes32 rowId, bytes32 colId) public view returns(bool){
        if(!_map.isExists(rowId)){
            return false;
        }
        DataRow row = DataRow(_map.getValue(rowId));
        return row.isExists(colId);
    }

    function isExists(bytes32 rowId) public view returns(bool){
       return _map.isExists(rowId);
    }

    function rowCount()public view returns(uint256){
        return _map.getSize();
    }
    
     function iterate_start() public view returns(Pair){
        return _map.iterate_start();
    }

    function iterate_next(Pair iter) public view returns(Pair){
        return _map.iterate_next(iter);
    }
    
    function can_iterate(Pair iter) public view returns(bool){
        return _map.can_iterate (iter);
    }
}