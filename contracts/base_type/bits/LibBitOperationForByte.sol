pragma solidity ^0.4.25;

/**
* @author wpzczbyqy <weipengzhen@czbyqy.com>
* @description  byte类型位操作
* 提供solidity内置函数不包括的位操作方法，例如按位非、移位、取前/后n位等方法
**/

library LibBitOperationForByte {

    /**
    *按位非
    *@param  a byte类型参数
    *@return byte
    **/
    function invert(byte a) internal pure returns (byte) {
        return a ^ 0xff;
    }

    /**
    *向左移动n位
    *@param  a byte类型参数
    *@param  n 向左移动的位数
    *@return byte
    * 例如：0xa1向左移动2位，为0x84
    **/
    function leftShift(byte a, uint n) internal pure returns (byte) {
        uint shifted = uint(a) * 2 ** n;
        return byte(shifted);
    }

    /**
    *向右移动n位
    *@param  a byte类型参数
    *@param  n 向右移动的位数
    *@return byte
    * 例如：0xa1向右移动2位，为0x28
    **/
    function rightShift(byte a, uint n) internal pure returns (byte) {
        uint shifted = uint(a) / 2 ** n;
        return byte(shifted);
    }

    /**
    *获取前n位
    *@param  a byte类型参数
    *@param  n 获取的位数长度
    *@return byte
    * 例如：0xa1获取前2位，为0x80
    **/
    function getFirstN(byte a, uint8 n) internal pure isValidLength(n) returns (byte) {
        byte nbits = byte(2 ** n - 1);
        byte mask = leftShift(nbits, 8 - n);//constrcut the mask,e.g when n == 4, mask is 1111 0000
        return a & mask;
    }

    /**
    *获取后n位
    *@param  a byte类型参数
    *@param  n 获取的位数长度
    *@return byte
    * 例如：0xa1获取后2位，为0x01
    **/
    function getLastN(byte a, uint8 n) internal pure isValidLength(n) returns (byte) {
        if(n == 8) {
            return a;
        }
        uint8 lastN = uint8(a) % (2 ** n);
        return byte(lastN);
    }

    /**
    *获取第n个位置上的bit
    *@param  a byte类型参数
    *@param  n 第n位
    *@return uint8，第n位的值0/1
    **/
    function getBitAtPositionN(byte a, uint8 n) internal pure isValidPosition(n) returns (uint8) {
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
    *@return byte
    **/
    function invertBitAtPositionN(byte a, uint8 n) internal pure isValidPosition(n) returns (byte) {
        return a ^ leftShift(0x01, n);
    }

    /*校验长度*/
    modifier isValidLength(uint8 n) {
        require(n < 9, "Invalid Length: byte is 8 bits");
        _;
    }

    /*校验位置*/
    modifier isValidPosition(uint8 n) {
        require(n < 8, "Invalid Position: n start with 0, n < 8");
        _;
    }
}