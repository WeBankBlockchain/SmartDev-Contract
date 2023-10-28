// SPDX-License-Identifier: GPL-2.0-or-laterpragma sol
pragma solidity ^0.6.10;
pragma experimental ABIEncoderV2;

import "Ownable.sol";
import "Enum.sol";
// 问题:
// 在比赛前夜，有关比赛试题的疑似泄露情况引发了广泛讨论。
// 更令人担忧的是，原定发放的纸质试卷在比赛当天被临时换成了U盘方式发放，引发了一些参赛者的不安

// 实现题库
// 考试前基于题库抽取部分题
// 需要真正的随机且题目为题目流程相关



contract PaperManagerment is Ownable {


    // 基于30%题目随机抽取
    struct Question {
        string title; 
        string answer;
        Enum.QuestionStatus questionStatus;
        bool flag; // 是否废除
    }

    mapping(uint256 => Question) private questions;
    uint256 private questionCount; // 被添加入题库的
    uint256 private verifyCount; // 已经被验证过的
    uint256 private endTime; // 公示题目时间
    constructor() public {
        endTime = block.timestamp + 30 days;
    }

    function addQuestion(string memory title, string memory answer) public onlyOwner {
        questions[questionCount++] = Question(title, answer, Enum.QuestionStatus.UnAuthorized, false);
    }

    function verifyQuestion(uint256 _questionIndex, Enum.QuestionStatus _questionStatus) public onlyOwner {
        questions[_questionIndex].questionStatus = _questionStatus;
        if(_questionStatus == Enum.QuestionStatus.Wrong) { // 题目不符规则
            questions[_questionIndex].flag = true;
            return;
        }
        verifyCount += 1;
    }

    function removeQuestion(uint256 _questionIndex) public onlyOwner {
        questions[_questionIndex].flag = true;
    }

    // 查看所有已验证过的题库
    function showRightQuestion() private view returns(Question[] memory) {
        require(block.timestamp >= endTime, "info: That time does not arrive");
        Question[] memory _questions = new Question[](verifyCount);
        uint256 start = 0;
        for(uint256 i = 0; i < verifyCount; i++) {
            if(questions[i].questionStatus == Enum.QuestionStatus.Right) {
              _questions[start++] = questions[i];  
            }
        }

        return _questions;
    }

    // TODO 从已验证题库中，抽取题目，需要VRF实现随机，这里不可再使用伪随机数

}