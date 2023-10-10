// SPDX-License-Identifier: UNLICENSED
/// @author tianlan

pragma solidity >=0.8.0;

import "./MultiCall.sol";

contract MultiCallTest {
    MultiCall public _multi;

    constructor(MultiCall multi) {
        _multi = multi;
    }

    function show(uint value) external pure returns (uint) {
        return value;
    }

    function getData(uint value) internal pure returns (bytes memory) {
        return abi.encodeWithSelector(this.show.selector, value);
    }

    function testMultiCall() external  view returns (bytes[] memory) {
        address[] memory addr = new address[](2);
        addr[0] = address(this);
        addr[1] = address(this);

        bytes[] memory data =  new bytes[](2);
        data[0] = getData(1);
        data[1] = getData(2);

        return _multi.call(addr, data);
    }
}