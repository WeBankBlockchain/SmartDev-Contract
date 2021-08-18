pragma solidity ^0.4.25;

import "./LibLinkedList.sol";



interface DataItem{
}

contract EndNode is DataItem{
}

contract Pair is DataItem{
    bytes32 key;
    DataItem value;
    constructor(bytes32 k, DataItem v){
         key = k;
         value = v;
    }
    
    function getKey() public returns(bytes32){
        return key;
    }
    
    function getValue()public returns(DataItem){
        return value;
    }
    
}

//map
contract Map{
    address constant private NULLADDR = address(0x0);

    using LibLinkedList for LibLinkedList.LinkedList;  
    LibLinkedList.LinkedList  _list;
    
    mapping(bytes32=>Pair) _nodeSet;
    constructor(){
         _nodeSet[bytes32(0)] = new Pair(bytes32(0), new EndNode());
    }
    
    function insert(bytes32 key, DataItem value)public {
        require(_nodeSet[key] == NULLADDR, "the item is already exists");
        Pair pair = new Pair(key, value);
        _list.addNode(key);
        _nodeSet[key] = pair;
    }
    
    function getValue(bytes32 key)public view returns(DataItem){
        require(_nodeSet[key] != NULLADDR, "the item is not exists");
        return _nodeSet[key].getValue();
    }
    
    
    function getSize()public view returns(uint256){
        return _list.getSize();
    }
    
    function isEmpty() public view returns(bool){
        return _list.getSize() == 0;
    }
    
    function isExists(bytes32 key) public view returns(bool){
        return _nodeSet[key] != NULLADDR;
    }
    
    function iterate_start() public view returns(Pair){
        return _nodeSet[_list.iterate_start()];
    }

    function iterate_next(Pair iter) public view returns(Pair){
        require(_nodeSet[iter.getKey()] != NULLADDR, "the iter is not exists");
        return _nodeSet[_list.iterate_next(iter.getKey())];
    }
    
    function can_iterate(Pair iter) public view returns(bool){
        return _list.can_iterate(iter.getKey());
    }
}