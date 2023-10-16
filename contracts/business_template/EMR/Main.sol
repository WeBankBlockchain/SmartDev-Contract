pragma solidity ^0.4.25;

import "HospitalContract.sol";

contract Main is HospitalContract {
    
    constructor(address owner) public HospitalContract(owner) { } 
    
}