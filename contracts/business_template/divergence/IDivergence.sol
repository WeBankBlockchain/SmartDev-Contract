// SPDX-License-Identifier: UNLICENSED
pragma solidity^0.6.10;

// 定义接口
interface IDivergence {
    // 注册
    function register(string memory _name) external;
    // 出手
    function punch(bytes32 _hash) external;
    // 证明
    function proofing(string memory _salt, uint8 _opt) external;
    // 查看获胜
    // 返回值： 1. 昵称 2. 玩家1出手 3. 玩家2出手 4. 轮次
    function winner() external view returns (string memory, string memory, string memory, uint256);
}
