pragma solidity ^0.6.10;

import './UserStorage.sol';


contract SharedBikes {

    uint32 public userCreditThreshold = 60;
    address public admin;
    UserStorage public userStorage;

   

    //使用合约地址构造，指定要获取的对象
    constructor(address _address) public{
        admin = msg.sender;
        address addr=address(_address);
        userStorage =UserStorage(addr);
       
    }   

    modifier onlyAdmin(){
        require(msg.sender == admin, "admin required");
        _;
    }

    modifier userRegistered(address user){
        require(userStorage.exists(user), "user not registered");
        _;
    }

    modifier requireStatus(uint256 bikeId, BikeStatus bikeStatus){
        require(_bikes[bikeId].status == bikeStatus, "bad bike status");
        _;
    }

/**
 * 定义单车状态对象
 */
    struct Bike {
        BikeStatus status;
    }
    /**
     * 定义一个枚举，以便可以使用数字代表单车的状态
     * 不存在 0 ,可使用 1 ,已借出 2 ,修理中 3
     */
    enum BikeStatus {
        NotExist,
        Available,
        InBorrow,
        InRepair
    }

    
    event RegisterBike(uint256 indexed bikeId);//注册
    event RevokeBike(uint256 indexed bikeId);//废除
    event BorrowBike(address indexed borrower, uint256 indexed bikeId);//借出
    event ReturnBike(address indexed borrower, uint256 indexed bikeId);//归还
    event ReportDamage(address indexed reporter, uint256 indexed bikeId);//报告损坏
    event FixDamage(uint256 indexed bikeId);//修复损坏
    event Reward(address indexed borrower, uint32 credits);//奖励
    event Punish(address indexed borrower, uint32 credits);//惩罚
    event SetCreditThreshold(uint32 newThreshold);//设置信用阈值
    event TransferAdmin(address oldAdmin, address newAdmin);//转移使用者
    
    //自增单车ID
    uint256 private _bikeCount;
    //存储不同单车的状态
    mapping(uint256=>Bike) private _bikes;
    //存储用户借用
    mapping(address=>uint256) private _borrows;

    // Business functions
    //增
    function registerBike() external onlyAdmin returns(uint256 bikeId) {
        _bikeCount++;
        bikeId = _bikeCount;
        Bike storage bike = _bikes[bikeId];
        bike.status = BikeStatus.Available;
        emit RegisterBike(bikeId);
    }

//  function getUser() external returns (string memory, string memory, uint32, uint32) {
//     require(userStorage.exists(msg.sender), "user not exists");
//     (string memory name, string memory contact, uint32 creditPoints, uint32 status) = userStorage.getUser();
//     return (name, contact, creditPoints, status);
// }
//  function ex() external view returns(bool){
//     bool b= userStorage.exists(msg.sender);
//     return b;
//  }

    //删
    function revokeBike(uint256 bikeId) external onlyAdmin requireStatus(bikeId, BikeStatus.Available){
        Bike storage bike = _bikes[bikeId];
        //修改单车状态为不存在
        bike.status = BikeStatus.NotExist;
        emit RevokeBike(bikeId);
    }
    //借
    function borrowBike(uint256 bikeId) external userRegistered(msg.sender) requireStatus(bikeId, BikeStatus.Available){
        //判断是否已经借出
        require(_borrows[msg.sender] == 0, "user in borrow");
        //判断用户信用分数
        require(userStorage.getCredits(msg.sender) >= userCreditThreshold, "not enough credits");

        //修改借用者状态
        _borrows[msg.sender] = bikeId;
        //修改自行车状态
        Bike storage bike = _bikes[bikeId];
        bike.status = BikeStatus.InBorrow;

        emit BorrowBike(msg.sender, bikeId);
    }
    //还
    function returnBike(uint256 bikeId) external  userRegistered(msg.sender) requireStatus(bikeId, BikeStatus.InBorrow){
        require(_borrows[msg.sender] == bikeId, "not borrowing this one");
        _borrows[msg.sender] = 0;
        Bike storage bike = _bikes[bikeId];
        bike.status = BikeStatus.Available;
        emit ReturnBike(msg.sender, bikeId);
    }

    function reportDamge(uint256 bikeId) external  userRegistered(msg.sender) requireStatus(bikeId, BikeStatus.Available){
        Bike storage bike = _bikes[bikeId];
        bike.status = BikeStatus.InRepair;
        emit ReportDamage(msg.sender, bikeId);
    }

    function fixDamge(uint256 bikeId) external onlyAdmin requireStatus(bikeId, BikeStatus.InRepair){
        Bike storage bike = _bikes[bikeId];
        bike.status = BikeStatus.Available;
        emit FixDamage(bikeId);
    }
    
    function reward(address user, uint32 credits) external userRegistered(user) onlyAdmin{
        userStorage.addCredits(user, credits);
        emit Reward(user, credits);
    }

    function punish(address user, uint32 credits) external userRegistered(user) onlyAdmin{
        userStorage.subCredits(user, credits);
        emit Punish(user, credits);
    }

    // Governance functions
    function setCreditThreshold(uint32 newThreshold) external onlyAdmin {
        userCreditThreshold = newThreshold;
        emit SetCreditThreshold(newThreshold);
    }

    function transferAdmin(address newAdmin) external onlyAdmin {
        address oldAdmin = admin;
        admin = newAdmin;
        emit TransferAdmin(oldAdmin, newAdmin);
    }
}











