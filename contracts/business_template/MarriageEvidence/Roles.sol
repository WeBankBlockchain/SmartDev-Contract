pragma solidity^0.4.25;

library Roles{
    struct Role{
        mapping(address=>bool) bearer;
        mapping(address=>string) summary;
    }
    //判断角色
    function has(Role storage role,address amount)internal view returns(bool){
        require(amount!=address(0),"Address is zero address");
        return role.bearer[amount];
    }
    //添加角色
    function add(Role storage role,address amount,string _summary)internal{
        require(!has(role,amount),"Address already exists");
        role.bearer[amount] = true;
        role.summary[amount] = _summary;
    }
    //删除角色
    function remove(Role storage role,address amount)internal{
        require(has(role,amount),"Address does not exist");
        role.bearer[amount] = false;
    }
    //修改角色
    function revise(Role storage role,address amount,string _summary)internal {
        require(has(role,amount),"Address does not exist");
        role.summary[amount] = _summary;
    }
    //查询角色
    function seek(Role storage role,address amount)internal view returns(string){
        require(has(role,amount),"Address does not exist");
        return role.summary[amount];
    }
    
}