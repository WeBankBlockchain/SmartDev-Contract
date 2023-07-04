# HistorySnapshotV2

>   广东工业大学 陈汛

## 合约简介

历史状态快照合约：通过块高来查询某一个值任何历史状态，适用于0.4.25及以上版本。

## 使用方法

import该合约(HistorySnapshotV2.sol)并实例化调用即可。下面是一个例子：

```
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
```



## API列表

| 编号 | API                                                          | 描述                              |
| ---- | ------------------------------------------------------------ | --------------------------------- |
| 1    | addAvailable(address _addr) public                           | 添加授权                          |
| 2    | deleteAvailable(address _addr) public                        | 删除授权                          |
| 3    | updateBytes(string memory _field, bytes memory _value) public | 增加bytes类型的历史快照           |
| 4    | updateBytes32(string memory _field, bytes32 _value) public   | 增加bytes32类型的历史快照         |
| 5    | updateString(string memory _field, string memory _value) public | 增加string类型的历史快照          |
| 6    | updateUint256(string memory _field, uint256 _value) public   | 增加uint256类型的历史快照         |
| 7    | updateAddress(string memory _field, address _value) public   | 增加address类型的历史快照         |
| 8    | updateBool(string memory _field, bool _value) public         | 增加bool类型的历史快照            |
| 9    | getBytes(string memory _field, uint256 _blockNumber) public view returns (bytes memory) | 获取bytes类型的历史快照           |
| 10   | getBytes32(string memory _field, uint256 _blockNumber) public view returns (bytes32) | 获取bytes32类型的历史快照         |
| 11   | getString(string memory _field, uint256 _blockNumber) public view returns (string memory) | 获取string类型的历史快照          |
| 12   | getUint256(string memory _field, uint256 _blockNumber) public view returns (uint256) | 获取uint256类型的历史快照         |
| 13   | getAddress(string memory _field, uint256 _blockNumber) public view returns (address) | 获取address类型的历史快照         |
| 14   | getBool(string memory _field, uint256 _blockNumber) public view returns (bool) | 获取bool类型的历史快照            |
| 15   | getBytesHistory(string memory _field) public view returns (uint256[] memory blockNumbers, bytes[] memory values) | 获取bytes类型的所有历史快照节点   |
| 16   | getBytes32History(string memory _field) public view returns (uint256[] memory blockNumbers, bytes32[] memory values) | 获取bytes32类型的所有历史快照节点 |
| 17   | getStringHistory(string memory _field) public view returns (uint256[] memory blockNumbers, string[] memory values) | 获取string类型的所有历史快照节点  |
| 18   | getUint256History(string memory _field) public view returns (uint256[] memory blockNumbers, uint256[] memory values) | 获取uint256类型的所有历史快照节点 |
| 19   | getAddressHistory(string memory _field) public view returns (uint256[] memory blockNumbers, address[] memory values) | 获取address类型的所有历史快照节点 |
| 20   | getBoolHistory(string memory _field) public view returns (uint256[] memory blockNumbers, bool[] memory values) | 获取bool类型的所有历史快照节点    |

