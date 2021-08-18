pragma solidity ^0.4.25;

import "./ISing.sol";
/**
 * @author SomeJoker
 * @title 实现
 */
contract Sing is ISing{  

    event SingLog(address singer,uint256 time);

    function singing(address _singer) public {
        emit SingLog(_singer, now);
    }
}