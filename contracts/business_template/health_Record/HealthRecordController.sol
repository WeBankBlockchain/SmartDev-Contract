/*
 * Copyright 2014-2019 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * */

pragma solidity ^0.4.25;

import "./Auth.sol";

contract HealthRecordController is Auth {

    mapping (address => doctor) private doctors;
    mapping (address => agency) private agencies;
    mapping (address => patient) private patients;
    mapping (address => mapping (address => uint)) private patientToDoctor;
    mapping (address => mapping (address => uint)) private patientToAgency;
    mapping (bytes32 => filesInfo) private hashToFile;
    mapping (address => mapping (bytes32 => uint)) private patientToFile;

    //event
    event SignupPatientEvent(address pat,uint timestamp);
    event SignupDoctorEvent(address doc,uint timestamp);
    event SignupAgencyEvent(address agy,uint timestamp);
    event GrantAccessToDoctorEvent(address pat,address doctor_id,uint timestamp);
    event GrantAccessToAgencyEvent(address pat,address agency_id,uint timestamp);
    event AddFileEvent(address pat,bytes32 _fileHash,uint timestamp);


    //患者信息
    struct patient {
        string ssid; //社保卡号
        string name;
        uint8 age;
        address id;
        bytes32[] files;// 病历文件
        address[] doctor_list; //患者所属医生列表
        address[] agency_list; //患者授权第三方机构列表
        uint   patient_create_time;
    }

    //医生信息
    struct doctor {
        string name;
        address id;
        address[] patient_list; //医生所属患者列表
        uint   doctor_create_time;
    }

    //第三方数据共享机构信息
    struct agency {
        string name;
        address id;
        address[] patient_list; //第三方机构所属患者列表
        uint   agency_create_time;
    }

    //病历文件信息
    struct filesInfo {
        string file_name;
        string file_type;
        string file_secret;
        uint   file_create_time;
    }

    //检查患者信息是否存在
    modifier checkPatient(address id) {
        patient memory p = patients[id];
        require(p.id > address(0x0));
        _;
    }

    //检查医生信息是否存在
    modifier checkDoctor(address id) {
        doctor memory d = doctors[id];
        require(d.id > address(0x0));
        _;
    }

    //检查机构信息是否存在
    modifier checkAgency(address id) {
        agency memory a = agencies[id];
        require(a.id > address(0x0));
        _;
    }

    //检查文件是否存在
    modifier checkFile(bytes32 fileHashId) {
        bytes memory tempString = bytes(hashToFile[fileHashId].file_name);
        require(tempString.length > 0);
        _;
    }

    //检查文件访问权限
    modifier checkFileAccess(string memory role, address id, bytes32 fileHashId, address pat) {
        uint pos;
        if(keccak256(abi.encodePacked(role)) == keccak256("doctor")) {
            require(patientToDoctor[pat][id] > 0);
            pos = patientToFile[pat][fileHashId];
            require(pos > 0);
        }
        if(keccak256(abi.encodePacked(role)) == keccak256("agency")) {
            require(patientToAgency[pat][id] > 0);
            pos = patientToFile[pat][fileHashId];
            require(pos > 0);
        }
        else if(keccak256(abi.encodePacked(role)) == keccak256("patient")) {
            pos = patientToFile[id][fileHashId];
            require(pos > 0);
        }
        _;
    }


    //1-患者注册
    function signupPatient(string memory _ssid, string memory _name, uint8 _age) public {
        patient storage p = patients[msg.sender];
        require(keccak256(abi.encodePacked(_name)) != keccak256(""));
        require((_age > 0) && (_age < 200));
        require(!(p.id > address(0x0)));

        patients[msg.sender] = patient({ssid:_ssid,name:_name,age:_age,id:msg.sender,files:new bytes32[](0),doctor_list:new address[](0),agency_list:new address[](0),patient_create_time:now});
        emit SignupPatientEvent(msg.sender,now);
    }

    //2-医生注册
    function signupDoctor(string memory _name) public {
        doctor storage d = doctors[msg.sender];
        require(keccak256(abi.encodePacked(_name)) != keccak256(""));
        require(!(d.id > address(0x0)));

        doctors[msg.sender] = doctor({name:_name,id:msg.sender,patient_list:new address[](0),doctor_create_time:now});
        emit SignupDoctorEvent(msg.sender,now);
    }

    //3-第三方数据共享机构注册
    function signupAgency(string memory _name) public {
        agency storage d = agencies[msg.sender];
        require(keccak256(abi.encodePacked(_name)) != keccak256(""));
        require(!(d.id > address(0x0)));

        agencies[msg.sender] = agency({name:_name,id:msg.sender,patient_list:new address[](0),agency_create_time:now});
        emit SignupAgencyEvent(msg.sender,now);
    }

    //3-患者给医生授权，将医生id加入患者所属医生列表以及患者id加入医生管理的患者列表
    function grantAccessToDoctor(address doctor_id) public checkPatient(msg.sender) checkDoctor(doctor_id) {
        patient storage p = patients[msg.sender];
        doctor storage d = doctors[doctor_id];
        require(patientToDoctor[msg.sender][doctor_id] < 1);

        uint pos = p.doctor_list.push(doctor_id);
        patientToDoctor[msg.sender][doctor_id] = pos;
        d.patient_list.push(msg.sender);
        emit GrantAccessToDoctorEvent(msg.sender,doctor_id,now);
    }

    //4-医生增加患者病历文件，文件名、文件类型、文件哈希以及文件密钥（获得患者授权后）
    function addFile(address pat,string memory _file_name, string memory _file_type, bytes32 _fileHash, string memory _file_secret) public checkDoctor(msg.sender) checkPatient(pat) {
        patient storage p = patients[pat];

        require(patientToFile[pat][_fileHash] < 1);

        hashToFile[_fileHash] = filesInfo({file_name:_file_name, file_type:_file_type,file_secret:_file_secret,file_create_time:now});
        uint pos = p.files.push(_fileHash);
        patientToFile[pat][_fileHash] = pos;
        emit AddFileEvent(msg.sender,_fileHash,now);
    }

    // 5-医生获取相应患者信息
    function getPatientInfoForDoctor(address pat) public view checkPatient(pat) checkDoctor(msg.sender) returns(string memory, uint8, address, bytes32[] memory){
        patient memory p = patients[pat];

        require(patientToDoctor[pat][msg.sender] > 0);

        return (p.name, p.age, p.id, p.files);
    }

    //6-患者本人查询个人病历信息
    function getPatientInfo() public view checkPatient(msg.sender) returns(string memory, uint8, bytes32[] memory , address[] memory) {
        patient memory p = patients[msg.sender];
        return (p.name, p.age, p.files, p.doctor_list);
    }

    //获取文件信息
    function getFileInfo(bytes32 fileHashId) private view checkFile(fileHashId) returns(filesInfo memory) {
        return hashToFile[fileHashId];
    }

    //7-获取文件密钥，在获取密钥后，在应用层对诊断报告文件进行解密
    function getFileSecret(bytes32 fileHashId, string memory role, address id, address pat) public view checkFile(fileHashId) checkFileAccess(role, id, fileHashId, pat) returns(string memory) {
        filesInfo memory f = getFileInfo(fileHashId);
        return (f.file_secret);
    }

    //8-医生查询患者某一诊断病历文件信息
    function getFileInfoDoctor(address doc, address pat, bytes32 fileHashId) public view onlyOwner checkPatient(pat) checkDoctor(doc) checkFileAccess("doctor", doc, fileHashId, pat) returns(string memory, string memory,uint) {
        filesInfo memory f = getFileInfo(fileHashId);
        return (f.file_name, f.file_type,f.file_create_time);
    }

    //9-患者查询自己某一诊断病历文件信息
    function getFileInfoPatient(address pat, bytes32 fileHashId) public view onlyOwner checkPatient(pat) checkFileAccess("patient", pat, fileHashId, pat)
    returns(string memory, string memory) {
        filesInfo memory f = getFileInfo(fileHashId);
        return (f.file_name, f.file_type);
    }

    //10-患者给机构授权，将机构id加入患者所属机构列表以及患者id加入机构管理的患者列表
    function grantAccessToAgency(address agency_id) public checkPatient(msg.sender) checkAgency(agency_id) {
        patient storage p = patients[msg.sender];
        agency storage a = agencies[agency_id];
        require(patientToAgency[msg.sender][agency_id] < 1);

        uint pos = p.agency_list.push(agency_id);
        patientToAgency[msg.sender][agency_id] = pos;
        a.patient_list.push(msg.sender);
        emit GrantAccessToAgencyEvent(msg.sender,agency_id,now);
    }

    // 11-第三方机构获取机构下患者信息
    function getPatientInfoForAgency(address pat) public view checkPatient(pat) checkAgency(msg.sender) returns(string memory, uint8, address, bytes32[] memory){
        patient memory p = patients[pat];

        require(patientToAgency[pat][msg.sender] > 0);

        return (p.name, p.age, p.id, p.files);
    }

    //12-第三方机构查询患者某一诊断病历文件信息
    function getFileInfoAgency(address agy, address pat, bytes32 fileHashId) public view onlyOwner checkPatient(pat) checkAgency(agy) checkFileAccess("agency", agy, fileHashId, pat) returns(string memory, string memory,uint) {
        filesInfo memory f = getFileInfo(fileHashId);
        return (f.file_name, f.file_type,f.file_create_time);
    }

}
