pragma solidity ^0.6.10;

import './UserStorage.sol';

contract SharedBikes {

    uint32 public userCreditThreshold = 60;
    address public admin;
    UserStorage public userStorage;

    constructor() public{
        admin = msg.sender;
        userStorage = new UserStorage(address(this));
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


    struct Bike {
        BikeStatus status;
    }

    enum BikeStatus {
        NotExist,
        Available,
        InBorrow,
        InRepair
    }

    event RegisterBike(uint256 indexed bikeId);
    event RevokeBike(uint256 indexed bikeId);
    event BorrowBike(address indexed borrower, uint256 indexed bikeId);
    event ReturnBike(address indexed borrower, uint256 indexed bikeId);
    event ReportDamage(address indexed reporter, uint256 indexed bikeId);
    event FixDamage(uint256 indexed bikeId);
    event Reward(address indexed borrower, uint32 credits);
    event Punish(address indexed borrower, uint32 credits);
    event SetCreditThreshold(uint32 newThreshold);
    event TransferAdmin(address oldAdmin, address newAdmin);

    uint256 private _bikeCount;
    mapping(uint256=>Bike) private _bikes;
    mapping(address=>uint256) private _borrows;

    // Business functions
    function registerBike() external onlyAdmin returns(uint256 bikeId) {
        _bikeCount++;
        bikeId = _bikeCount;
        Bike storage bike = _bikes[bikeId];
        bike.status = BikeStatus.Available;
        emit RegisterBike(bikeId);
    }

    function revokeBike(uint256 bikeId) external onlyAdmin requireStatus(bikeId, BikeStatus.Available){
        Bike storage bike = _bikes[bikeId];
        bike.status = BikeStatus.NotExist;
        emit RevokeBike(bikeId);
    }

    function borrowBike(uint256 bikeId) external userRegistered(msg.sender) requireStatus(bikeId, BikeStatus.Available){
        require(_borrows[msg.sender] == 0, "user in borrow");
        require(userStorage.getCredits(msg.sender) >= userCreditThreshold, "not enough credits");
        _borrows[msg.sender] = bikeId;
        emit BorrowBike(msg.sender, bikeId);
    }

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
        bike.status = BikeStatus.InRepair;
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











