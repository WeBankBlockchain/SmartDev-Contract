// SPDX-License-Identifier: UNLICENSED
/// @author tianlan

pragma solidity >=0.8.0;

contract HistoryQuery {
    uint public _value;
    mapping(uint => uint) public _historyValue;

    function setValue(uint value) external {
        uint prevValue = _historyValue[block.number];
        _value = value;
        _historyValue[block.number] = prevValue;
    }

    function getValue(uint blockNumber) external view returns (uint) {
        uint low = 0;
        uint high = block.number;
        
        while (low <= high) {
            uint mid = (low + high) / 2;
            if (mid == blockNumber) {
                return _historyValue[mid];    
            } else if (mid < blockNumber) {
                low = mid + 1;
            } else {
                high = mid - 1;   
            }
        }

        return _historyValue[blockNumber];
    }
}



