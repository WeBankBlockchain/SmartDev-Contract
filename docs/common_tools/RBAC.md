# 权限管理
权限管理有四个合约
1. Roles library 用于角色管理
2. RBAC  合约 管理用户和角色的映射关系
3. Ownable 合约 对合约的所属权进行管理
4. Example 合约 使用上述三个合约完成的一个小例子

## Roles 
编号 | API | API描述
---|---|---
1 | *function addRole(Role storage role ,address addr) internal* | 添加某个角色里的用户
2 | *function removeRole(Role storage role,address addr) internal* | 移除某个角色里的用户
3 | *function hasRole(Role storage role,address addr) internal view returns(bool)* | 检查某个角色下是否有某个用户
4 | *function checkRole(Role storage role,address addr) public view* | 确保某个用户属于某个角色，否则revert


## RBAC 
编号 | API | API描述
---|---|---
1 | *function addRole(address _operater, string memory _role) internal* | 添加某个角色里的用户
2 | *function removeRole(address _operater, string memory _role) internal* | 移除某个角色里的用户
3 | *function hasRole(address _operater, string memory _role) public view returns(bool)* | 检查某个角色下是否有某个用户
4 | *function checkRole(address _operater, string memory _role) public view* | 确保某个用户属于某个角色，否则revert
5 | *modifier onlyRole(string memory _role)*| 修饰符确保只有某个角色可以操作


## Ownable
编号 | API | API描述
---|---|---
1 | *modifier onlyOwner* | 修饰符确保只有owner可以操作
2 | *function renounceOwnership() public onlyOwner* | 放弃owner权限
3 | *function transferOwnership(address _newOwner) public onlyOwner* | 将owner权限转给其他地址


## Example
在 Example 实现了加、减、乘、除四个方法，对应了四种权限，只有拥有相应的权限才可以进行相应的操作。  

编号 | API | API描述
---|---|---
1 | *function setRole(address addr,string memory _role) public onlyOwner* | 设置给某个地址设置某个角色
2 | *function resetRole(address addr,string memory _role) public onlyOwner* | 移除某个地址的某个角色
3 | *function add(uint a,uint b) public view onlyRole(ADD) returns(uint)*  | 加
4 | *function sub(uint a,uint b) public view onlyRole(SUB) returns(uint)*  | 减
5 | *function mul(uint a,uint b) public view onlyRole(MUL) returns(uint)*  | 乘
6 | *function div(uint a,uint b) public view onlyRole(DIV) returns(uint)*  | 除

