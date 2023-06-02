// SPDX-License-Identifier: MIT
pragma solidity >=0.4.25;

import "./TypeUtils.sol";

/**
 * @dev TypeUtils测试demo
 * @author ashinnotfound
 */
contract TypeUtilsDemo{

    function stringToBytes32Test() public pure returns (bytes32) {
        string memory word = "ni hao";
        return TypeUtils.stringToBytes32(word);
        // result: 0x6e692068616f0000000000000000000000000000000000000000000000000000
    }

    function bytes32ToStringTest() public pure returns (string memory) {
        bytes32 word = 0x6e692068616f0000000000000000000000000000000000000000000000000000;
        return TypeUtils.bytes32ToString(word);
        // result: "ni hao"
    }

    function stringToBytesTest() public pure returns (bytes memory) {
        string memory word = "ni hao";
        return TypeUtils.stringToBytes(word);
        // result: 0x6e692068616f
    }

    function bytesToStringTest() public pure returns (string memory, string memory) {
        bytes memory word1 = "0x6e692068616f";
        bytes memory word2 = "0x6e692068616f0000000000000000000000000000000000000000000000000000";
        return (TypeUtils.bytesToString(word1), TypeUtils.bytesToString(word2));
        // result: "ni hao", "ni hao\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000"
    }

    function bytesToBytes32Test() public pure returns (bytes32) {
        bytes memory word = "0x6e692068616f";
        return TypeUtils.bytesToBytes32(word);
        // result: 0x6e692068616f0000000000000000000000000000000000000000000000000000
    }

    function bytes32ToBytesTest() public pure returns (bytes memory){
        bytes32 word = 0x6e692068616f0000000000000000000000000000000000000000000000000000;
        return TypeUtils.bytes32ToBytes(word);
        // result: 0x6e692068616f
    }

    function addressToStringTest() public pure returns (string memory) {
        address addr = 0x86cA07C6D491Ad7A535c26c5e35442f3e26e8497;
        return TypeUtils.addressToString(addr);
        // result: "0x86cA07C6D491Ad7A535c26c5e35442f3e26e8497"
    }

    function stringToAddressTest() public pure returns (address) {
        string memory addr = "0x86cA07C6D491Ad7A535c26c5e35442f3e26e8497";
        return TypeUtils.stringToAddress(addr);
        // result: 0x86cA07C6D491Ad7A535c26c5e35442f3e26e8497
    }

    function bytesToAddressTest() public pure returns (address) {
        bytes memory addr = "0x86cA07C6D491Ad7A535c26c5e35442f3e26e8497";
        return TypeUtils.bytesToAddress(addr);
        // result: 0x86cA07C6D491Ad7A535c26c5e35442f3e26e8497

        // bytes memory addr = "0x86cA07C6D491Ad7A535c26c5e35442f3e26e849700";
        // return TypeUtils.bytesToAddress(addr);
        // // result: TypeUtils::bytesToAddressException: Invalid input length
    }

    function addressTobytesTest() public pure returns (bytes memory) {
        address addr = 0x86cA07C6D491Ad7A535c26c5e35442f3e26e8497;
        return TypeUtils.addressTobytes(addr);
        // result: "0x86cA07C6D491Ad7A535c26c5e35442f3e26e8497"
    }

    function uint256ToStringTest() public pure returns (string memory) {
        uint256 num = 17666;
        return TypeUtils.uint256ToString(num);
        // result: "17666"
    }

    function stringToUint256Test() public pure returns (uint256) {
        string memory num = "17666";
        return TypeUtils.stringToUint256(num);
        // result: 17666

        // string memory num = "17666hhh";
        // return TypeUtils.stringToUint256(num);
        // // result: TypeUtils::stringToUint256Exception: Invalid number in string
    }

    function uint256ToBytes32Test() public pure returns (bytes32) {
        uint256 num = 17666;
        return TypeUtils.uint256ToBytes32(num);
        // result: 0x0000000000000000000000000000000000000000000000000000000000004502
    }

    function bytes32ToUint256Test() public pure returns (uint256) {
        bytes32 num = 0x0000000000000000000000000000000000000000000000000000000000004502;
        return TypeUtils.bytes32ToUint256(num);
        // result: 17666
    }

    function bytesToUint256Test() public pure returns (uint256) {
        bytes memory num = "0x0000000000000000000000000000000000000000000000000000000000004502";
        return TypeUtils.bytesToUint256(num);
        // result: 17666
    }

    function uint256ToBytesTest() public pure returns (bytes memory) {
        uint256 num = 17666;
        return TypeUtils.uint256ToBytes(num);
        // result: 0x0000000000000000000000000000000000000000000000000000000000004502
    }
}