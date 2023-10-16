// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.10;

contract BatchExecutionTest{
    struct User{
        string name;
        uint256 age;
    }
    
    mapping(uint256 => User) userMap;
    
    //存储数据，方便查看测试结果
    User[] userList;
    
    function setUser(uint256 id,string memory name,uint256 age) public {
        User memory user = User(name,age);
        userMap[id] = user;
        userList.push(user);
    }
    
    function getUser(uint256 id) public view returns(string memory,uint256){
        User memory user = userMap[id];
        return (user.name,user.age);
    }
}