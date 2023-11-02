pragma solidity ^0.6.10;

// 用户数据存储合约
contract UserStorage{

    // 合约调用者
    address public admin;

    // 用户实体类
    struct User {
        string name;            // 用户名
        string contact;         // 联系方式
        uint32 creditPoints;    // 信用积分
        uint32 status;          // 用户状态
    }

    // 用于存储用户的信息
    mapping(address=>User) private registeredUsers;

    // 初始化合约的调用者地址
    constructor(address _admin) public{
        admin = _admin;
    }

    // 修饰符函数 只有合约调用者地址才有权限
    modifier onlyAdmin(){
        require(msg.sender == admin, "admin required");
        _;
    }
    // 用户注册事件
    event RegisterUser(address indexed addr, string name, string contact);

    /**
     * 用户注册
     * @param name 用户名称
     * @param contact 用户联系方式
     */
    function registerUser(string memory name, string memory contact) external {
    	// 判断当前用户是否已经注册
        require(!exists(msg.sender), "user existed");
        // 用户注册
        User storage user = registeredUsers[msg.sender];
        user.name = name;
        user.contact = contact;
        // 触发用户注册事件
        emit RegisterUser(msg.sender, name, contact);
    }

    /**
     * 查询用户积分
     * @param user      用户的地址
     * @return credits  用户的积分
     */
    function getCredits(address user) external view returns(uint32 credits) { 
     	// 判断当前用户是否已经注册
        require(exists(user), "user not exists");       
        return registeredUsers[user].creditPoints;
    }

    /**
     * 查询当前用户是否已经注册
     */
    function exists(address user) public view returns(bool) {
        return registeredUsers[user].status != 0;
    }

    /**
     * 添加积分
     * @param user 用户地址
     * @param credits 积分的数量
     */
    function addCredits(address user, uint32 credits) public onlyAdmin {
    	// 积分必须要大于0 用户需要已经注册
        require(credits > 0, "credits zero");
        require(exists(user), "user not exists");   
        uint32 newPoint = registeredUsers[user].creditPoints + credits;
        require(newPoint > credits, "overflow");
        registeredUsers[user].creditPoints= newPoint;
    }

    /**
     * 减少积分操作
     * @param user 用户地址
     * @param credits 积分的数量
     */
    function subCredits(address user, uint32 credits) public onlyAdmin {
    	// 积分必须要大于0 用户需要已经注册
        require(credits > 0, "credits zero");
        require(exists(user), "user not exists");   
        uint32 newPoint = registeredUsers[user].creditPoints - credits;
        require(newPoint < credits, "overflow");
        registeredUsers[user].creditPoints= newPoint;
    }
}