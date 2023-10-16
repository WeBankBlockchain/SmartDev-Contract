pragma solidity ^0.4.25;

import "./LibAscii.sol";

contract LibAsciiDemo{

    function ascii2str() public pure returns(string,string,string,string){
        //10进制ascii转字符串
        string memory result= LibAscii.decAscii2str("55");
        //result："7"
        string memory result1= LibAscii.decAscii2str("109");
        //result："m"

        //16进制ascii转字符串
        string memory result2= LibAscii.hexAscii2str("37");
        //result1："7"
        string memory result3= LibAscii.hexAscii2str("6D");
        //result1："m"

        return (result,result1,result2,result3);
    }

    function str2ascii() public pure returns(string){
        string memory result=LibAscii.str2ascii("Zz");
        //result："90122"
        return result;
    }
}