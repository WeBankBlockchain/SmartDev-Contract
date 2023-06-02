// SPDX-License-Identifier: UNLICENSED
/// @author tianlan

pragma solidity >=0.8.0;

contract MultiCall {
    function call(
        address[] calldata addrs,
        bytes[] calldata data
    ) external view returns (bytes[] memory) {
        require(addrs.length == data.length, "target length != data length");

        bytes[] memory results = new bytes[](data.length);

        for (uint i; i < addrs.length; i++) {
            (bool success, bytes memory result) = addrs[i].staticcall(data[i]);
            require(success, "call failed");
            results[i] = result;
        }

        return results;
    }
}


