pragma solidity ^0.4.25;

contract LibBits {
    function and(bytes1 a, bytes1 b) returns (bytes1) {
        return a & b;
    }
    function or(bytes1 a, bytes1 b) returns (bytes1) {
         return a | b;
    }
    function xor(bytes1 a, bytes1 b) returns (bytes1) {
        return a ^ b;
    }
    function negate(bytes1 a) returns (bytes1) {
        return a ^ allOnes();
    }
    function shiftLeft(bytes1 a, uint8 n) returns (bytes1) {
        var shifted = uint8(a) <<n;
        return bytes1(shifted);
    }
    function shiftRight(bytes1 a, uint8 n) returns (bytes1) {
        var shifted = uint8(a) >> n;
        return bytes1(shifted);
    }

    function getFirstN(bytes1 a, uint8 n) returns (bytes1) {
        var nOnes = bytes1(2 ** n - 1);
        var mask = shiftLeft(nOnes, 8 - n); // Total 8 bits
        return a & mask;
    }

    function getLastN(bytes1 a, uint8 n) returns (bytes1) {
        var lastN = uint8(a) % 2 ** n;
        return bytes1(lastN);
    }

    // Sets all bits to 1
    function allOnes() returns (bytes1) {
        return bytes1(-1); // 0 - 1, since data type is unsigned, this results in all 1s.
    }

    // Get bit value at position
    function getBit(bytes1 a, uint8 n) returns (bool) {
        return a & shiftLeft(0x01, n) != 0;
    }

    // Set bit value at position
    function setBit(bytes1 a, uint8 n) returns (bytes1) {
        return a | shiftLeft(0x01, n);
    }

    // Set the bit into state "false"
    function clearBit(bytes1 a, uint8 n) returns (bytes1) {
        bytes1 mask = negate(shiftLeft(0x01, n));
        return a & mask;
    }
}

