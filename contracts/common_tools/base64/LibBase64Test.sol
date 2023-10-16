pragma solidity ^0.4.25;
import "./LibBase64.sol";

contract LibBase64 {
    function test_encode() public pure returns (string memory) {
        string memory _str = "hello world";
        return LibBase64.encode(_str);
    }

    function test_decode() public pure returns (string memory) {
        string memory _str = "aGVsbG8gd29ybGQ=";
        return LibBase64.decode(_str);
    }
}