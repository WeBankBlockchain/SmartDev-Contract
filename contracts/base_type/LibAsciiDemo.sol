pragma solidity ^0.4.25;

import "./LibAscii.sol";

contract LibAsciiDemo{

    function str2ascii() public view returns(string,string){
        string memory result= LibAscii.str2ascii("55",10);
        //result："7"
        string memory result1= LibAscii.str2ascii("55",16);
        //result1："U"
        return (result,result1);
    }

    function ascii2str() public view returns(string){
        string memory result=LibAscii.ascii2str("Aa");
        //result："6597"
        return result;
    }
}