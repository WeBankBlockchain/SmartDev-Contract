pragma solidity ^0.6.10;
import "./Roles.sol";

/**
 * @author SomeJoker
 * @title  RBAC
 */
contract RBAC{  
    using Roles for Roles.Role;

    mapping (string => Roles.Role) private roles;

    event RoleAdded(address indexed operater,string role);
    event RoleRemoved(address indexed operater,string role);
    
    function addRole(address _operater, string memory _role) internal{
        roles[_role].addRole(_operater);
        emit RoleAdded(_operater,_role);
    }

    function removeRole(address _operater, string memory _role) internal{
        roles[_role].removeRole(_operater);
        emit RoleRemoved(_operater,_role);
    }

    function hasRole(address _operater, string memory _role) public view returns(bool){
        return roles[_role].hasRole(_operater);
    }

    function checkRole(address _operater, string memory _role) public view{
        roles[_role].checkRole(_operater);
    } 

    modifier onlyRole(string memory _role){
        checkRole(msg.sender, _role);
        _;
    } 
}