/**
 * 贷款方融资流程控制器
*/
pragma solidity ^0.4.25;
pragma experimental ABIEncoderV2;

import "./role/Role.sol";
import "./utils/Ownable.sol";
import "./utils/LibString.sol";
import "./service/FinancingProcessStorage.sol";
import "./service/FinancingDetailStorage.sol";
import "./service/PledgeGoodsStorage.sol";
import "./service/PledgeReceiptStorage.sol";

contract FinancingProcessController is Ownable, Role {

    using LibString for string;

    FinancingProcessStorage private financingProcessStorage;
    FinancingDetailStorage private financingDetailStorage;
    PledgeGoodsStorage private pledgeGoodsStorage;
    PledgeReceiptStorage private pledgeReceiptStorage;

    event IssueResult(int256);

    //日志打印
    event LogMessage(string _m);
    function _log(bool _b , string memory _m) private {
        if(_b){
            emit LogMessage(_m);
        }
    }

    constructor() public {
        financingProcessStorage = new FinancingProcessStorage();
        financingDetailStorage = new FinancingDetailStorage();
        pledgeGoodsStorage = new PledgeGoodsStorage();
        pledgeReceiptStorage = new PledgeReceiptStorage();
    }

    /**
    * 发布融资流程
    * _processStr 流程详情
    * _detailStr 融资单信息
    * _goodsStr 质押物品信息 "11,ZW2108239960,畜牧-牛,吨,100000,6800,110000,701,200000,奶牛养殖场"
    * _user_id   操作用户id
    */
    function issue(string _processStr, string _detailStr, string _goodsStr, string _user_id) external onlyOwner returns(int256){
        onlyDKRole(_user_id);
        int256 count = financingProcessStorage.insert(_processStr, _detailStr, _goodsStr);
        _log(!(count > 0), "FinancingProcessController issue: fail!");
        emit IssueResult(count);
        return count;
    }

    /**
    * 查询融资流程详情
    * _processId 流程id
    */
    function query(string _processId) external returns(string){
        string memory _json = "{";

        _json = _json.concat("'financingProcess':");
        _json = _json.concat(financingProcessStorage.getDetail(_processId));
        _json = _json.concat(",");

        _json = _json.concat("'financingDetail':");
        _json = _json.concat(financingDetailStorage.getDetail(_processId));
        _json = _json.concat(",");

        _json = _json.concat("'pledgeGoods':");
        _json = _json.concat(pledgeGoodsStorage.getDetail(_processId));

        _json = _json.concat("}");

        return _json;
    }

}