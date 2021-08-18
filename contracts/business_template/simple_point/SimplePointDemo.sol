pragma solidity ^0.4.25;

contract PointDemo{
    
    address public minter;
    
    mapping(address => uint) public balances;
    
    event Sent(address from,address to,uint amount);
    constructor() public{
        minter = msg.sender;
    }
    function mint(address receiver,uint amount) public{
        require(msg.sender == minter);
        balances[receiver] += amount;
    }
    
    function send(address receiver,uint amount) public{
        require(amount <= balances[msg.sender]);
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        emit Sent(msg.sender,receiver,amount);
    }
}