/**
* 资金方控制器
*/
pragma solidity ^0.4.25;
pragma experimental ABIEncoderV2;

import "./role/Role.sol";
import "./utils/Ownable.sol";
import "./utils/LibString.sol";
import "./service/FinancingProcessStorage.sol";

contract FinancingFundController is Ownable, Role {

    using LibString for string;

    FinancingProcessStorage private financingProcessStorage;

    event IssueResult(int256);
    event FundAuditResult(bool);
    event FundConfirmAuditResult(bool);
    event LoanAuditResult(bool);

    string constant Fund_Audit_Accept = "FundAuditAccept";	// 融资审批同意状态
    string constant Fund_Audit_Reject = "FundAuditReject";	// 融资审批拒绝状态
    string constant Fund_Confirm_Audit_Accept = "FundConfirmAuditAccept";	// 融资确认审批同意状态
    string constant Fund_Confirm_Audit_Reject = "FundConfirmAuditReject";	// 融资确认审批拒绝状态
    string constant Fund_Loan_Audit_Accept = "FundLoanAuditAccept";	// 融资放款审批同意状态

    //日志打印
    event LogMessage(string _m);
    function _log(bool _b , string memory _m) private {
        if(_b){
            emit LogMessage(_m);
        }
    }

    constructor() public {
        financingProcessStorage = new FinancingProcessStorage();
    }

    /** 资金方审核融资单同意
    * 资金方融资审批（确认后到出质审批）
    * _processId 流程id
    * _user_id   操作用户id
    */
    function auditAccept(string _processId, string _user_id) external onlyOwner returns(bool){
        onlyZJRole(_user_id);
        _log(_processId.empty(), "FinancingFundController fundAudit: _processId is empty");
        require(!_processId.empty(), "FinancingFundController fundAudit: _processId is empty");

        int256 count = financingProcessStorage.updateDebtorStatus(_processId, Fund_Audit_Accept);
        emit FundAuditResult(count > int256(0));
        return count > int256(0);
    }

    /** 资金方审核融资单拒绝
    * _processId 流程id
    * _user_id   操作用户id
    */
    function auditReject(string _processId, string _user_id) external onlyOwner returns(bool){
        onlyZJRole(_user_id);
        _log(_processId.empty(), "FinancingFundController fundAudit: _processId is empty");
        require(!_processId.empty(), "FinancingFundController fundAudit: _processId is empty");

        int256 count = financingProcessStorage.updateDebtorStatus(_processId, Fund_Audit_Reject);
        emit FundAuditResult(count > int256(0));
        return count > int256(0);
    }

    /** 资金方审核放货同意
    * 资金方确认融资审批（确认后走放款流程）
    * _processId 流程id
    * _user_id   操作用户id
    */
    function confirmAuditAccept(string _processId, string _user_id) external onlyOwner returns(bool){
        onlyZJRole(_user_id);
        _log(_processId.empty(), "FinancingFundController fundConfirmAudit: _processId is empty");
        require(!_processId.empty(), "FinancingFundController fundConfirmAudit: _processId is empty");

        int256 count = financingProcessStorage.updateCreditSideStatus(_processId, Fund_Confirm_Audit_Accept);
        emit FundConfirmAuditResult(count > int256(0));
        return count > int256(0);
    }

    /** 资金方审核放货拒绝
    * _processId 流程id
    * _user_id   操作用户id
    */
    function confirmAuditReject(string _processId, string _user_id) external onlyOwner returns(bool){
        onlyZJRole(_user_id);
        _log(_processId.empty(), "FinancingFundController fundConfirmAudit: _processId is empty");
        require(!_processId.empty(), "FinancingFundController fundConfirmAudit: _processId is empty");

        int256 count = financingProcessStorage.updateCreditSideStatus(_processId, Fund_Confirm_Audit_Reject);
        emit FundConfirmAuditResult(count > int256(0));
        return count > int256(0);
    }

    /** 资金方放款审批同意
    * 流程结束
    * _processId 流程id
    * _user_id   操作用户id
    */
    function loanAuditAccept(string _processId, string _user_id) external onlyOwner returns(bool){
        onlyZJRole(_user_id);
        _log(_processId.empty(), "FinancingFundController loanAudit: _processId is empty");
        require(!_processId.empty(), "FinancingFundController loanAudit: _processId is empty");
        
        int256 count = financingProcessStorage.updateCreditSideStatus(_processId, Fund_Loan_Audit_Accept);
        emit LoanAuditResult(count > int256(0));
        return count > int256(0);
    }

    /** 资金方放款审批拒绝
    * 流程回转到资金方审核融资单
    * _processId 流程id
    * _user_id   操作用户id
    */
    function loanAuditReject(string _processId, string _user_id) external onlyOwner returns(bool){
        onlyZJRole(_user_id);
        _log(_processId.empty(), "FinancingFundController loanAudit: _processId is empty");
        require(!_processId.empty(), "FinancingFundController loanAudit: _processId is empty");

        int256 count = financingProcessStorage.updateCreditSideStatus(_processId, Fund_Audit_Reject);
        emit LoanAuditResult(count > int256(0));
        return count > int256(0);
    }

}