pragma solidity ^0.4.25;
pragma experimental ABIEncoderV2;

import "./utils/Ownable.sol";
import "./utils/LibString.sol";
import "./service/BillStorage.sol";

contract BillController is Ownable {

    using LibString for string;

    BillStorage private billStorage;

    event IssueResult(int256);
    event EndorseResult(bool);
    event EcceptResult(bool);
    event EcceptReject(bool);

    //日志打印
    event LogMessage(string _m);
    function _log(bool _b , string memory _m) private {
        if(_b){
            emit LogMessage(_m);
        }
    }

    constructor() public {
        billStorage = new BillStorage();
    }

    /**发布票据 */
    function issue(string _s) external onlyOwner returns(int256){
        int256 count = billStorage.insert(_s);
        emit IssueResult(count);
        return count;
    }

    /**批量查询当前持票人的票据 */
    function queryBills(string _holdrCmID) external returns(string[] memory){
        string[] memory result = billStorage.selectListByHoldrCmID(_holdrCmID);
        return result;
    }

    /**根据票据号码查询票据详情 */
    function queryBillByNo(string _infoID) external returns(string){
        return billStorage.getDetail(_infoID);
    }

    /**发起背书请求 */
    function endorse(string _infoID, string _waitEndorseCmID, string _waitEndorseAcct) external onlyOwner returns(bool){
        string memory _holdrCmID = billStorage.getHoldrCmID(_infoID);
        _log(_holdrCmID.empty(), "BillController: holdrCmID is empty");
        //require, false时执行
        require(!_holdrCmID.empty(), "BillController: holdrCmID is empty");
        // 待背书人不能是当前持票人
        require(!_holdrCmID.equal(_waitEndorseCmID), "BillController: waitEndorseCmID != holdrCmID");

        int256 count = billStorage.updateEndorse(_infoID, _waitEndorseCmID, _waitEndorseAcct);
        emit EndorseResult(count > int256(0));
        return count > int256(0);
    }

    /**查询待背书票据列表 */
    function queryWaitBills(string _waitEndorseCmID) external returns(string[] memory){
        string[] memory result = billStorage.selectListByWaitEndorseCmID(_waitEndorseCmID);
        return result;
    }

    /**背书签收 */
    function accept(string _infoID, string _holdrCmID, string _holdrAcct) external onlyOwner returns(bool){

        int256 count = billStorage.updateEccept(_infoID, _holdrCmID, _holdrAcct);
        emit EcceptResult(count > int256(0));
        return count > int256(0);
    }

    /**拒绝背书 */
    function reject(string _infoID, string _rejectEndorseCmID, string _rejectEndorseAcct) external onlyOwner returns(bool){
        int256 count = billStorage.updateReject(_infoID, _rejectEndorseCmID, _rejectEndorseAcct);
        emit EcceptReject(count > int256(0));
        return count > int256(0);
    }

}