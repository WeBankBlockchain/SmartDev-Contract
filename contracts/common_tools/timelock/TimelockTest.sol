pragma solidity ^0.6.10;

/*
 * @dev 时间锁测试合约测试
 */
contract TimelockTest{
    address private timelock;

    struct User{
        string name;
        uint256 age;
    }

    mapping(uint256 => User) userMap;

    constructor(address _timelockAddress) public {
        timelock = _timelockAddress;
    }

    modifier onlyTimelock(){
        require(msg.sender == timelock,"Call must come from Timelock");
        _;
    }

    function addUser(uint256 id,string memory name,uint256 age) public onlyTimelock{
        User memory user = User(name,age);
        userMap[id] = user;
    }

    function getUser(uint256 id) public view returns(string memory,uint256){
        User memory user = userMap[id];
        return (user.name,user.age);
    }
}