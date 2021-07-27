pragma solidity ^0.4.25;


library SafeRole {
    struct Role {
        mapping (address => bool) bearer;
    }

    /**
     * 给账户赋予角色.
     */
    function add(Role storage role, address account) internal {
        require(!has(role, account), "Roles: account already has role");
        role.bearer[account] = true;
    }

   /**
    * 账户移除角色
    */
    function remove(Role storage role, address account) internal {
        require(has(role, account), "Roles: account does not have role");
        role.bearer[account] = false;
    }

   /**
    * 判断账户是否有此角色
    */
    function has(Role storage role, address account) internal view returns (bool) {
        require(account != address(0), "Roles: account is the zero address");
        return role.bearer[account];
    }
}