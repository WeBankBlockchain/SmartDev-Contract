// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./VotingContract.sol";

contract VotingFactory {
    address public admin;
    address[] public deployedVotingContracts;

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this function");
        _;
    }

    function createVotingContract(address userContractAddress, uint startTime, uint endTime, string memory voteContent, string[] memory options) public onlyAdmin {
        address newVotingContract = address(new VotingContract(userContractAddress, startTime, endTime, voteContent, options));
        deployedVotingContracts.push(newVotingContract);
    }

    function getDeployedVotingContracts() public view returns (address[] memory) {
        return deployedVotingContracts;
    }
}
