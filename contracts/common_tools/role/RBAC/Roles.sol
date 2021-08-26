pragma solidity ^0.6.10;
/**
 * @author SomeJoker
 * @title  角色
 */
library Roles{  
    
    struct Role{
        mapping(address => bool) bearer;
    }
    
    function addRole(Role storage role ,address addr) internal{
        role.bearer[addr] = true;
    }

    function removeRole(Role storage role,address addr) internal{
        role.bearer[addr] = false;
    }

    function hasRole(Role storage role,address addr) internal view returns(bool){
        return role.bearer[addr];
    }

    function checkRole(Role storage role,address addr) public view{
        require(hasRole(role, addr));
    }
    
}