pragma solidity ^0.4.25;

/**
* @author  weipengzhen@czbyqy.com
* @title   byte类型位操作
**/

library LibBitOperationForByte {

    /*
    *@notice 与操作
    *@return byte
    * 例如：0xa1 & 0x11 = 0x01
    */
    function and(byte a, byte b) internal pure returns (byte) {
        return a & b;
    }

    //或操作
    function or(byte a, byte b) internal pure returns (byte) {
        return a | b;
    }

    //异或操作
    function xor(byte a, byte b) internal pure returns (byte) {
        return a ^ b;
    }

    //非操作
    function invert(byte a) internal pure returns (byte) {
        return a ^ setAllBitsToOne();
    }

    /*
    *@notice 向左移动n位
    *@return byte
    * 例如：0xa1向左移动2位，为0x84
    */
    function leftShift(byte a, uint n) internal pure returns (byte) {
        uint shifted = uint(a) * 2 ** n;
        return byte(shifted);
    }

    /*
    *@notice 向右移动n位
    *@return byte
    */
    function rightShift(byte a, uint n) internal pure returns (byte) {
        uint shifted = uint(a) / 2 ** n;
        return byte(shifted);
    }

    /*
    *@notice 获取前n位
    *@return byte
    * 例如：0xa1获取前2位，为0x80
    */
    function getFirstN(byte a, uint8 n) internal pure isValidLength(n) returns (byte) {
        byte nbits = byte(2 ** n - 1);
        byte mask = leftShift(nbits, 8 - n);//constrcut the mask,e.g when n == 4, mask is 1111 0000
        return a & mask;
    }

    //获取后n位
    function getLastN(byte a, uint8 n) internal pure isValidLength(n) returns (byte) {
        uint8 lastN = uint8(a) % 2 ** n;
        return byte(lastN);
    }

    /*
    *@notice 把所有的位都置为1
    *@return byte 0xff
    */
    function setAllBitsToOne() internal pure returns (byte) {
        return byte(-1); // 0 - 1, since data type is unsigned, this results in all 1, 1111 1111.
    }

    /*
    *@notice 获取第n个位置上的bit
    *@return uint8，第n位的值0/1
    */
    function getBitAtPositionN(byte a, uint8 n) internal pure isValidPosition(n) returns (uint8) {
        bool val = a & leftShift(0x01, n) != 0;
        if(val == true){
            return 1;
        }
        return 0;
    }

    /*
    *@notice 将第n个位置上的bit取反
    *@return byte
    */
    function invertBitAtPositionN(byte a, uint8 n) internal pure isValidPosition(n) returns (byte) {
        return a ^ leftShift(0x01, n);
    }

    modifier isValidLength(uint8 n) {
        require(n < 9, "byte is 8 bits");
        _;
    }

    modifier isValidPosition(uint8 n) {
        require(n < 8, "n start with 0, n < 8");
        _;
    }
}
