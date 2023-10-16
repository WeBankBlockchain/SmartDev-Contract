pragma solidity ^0.4.25;

// import "StrUtils.sol";
import "Roles.sol";
import "Ownable.sol";
import "CaseHistoryManager.sol";

contract HospitalContract is Ownable, CaseHistoryManager {
    using Roles for Roles.Role; 
    // 医院信息
    struct Hospital {
        string ID;
        string hospitalName; // 医院名字
        string shortIntroduction; // 医院简介
        mapping(uint256 => Department) departments; // 院内涵盖的科室 => 及科室涵盖医生
        uint256 index;
    }
    
    // 科室信息
    struct Department {
        uint256 ID;
        string departmentName;
        string shortIntroduction; 
        uint visitTime; // 出诊时间
        string callSite; // 出诊地点
        string phone; // 咨询电话
        mapping(uint256 => Doctor) doctors;
        uint256 index;
    }
    
    // 医生信息
    struct Doctor {
        uint256 ID;
        string jobTitle; // 职称
        string doctorName; // 医生姓名
        string shortIntroduction; // 医生简介
    }

    modifier MustNoExist(string ID) {
        require(!hospitalRegisters[ID], "Add failed. Hospital already exists");
        _;
    }
    
    modifier MustYesExist(string ID) {
        require(hospitalRegisters[ID], "update failed. Hospital is exists");
        _;
    }
    
    
    // Roles.Role private hospitalManager; 
    mapping(string => Hospital) hospitalInfos; // 医院信息
    mapping(string => bool) hospitalRegisters;
    
    constructor(address owner) public Ownable(owner) CaseHistoryManager(owner) {
    }
    
    // 添加医院信息
    function addHospital(
        string memory ID,
        string memory hospitalName,
        string memory shortIntroduction,
        address hospitalAddr
        ) public onlyOwner MustNoExist(ID) {
            hospitalInfos[ID] = Hospital(ID, hospitalName, shortIntroduction, 0);
            // hospitalManager.add(hospitalAddr);
        }
    
    // 更新医院简介
    function updateHospitaShortIntroduction(
        string memory ID,
        string memory shortIntroduction
        ) public onlyOwner MustYesExist(ID) {
            hospitalInfos[ID].shortIntroduction = shortIntroduction;
        }    
        
    // 添加医院科室
    function addHospitalDepartment(
        string memory hospitalID,
        uint256 departmentID,
        string memory departmentName,
        string memory shortIntroduction,
        uint visitTime,
        string memory callSite,
        string memory phone
    ) public onlyOwner MustYesExist(hospitalID) {
            uint256 _index = hospitalInfos[hospitalID].index;
            Department memory department = Department(
                departmentID,
                departmentName,
                shortIntroduction,
                visitTime,
                callSite,
                phone,
                0
            );
            hospitalInfos[hospitalID].departments[_index] = department;
            _index = _index + 1;
            hospitalInfos[hospitalID].index = _index;
    }
    
    // 更新科室信息(简介)
    function updateDepartmentShortIntroduction(
        string memory hospitalID,
        uint256 departmentID,
        string memory shortIntroduction
        ) public onlyOwner MustYesExist(hospitalID) {
        require(hospitalInfos[hospitalID].index >= departmentID, "Department does not exist");
        hospitalInfos[hospitalID].departments[departmentID].shortIntroduction = shortIntroduction; 
    }
    
    // 更新科室(出诊时间)
    function updateDepartmentVisitTime(
        string memory hospitalID,
        uint256 departmentID,
        uint visitTime
        ) public onlyOwner MustYesExist(hospitalID) {
        require(hospitalInfos[hospitalID].index >= departmentID, "Department does not exist");
        hospitalInfos[hospitalID].departments[departmentID].visitTime = visitTime;
    }
    
    
    // 添加医生
    //@param uint256 ID;
    //@param string jobTitle; // 职称
    //@param string doctorName; // 医生姓名
    //@param string shortIntroduction; // 医生简介
    function addDoctor(
        string memory hospitalID,
        uint256 departmentID,
        string memory jobTitle,
        string memory doctorName,
        string memory shortIntroduction
        ) public onlyOwner MustYesExist(hospitalID) {
        require(hospitalInfos[hospitalID].index >= departmentID, "Department does not exist");
        uint256 _index = hospitalInfos[hospitalID].departments[departmentID].index;
        Doctor memory doctor = Doctor(
            _index,
            jobTitle,
            doctorName,
            shortIntroduction
        );
        hospitalInfos[hospitalID].departments[departmentID].doctors[_index] = doctor;
        _index = _index + 1;
        hospitalInfos[hospitalID].departments[departmentID].index = _index;
    }
    
    // 更新医生信息(职称)
    function updateDoctorJobTitle(
        string memory hospitalID,
        uint256 departmentID,
        uint256 doctorID,
        string memory jobTitle
        ) public onlyOwner MustYesExist(hospitalID) {
        require(hospitalInfos[hospitalID].index >= departmentID, "Department does not exist");
        require(hospitalInfos[hospitalID].departments[departmentID].index >= doctorID, "Doctor does not exist");
        hospitalInfos[hospitalID].departments[departmentID].doctors[doctorID].jobTitle = jobTitle; 
    }
    
    // 更新医生信息(简介)
    function updateDoctorShortIntroduction(
        string memory hospitalID,
        uint256 departmentID,
        uint256 doctorID,
        string memory shortIntroduction
        ) public onlyOwner MustYesExist(hospitalID) {
        require(hospitalInfos[hospitalID].index >= departmentID, "Department does not exist");
        require(hospitalInfos[hospitalID].departments[departmentID].index >= doctorID, "Doctor does not exist");
        hospitalInfos[hospitalID].departments[departmentID].doctors[doctorID].shortIntroduction = shortIntroduction;
    }
    
    // 获取医院信息
    function getHosipitalBaseInfo(string memory hospitalID) public view returns(string memory,string memory) {
        return (hospitalInfos[hospitalID].hospitalName, hospitalInfos[hospitalID].shortIntroduction);
    }
    
    // 获取部门索引(索引从0开始)
    function getDepartmentIndex(string memory hospitalID) public view returns(uint256) {
        return (hospitalInfos[hospitalID].index);
    }
    
    // 获取部门信息
    // @returns
    //  string departmentName;
    //  string shortIntroduction; 
    //  uint visitTime; // 出诊时间
    //  string callSite; // 出诊地点
    //  string phone; // 咨询电话
    function getDepartmentBaseInfo(
        string memory hospitalID,
        uint256 departmentID
    ) public view returns(string memory, string memory, uint, string memory, string memory) {
        return (
            hospitalInfos[hospitalID].departments[departmentID].departmentName, 
            hospitalInfos[hospitalID].departments[departmentID].shortIntroduction,
            hospitalInfos[hospitalID].departments[departmentID].visitTime,
            hospitalInfos[hospitalID].departments[departmentID].callSite,
            hospitalInfos[hospitalID].departments[departmentID].phone
        );
    }
    
    // 获取医生索引(索引从0开始)
    function getDoctorIndex(
        string memory hospitalID,
        uint256 departmentID
    ) public view returns(uint256) {
        return hospitalInfos[hospitalID].departments[departmentID].index;
    }
    
    // 获取医生信息
    // @returns
    // uint256 ID;
    // string jobTitle; // 职称
    // string doctorName; // 医生姓名
    // string shortIntroduction; // 医生简介
    function getDoctorBaseInfo(
        string memory hospitalID,
        uint256 departmentID,
        uint256 doctorID
    ) public view returns(string memory, string memory, string memory) {
        return (
            hospitalInfos[hospitalID].departments[departmentID].doctors[doctorID].jobTitle,
            hospitalInfos[hospitalID].departments[departmentID].doctors[doctorID].doctorName,
            hospitalInfos[hospitalID].departments[departmentID].doctors[doctorID].shortIntroduction
        );
    }
}