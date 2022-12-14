// SPDX-License-Identifier: MIT
pragma solidity ^0.6.10;
pragma experimental ABIEncoderV2;

import "./MinimalProxy.sol";

contract MinimalProxyFactory is MinimalProxy {
    // 代理合约
    struct Proxy {
        uint256    id;
        address    clone;
        string     description;
    }
    // 一份逻辑合约对应多个代理合约
    mapping (address => Proxy[]) logic;

    event cloneProxy(Proxy proxy);

    function createCloneProxy(address implementation, string memory _description) public returns(address) {
        address clone = createClone(implementation);
        // Read slot from memory.
        uint length = logic[implementation].length;
        uint _id = logic[implementation].length == 0 ? 1: ++length;
        Proxy memory proxy = Proxy({id: _id, clone: clone, description: _description});
        logic[implementation].push(proxy);
        emit cloneProxy(proxy);
        return clone;
    }

    function getClone(address implementation, uint256 id) public view returns(Proxy memory) {
        Proxy memory proxy;
        for (uint i=0; i < logic[implementation].length; i++) {
            if (logic[implementation][i].id == id) proxy = logic[implementation][i];
        }
        require(proxy.clone != address(0), "The clone contract cannot be found");
        return proxy;
    }

    function getClones(address implementation) public view returns(Proxy[] memory) {
        return logic[implementation];
    }
}
