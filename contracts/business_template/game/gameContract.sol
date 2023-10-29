pragma solidity>=0.4.24 <0.6.11;


contract gameContract{
    
    struct User {
        string UserName;
        address UserAddress;
        uint256 balances;
        uint[] jineng;
    }
    
    mapping(address => User) UserMap;
    address[] public zdUsers;
    
    function addUser(string memory name,address useraddress,uint256 balances,uint[] memory jineng) public returns(bool){
        require(jineng.length<=6,"jineng length false");
        User memory newUser = User(name,useraddress,balances,jineng);
        zdUsers.push(useraddress);
        UserMap[useraddress] = newUser;
        return true;
    }
    
    function getUser(address useraddress)public view returns(string memory,address,uint256,uint[] memory){
        User memory user = UserMap[useraddress];
        return (user.UserName,user.UserAddress,user.balances,user.jineng);
    }
    
    //技能添加
    function addjineng(address useraddress, uint256 jnid) public returns (bool) {
        User storage user = UserMap[useraddress];
        uint[] storage jineng = user.jineng;
        for(uint i =0; i<jineng.length; i++){
            if(jineng[i] < 1){
                jineng[i] = jnid;
                user.jineng = jineng;
            }
        }
        if(jineng.length <6){
            jineng.push(jnid);
            user.jineng = jineng;
            return true;
        }
            return false;
    }
 //删除技能
    function tionjineng(address useraddress, uint256 jnid) public  returns (uint256[] memory) {
        User storage user = UserMap[useraddress];
        uint[] storage jineng = user.jineng;
        for(uint8 i = 0; i<jineng.length; i++){
           if(jineng[i] == jnid){
               delete jineng[i];
           } 
        }
        
        return user.jineng;
    }
     
    function addbalances(address useraddress, uint256 _balances) public returns(uint256){
        User storage user = UserMap[useraddress];
        user.balances += _balances;
        return user.balances;
    }
    function subbalances(address useraddress, uint256 _balances) public returns(uint256){
        User storage user = UserMap[useraddress];
        if(user.balances> _balances){
            user.balances -= _balances;
            return user.balances;
        }
        
        
    }
}