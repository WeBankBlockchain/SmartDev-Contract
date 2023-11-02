// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.6.10;

contract Enum {


    // 裁判星级
    enum JudgeCreditStatus {
        Low, Medium, High
    }

    // 题目等级（已验证，未验证, 错误）
    enum QuestionStatus {
        Right,UnAuthorized,Wrong
    }


    // 题目模块
    enum QuestionModule {
        A, B, C
    }
    
}

