// SPDX-License-Identifier: UNLICENSED
/// @author Steve Jin

pragma solidity >=0.8.0;

contract Ballot {

    address private chairperson;

    bytes32 private subjectName;

    struct Voter {
        uint weight;
        bool voted;
        address delegate;
        uint vote;
    }

    mapping(address => Voter) private voters;

    struct Proposal {
        bytes32 name;
        uint voteCount;
    }

    Proposal[] private proposals;

    constructor(bytes32 _subjectName, bytes32[] memory _proposalNames) {
        chairperson = msg.sender;
        subjectName = _subjectName;
        voters[chairperson].weight = 1;
        for (uint i = 0; i < _proposalNames.length; i++) {
            proposals.push(Proposal({
                name: _proposalNames[i],
                voteCount: 0
            }));
        }
    }

    function giveRightToVote(address _voter) external {
        require(msg.sender == chairperson, "Only chairperson can give right to vote.");
        require(!voters[_voter].voted, "The voter already voted.");
        require(voters[_voter].weight == 0);
        voters[_voter].weight = 1;
        voters[_voter].voted = false;
    }

    function delegate(address _to) external {
        Voter storage sender = voters[msg.sender];
        require(sender.weight != 0, "You have no right to vote");
        require(!sender.voted, "You already voted.");

        require(_to != msg.sender, "Self-delegation is disallowed.");

        while (voters[_to].delegate != address(0)) {
            _to = voters[_to].delegate;
            require(_to != msg.sender, "Found loop in delegation.");
        }

        Voter storage delegate_ = voters[_to];

        require(delegate_.weight >= 1);

        sender.voted = true;
        sender.delegate = _to;

        if (delegate_.voted) {
            proposals[delegate_.vote].voteCount += sender.weight;
        } else {
            delegate_.weight += sender.weight;
        }
    }

    function vote(uint _proposal) external {
        Voter storage sender = voters[msg.sender];
        require(sender.weight != 0, "No permission.");
        require(!sender.voted, "Already voted.");
        sender.voted = true;
        sender.vote = _proposal;

        proposals[_proposal].voteCount += sender.weight;

        voters[msg.sender] = sender;
    }

    function winningProposal() external view returns(uint winningProposal_) {
        uint winningVoteCount = 0;
        for (uint p = 0; p < proposals.length; p++) {
            if (proposals[p].voteCount > winningVoteCount) {
                winningVoteCount = proposals[p].voteCount;
                winningProposal_ = p;
            }
        }
    }

    function winnerName() public view returns(bytes32 winnerName_) {
        winnerName_ = proposals[this.winningProposal()].name;
    }

    function getChairperson() public view returns(address chairperson_) {
        chairperson_ = chairperson;
    }

    function getSubjectName() public view returns(bytes32 subjectName_) {
        subjectName_ = subjectName;
    }

    function getVoters(address _voter) public view returns(uint weight_, bool voted_, address delegate_, uint vote_) {
        weight_ = voters[_voter].weight;
        voted_ = voters[_voter].voted;
        delegate_ = voters[_voter].delegate;
        vote_ = voters[_voter].vote;
    }

    function getProposalsLength() public view returns(uint proposalsLength_) {
        proposalsLength_ = proposals.length;
    }

    function getProposals(uint _proposalIndex) public view returns(bytes32 name_, uint voteCount_) {
        name_ = proposals[_proposalIndex].name;
        voteCount_ = proposals[_proposalIndex].voteCount;
    }

}