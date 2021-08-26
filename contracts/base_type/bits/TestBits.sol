pragma solidity >=0.4.24 <0.6.11;

import "./LibBits.sol";

contract TestBits {
    
    function testAnd() public view returns(bytes1 ){
        bytes1 a = 1;
        bytes1 b = 5;
        bytes1 result = LibBits.and(a, b);//Expected to be 1
        return result;
    }

    function testOr() public view returns(bytes1 ){
        bytes1 a = 2; // 0x010
        bytes1 b = 5; // 0x101
        bytes1 result = LibBits.or(a, b);//Expected to be 7, 0x111
        return result;
    }

    function testXor() public view returns(bytes1 ){
        byte a = 3; // 0x011
        byte b = 5; // 0x101
        bytes1 result = LibBits.xor(a, b); //Expected to be 6, 0x110
        return result;
    }

    function testNegate() public view returns(bytes1){
        bytes1 r = LibBits.negate(5);//Expected to be -6 0x00000101 -> 0x11111010
        return r;
    }

    function testShiftLeft() public view returns(bytes1){
        bytes1 r = LibBits.shiftLeft(2,3);//Expected to be 16, 0x00000010 -> 0x00010000
        return r;
    }

    function testShiftRight() public view returns(bytes1){
        bytes1 r = LibBits.shiftRight(15,3);//Expected to be 1, 0x00001111 -> 0x00000001
        return r;
    }

    function testGetLastN() public view returns(bytes1){
        bytes1 r = LibBits.getLastN(60,3);//Expected to be 4 0x00111100 -> 0x00000100
        return r;
    }

    function getFirstN() public view returns(bytes1){
        byte r = LibBits.getFirstN(60,3);//Expected to be 32,  0x00111100 -> 0x00100000
        return r;
    }

    function testAllOnes() public view returns(bytes1){
        byte r = LibBits.allOnes();//Expected to be 255
        return r;
    }

    function testGetBit() public view returns(bool){
        bool r = LibBits.getBit(3,2);//Expected to be 1
        return r;
    }

    function testSetBit() public view returns(bytes1){
       byte r = LibBits.setBit(17,2);//Expected to be 19, 0x00010001 -> 0x00010011
       return r;
    }

    function testClearBit() public view returns(bytes1){
      byte r = LibBits.clearBit(17,5);//Expected to be 1
      return r;
    }
}