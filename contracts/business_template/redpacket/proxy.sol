pragma solidity ^0.4.25;


//负责接受积分合约的授权，以完成积分转移
contract Proxy {
    IPoint point;
    address owner;
    constructor() public {
       owner = msg.sender; 
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "only owner can do");
        _;
    }
    
    function setPointAddr(address _addr) public onlyOwner {
        point = IPoint(_addr);
    }
    
    function transfer(address _from, address _to, uint256 _value) external returns (bool success) {
        point.transferFrom(_from, _to, _value);
    }
    
    function allowance(address _from) public view returns (uint256) {
        return point.allowance(_from, address(this));
    }
    
    function balanceOf(address _who) public view returns (uint256) {
        return point.balanceOf(_who);
    }
    
    function addr() public view returns (address) {
        return address(this);
    }
}

interface IPoint {
   function balanceOf(address _owner) external view returns (uint256 balance);
   function transfer(address _to, uint256 _value) external returns (bool success);
   function approve(address _spender, uint256 _value) external returns (bool success);
   function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
   function allowance(address _owner, address _spender) external view returns (uint256 remaining);
}