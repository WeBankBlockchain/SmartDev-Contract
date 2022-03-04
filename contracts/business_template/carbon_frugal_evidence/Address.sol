pragma solidity ^0.4.24;

library Address {

    function isContract(address addr) internal view returns(bool) {
        uint256 size;
        assembly { size := extcodesize(addr) }  
        return size > 0;
    }

    function isEmptyAddress(address addr) internal pure returns(bool){
        return addr == address(0);
    }
}