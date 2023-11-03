pragma solidity ^0.4.24;

import "./Roles.sol";

contract RolesAuth {
    
    using Roles for Roles.Role;
    
    // 创建三个不同的角色权限
    Roles.Role private productCompany;
    Roles.Role private logisticCompany;
    Roles.Role private supermaket;
    
    
    // 定义两个常量, 我是用constant可以减少gas消耗 
    bool constant internal IS_ROLE = true;
    bool constant internal NOT_ROLE = false;
    
    // 添加的权限
    function addPCompanyRole(address _userAddress) {
        require(productCompany.has(_userAddress) == NOT_ROLE,"当前用户已经存在角色权限");
        productCompany.add(_userAddress);
    }
    
    
    // 添加的权限
    function addLCompanyRole(address _userAddress) {
        require(logisticCompany.has(_userAddress) == NOT_ROLE,"当前用户已经存在角色权限");
        logisticCompany.add(_userAddress);
    }

    // 添加的权限
    function addSupermaketRole(address _userAddress) {
        require(supermaket.has(_userAddress) == NOT_ROLE,"当前用户已经存在角色权限");
        supermaket.add(_userAddress);
    }
    
    function hasPCompanyRole(address _userAddress) public returns(bool){
        return productCompany.has(_userAddress);
    }
     
    function hasLCompanyRole(address _userAddress) public returns(bool){
        return logisticCompany.has(_userAddress);
    }
     
    function hasSupermaketRole(address _userAddress) public returns(bool){
        return supermaket.has(_userAddress);
    }
    
}