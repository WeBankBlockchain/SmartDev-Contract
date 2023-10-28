// SPDX-License-Identifier: GPL-2.0-or-laterpragma sol
pragma solidity ^0.6.10;
pragma experimental ABIEncoderV2;

import "./Enum.sol";
import "./utils/Roles.sol";
import "./utils/Ownable.sol";
import "./utils/LibSafeMathForFloatUtils.sol";

// 评卷管理

// 只有裁判可以评分
// 根据每一小问进行评分并且记录
// 评完所有问题需要将分数发送至选手合约进行汇总

contract MarkingManagerment is Ownable {
    using Roles for Roles.Role;
    using LibSafeMathForFloatUtils for uint256;


    struct Question {
        // (A-1-1)
        Enum.QuestionModule module; // 题目位于模块
        uint8 bigQuestionNum; // 大题序号
        uint8 smallQuestionNum; // 小题序号
        string playerID; // 答题选手（已加密）
        address[] judgeAddr; // 评分裁判(三位裁判共同评分，求平均值)
        uint256[] score; // 评分(链下需要再次除以10)
        uint256 maxScore; // 本题分值
    }   

    // 选手序号 => 自增序号 => 选手答案评分
    mapping(bytes32 => Question[]) private questions;
    // mapping(bytes32 => uint256) private questionIndexs; // 评分索引，顺序 0-N
    
    // Roles.Role private judgeRoles; // 裁判库

    // modifier onlyJudge {
    //     require(judgeRoles.has(msg.sender), "info: permission denied");
    //     _;
    // }

    // 部署时，需要将所有合法裁判添加进本合约
    constructor(/*address[] memory judgeAddrs*/) public {
        // for(uint i = 0; i < judgeAddrs.length; i++) {
        //     judgeRoles.add(judgeAddrs[i]);
        // }
    }

    // TODO 新增Question(由试卷管理合约(PaperManagerment.sol)自动生成)
    function addQuestion(
        Enum.QuestionModule _module,
        uint8 _bigQuestionNum,
        uint8 _smallQuestionNum,
        string memory _playerID,
        uint256 maxScore
    ) public onlyOwner {
        questions[bytes32(keccak256(abi.encodePacked(_playerID)))].push(
            Question(
            _module,
            _bigQuestionNum, 
            _smallQuestionNum,
            _playerID,
            new address[](0),
            new uint256[](0),
            maxScore)
        );
        // questionIndexs[bytes32(keccak256(abi.encodePacked(_playerID)))] += 1;            
    }

    // TODO 评分裁判评分
    function giveScore(
        string memory _playerID,
        uint256 _score, // 分数需已进行倍增
        uint256 _questionIndex,
        address judgeAddr
     ) public onlyOwner {
        require(questions[bytes32(keccak256(abi.encodePacked(_playerID)))][_questionIndex].judgeAddr.length < 3, "warning: judge already given score");
        require(questions[bytes32(keccak256(abi.encodePacked(_playerID)))][_questionIndex].maxScore >= _score, "error: score overflow");
        bytes32 _index = bytes32(keccak256(abi.encodePacked(_playerID)));
        // uint256 index = questionIndexs[bytes32(_playerID)];
        questions[_index][_questionIndex].score.push(_score);
        questions[_index][_questionIndex].judgeAddr.push(judgeAddr);
        // questionIndexs[bytes32(_playerID)] += 1;
    }

    // TODO 汇总所有评分并发送至选选手合约 
    function sendModuleScore(string memory _palyerID) public onlyOwner returns(uint256, uint256, uint256) {
        bytes32 _index = bytes32(keccak256(abi.encodePacked(_palyerID)));
        uint256 len = questions[_index].length;
        uint256 _scoreA = 0; // type is float
        uint256 _scoreB = 0; // type is float
        uint256 _scoreC = 0; // type is float

        for(uint i = 0; i < len; i++) { // 求浮点数平均值
            if(questions[_index][i].module == Enum.QuestionModule.A) {
                _scoreA = _mergeModuleScore(_index, _scoreA, i);
            }else if(questions[_index][i].module == Enum.QuestionModule.B) {
                _scoreB = _mergeModuleScore(_index, _scoreB, i);
            }else if(questions[_index][i].module == Enum.QuestionModule.B) {
                _scoreC = _mergeModuleScore(_index, _scoreC, i);
            }
        }   
        return (_scoreA, _scoreB, _scoreC);
    }

    // 汇总分数
    function _mergeModuleScore(bytes32 _index, uint256 _moduleScore, uint256 i) private view returns(uint256) {
        uint256 _score = 0; 
        (_score, )  = _score.fadd(1, questions[_index][i].score[0], 1);
        (_score, )  = _score.fadd(1, questions[_index][i].score[1], 1);
        (_score, )  = _score.fadd(1, questions[_index][i].score[2], 1);
        (_score, )  = _score.fdiv(1, 3, 1);
        (_moduleScore, ) = _moduleScore.fadd(1, _score, 1);
        return _moduleScore;
    }

    
    

    
}