pragma solidity ^0.6.10;


/**
 * @author SomeJoker
 * @title  Ownable
 */
contract Ownable{
    address public owner;

    event OwnershipRenounced(address indexed lastOwner);
    event OwnershipTransfer(address indexed lastOwner,address indexed currentOwner);

    constructor() public{
        owner = msg.sender;
    }

    modifier onlyOwner{
        require(msg.sender == owner, "msg.sender is not owner");
        _;
    }

    function renounceOwnership() public onlyOwner{
        emit OwnershipRenounced(owner);
        owner = address(0);
    }

    function transferOwnership(address _newOwner) public onlyOwner {
        require(_newOwner != address(0),"_newOwner Can't be Zero address");
        emit OwnershipTransfer(owner,_newOwner);
        owner = _newOwner;
    }
}  