pragma solidity ^0.6.10;

import "./Ownable.sol";
import "./RBAC.sol";

/**
 * @author SomeJoker
 * @title  例子
 */
contract Example is Ownable,RBAC{
    string constant private ADD = "ADD";
    string constant private SUB = "SUB";
    string constant private MUL = "MUL";
    string constant private DIV = "DIV";

    function setRole(address addr,string memory _role) public onlyOwner{
        addRole(addr, _role);
    }

    function resetRole(address addr,string memory _role) public onlyOwner{
        removeRole(addr, _role);
    }

    function add(uint a,uint b) public view onlyRole(ADD) returns(uint){
        return a+b;
    }

    function sub(uint a,uint b) public view onlyRole(SUB) returns(uint){
        return a-b;
    }

    function mul(uint a,uint b) public view onlyRole(MUL) returns(uint){
        return a*b;
    }

    function div(uint a,uint b) public view onlyRole(DIV) returns(uint){
        return a/b;
    }


}