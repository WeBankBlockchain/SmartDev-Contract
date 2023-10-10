pragma solidity >=0.4.25;

library LibBits {
    function and(bytes1 a, bytes1 b) internal pure returns (bytes1) {
        return a & b;
    }

    function or(bytes1 a, bytes1 b) internal pure returns (bytes1) {
        return a | b;
    }

    function xor(bytes1 a, bytes1 b) internal pure returns (bytes1) {
        return a ^ b;
    }

    /**
    *按位非
    *@param  a bytes1类型参数
    *@return bytes1
    **/
    function invert(bytes1 a) internal pure returns (bytes1) {
        return a ^ 0xff;
    }

    function negate(bytes1 a) internal pure returns (bytes1) {
        return a ^ allOnes();
    }

    function shiftLeft(bytes1 a, uint8 n) internal pure returns (bytes1) {
        uint8 shifted = uint8(a) << n;
        return bytes1(shifted);
    }

    function shiftRight(bytes1 a, uint8 n) internal pure returns (bytes1) {
        uint8 shifted = uint8(a) >> n;
        return bytes1(shifted);
    }

    // get the high bit data and keep it on high
    function getFirstN(bytes1 a, uint8 n) internal pure isValidLength(n) returns (bytes1) {
        bytes1 nOnes = bytes1(uint8(2)**n - 1);
        bytes1 mask = shiftLeft(nOnes, 8 - n); // Total 8 bits
        return a & mask;
    }

    function getLastN(bytes1 a, uint8 n) internal pure isValidLength(n) returns (bytes1) {
        uint8 lastN = uint8(a) % uint8(2)**n;
        return bytes1(lastN);
    }

    // Sets all bits to 1
    function allOnes() internal pure returns (bytes1) {
        return bytes1(0xff);
    }

    // Get bit value at position
    function getBit(bytes1 a, uint8 n)
        internal
        pure
        isValidPosition(n)
        returns (bool)
    {
        n--;
        return a & shiftLeft(0x01, n) != 0;
    }

    // Set bit value at position
    function setBit(bytes1 a, uint8 n)
        internal
        pure
        isValidPosition(n)
        returns (bytes1)
    {
        n--;
        return a | shiftLeft(0x01, n);
    }

    // Set the bit into state "false"
    function clearBit(bytes1 a, uint8 n)
        internal
        pure
        isValidPosition(n)
        returns (bytes1)
    {
        n--;
        bytes1 mask = negate(shiftLeft(0x01, n));
        return a & mask;
    }

    modifier isValidPosition(uint8 n) {
        require(n < 9 && n > 0, "Invalid Position: n start with 1, n <= 8");
        _;
    }

    /*校验长度*/
    modifier isValidLength(uint8 n) {
        require(n < 9, "Invalid Length: byte is 8 bits");
        _;
    }
}
