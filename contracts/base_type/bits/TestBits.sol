
pragma solidity >=0.4.24 <0.6.11;

import "./LibBits.sol"; // 导入LibBits.sol合约

contract TestBits {

    function testAnd() public view returns(bytes1 ){
        bytes1 a = 1; // 定义变量a为1
        bytes1 b = 5; // 定义变量b为5
        bytes1 result = LibBits.and(a, b); // 调用LibBits合约中的and函数进行按位与操作，将结果赋值给result变量，预期结果为1
        return result; // 返回result变量
    }

    function testOr() public view returns(bytes1 ){
        bytes1 a = 2; // 定义变量a为2，对应的二进制为0x010
        bytes1 b = 5; // 定义变量b为5，对应的二进制为0x101
        bytes1 result = LibBits.or(a, b); // 调用LibBits合约中的or函数进行按位或操作，将结果赋值给result变量，预期结果为7，对应的二进制为0x111
        return result; // 返回result变量
    }

    function testXor() public view returns(bytes1 ){
        byte a = 3; // 定义变量a为3，对应的二进制为0x011
        byte b = 5; // 定义变量b为5，对应的二进制为0x101
        bytes1 result = LibBits.xor(a, b); // 调用LibBits合约中的xor函数进行按位异或操作，将结果赋值给result变量，预期结果为6，对应的二进制为0x110
        return result; // 返回result
    }

    function testNegate() public view returns(bytes1){
        bytes1 r = LibBits.negate(5); // 调用LibBits合约中的negate函数进行按位取反操作，将结果赋值给r变量，预期结果为-6，对应的二进制为0x00000101 -> 0x11111010
        return r; // 返回r
    }

    function testShiftLeft() public view returns(bytes1){
        bytes1 r = LibBits.shiftLeft(2,3); // 调用LibBits合约中的shiftLeft函数进行左移操作，将结果赋值给r变量，预期结果为16，对应的二进制为0x00000010 -> 0x00010000
        return r; // 返回r
    }

    function testShiftRight() public view returns(bytes1){
        bytes1 r = LibBits.shiftRight(15,3); // 调用LibBits合约中的shiftRight函数进行右移操作，将结果赋值给r变量，预期结果为1，对应的二进制为0x00001111 -> 0x00000001
        return r; // 返回r
    }

    function testGetLastN() public view returns(bytes1){
        bytes1 r = LibBits.getLastN(60,3); // 调用LibBits合约中的getLastN函数获取指定数字二进制的最后n位，将结果赋值给r变量，预期结果为4，对应的二进制为0x00111100 -> 0x00000100
        return r; // 返回r变量
    }

    function getFirstN() public view returns(bytes1){
        byte r = LibBits.getFirstN(60,3); // 调用LibBits合约中的getFirstN函数获取指定数字二进制的前n位，将结果赋值给r变量，预期结果为32，对应的二进制为0x00111100 -> 0x00100000
        return r; // 返回r
    }

    function testAllOnes() public view returns(bytes1){
        byte r = LibBits.allOnes(); // 调用LibBits合约中的allOnes函数获取二进制全为1的数字，将结果赋值给r变量，预期结果为255
        return r; // 返回r变量
    }

    function testGetBit() public view returns(bool){
        bool r = LibBits.getBit(3,2); // 调用LibBits合约中的getBit函数获取指定数字二进制的