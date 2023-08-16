pragma solidity ^0.6.10;



contract UserStorage{

    address public admin;
    

    struct User {
        string name;            //姓名
        string contact;         //联系方式
        uint32 creditPoints;    //信誉分
        uint32 status;          //用户状态
    }//结构体，相当于User模板

    User public users;//用户信息对象

    //其中mapping对象储存用户信息，用户信息主要封装在这里
    mapping(address=>User) public registeredUsers;

    //直接用调用者作为admin地址
    constructor() public{
        admin = msg.sender;
    }
   
    event RegisterUser(address indexed addr, string name, string contact);

    //注册
    function registerUser(string memory name, string memory contact) external {
        //if status==0,is new User
        require(!exists(msg.sender), "user existed");
       
        registeredUsers[msg.sender].name = name;
        registeredUsers[msg.sender].contact = contact;
        registeredUsers[msg.sender].status = 1;
        registeredUsers[msg.sender].creditPoints = 100;
        
        emit RegisterUser(msg.sender, name, contact);
    }

    //查询信誉分
    function getCredits(address user) external view returns(uint32 credits) { 
        require(exists(user), "user not exists");       
        return registeredUsers[user].creditPoints;
    }

    //用户是否注册过
    function exists(address user) public view returns(bool) {
        //用户状态为0就是未注册
        return registeredUsers[user].status != 0;
    }

    //加分
    function addCredits(address user, uint32 credits) public  {
        
        require(exists(user), "user not exists");   
        
        uint32 newPoint = registeredUsers[user].creditPoints + credits;
        registeredUsers[user].creditPoints= newPoint;
    }

    //减分
    function subCredits(address user, uint32 credits) public  {
        require(exists(user), "user not exists");   
        require(credits > 0, "credits zero");
        
        //添加if判断，防止溢出
        uint32 newPoint=0;
        if (registeredUsers[user].creditPoints > credits) {
            newPoint = registeredUsers[user].creditPoints - credits;
        } else {
            newPoint = 0;
        }
        
        registeredUsers[user].creditPoints= newPoint;
    }
}