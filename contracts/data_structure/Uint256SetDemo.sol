pragma solidity ^0.4.25;

import "./LibUint256Set.sol";

contract UintSetTest{

    using LibUint256Set for LibUint256Set.Uint256Set;
    LibUint256Set.Uint256Set private uintSet;

    function add() public view returns (bool) {
        uintSet.add(1);
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

    function remove() public view returns (uint256[]) {
        uintSet.add(1);
        uintSet.add(2);
        uintSet.add(3);
        uintSet.remove(3);
        return uintSet.getAll();
    }

    function removeAndAtPositon(uint256 del, uint256 key) public view returns (bool,uint256) {
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
}