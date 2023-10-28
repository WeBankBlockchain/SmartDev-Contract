// SPDX-License-Identifier: GPL-2.0-or-laterpragma sol
pragma solidity ^0.6.10;
pragma experimental ABIEncoderV2;

import "./utils/Ownable.sol";
import "./utils/Roles.sol";
// 申诉管理
// 问题：
// 1. 各参赛队提出合理诉求，如何以最快解决诉求
// 2. 某些问题一定程度解决后，各参赛队不信任裁判及仲裁


contract AppealManagerment is Ownable {
    using Roles for Roles.Role;

    struct Appeal {
        string title; // 诉求标题
        string detail; // 诉求详情
        string from; // 来自学校
        bool resolve; // 是否解决
    }

    struct School {
        string name; // 学校名
        uint8 count; // 诉求数量
        uint256[] index; // 存储Resolve索引
        bool used; // 是否已注册
    }

    struct Resolove {
        string solution; // 解决方案
        bool flag; // 是否为合理诉求(不合理不予解决)
    }

    // 公开所有信息
    Appeal[] public appeals; // 诉求
    uint256 public schoolCount; // 已注册学校总数
    uint256 public endTime; // 结束时间
    Resolove[] public resolves; // 诉求解决方案

    mapping(address => School) public schools;
    Roles.Role private schoolRoles;

    event AddSchool(address indexed _index);
    event AddAppeal(uint256 indexed _index);

    modifier onlyRegister() {
        require(_existSchool(), "info: schoolRoles does not add school");
        _;
    }


    // 将所有参赛学校地址入库
    constructor(address[] memory _schools) public {
        // 申诉时间为7天内
        endTime = block.timestamp + 7 days;
        
        for(uint i = 0; i < _schools.length; i++) {
            if(!_existSchool(_schools[i])) { // 防止重复注册
                schoolRoles.add(_schools[i]);
            }
        }
    }
    
    // 添加参赛学校
    // 条件：只有参赛学校可以添加
    function addSchool(string memory name) public onlyRegister {
        require(!schools[msg.sender].used, "info: school already exist");
        schools[msg.sender] = School(name, 0,new uint256[](0),true);
        schoolCount += 1;
        emit AddSchool(msg.sender);
    }

    // 添加诉求
    // 条件：特定时间内的各校参赛队
    // 每个学校至多只能提交三个诉求
    function addAppeal(string memory title, string memory detail) public onlyRegister {
        require(schools[msg.sender].used, "info: school does already exist");
        require(block.timestamp < endTime, "info: appeal time already expired");
        require(schools[msg.sender].count <= 3, "info: appeal have been more than 3"); 
        appeals.push(Appeal(
            title,
            detail,
            schools[msg.sender].name,
            false
        ));
        schools[msg.sender].index.push(appeals.length - 1);
        schools[msg.sender].count += 1;
        emit AddAppeal(appeals.length - 1);
    }

    // 解决诉求
    function addResolve(uint256 _index,string memory _solution, bool _flag) public onlyOwner {
        // uint256 index = resolves[_index];
        resolves[_index].solution = _solution;
        resolves[_index].flag = _flag; 
    }

    // 各参赛学校提交是否解决诉求情况
    function updateAppealResolve(uint256 _resolveIndex, bool isResolve) public onlyRegister {
        require(_existResolve(_resolveIndex), "info: Please input the correct index");
        appeals[_resolveIndex].resolve = isResolve;
    }

    function _existResolve(uint256 _resolveIndex) private view returns(bool) {
        for(uint256 i = 0; i < schools[msg.sender].index.length; i++) {
            if(schools[msg.sender].index[i] == _resolveIndex) return true;
        }
    }

    function _existSchool() internal view returns(bool) {
        return schoolRoles.has(msg.sender);
    }

    function _existSchool(address _addr) internal view returns(bool) {
        return schoolRoles.has(_addr);
    }

} 