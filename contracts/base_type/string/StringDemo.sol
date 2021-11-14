pragma solidity ^0.4.25;
import "./LibString.sol";

contract StringDemo {

    function demo1() public{
        string memory str = "你好";
        uint256 lenOfChars = LibString.lenOfChars(str);
        uint256 lenOfBytes = LibString.lenOfBytes(str);
        require(lenOfChars == 2);
        require(lenOfBytes == 6);
    }

    function demo2() public view returns(string memory)  {
        string memory c = LibString.toUppercase("abcd");// Expected to be ABCD
        return c;
    }

    function demo3() public view {
        bool r = LibString.equal("abcd","abcd");//Expected to be true
        require(r);
    }
}
