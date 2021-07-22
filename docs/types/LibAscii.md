# LibAscii.sol

LibAscii 提供ascii与字符串之间的转换


## 接口说明
1. str2ascii(string data, uint radix)：字符串转ascii字符串
- data：原字符串(大小写均可)，需要和radix配合，若不匹配会回滚报错
- radix 原字符串进制 仅支持10，16进制

2. ascii2str(string ascii)：ascii字符串转10进制字符串
- ascii：ascii字符串

## 使用方法

```
pragma solidity ^0.4.25;

import "./LibAscii.sol";

contract LibAsciiTest{
    
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

```