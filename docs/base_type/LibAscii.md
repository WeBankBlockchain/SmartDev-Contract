# LibAscii.sol

LibAscii 提供ascii与字符串之间的转换


## 函数说明
1. decAscii2str(string memory data)：10进制ascii转字符串
- data：10进制ascii字符串 0至127

2. hexAscii2str(string memory data)：16进制ascii转字符串
- data：16进制ascii字符串 00至7f(不限大小写)

3. str2ascii(string memory ascii)：ascii字符串转10进制字符串
- ascii：ascii字符串

## 使用方法

```
pragma solidity ^0.4.25;

import "./LibAscii.sol";

contract LibAsciiTest{
    
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

```