pragma solidity ^0.4.25;

import "./LibUint256Set.sol";

contract Uint256SetDemo {
    using LibUint256Set for LibUint256Set.Uint256Set;

    LibUint256Set.Uint256Set private uintSet;
    LibUint256Set.Uint256Set private uintSet2;

    function add() public view returns (bool) {
        return uintSet.add(1);
    }

    function contains() public view returns (bool) {
        uintSet.add(1);
        return uintSet.contains(1);
    }

    function getAll() public view returns (uint256[]) {
        uintSet.add(1);
        uintSet.add(2);
        uintSet.add(3);
        return uintSet.getAll();
    }

    function remove(uint256 del) public view returns (bool, uint256[]) {
        uintSet.add(1);
        uintSet.add(2);
        uintSet.add(3);
        bool b = uintSet.remove(del);
        return (b, uintSet.getAll());
    }

    function removeAndAtPositon(uint256 del, uint256 key)
        public
        view
        returns (bool, uint256)
    {
        uintSet.add(1);
        uintSet.add(2);
        uintSet.add(3);
        uintSet.remove(del);
        return uintSet.atPosition(key);
    }

    function getSize() public view returns (uint256) {
        uintSet.add(1);
        uintSet.add(2);
        uintSet.add(3);
        return uintSet.getSize();
    }

    function getByIndex(uint256 index) public view returns (uint256) {
        uintSet.add(1);
        uintSet.add(2);
        uintSet.add(3);
        return uintSet.getByIndex(index);
    }

    function union() public view returns (uint256[]){
        uintSet.add(1);
        uintSet.add(2);
        uintSet.add(3);
        uintSet2.add(3);
        uintSet2.add(4);
        uintSet2.add(5);
        return uintSet.union(uintSet2);
    }

    function relative() public view returns (uint256[]){
        uintSet.add(1);
        uintSet.add(2);
        uintSet.add(3);
        uintSet2.add(3);
        uintSet2.add(4);
        uintSet2.add(5);
        return uintSet.relative(uintSet2);
    }

    function intersect() public view returns (uint256[]){
        uintSet.add(1);
        uintSet.add(2);
        uintSet.add(3);
        uintSet2.add(3);
        uintSet2.add(4);
        uintSet2.add(5);
        return uintSet.intersect(uintSet2);
    }
}
