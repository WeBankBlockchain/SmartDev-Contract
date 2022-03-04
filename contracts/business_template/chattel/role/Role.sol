pragma solidity ^0.4.25;

import "./RoleStorage.sol";

contract Role {

    string constant private DK_Role = "DK";	// 货款方
    string constant private ZJ_Role = "ZJ";	// 资金方
    string constant private JG_Role = "JG";	// 监管方

    RoleStorage private roleStorage;

    constructor() public {
        roleStorage = new RoleStorage();
    }

    function onlyDKRole(string memory _user_id) public view{
        require(roleStorage.hasRole(DK_Role, _user_id), "not has dk permission");
    }

    function onlyZJRole(string memory _user_id) public view{
        require(roleStorage.hasRole(ZJ_Role, _user_id), "not has zj permission");
    }

    function onlyJGRole(string memory _user_id) public view{
        require(roleStorage.hasRole(JG_Role, _user_id), "not has jg permission");
    }

}
