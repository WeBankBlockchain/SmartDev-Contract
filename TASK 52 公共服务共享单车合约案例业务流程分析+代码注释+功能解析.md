# 公共服务共享单车合约案例业务流程分析+代码注释+功能解析

> 作者： 
>
> - 深圳职业技术大学 彭添淞
> - 开源指导老师：张宇豪

本合约来自仓库：https://smartdev-doc.readthedocs.io/zh_CN/latest/docs/WeBankBlockchain-SmartDev-Contract/quick_start.html

| 合约名称    | 案例名称 | 案例功能           |
| ----------- | -------- | ------------------ |
| SharedBikes | 共享单车 | 实现共享单车的案例 |

本文章我们将会带大家如何去入手一个合约的案例项目，从如何对合约的功能场景进行分析，并对整体的业务使用流程图等方式进行展示，对业务快速上手之后，我们可以进行业务的扩展，所以通过本文章你可以学到如何从一个0注释的合约项目进行添加注释解析，分析业务场景，实现业务扩展。



## 1.合约源代码

### 1.1 UserStorage合约	

```solidity
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
```



### 1.2 SharedBikes合约

```solidity
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

```

> 上面的代码并没有注释：
>
> - 首先，我们需要进行对结构体和数据存储使用到的变量进行分析，我们查看到了User和Bike的结构体
> - 然后，我们需要判断当前两个合约谁是主合约，ShareBikes中使用了import，所有该合约作为主合约
> - 然后，我们分析UserStorage的合约业务函数，可以看出当前和合约是作为用户相关的业务操作
> - 最后，分析SharedBikes合约的业务函数，该合约提供了，添加共享单车、注销共享单车、报告修理、维修单车，以及租借和归还单车，包括权限的转换。
>
> 注意： 可以先通过函数名去判断当前函数是什么样的业务



## 2.案例的流程分析

### 2.1 案例流程图

将如上分析的业务以及流程，简单的转换成流程图，这里流程图不需要很标准，理清一个案例的主要功能即可。

![截图 2023-08-18 13-00-52](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/截图 2023-08-18 13-00-52.png)



### 2.2 案例的场景分析

> 如下的几个场景分析比较适合该案例

基于区块链的共享单车在智能合约的支持下，可以带来一些有趣的场景和优势。以下是一些基于区块链的共享单车的场景分析：

1. **透明的租借流程：** 区块链可以为租借单车提供透明度。用户可以在区块链上记录租借和归还的过程，确保数据的可追溯性和不可篡改性。这可以消除任何不公平的争议，提高用户信任度。
2. **智能合约的自动执行：** 使用智能合约，租借和归还单车的流程可以自动执行。例如，当用户借走单车时，合约可以自动锁定用户一定金额，归还时则自动解锁。这消除了需要中介的需求，提高了效率。
3. **信用积分系统：** 基于区块链的共享单车可以实施信用积分系统，鼓励用户良好行为，如按时归还、遵守交通规则等。用户积累的信用积分可以用于获取更好的租借条件、折扣等。
4. **防盗和安全性：** 区块链可以用于跟踪单车的位置和状态，从而减少盗窃和损坏的风险。如果单车的状态发生异常变化，可以立即触发报警或自动将单车标记为“维修中”。
5. **用户激励和治理：** 区块链可以为共享单车建立去中心化的用户社区。用户可以参与决策，例如制定规则、管理信用积分系统等，增强用户参与感。



**存储方面**

在本案例中使用的是`mapping`的方式进行存储，`mapping` 需要在区块链上持久化存储数据，而存储数据是昂贵的。大量使用`mapping`会增加合约的存储成本，导致需要更多的Gas费用来执行操作。Solidity中的`mapping`并不适合迭代和遍历，这使得获取`mapping`中的所有值变得复杂。如果需要在合约中执行大规模的数据分析或迭代操作，使用`mapping`可能会限制功能。`mapping` 中的数据是公开的，任何人都可以查看。所以在更加复杂的业务的时候存储可以考虑Table。



**租借场景**

在生活中，共享单车租借会计算时间，然后通过计算时间去扣取对应的金额，所以我们可以在租借的时候设置一个有效的时间，如果超过该时间则会增加对应的金额，同时还需要考虑租借共享单车需要按时间计算金额，所以我们还可以继续拓展业务，比如增加对每一个共享单车的最小时长金额。



**信用积分场景**

在上面说到，鼓励用户良好行为，如按时归还、主动提交报修、遵守交通规则等。用户积累的信用积分可以用于获取更好的租借条件、折扣等。我们可以根据用户设定的一个信用积分的阈值，然后进行判断，假如当前的信誉积分默认是60，但是达到了100。用户可以享受折扣租借。



## 3.代码注释以及功能解析

经过如上的分析之后，我们添加如下的所有注释。

### 3.1 UserStorage添加注释

**函数 `registerUser(string memory name, string memory contact) external`：**

- 允许用户注册并存储信息。

**函数 `getCredits(address user) external view returns(uint32 credits)`：**

- 查询用户的积分数量。

**函数 `exists(address user) public view returns(bool)`：**

- 检查用户是否已注册。

**函数 `addCredits(address user, uint32 credits) public onlyAdmin`：**

- 增加用户积分，仅管理员可操作。

**函数 `subCredits(address user, uint32 credits) public onlyAdmin`：**

- 减少用户积分，仅管理员可操作。

```solidity
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
```



### 3.2 SharedBikes添加注释

**函数 `registerBike() external onlyAdmin returns(uint256 bikeId)`：**

- 描述：管理员注册一辆新的共享单车。
- 返回值：新注册的单车的 ID。

**函数 `revokeBike(uint256 bikeId) external onlyAdmin requireStatus()`：**

- 描述：管理员注销一辆共享单车。

**函数 `borrowBike(uint256 bikeId) external userRegistered(msg.sender) requireStatus()`：**

- 描述：用户借走一辆共享单车。

**函数 `returnBike(uint256 bikeId) external userRegistered(msg.sender) requireStatus()`：**

- 描述：用户归还一辆共享单车。

**函数 `reportDamge(uint256 bikeId) external userRegistered(msg.sender) requireStatus()`：**

- 描述：用户报告一辆共享单车损坏。

**函数 `fixDamge(uint256 bikeId) external onlyAdmin requireStatus()`：**

- 描述：管理员修复一辆共享单车损坏。

**函数 `reward(address user, uint32 credits) external userRegistered(user) onlyAdmin`：**

- 描述：管理员对用户进行信用积分奖励。

**函数 `punish(address user, uint32 credits) external userRegistered(user) onlyAdmin`：**

- 描述：管理员对用户进行信用积分惩罚。

**函数 `setCreditThreshold(uint32 newThreshold) external onlyAdmin`：**

- 描述：管理员设置用户信用积分阈值。

**函数 `transferAdmin(address newAdmin) external onlyAdmin`：**

- 描述：管理员权限转让给新的管理员。

```solidity
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
```





### 3.3 扩展功能

在上面所讲到的信用积分部分，我们在ShareBikes合约中，加了freeTime字段，控制在2小时之内免费租借共享单车，如果超时，则扣取1分的积分。

> 我们可以根据自己的需求，然后再类似逐步添加扩展的功能。

```solidity

uint256 public freeTime;

/**
 * 租借单车
 */
function borrowBike(uint256 bikeId) external userRegistered(msg.sender) requireStatus(bikeId, BikeStatus.Available){
    require(_borrows[msg.sender] == 0, "user in borrow");
    require(userStorage.getCredits(msg.sender) >= userCreditThreshold, "not enough credits");
    _borrows[msg.sender] = bikeId;
    // 在租借的时候将该时间设置为2小时后
    freeTime = block.timestamp + 2 hours * 1000;
    emit BorrowBike(msg.sender, bikeId);
}

/**
 * 归还单车
 */ 
function returnBike(uint256 bikeId) external  userRegistered(msg.sender) requireStatus(bikeId, BikeStatus.InBorrow){
    require(_borrows[msg.sender] == bikeId, "not borrowing this one");
    _borrows[msg.sender] = 0;
    // 在归还单车的时候进行简单的超时判断
    if (block.timestamp > freeTime){
        userStorage.subCredits(msg.sender,1);
    }
    Bike storage bike = _bikes[bikeId];
    bike.status = BikeStatus.Available;
    emit ReturnBike(msg.sender, bikeId);
}
```