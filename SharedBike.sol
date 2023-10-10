pragma solidity ^0.6.10;

import './UserStorage.sol';

// 共享单车主合约
contract SharedBikes {

    // 类似于用户的信誉阈值
    uint32 public userCreditThreshold = 60;
    // 合约的调用者
    address public admin;
    // 用户的数据存储
    UserStorage public userStorage;

    // 初始化构造函数
    constructor() public{
        admin = msg.sender;
        userStorage = new UserStorage(address(this));
    }   
    // 修饰符判断当前只有管理员有权限
    modifier onlyAdmin(){
        require(msg.sender == admin, "admin required");
        _;
    }
    
    // 判断当前的用户是否已经注册
    modifier userRegistered(address user){
        require(userStorage.exists(user), "user not registered");
        _;
    }

    // 判断共享单车的状态
    modifier requireStatus(uint256 bikeId, BikeStatus bikeStatus){
        require(_bikes[bikeId].status == bikeStatus, "bad bike status");
        _;
    }

    // 存储单车的结构体
    struct Bike {
        BikeStatus status;
    }

    // 共享单车的状态
    enum BikeStatus {
        NotExist,
        Available,
        InBorrow,
        InRepair
    }
    // 注册单车事件：当管理员成功注册一辆新单车时触发
    event RegisterBike(uint256 indexed bikeId);
    
    // 注销单车事件：当管理员成功注销一辆单车时触发
    event RevokeBike(uint256 indexed bikeId);
    
    // 借车事件：当用户成功借走一辆单车时触发
    event BorrowBike(address indexed borrower, uint256 indexed bikeId);
    
    // 还车事件：当用户成功将借走的单车归还时触发
    event ReturnBike(address indexed borrower, uint256 indexed bikeId);
    
    // 报告损坏事件：当用户报告单车损坏时触发
    event ReportDamage(address indexed reporter, uint256 indexed bikeId);
    
    // 修复损坏事件：当管理员修复损坏的单车时触发
    event FixDamage(uint256 indexed bikeId);
    
    // 奖励事件：当管理员对用户进行信用积分奖励时触发
    event Reward(address indexed borrower, uint32 credits);
    
    // 惩罚事件：当管理员对用户进行信用积分惩罚时触发
    event Punish(address indexed borrower, uint32 credits);
    
    // 设置信用积分阈值事件：当管理员成功设置新的信用积分阈值时触发
    event SetCreditThreshold(uint32 newThreshold);
    
    // 转移管理员权限事件：当管理员权限成功转移时触发
    event TransferAdmin(address oldAdmin, address newAdmin);

	// 共享单车的总数全局变量
    uint256 private _bikeCount;
    // ID对应Bike的结构体
    mapping(uint256=>Bike) private _bikes;
    // 存储被用户租借的共享单车ID
    mapping(address=>uint256) private _borrows;

    /**
     * 共享单车公司进行添加共享单车
     */
    function registerBike() external onlyAdmin returns(uint256 bikeId) {
        _bikeCount++;
        bikeId = _bikeCount;
        Bike storage bike = _bikes[bikeId];
        bike.status = BikeStatus.Available;
        emit RegisterBike(bikeId);
    }

    /**
     * 注销单车
     * @param bikeId 共享单车ID
     */
    function revokeBike(uint256 bikeId) external onlyAdmin requireStatus(bikeId, BikeStatus.Available){
        Bike storage bike = _bikes[bikeId];
        bike.status = BikeStatus.NotExist;
        emit RevokeBike(bikeId);
    }

    /**
     * 租借单车
     * @param bikeId 共享单车ID
     */
    function borrowBike(uint256 bikeId) external userRegistered(msg.sender) requireStatus(bikeId, BikeStatus.Available){
    	// 判断当前的共享是否已经被租借
        require(_borrows[msg.sender] == 0, "user in borrow");
        // 判断当前用户的积分是否大于或者等于预设的信用积分阈值
        require(userStorage.getCredits(msg.sender) >= userCreditThreshold, "not enough credits");
        _borrows[msg.sender] = bikeId;
        emit BorrowBike(msg.sender, bikeId);
    }
    
    /**
     * 归还单车
     * @param bikeId 共享单车ID
     */ 
    function returnBike(uint256 bikeId) external  userRegistered(msg.sender) requireStatus(bikeId, BikeStatus.InBorrow){
    	// 判断当前的共享单车是否已经被借阅
        require(_borrows[msg.sender] == bikeId, "not borrowing this one");
        _borrows[msg.sender] = 0;
        Bike storage bike = _bikes[bikeId];
        bike.status = BikeStatus.Available;
        emit ReturnBike(msg.sender, bikeId);
    }
    
    /**
     * 报告损坏
     * @param bikeId 共享单车ID
     */
    function reportDamge(uint256 bikeId) external  userRegistered(msg.sender) requireStatus(bikeId, BikeStatus.Available){
        Bike storage bike = _bikes[bikeId];
        bike.status = BikeStatus.InRepair;
        emit ReportDamage(msg.sender, bikeId);
    }

    /**
     * 修复损坏
     * @param bikeId 共享单车ID
     */
    function fixDamge(uint256 bikeId) external onlyAdmin requireStatus(bikeId, BikeStatus.InRepair){
        Bike storage bike = _bikes[bikeId];
        bike.status = BikeStatus.InRepair;
    }

    /**
     * 奖励用户 
     * @param user 用户地址
     * @param credits 奖励积分数量
     */
    function reward(address user, uint32 credits) external userRegistered(user) onlyAdmin{
        userStorage.addCredits(user, credits);
        emit Reward(user, credits);
    }

    /**
     * 惩罚用户
     * @param user 用户地址
     * @param credits 惩罚积分数量
     */
    function punish(address user, uint32 credits) external userRegistered(user) onlyAdmin{
        userStorage.subCredits(user, credits);
        emit Punish(user, credits);
    }

    /**
     * 设置用户信用积分阈值
     * @param newThreshold 新的阈值
     */
    function setCreditThreshold(uint32 newThreshold) external onlyAdmin {
        userCreditThreshold = newThreshold;
        emit SetCreditThreshold(newThreshold);
    }

    /**
     * 权限转让
     */
    function transferAdmin(address newAdmin) external onlyAdmin {
        address oldAdmin = admin;
        admin = newAdmin;
        emit TransferAdmin(oldAdmin, newAdmin);
    }
}