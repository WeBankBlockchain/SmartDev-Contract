pragma solidity ^0.4.25;

/**
 * @title Counters
 * @author SomeJoker
 * @dev 提供只能递增或递减1的计数器。这可以用于例如 跟踪铸造的ERC721的id或计数请求id。
 * 
 * 用法: `using Counters for Counters.Counter;`
 */
library Counters {
    struct Counter {
        uint256 _value; // default: 0
    }

    function current(Counter storage counter) internal view returns (uint256) {
        return counter._value;
    }

    function increment(Counter storage counter) internal {
        // 以1为增量，要达到2^256=1.1579209e+77,几乎不存在这样的场景,所以跳过了加法的安全检查,以节省gas
        counter._value += 1;
    }

    function decrement(Counter storage counter) internal {
        require(counter._value >= 1, "Counters decrement: subtraction overflow");
        counter._value = counter._value - 1;
    }
}
