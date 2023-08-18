pragma solidity ^0.4.25;
pragma experimental ABIEncoderV2;

// import "StrUtils.sol";
import "Roles.sol";
import "Patient.sol";

// 病历管理
contract CaseHistoryManager is Patient  {
    // using Roles for Role.Roles;
    /*
    主诉：病人就诊时主动告诉医生的主要症状或问题。
    现病史：病人就诊前至现在发生的疾病状况、症状表现、治疗情况等。
    既往史：病人过去的疾病史、手术史、外伤史、输血史等病史信息。
    药物过敏史：病人对药物或某些物质产生过敏反应的历史记录。
    个人及家族史：病人个人的健康情况、生活习惯、家族中是否有遗传性疾病等相关信息。
    体格检查：医生通过观察、触摸、听诊、叩诊等方法对病人进行身体检查，以获得体征和症状的客观数据。
    辅助检查：为了明确诊断或进一步评估疾病，医生可能会要求病人进行各种实验室检查、影像学检查、生物学检查等。
    初步诊断：根据主诉、病史、体格检查和辅助检查结果初步确定的疾病诊断。
    诊疗：根据初步诊断结果，医生制定相应的治疗方案，并进行治疗。
    */
    
    struct CaseHistory {
        string chiefComplaint; // 主诉。
        string presentIllnessHistory; // 现病史
        string pastMedicalHistory; // 既往史
        string drugAllergyHistory;// 药物过敏史
        string personalAndFamilyHistory;// 个人及家族史
        string physicalExamination;// 体格检查
        string diagnosticTests;// 辅助检查
        string preliminaryDiagnosis;// 初步诊断
        string diagnosisAndTreatment;// 诊疗
        uint256 doctorID; // 主治医生 
        string patientID; // 患者
        string hospitalID; // 医院
        bool register;
    }
    
    
    mapping(string => mapping(uint256 => CaseHistory)) caseHistoryInfos; // 患者对应多个病历
    uint256 index;    
    
    constructor(address addr) public Patient(addr) {
        index = 1;
    }
    
    // 院方接诊
    // function 
    
    // @params
    // string chiefComplaint; // 主诉。
    // string presentIllnessHistory; // 现病史
    // string pastMedicalHistory; // 既往史
    // string drugAllergyHistory;// 药物过敏史
    //     string personalAndFamilyHistory;// 个人及家族史
    //     string physicalExamination;// 体格检查
    //     string diagnosticTests;// 辅助检查
    //     string preliminaryDiagnosis;// 初步诊断
    //     string diagnosisAndTreatment;// 诊疗
    //     uint256 doctorID; // 主治医生 
    //     string patientID; // 患者
    //     string hospitalID; // 医院
    // 问诊
    function addCaseHistoryBaseInfo(
        string memory chiefComplaint, 
        string memory presentIllnessHistory,
        string memory pastMedicalHistory,
        string memory drugAllergyHistory,
        string memory personalAndFamilyHistory,
        string memory physicalExamination,
        uint256 doctorID,
        string memory patientID,
        string memory hospitalID
        ) public checkViewAddr(msg.sender, patientID) returns(uint256) {
            CaseHistory memory caseHistory = CaseHistory(
                chiefComplaint,  
                presentIllnessHistory,
                pastMedicalHistory,
                personalAndFamilyHistory,
                chiefComplaint,
                physicalExamination,
                "",
                "",
                "",
                doctorID,
                patientID,
                hospitalID,
                true
            );
            caseHistoryInfos[patientID][index] = caseHistory;
            index = index + 1;
            return index - 1;
    }
    
    // 病历信息添加(辅助检查)
    function addCaseHistoryDiagnosticTests(
        uint256 index,
        string memory diagnosticTests,
        string memory patientID
    ) public checkViewAddr(msg.sender, patientID) {
        require(caseHistoryInfos[patientID][index].register, "The server endpoint cannot perform the operation"); // 必须在主治医生问诊
        caseHistoryInfos[patientID][index].diagnosticTests = diagnosticTests;
    } 
    
     // 病历信息添加(初步诊断 & 诊疗)
    function addCaseHistoryPreliminaryDiagnosis(
        uint256 index,
        string memory preliminaryDiagnosis,
        string memory diagnosisAndTreatment,
        string memory patientID
    ) public checkViewAddr(msg.sender, patientID) {
        require(caseHistoryInfos[patientID][index].register, "The server endpoint cannot perform the operation"); // 必须在主治医生问诊
        caseHistoryInfos[patientID][index].preliminaryDiagnosis = preliminaryDiagnosis;
        caseHistoryInfos[patientID][index].diagnosisAndTreatment = diagnosisAndTreatment;
    }
    
    
}