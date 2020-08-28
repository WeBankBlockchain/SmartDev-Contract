pragma solidity ^0.4.25;

contract Authentication{
    address public _owner;
    mapping(address=>bool) private _acl;

    constructor() public{
      _owner = msg.sender;
    } 

    modifier onlyOwner(){
      require(msg.sender == _owner, "Not admin");
      _;
    }

    modifier auth(){
      require(msg.sender == _owner || _acl[msg.sender]==true, "Not authenticated");
      _;
    }

    function allow(address addr) public onlyOwner{
      _acl[addr] = true;
    }

    function deny(address addr) public onlyOwner{
      _acl[addr] = false;
    }
}
