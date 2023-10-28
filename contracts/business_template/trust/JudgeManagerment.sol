// SPDX-License-Identifier: GPL-2.0-or-laterpragma sol
pragma solidity ^0.6.10;
pragma experimental ABIEncoderV2;

import "./Enum.sol";
import "./utils/Ownable.sol";
import "./utils/Roles.sol";

contract JudgeManagerment is Ownable {
    using Roles for Roles.Role;

    // 裁判
    struct Judge {
        string ID; // 身份证号码
        Enum.JudgeCreditStatus credit; // 裁判信用星级
        uint8 from; // 裁判来自省份
        address owner;
        bool isBlacklisted; // 是否被拉入黑名单
        bool used; // 是否加入裁判库
    }

    mapping(uint256 => Judge) private judges;
    uint256 public count; // 总裁判数量
    uint256 public legalCount; // 合法裁判数量
    bool private flag; // 判断当前合法裁判数量是否已更新
    Roles.Role private judgeRoles;
    
    event AddResult(uint256 indexed _index);
    event UpdateLegalCount(uint256 indexed _legalCount);
    event UpdateFlag(bool);

    constructor() public {
        count = 0;
        legalCount = 0;
        flag = false;
    }

    // 查看裁判是否已入库或裁判是否已因为信用等级过低而加入黑名单
    modifier isExistJudg {
        require(!judges[count].isBlacklisted && !judges[count].used, "error: The referee is not qualified!");
        _;
    }

    // 检查裁判是否注册
    modifier onlyJudge(address _sender) {
        require(!judges[count].isBlacklisted && judgeRoles.has(_sender) && judges[count].used, "info: judge does not register");
        _;
    }



    // 排除台湾省，河北省裁判。共计30位裁判
    function addJudge(string memory _ID, uint8 _from, address _judgeAddr) 
    onlyOwner isExistJudg public {        

        judges[count++] = Judge(
            _ID, Enum.JudgeCreditStatus.Medium, _from, _judgeAddr, false, true
        );
        flag = true; // 需要更新一下合法裁判数量
        judgeRoles.add(_judgeAddr); // 添加裁判地址至裁判权限管理库
        emit AddResult(count);
    }   
    
    // 所有合法裁判
    function showLegalJudgeList() public view returns(Judge[] memory) {
        uint256[] memory _legalIndexs = _LegalJudgeIndexList();
        Judge[] memory _judges = new Judge[](_legalIndexs.length);
        for(uint i = 0; i < _legalIndexs.length; i++) {
            _judges[i] = judges[_legalIndexs[i]];
        }
        return _judges;
    }

    function showLegalJudgeAdrrList() internal view returns(address[] memory) {
        uint256[] memory _legalIndexs = _LegalJudgeIndexList();
        address[] memory _judges = new address[](_legalIndexs.length);
        for(uint i = 0; i < _legalIndexs.length; i++) {
            _judges[i] = judges[_legalIndexs[i]].owner;
        }
        return _judges;
    }

    // 查看所有合法裁判索引
    function _LegalJudgeIndexList() private view returns(uint256[] memory) {
        uint256[] memory _legalIndexs = new uint256[](legalCount);
        // 由于可能出现已被拉入黑名单的裁判，需要重新计算索引，而又保持原顺序
        uint start = 0;
        
        for(uint i = 0; i < count; i++) {
            if(!judges[i].isBlacklisted) { // 合法裁判判断
                _legalIndexs[start++] = i; 
            }
        }
        return _legalIndexs;
    }

    // 计算合法裁判数量
    function calcLegalCount() public onlyOwner {
        require(flag, "info: calcLegalCount is newest!"); // 已经是最新数量，无需更新
        uint256 calcCount = 0;
        for(uint i = 0; i < count; i++) {
            if(!judges[i].isBlacklisted && judges[i].used) {
                calcCount += 1;
            }
        }
        flag = false;
        legalCount = calcCount;
        emit UpdateLegalCount(calcCount);
    }

    // TODO 裁判加入黑名单
    function _addJudgeBlacked(uint256 _index) private onlyOwner {
        // 禁止反复更新
        require(!judges[_index].isBlacklisted, "info: judge already blacklist");
        judges[_index].isBlacklisted = true;

        // 更新合法裁判数量
        legalCount -= 1;
    }

    // TODO 裁判星级更新
    function updateJudgeCredit(uint256 _index, Enum.JudgeCreditStatus _status) public onlyOwner {
        require(judges[_index].used, "info: judge does not creaed");

        judges[_index].credit = _status;
        
        // 是否加入黑名单并更新合法裁判数量
        if(judges[_index].credit == Enum.JudgeCreditStatus.Low) {
            _addJudgeBlacked(_index);
        }
    }

}
