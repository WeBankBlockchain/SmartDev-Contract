pragma solidity ^0.4.25;

import "./LibAscii.sol";

contract LibAsciiTest{

    function str2ascii() public {
        string memory result= LibAscii.str2ascii("55",10);
        //result："7"
        string memory result1= LibAscii.str2ascii("55",16);
        //result1："U"
    }
    function ascii2str(string ascii) public pure returns (string){
        return LibAscii.ascii2str(ascii);
    }
}