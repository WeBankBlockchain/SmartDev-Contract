// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract VotingContract {
    address public admin;
    address public userContractAddress;
    uint public startTime;
    uint public endTime;
    string public voteContent;
    string[] public options;
    mapping(address => bool) public hasVoted;
    mapping(string => uint) public optionVotes;

    constructor(address _userContractAddress, uint _startTime, uint _endTime, string memory _voteContent, string[] memory _options) {
        admin = msg.sender;
        userContractAddress = _userContractAddress;
        startTime = _startTime;
        endTime = _endTime;
        voteContent = _voteContent;
        options = _options;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this function");
        _;
    }

    modifier onlyRegisteredUser() {
        require(isUserRegistered(msg.sender), "Only registered users can participate");
        _;
    }

    function isUserRegistered(address user) internal view returns (bool) {
        (bool success, bytes memory data) = userContractAddress.staticcall(abi.encodeWithSignature("registeredUsers(address)", user));
        if (success) {
            return abi.decode(data, (bool));
        } else {
            revert("Failed to check user registration");
        }
    }

    function vote(string memory option) public onlyRegisteredUser {
        require(block.timestamp >= startTime && block.timestamp <= endTime, "Voting not allowed now");
        require(!hasVoted[msg.sender], "You have already voted");
        require(optionVotes[option] != 0, "Invalid option");

        hasVoted[msg.sender] = true;
        optionVotes[option]++;
    }
}