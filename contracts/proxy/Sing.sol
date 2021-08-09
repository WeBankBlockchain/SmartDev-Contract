pragma solidity ^0.6.10;

import "./ISing.sol";
/**
 * @author SomeJoker
 * @title 实现
 */
contract Sing is ISing{  

    event SingLog(address indexed singer,uint256 indexed time);

    function singing(address _singer) public override{
        emit SingLog(_singer, now);
    }
}