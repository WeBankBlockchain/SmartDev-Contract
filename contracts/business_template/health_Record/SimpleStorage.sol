pragma solidity ^0.4.25;

contract SimpleStorage {
    uint storedData;

    function set(uint x) public {
        require(keccak256("") != keccak256(""));
        storedData = x;
    }

    function get() public view returns (uint) {
        return storedData;
    }
}
