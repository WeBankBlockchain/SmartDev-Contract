/**
* 监管方控制器
*/
pragma solidity ^0.4.25;
pragma experimental ABIEncoderV2;

import "./role/Role.sol";
import "./utils/Ownable.sol";
import "./utils/LibString.sol";
import "./service/FinancingProcessStorage.sol";
import "./service/PledgeReceiptStorage.sol";

contract FinancingSupervisorController is Ownable, Role {

    using LibString for string;

    FinancingProcessStorage private financingProcessStorage;
    PledgeReceiptStorage private pledgeReceiptStorage;

    event CreateReceiptResult(int256);
    event SupervisorAuditResult(bool);

    string constant Supervisor_Audit_Accept = "SupervisorAuditAccept";	// 监管方出质审批同意状态
    string constant Supervisor_Audit_Reject = "SupervisorAuditReject";	// 监管方出质审批拒绝状态

    //日志打印
    event LogMessage(string _m);
    function _log(bool _b , string memory _m) private {
        if(_b){
            emit LogMessage(_m);
        }
    }

    constructor() public {
        financingProcessStorage = new FinancingProcessStorage();
        pledgeReceiptStorage = new PledgeReceiptStorage();
    }

    /** 创建仓单
    *  _processId  流程id
    *  _receiptStr 仓单信息
    */
    function createReceipt(string _processId, string _receiptStr, string _user_id) external onlyOwner returns(int256){
        onlyJGRole(_user_id);
        _log(_processId.empty(), "FinancingSupervisorController createReceipt: _processId is empty");
        require(!_processId.empty(), "FinancingSupervisorController createReceipt: _processId is empty");

        int256 count = pledgeReceiptStorage.insert(_processId, _receiptStr);
        emit CreateReceiptResult(count);
        return count;
    }

    /** 监管方审核同意
    * 监管方出质审批（确认后到资金方确认审批）
    * _processId 流程id
    */
    function supervisorAuditAccept(string _processId, string _user_id) external onlyOwner returns(bool){
        onlyJGRole(_user_id);
        _log(_processId.empty(), "FinancingSupervisorController supervisorAudit: _processId is empty");
        require(!_processId.empty(), "FinancingSupervisorController supervisorAudit: _processId is empty");
        
        int256 count = financingProcessStorage.updateSupervisorStatus(_processId, Supervisor_Audit_Accept);
        emit SupervisorAuditResult(count > int256(0));
        return count > int256(0);
    }

    /** 监管方审核拒绝
    * _processId 流程id
    */
    function supervisorAuditReject(string _processId, string _user_id) external onlyOwner returns(bool){
        onlyJGRole(_user_id);
        _log(_processId.empty(), "FinancingSupervisorController supervisorAudit: _processId is empty");
        require(!_processId.empty(), "FinancingSupervisorController supervisorAudit: _processId is empty");

        int256 count = financingProcessStorage.updateSupervisorStatus(_processId, Supervisor_Audit_Reject);
        emit SupervisorAuditResult(count > int256(0));
        return count > int256(0);
    }

}