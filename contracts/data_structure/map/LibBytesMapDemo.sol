pragma solidity ^0.4.25;
import "./LibBytesMap.sol";
contract LibBytesMapDemo {
    using LibBytesMap for LibBytesMap.Map;  
    LibBytesMap.Map private map;  
    event Log(bytes key, uint256 index);  

    function f() public {
        string memory k1 = "k1";  // 键1
        string memory k2 = "k2";  // 键2
        string memory k3 = "k3";  // 键3
        string memory v1 = "v1";  // 值1
        string memory v2 = "v2";  // 值2
        string memory v3 = "v3";  // 值3
        map.put(bytes(k1), bytes(v1));  // 将键1和值1存入映射中
        map.put(bytes(k2), bytes(v2));  // 将键2和值2存入映射中
        map.put(bytes(k3), bytes(v3));  // 将键3和值3存入映射中

        uint256 i = map.iterate_start();  

        while (map.can_iterate(i)) {  
            emit Log(map.getKeyByIndex(i), i);  // 发出Log事件，记录键和索引
            i = map.iterate_next(i);  // 获取下一个迭代的索引
        }
    }
}