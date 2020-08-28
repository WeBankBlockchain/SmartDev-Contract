pragma solidity ^0.4.25;

import "./LibAddressSet.sol";
import "./LibBytes32Set.sol";

contract TestSet {
    using LibAddressSet for LibAddressSet.AddressSet;    
    using LibBytes32Set for LibBytes32Set.Bytes32Set;    
    LibAddressSet.AddressSet private addressSet;
    LibBytes32Set.Bytes32Set private bytes32Set;
    
    function testAddress() public {
	addressSet.add(address(1));
        uint256 size = addressSet.size();//Expected to be 1
    }
    
    function testBytes32() public {
	bytes32Set.add(bytes32(1));
        uint256 size = bytes32Set.size();//Expected to be 1
    }
}
