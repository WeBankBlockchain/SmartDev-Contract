pragma solidity ^0.4.25;

contract HealthRecordRepository {
    address private owner;
    uint private gpos;

    mapping (address => doctor) private doctors;// doctor and list of patient profile he can access
    mapping (address => patient) private patients;
    mapping (address => mapping (address => uint)) private patientToDoctor;
    mapping (bytes32 => filesInfo) private hashToFile; //filehash to file info
    mapping (address => mapping (bytes32 => uint)) private patientToFile;

    //文件信息
    struct filesInfo {
        string file_name;
        string file_type;
        string file_secret;
    }

    //病人信息
    struct patient {
        string name;
        uint8 age;
        address id;
        bytes32[] files;// hashes of file that belong to this user for display purpose
        address[] doctor_list;
    }

    //医生信息
    struct doctor {
        string name;
        address id;
        address[] patient_list;
    }

    constructor() public {
        owner = msg.sender;
    }

    modifier checkDoctor(address id) {
        doctor memory d = doctors[id];
        require(d.id > address(0x0));//check if doctor exist
        _;
    }

    modifier checkPatient(address id) {
        patient memory p = patients[id];
        require(p.id > address(0x0));//check if patient exist
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
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
        else if(keccak256(abi.encodePacked(role)) == keccak256("patient")) {
            pos = patientToFile[id][fileHashId];
            require(pos > 0);
        }
        _;
    }

    //检查文件是否存在
    modifier checkFile(bytes32 fileHashId) {
        bytes memory tempString = bytes(hashToFile[fileHashId].file_name);
        require(tempString.length > 0);
        _;
    }

    //患者签名
    function signupPatient(string memory _name, uint8 _age) public {
        patient memory p = patients[msg.sender];
        require(keccak256(abi.encodePacked(_name)) != keccak256(""));
        require((_age > 0) && (_age < 200));
        require(!(p.id > address(0x0)));

        patients[msg.sender] = patient({name:_name,age:_age,id:msg.sender,files:new bytes32[](0),doctor_list:new address[](0)});
    }

    //医生签名
    function signupDoctor(string memory _name) public {
        doctor memory d = doctors[msg.sender];
        require(keccak256(abi.encodePacked(_name)) != keccak256(""));
        require(!(d.id > address(0x0)));

        doctors[msg.sender] = doctor({name:_name,id:msg.sender,patient_list:new address[](0)});
    }

    //给医生授权
    function grantAccessToDoctor(address doctor_id) public checkPatient(msg.sender) checkDoctor(doctor_id) {
        patient storage p = patients[msg.sender];
        doctor storage d = doctors[doctor_id];
        require(patientToDoctor[msg.sender][doctor_id] < 1);// this means doctor already been access

        uint pos = p.doctor_list.push(doctor_id);// new length of array
        gpos = pos;
        patientToDoctor[msg.sender][doctor_id] = pos;
        d.patient_list.push(msg.sender);
    }

    //增加文件
    function addFile(string memory _file_name, string memory _file_type, bytes32 _fileHash, string memory _file_secret) public checkPatient(msg.sender) {
        patient storage p = patients[msg.sender];

        require(patientToFile[msg.sender][_fileHash] < 1);

        hashToFile[_fileHash] = filesInfo({file_name:_file_name, file_type:_file_type,file_secret:_file_secret});
        uint pos = p.files.push(_fileHash);
        patientToFile[msg.sender][_fileHash] = pos;
    }

    //获取患者信息
    function getPatientInfo() public view checkPatient(msg.sender) returns(string memory, uint8, bytes32[] memory , address[] memory) {
        patient memory p = patients[msg.sender];
        return (p.name, p.age, p.files, p.doctor_list);
    }

    //获取医生信息
    function getDoctorInfo() public view checkDoctor(msg.sender) returns(string memory, address[] memory){
        doctor memory d = doctors[msg.sender];
        return (d.name, d.patient_list);
    }

    function checkProfile(address _user) public view onlyOwner returns(string memory, string memory){
        patient memory p = patients[_user];
        doctor memory d = doctors[_user];

        if(p.id > address(0x0))
            return (p.name, 'patient');
        else if(d.id > address(0x0))
            return (d.name, 'doctor');
        else
            return ('', '');
    }

    //为医生获取相应患者信息
    function getPatientInfoForDoctor(address pat) public view checkPatient(pat) checkDoctor(msg.sender) returns(string memory, uint8, address, bytes32[] memory){
        patient memory p = patients[pat];

        require(patientToDoctor[pat][msg.sender] > 0);

        return (p.name, p.age, p.id, p.files);
    }

    //获取文件信息
    function getFileInfo(bytes32 fileHashId) private view checkFile(fileHashId) returns(filesInfo memory) {
        return hashToFile[fileHashId];
    }

    //获取文件密钥
    function getFileSecret(bytes32 fileHashId, string memory role, address id, address pat) public view
    checkFile(fileHashId) checkFileAccess(role, id, fileHashId, pat)
    returns(string memory) {
        filesInfo memory f = getFileInfo(fileHashId);
        return (f.file_secret);
    }

    //获取医生文件信息
    function getFileInfoDoctor(address doc, address pat, bytes32 fileHashId) public view
    onlyOwner checkPatient(pat) checkDoctor(doc) checkFileAccess("doctor", doc, fileHashId, pat)
    returns(string memory, string memory) {
        filesInfo memory f = getFileInfo(fileHashId);
        return (f.file_name, f.file_type);
    }

    //获取患者文件信息
    function getFileInfoPatient(address pat, bytes32 fileHashId) public view
    onlyOwner checkPatient(pat) checkFileAccess("patient", pat, fileHashId, pat) returns(string memory, string memory) {
        filesInfo memory f = getFileInfo(fileHashId);
        return (f.file_name, f.file_type);
    }

}