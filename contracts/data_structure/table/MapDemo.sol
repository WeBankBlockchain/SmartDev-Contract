pragma solidity ^0.4.25;
import "./LibBytesMap.sol";

contract MapDemo {
    using LibBytesMap for LibBytesMap.Map;

    LibBytesMap.Map private map;

    event Log(bytes key, uint256 index);
    function f() public {
        string memory k1 = "k1";
        string memory k2 = "k2";
        string memory k3 = "k3";
        string memory v1 = "v1";
        string memory v2 = "v2";
        string memory v3 = "v3";
        map.put(bytes(k1),bytes(v1));
        map.put(bytes(k2),bytes(v2));
        map.put(bytes(k3),bytes(v3));

        uint256 i = map.iterate_start();

        while(map.can_iterate(i)){
            emit Log(map.getKeyByIndex(i), i);
            i = map.iterate_next(i);
        }
    }
}
