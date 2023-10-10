// SPDX-License-Identifier: UNLICENSED
/// @author Steve Jin

pragma solidity >=0.8.0;

contract DonationContract {
    address public owner;
    mapping(address => uint256) public donations;
    mapping(address => bool) public hasDonated;
    Proposal[] public proposals;
    
    struct Proposal {
        address beneficiary;
        uint256 amount;
        uint256 votes;
        bool executed;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }
    
    constructor() {
        owner = msg.sender;
    }
    
    function donate() public payable {
        require(msg.value > 0, "Donation amount must be greater than 0");
        donations[msg.sender] += msg.value;
        hasDonated[msg.sender] = true;
    }
    
    function submitProposal(address _beneficiary, uint256 _amount) public {
        proposals.push(Proposal({
            beneficiary: _beneficiary,
            amount: _amount,
            votes: 0,
            executed: false
        }));
    }
    
    function vote(uint256 _proposalIndex) public {
        require(_proposalIndex < proposals.length, "Invalid proposal index");
        require(hasDonated[msg.sender], "You must donate before voting");
        proposals[_proposalIndex].votes++;
    }
    
    function executeProposal(uint256 _proposalIndex) public onlyOwner {
        require(_proposalIndex < proposals.length, "Invalid proposal index");
        require(!proposals[_proposalIndex].executed, "Proposal already executed");
        
        Proposal storage proposal = proposals[_proposalIndex];
        require(proposal.votes > (donations[owner] / 2), "Insufficient votes for execution");
        
        require(donations[owner] >= proposal.amount, "Insufficient balance");
        
        payable(proposal.beneficiary).transfer(proposal.amount);
        proposal.executed = true;
    }
}
