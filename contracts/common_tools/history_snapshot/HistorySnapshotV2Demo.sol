// SPDX-License-Identifier: MIT
pragma solidity >=0.4.25;
pragma experimental ABIEncoderV2;

import "./HistorySnapshotV2.sol";
/**
 * @dev 历史状态快照合约测试demo
 */
contract HistorySnapshotV2Demo{
    HistorySnapshotV2 private historySnapshotV2;
    
    //以string类型为例
    function test() returns (string memory value1, string memory value2, uint256[] memory blockNumbers, string[] memory values){
        historySnapshotV2 = new HistorySnapshotV2;

        // updateString1();
        value1 = historySnapshotV2.getString("test", 0);
        // 此时value1应该为hello
        // updateString2();
        value1 = historySnapshotV2.getString("test", 0);
        // 此时value1应该为world
        (blockNumbers, values) = historySnapshotV2.getStringHistory("test");
        // blockNumbers应该为[num1, num2] 其中num1和num2为调用updateString1()、updateString2()时的块号 
        // values应该为["hello", "world"]
    }

    function updateString1() public {
        historySnapshotV2.updateString("test", "hello");
    }
    function updateString2() public {
        historySnapshotV2.updateString("test", "world");
    }
}