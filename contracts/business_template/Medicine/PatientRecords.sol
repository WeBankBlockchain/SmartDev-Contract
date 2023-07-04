pragma solidity ^0.4.21;

/// @title PatientRecords
/// @author Nicolas Frega - <frega.nicolas@gmail.com>
/// Allows Medical Record System to maintain records of patients in their network.
/// Records can be accessed by Hospitals if and only if patient provides name.
/// Patients are rewarded with erc20 tokens for providing their name

import "./InterfacePatientRecords.sol";
import "./SpringToken.sol";
import "./TokenDestructible.sol";
import "./SafeMath.sol";

contract PatientRecords is InterfacePatientRecords, TokenDestructible {
    using SafeMath for uint256;

    /*
    * Events
    */
    event Deposit(address indexed sender, uint256 value);
    event HospitalAddition(address hospital);
    event HospitalRemoval(address hospital);
    event PatientAddition(address patient);
    event PatientRemoval(address patient);
    event PatientRecordAdded(uint256 recordID, address patientAddress);
    event NameAddedToRecords(uint256 recordID, address patientAddress);
    event TokenRewardSet(uint256 tokenReward);
    event PatientPaid(address patientAddress);

    /*
    * Constans
    */
    uint constant public MAX_COUNT = 50;

    /*
    * Storage
    */
    SpringToken public springToken;
    mapping (address => bool) public isPatient;
    mapping (address => bool) public isHospital;
    mapping (uint256 => mapping (address => Records)) records;
    mapping (uint256 => dateRange) dateRanges;
    mapping (address => mapping (string => uint256)) mappingByName;
    uint256 public recordCount = 0;
    uint256 public tokenRewardAmount;
    address public tokenAddress;

    struct Records {
        bool providedName;
        string name;
        address patient;
        address hospital;
        uint256 admissionDate;
        uint256 dischargeDate;
        uint256 visitReason;
    }

    struct dateRange {
        uint256 admissionDate;
        uint256 dischargeDate;
    }

    /*
    * Modifiers
    */
    modifier validParameters(uint count) {
        require(count <= MAX_COUNT && count != 0);
        _;
    }

    modifier hospitalDoesNotExist(address hospital) {
        require(!isHospital[hospital]);
        _;
    }

    modifier hospitalExist(address hospital) {
        require(isHospital[hospital]);
        _;
    }

    modifier patientDoesNotExist(address patient) {
        require(!isPatient[patient]);
        _;
    }

    modifier patientExist(address patient) {
        require(isPatient[patient]);
        _;
    }

    modifier notNull(address _address) {
        require(_address != 0);
        _;
    }

    modifier notEmpty(string name) {
        bytes memory tempString = bytes(name);
        require(tempString.length != 0);
        _;
    }

    modifier onlyPatient(uint256 recordId) {
        require(records[recordId][msg.sender].patient == msg.sender);
        _;
    }

    modifier onlyHospital(uint256 recordId, address _patientAddress) {
        require(records[recordId][_patientAddress].hospital == msg.sender);
        _;
    }

    modifier recordExists(uint256 recordId, address patientAddress) {
        address _hospital = records[recordId][patientAddress].hospital;
        require(_hospital != 0x0);
        _;
    }

    modifier patientProvidedName(uint256 recordId, address patient) {
        require(records[recordId][patient].providedName == true);
        _;
    }

    modifier patientNotProvidedName(uint256 recordId, address patient) {
        require(records[recordId][patient].providedName == false);
        _;
    }

    modifier higherThanZero(uint256 _uint) {
        require(_uint > 0);
        _;
    }

    /// @dev Fallback function allows to deposit ether.
    function()
        public
        payable
    {
        if (msg.value > 0) {
            emit Deposit(msg.sender, msg.value);
          }
    }

    /*
     * Public functions
     */
    /// @dev Contract constructor sets initial hospitals and patients.
    /// @param _hospitals Address array of initial hospitals.
    /// @param _patients Address array of initial patients
    constructor(address[] _hospitals, address[] _patients)
        public
        validParameters(_hospitals.length)
        validParameters(_patients.length)
    {
        uint i;
        for (i = 0; i < _hospitals.length; i++) {
            require(_hospitals[i] != 0x0);
            isHospital[_hospitals[i]] = true;
        }

        for (i = 0; i < _patients.length; i++) {
            require(!isHospital[_patients[i]]);
            require(_patients[i] != 0x0);
            isPatient[_patients[i]] = true;
        }

        setSpringToken(new SpringToken());
        uint256 initialReward = 1000;
        setSpringTokenReward(initialReward);
    }

    /// @dev Allows to add a new hospital in the network.
    /// @param _hospital Address of new hospital.
    function addHospital(address _hospital)
        public
        onlyOwner
        hospitalDoesNotExist(_hospital)
        patientDoesNotExist(_hospital)
        notNull(_hospital)
    {
        isHospital[_hospital] = true;
        emit HospitalAddition(_hospital);
    }

    /// @dev Allows to remove a hospital in the network.
    /// @param _hospital Address of hospital to remove.
    function removeHospital(address _hospital)
        public
        onlyOwner
        hospitalExist(_hospital)
    {
        isHospital[_hospital] = false;
        emit HospitalRemoval(_hospital);
    }

    /// @dev Allows to add a new patient in the network.
    /// @param _patient Address of new patient.
    function addPatient(address _patient)
        public
        onlyOwner
        patientDoesNotExist(_patient)
        hospitalDoesNotExist(_patient)
        notNull(_patient)
    {
        isPatient[_patient] = true;
        emit PatientAddition(_patient);
    }

    /// @dev Allows to remove a patient in the network.
    /// @param _patient Address of patient to remove.
    function removePatient(address _patient)
        public
        onlyOwner
        patientExist(_patient)
    {
        isPatient[_patient] = false;
        emit PatientRemoval(_patient);
    }

    /// @dev Allows to add a patient record in the network.
    /// @param _patientAddress address of the patient for record.
    /// @param _hospital address of the hospital for record.
    /// @param _admissionDate date of admission, simple uint.
    /// @param _dischargeDate date of discharge, simple uint.
    /// @param _visitReason internal code for reason for visit.
    function addRecord (
        address _patientAddress,
        address _hospital,
        uint256 _admissionDate,
        uint256 _dischargeDate,
        uint256 _visitReason)
        public
        onlyOwner
        patientExist(_patientAddress)
        hospitalExist(_hospital)
    {
        records[recordCount][_patientAddress].providedName = false;
        records[recordCount][_patientAddress].patient = _patientAddress;
        records[recordCount][_patientAddress].hospital = _hospital;
        records[recordCount][_patientAddress].admissionDate = _admissionDate;
        records[recordCount][_patientAddress].dischargeDate = _dischargeDate;
        records[recordCount][_patientAddress].visitReason = _visitReason;

        dateRanges[recordCount].admissionDate = _admissionDate;
        dateRanges[recordCount].dischargeDate = _dischargeDate;

        emit PatientRecordAdded(recordCount, _patientAddress);

        recordCount += 1;
    }

    /// @dev Allows a patient to add their name to the record in the network.
    /// @param _recordID ID of the patient specific record.
    /// @param _name Name for the patient
    function addName(uint256 _recordID, string _name)
        public
        patientExist(msg.sender)
        onlyPatient(_recordID)
        recordExists(_recordID, msg.sender)
        notEmpty(_name)
        patientNotProvidedName(_recordID, msg.sender)
    {
        records[_recordID][msg.sender].providedName = true;
        records[_recordID][msg.sender].name = _name;
        address hostpitalInRecord = records[_recordID][msg.sender].hospital;
        mappingByName[hostpitalInRecord][_name] += 1;

        payPatient(msg.sender);

        emit NameAddedToRecords(_recordID, msg.sender);
    }

    /// @dev Allows a Hospital to retrieve the record for a patient.
    /// @param _recordID ID of the patient specific record.
    /// @param _patientAddress address of the patient for record.
    function getRecord(uint _recordID, address _patientAddress)
        public
        recordExists(_recordID, _patientAddress)
        patientProvidedName(_recordID, _patientAddress)
        onlyHospital(_recordID, _patientAddress)
        view
        returns (
            string _name,
            address _hospital,
            uint256 _admissionDate,
            uint256 _dischargeDate,
            uint256 _visitReason
        )
    {
        _name = records[_recordID][_patientAddress].name;
        _hospital = records[_recordID][_patientAddress].hospital;
        _admissionDate = records[_recordID][_patientAddress].admissionDate;
        _dischargeDate = records[_recordID][_patientAddress].dischargeDate;
        _visitReason = records[_recordID][_patientAddress].visitReason;
    }

    /// @dev Allows a Hospital to view the number of records for a patient.
    /// @param _name Name for the patient
    function getRecordByName(string _name)
        public
        hospitalExist(msg.sender)
        view
        returns (uint256 numberOfRecords)
    {
        if (mappingByName[msg.sender][_name] != 0) {
            numberOfRecords = mappingByName[msg.sender][_name];
            return numberOfRecords;
        }
        else
            return 0;
    }

    /// @dev Allows a Hospital to view the number of patients on a given date range.
    /// @param from Starting date
    /// @param to Ending date
    function getCurrentPatients(uint from, uint to)
        public
        hospitalExist(msg.sender)
        view
        returns (uint _numberOfPatients)
    {
        uint i;
        _numberOfPatients = 0;
        for(i = 0; i < recordCount; i++) {
            if(dateRanges[i].admissionDate >= from && dateRanges[i].dischargeDate <= to)
            _numberOfPatients += 1;
        }
    }

    /// @dev sets the amount of Spring token rewards for providing name.
    /// @param _tokenReward Amount of tokens to reward patient.
    function setSpringTokenReward(uint256 _tokenReward)
        public
        onlyOwner
        higherThanZero(_tokenReward)
    {
        tokenRewardAmount = _tokenReward;
        emit TokenRewardSet(_tokenReward);
    }

    /// @dev gets the balance of patient.
    /// @param _patientAddress address of patient.
    /// @return Returns patient balance.
    function getPatientBalance(address _patientAddress)
        public
        onlyOwner
        view
        returns (uint256)
    {
        return springToken.balanceOf(_patientAddress);
    }

    /*
    * Internal functions
    */
    /// @dev sets the patient token reward contract.
    /// @param _newspringToken Address of patient token.
    function setSpringToken(address _newspringToken)
        internal
        onlyOwner
        notNull(_newspringToken)
    {
        springToken = SpringToken(_newspringToken);
        tokenAddress = address(springToken);
    }

    /// @dev pays a patient for providing their name.
    /// @param _patientAddress to receive tokens.
    function payPatient(address _patientAddress)
        private
        notNull(_patientAddress)
    {
        springToken.transfer(_patientAddress, tokenRewardAmount);
        emit PatientPaid(_patientAddress);
    }

}
