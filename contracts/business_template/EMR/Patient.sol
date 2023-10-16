pragma solidity ^0.4.25;

import "StrUtils.sol";
import "Roles.sol";
import "Ownable.sol";

// ## 患者基本信息
contract Patient is Ownable {
    using StrUtils for *;
    using Roles for Roles.Role;
    struct PatientInfo{
        string id; // 身份证
        string name; // 姓名
        string age;
        uint sex;
        string phone;
    }
    
    // Roles.Role private patients;
    
    modifier isNull(string id, string name, string age, uint sex, string phone) {
        require(patientInfos[id].id.toSlice().len() == 0); // 存在不再创建
        require(id.toSlice().len() == 18, "ID card is less than 18 digits"); // 身份证长度校验
        require(name.toSlice().len() >= 2, "Name card is less than 2 digits"); // 名字长度校验
        require(age.toSlice().len() > 0, "Age card is less than 1 digits"); // 年龄
        require(sex == 0 || sex == 1, "Only 1 and 0 can be entered for gender"); // 性别校验
        require(phone.toSlice().len() == 11, "Phone card is less than 11 digits"); // 电话号码
        _;
    }
    
    modifier checkAddr(address addr, string id) {
        require(addr != address(0) && registers[id] == addr, "The user does not exist.");
        _;
    }
    
    modifier checkViewAddr(address addr, string id) {
        require(addr != address(0) && views[id][addr], "You do not have permission to view"); //无授权者无法查看
        _;
    }
    
    mapping(string => PatientInfo) patientInfos;
    mapping(string => mapping(address => bool)) views; // 查看权限; 病人 => 医生(多个并包括自己)
    mapping(string => address) registers; // 用户权限
    // mapping(string => )
    
    
    constructor(address addr) public Ownable(addr) {
        
    } 
    
    function addPatient(
        string memory id,
        string memory name,
        string memory age,
        uint sex,
        string memory phone
        ) public isNull(id, name, age, sex, phone) {
            PatientInfo memory patientInfo = PatientInfo(
               id,
               name,
               age,
               sex,
               phone
            );
            patientInfos[id] = patientInfo;
            views[id][msg.sender] = true; // 授权患者查看自己信息权限
            // patients.add(msg.sender);
    }
    
    function updateAge(string memory id, string memory age) public checkAddr(msg.sender, id)  {
        require(age.toSlice().len() > 0);
        patientInfos[id].age = age;
    } 
    
    function updatePhone(string memory id, string memory phone) public checkAddr(msg.sender, id) {
        require(phone.toSlice().len() > 0);
        patientInfos[id].phone = phone;
    }
    
    // 挂号
    function registration(
        string id,
        address doctorAddr
    ) external checkAddr(msg.sender, id) {
        views[id][doctorAddr] = true;    
    }
    
    // 由系统管理者强制授权基本信息
    function authDoctor(
        string id,
        address doctorAddr
    ) external onlyOwner {
        views[id][doctorAddr] = true;
    }
    
    // @returns
    // string name; // 姓名
    // string age;
    // uint sex;
    // string phone;
    function getPatientBaseInfo(
        string memory id
    ) public checkViewAddr(msg.sender, id) view returns(
        string memory,
        string memory,
        uint, 
        string memory
    ) {
        return (
            patientInfos[id].name,
            patientInfos[id].age,
            patientInfos[id].sex,
            patientInfos[id].phone
        );
    }
}