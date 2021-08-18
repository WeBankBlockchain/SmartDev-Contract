pragma solidity ^0.4.25;

import "./SafeRole.sol";


contract WhitelistAdminRole {
    using SafeRole for SafeRole.Role;

    event WhitelistAdminAdded(address indexed account);
    event WhitelistAdminRemoved(address indexed account);

    SafeRole.Role private _whitelistAdmins;

    /**
     * 构造器
     */ 
    constructor () internal {
        _addWhitelistAdmin(msg.sender);
    }
    /**
     * 白名单管理员权限修饰符
     */
    modifier onlyWhitelistAdmin() {
        require(isWhitelistAdmin(msg.sender), "WhitelistAdminRole: caller does not have the WhitelistAdmin role");
        _;
    }
    /**
     * 判断是否是白名单管理员
     */
    function isWhitelistAdmin(address account) public view returns (bool) {
        return _whitelistAdmins.has(account);
    }
    /**
     * 添加白名单管理员
     */
    function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
        _addWhitelistAdmin(account);
    }
    /**
     * 移除白名单管理员
     */ 
    function renounceWhitelistAdmin() public {
        _removeWhitelistAdmin(msg.sender);
    }

    function _addWhitelistAdmin(address account) internal {
        _whitelistAdmins.add(account);
        emit WhitelistAdminAdded(account);
    }

    function _removeWhitelistAdmin(address account) internal {
        _whitelistAdmins.remove(account);
        emit WhitelistAdminRemoved(account);
    }
}