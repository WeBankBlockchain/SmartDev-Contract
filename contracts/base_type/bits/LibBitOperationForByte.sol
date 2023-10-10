// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.4.25;

/**
* @author wpzczbyqy <weipengzhen@czbyqy.com>
* byte类型位操作 提供solidity内置函数不包括的位操作方法，例如按位非、移位、取前/后n位等方法
**/

library LibBitOperationForByte {
//在 0.8.0 之前, byte 用作为 bytes1 的别名。

    /**
    *按位非
    *@param  a byte类型参数
    *@return bytes1
    **/
    function invert(bytes1 a) internal pure returns (bytes1) {
        return a ^ 0xff;
    }

    /**
    *向左移动n位
    *@param  a byte类型参数
    *@param  n 向左移动的位数
    *@return bytes1
    * 例如：0xa1向左移动2位，为0x84
    **/
    function leftShift(bytes1 a, uint8 n) internal pure returns (bytes1) {
        uint8 shifted = uint8(a) * uint8(2) ** n;
        return bytes1(shifted);
    }

    /**
    *向右移动n位
    *@param  a byte类型参数
    *@param  n 向右移动的位数
    *@return bytes1
    * 例如：0xa1向右移动2位，为0x28
    **/
    function rightShift(bytes1 a, uint8 n) internal pure returns (bytes1) {
        uint8 shifted = uint8(a) / uint8(2) ** n;
        return bytes1(shifted);
    }

    /**
    *获取前n位
    *@param  a byte类型参数
    *@param  n 获取的位数长度
    *@return bytes1
    * 例如：0xa1获取前2位，为0x80
    **/
    function getFirstN(bytes1 a, uint8 n) internal pure isValidLength(n) returns (bytes1) {
        bytes1 nbits = bytes1(uint8(2) ** n - 1);
        bytes1 mask = leftShift(nbits, 8 - n);//constrcut the mask,e.g when n == 4, mask is 1111 0000
        return a & mask;
    }

    /**
    *获取后n位
    *@param  a byte类型参数
    *@param  n 获取的位数长度
    *@return bytes1
    * 例如：0xa1获取后2位，为0x01
    **/
    function getLastN(bytes1 a, uint8 n) internal pure isValidLength(n) returns (bytes1) {
        if(n == 8) {
            return a;
        }
        uint8 lastN = uint8(a) % (uint8(2) ** n);
        return bytes1(lastN);
    }

    /**
    *获取第n个位置上的bit
    *@param  a byte类型参数
    *@param  n 第n位
    *@return uint8，第n位的值0/1
    **/
    function getBitAtPositionN(bytes1 a, uint8 n) internal pure isValidPosition(n) returns (uint8) {
        bool val = a & leftShift(0x01, n) != 0;
        if(val == true){
            return 1;
        }
        return 0;
    }

    /**
    *将第n个位置上的bit取反
    *@param  a byte类型参数
    *@param  n 第n位
    *@return bytes1
    **/
    function invertBitAtPositionN(bytes1 a, uint8 n) internal pure isValidPosition(n) returns (bytes1) {
        return a ^ leftShift(0x01, n);
    }

    /*校验长度*/
    modifier isValidLength(uint8 n) {
        require(n < 9, "Invalid Length: bytes1 is 8 bits");
        _;
    }

    /*校验位置*/
    modifier isValidPosition(uint8 n) {
        require(n < 8, "Invalid Position: n start with 0, n < 8");
        _;
    }
}