pragma solidity ^0.6.10;
pragma experimental ABIEncoderV2;

contract HistorySnapshot {
    // 用一个结构体记录块高和其他想要记录的值
    struct Snapshot {
        uint blockNumber;
        string name;
    }
    // 当前值
    string _name;
    
    // 存储快照的数组
    Snapshot[] public _snapshotList;

    // 初始化
    constructor(string memory name) public {
        set(name);
    }
    
    // 更改当前值，并把值与当前块高push到快照数组
    function set(string memory name) public {
        _name = name;
        _snapshotList.push(Snapshot({ blockNumber: block.number, name: name }));
    }
    
    // 获取当前值
    function get() public view returns(string memory) {
        return _name;
    }
    
    // 调试用的获取当前块高
    function getBlockNumber() public view returns(uint) {
        return block.number;
    }
    
    // 通过块高获取值，用二分法找到<= blockNumber的最新值并返回
    function getByBlockNumber(uint blockNumber) public view returns(string memory) {
        require(blockNumber >= _snapshotList[0].blockNumber, "不存在！");
        
        uint l = 0;
        uint r = _snapshotList.length - 1;
        while (l <= r) {
            uint m = (l + r) / 2;
            Snapshot memory snapshot = _snapshotList[m];
            if (snapshot.blockNumber < blockNumber) {
                l = m + 1;
            } else if (snapshot.blockNumber > blockNumber) {
                r = m - 1;
            } else {
                return snapshot.name;
            }
        }
        return _snapshotList[r].name;
    }
}