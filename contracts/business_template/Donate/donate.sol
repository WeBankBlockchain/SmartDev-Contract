// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Donate {

    // 定义捐款人结构体
    struct Donor {
        address donorAddress; // 捐款人地址
        string name; // 捐款人姓名
        uint256 amount; // 捐款金额
        uint256 timestamp; // 捐款时间戳
    }

    // 定义公益项目结构体
    struct Project {
        string name; // 项目名称
        string description; // 项目描述
        uint256 targetAmount; // 目标金额
        uint256 currentAmount; // 当前金额
        uint256 deadline; // 截止时间戳
        bool completed; // 是否完成
        bool withdrawn; // 是否提取过
        uint256 voteCount; // 投票数
    }
  

    // 定义捐款人和项目的映射关系
    mapping (address => Donor[]) public donors;
    mapping (string => Project) public projects;
     mapping(address => bool) private voted;

    // 定义事件，用于记录捐款行为和投票行为
    event Donation(address indexed donor, string indexed projectName, uint256 amount, uint256 timestamp);
    event Vote(address indexed voter, string indexed projectName, uint256 timestamp);

    // 定义构造函数，用于初始化一些默认的项目
    constructor() {
        createProject("Save the Children", "A project to help children in need", 10 ether, 30);
        createProject("Clean the Ocean", "A project to reduce plastic pollution in the ocean", 20 ether, 60);
        createProject("Plant the Trees", "A project to restore the forest and combat climate change", 30 ether, 90);
    }

    // 定义函数，用于捐款
    function donate(string memory projectName, string memory donorName) public payable {
        require(msg.value > 0, "Donation amount should be greater than zero"); // 检查捐款金额是否大于0
        require(msg.value <= 10 ether, "Donation amount should be less than or equal to 10 ether"); // 检查捐款金额是否小于或等于10 ether
        require(bytes(projectName).length > 0, "Project name should not be empty"); // 检查项目名称是否为空
        require(bytes(donorName).length > 0, "Donor name should not be empty"); // 检查捐款人姓名是否为空

        require(projects[projectName].deadline > 0, "Project does not exist"); // 检查项目是否存在，如果不存在就抛出错误信息

        require(!projects[projectName].completed, "Project is already completed"); // 检查项目是否已经完成，如果是就抛出错误信息

        require(!checkProjectExpired(projectName), "Project is already expired"); // 检查项目是否已经过期，如果是就抛出错误信息

        // 更新项目当前金额
        projects[projectName].currentAmount += msg.value;

        // 添加捐款人信息
        donors[msg.sender].push(Donor(msg.sender, donorName, msg.value, block.timestamp));

        // 触发事件，记录捐款行为
        emit Donation(msg.sender, projectName, msg.value, block.timestamp);

        // 检查项目是否已经完成，如果是就更新状态
        checkProjectCompleted(projectName);
    }

    // 定义函数，用于查询捐款人的捐款记录
    function getDonationHistory(address donorAddress) public view returns (Donor[] memory) {
        return donors[donorAddress];
    }

    // 定义函数，用于查询项目当前金额（单位为ether）
    function getCurrentAmount(string memory projectName) public view returns (uint256) {
        return projects[projectName].currentAmount ;
    }

    // 定义函数，用于查询项目是否完成
    function isProjectCompleted(string memory projectName) public view returns (bool) {
        return projects[projectName].completed;
    }

    // 定义函数，用于检查项目是否已经过期（单位为天）
    function checkProjectExpired(string memory projectName) public view returns (bool) {
        return block.timestamp > projects[projectName].deadline;
    }

    // 定义函数，用于创建新的公益项目
    function createProject(string memory projectName, string memory projectDescription, uint256 targetAmount, uint256 daysToDeadline) public {
        uint deadline = block.timestamp + (daysToDeadline * 1 days);//期望截止日期为当前的多少天后
        require(bytes(projectName).length > 0, "Project name should not be empty"); // 检查项目名称是否为空
        require(bytes(projectDescription).length > 0, "Project description should not be empty"); // 检查项目描述是否为空
        require(targetAmount > 0, "Target amount should be greater than zero"); // 检查目标金额是否大于0
        require(deadline + block.timestamp > block.timestamp, "Deadline should be in the future"); // 检查截止日期是否在未来

        // 添加新的公益项目
        projects[projectName] = Project(projectName, projectDescription, targetAmount, 0, deadline, false, false, 0);
    }

    // 定义函数，用于检查项目是否已经完成
    function checkProjectCompleted(string memory projectName) internal {
        if (projects[projectName].currentAmount >= projects[projectName].targetAmount) {
            projects[projectName].completed = true;
        }
    }

    // 定义函数，用于投票
    function vote(string memory projectName) public {
        require(projects[projectName].deadline > 0, "Project does not exist"); // 检查项目是否存在，如果不存在就抛出错误信息

        require(!projects[projectName].completed, "Project is already completed"); // 检查项目是否已经完成，如果是就抛出错误信息

        require(!checkProjectExpired(projectName), "Project is already expired"); // 检查项目是否已经过期，如果是就抛出错误信息

        require(donors[msg.sender].length > 0, "You must donate before voting"); // 检查捐款人是否有捐款记录，如果没有就抛出错误信息

            
        // 新增变量，用于存储每个地址是否已经投过票
        // mapping(address => bool) private voted;

        // 新增判断条件，检查地址是否已经投过票，如果是就抛出错误信息
        require(!voted[msg.sender], "You have already voted");

        // 更新项目投票数
        projects[projectName].voteCount++;

        // 触发事件，记录投票行为
        emit Vote(msg.sender, projectName, block.timestamp);

         voted[msg.sender] = true;
    }

    // 定义函数，用于查询项目投票数
    function getVoteCount(string memory projectName) public view returns (uint256) {
        return projects[projectName].voteCount;
    }

    // 定义函数，用于提取捐款
    function withdraw(string memory projectName) public {
        require(msg.sender == address(this), "Only contract owner can withdraw"); // 检查调用者是否是合约拥有者，如果不是就抛出错误信息
        require(isProjectCompleted(projectName) || checkProjectExpired(projectName), "Project is not completed or expired"); // 检查项目是否已经完成或者过期，如果不是就抛出错误信息
        require(!projects[projectName].withdrawn, "Project is already withdrawn"); // 检查项目是否已经提取过，如果是就抛出错误信息

        require(projects[projectName].voteCount > 0, "Project must have at least one vote to withdraw"); // 新增判断条件，检查项目是否有至少一个投票，如果没有就抛出错误信息

        // 转账到指定地址
        payable(msg.sender).transfer(projects[projectName].currentAmount);

        // 清空项目金额
        projects[projectName].currentAmount = 0;

        // 更新项目提取状态
        projects[projectName].withdrawn = true;
    }
}
