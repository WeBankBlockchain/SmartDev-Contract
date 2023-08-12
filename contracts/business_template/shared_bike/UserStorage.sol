pragma solidity ^0.6.10;



contract UserStorage{

    address public admin;
    

    struct User {
        string name;
        string contact;
        uint32 creditPoints;
        uint32 status;
    }

    User public users;

    mapping(address=>User) public registeredUsers;

    //直接用调用者作为admin地址
    constructor() public{
        admin = msg.sender;
    }
    //由于通过SharedBike来调用的合约，获取到的msg.sender为调用合约的地址并非SharedBike的调用者
    // modifier onlyAdmin(){
    //     require(msg.sender== admin , "uadmin required");
    //     _;
    // }

    event RegisterUser(address indexed addr, string name, string contact);


  

    function registerUser(string memory name, string memory contact) external {
        //if status==0,is new User
        require(!exists(msg.sender), "user existed");
        // User storage user = registeredUsers[msg.sender];
        // user.name = name;
        // user.contact = contact;
        registeredUsers[msg.sender].name = name;
        registeredUsers[msg.sender].contact = contact;
        registeredUsers[msg.sender].status = 1;
        registeredUsers[msg.sender].creditPoints = 100;
        
        
       
        

        emit RegisterUser(msg.sender, name, contact);
    }

    function getCredits(address user) external view returns(uint32 credits) { 
        require(exists(user), "user not exists");       
        return registeredUsers[user].creditPoints;
    }

    function exists(address user) public view returns(bool) {
        // bool b=(registeredUsers[user].status != 0);
        return registeredUsers[user].status != 0;
    }

    function addCredits(address user, uint32 credits) public  {
        
        require(exists(user), "user not exists");   
        // 0信誉就不能加分了吗
        // require(credits > 0, "credits zero");
        uint32 newPoint = registeredUsers[user].creditPoints + credits;
        // require(newPoint >= credits, "overflow");
        registeredUsers[user].creditPoints= newPoint;
    }

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
         
        // require(newPoint <= credits, "overflow");错误的比较100-10=90，90>10不成立，无意义的比较
        registeredUsers[user].creditPoints= newPoint;
    }
}