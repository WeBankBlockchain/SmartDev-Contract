// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract UserContract {
    address public admin;
    mapping(address => bytes32) public encryptedRegistrationCodes;
    mapping(address => bool) public registeredUsers;

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this function");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function setRegistrationCode(address user, bytes32 encryptedCode) public onlyAdmin {
        encryptedRegistrationCodes[user] = encryptedCode;
    }

    function register(bytes32 registrationCode) public {
        require(block.timestamp >= startTime && block.timestamp <= endTime, "Registration not allowed now");
        require(keccak256(abi.encodePacked(registrationCode)) == encryptedRegistrationCodes[msg.sender], "Invalid registration code");
        registeredUsers[msg.sender] = true;
    }
}
