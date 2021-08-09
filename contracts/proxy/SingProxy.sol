pragma solidity ^0.6.10;

import "./ISing.sol";

/**
 * @author SomeJoker
 * @title 代理
 */
contract SingProxy{  

    event ProxyLog(address indexed singer,string indexed context);

    ISing iSing;
    constructor(address _sing) public{
        iSing = ISing(_sing);
    }

    function proxySing() public {
        emit ProxyLog(msg.sender,"before proxy do someting");
        iSing.singing(msg.sender);
        emit ProxyLog(msg.sender,"after proxy do someting");
    }
}