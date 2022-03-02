pragma solidity ^0.6.10;

contract UserStorage{

    address public admin;

    struct User {
        string name;
        string contact;
        uint32 creditPoints;
        uint32 status;
    }

    mapping(address=>User) private registeredUsers;

    constructor(address _admin) public{
        admin = _admin;
    }

    modifier onlyAdmin(){
        require(msg.sender == admin, "admin required");
        _;
    }

    event RegisterUser(address indexed addr, string name, string contact);

    function registerUser(string memory name, string memory contact) external {
        require(!exists(msg.sender), "user existed");
        User storage user = registeredUsers[msg.sender];
        user.name = name;
        user.contact = contact;
        emit RegisterUser(msg.sender, name, contact);
    }

    function getCredits(address user) external view returns(uint32 credits) { 
        require(exists(user), "user not exists");       
        return registeredUsers[user].creditPoints;
    }

    function exists(address user) public view returns(bool) {
        return registeredUsers[user].status != 0;
    }

    function addCredits(address user, uint32 credits) public onlyAdmin {
        require(credits > 0, "credits zero");
        require(exists(user), "user not exists");   
        uint32 newPoint = registeredUsers[user].creditPoints + credits;
        require(newPoint > credits, "overflow");
        registeredUsers[user].creditPoints= newPoint;
    }

    function subCredits(address user, uint32 credits) public onlyAdmin {
        require(credits > 0, "credits zero");
        require(exists(user), "user not exists");   
        uint32 newPoint = registeredUsers[user].creditPoints - credits;
        require(newPoint < credits, "overflow");
        registeredUsers[user].creditPoints= newPoint;
    }
}