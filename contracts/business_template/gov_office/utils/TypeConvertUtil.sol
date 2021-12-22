pragma solidity ^0.4.25;

/*
* solidity类型转换工具合约
*
*/
library TypeConvertUtil{

   /*
    * 将string转化为bytes32的工具方法
    *
    * @param source      字符串
    *
    * @return            bytes32值
    */
    function stringToBytes32(string memory source) internal pure returns (bytes32 result) {

        bytes memory tempEmptyStringTest = bytes(source);
        if (tempEmptyStringTest.length == 0) {
            return 0x0;
        }
        assembly {
            result := mload(add(source, 32))
        }
    }


   /*
    * 将bytes32转化为string的工具方法
    *
    * @param source     bytes32值
    *
    * @return           字符串
    */
    function bytes32ToString(bytes32 source) internal pure returns (string) {
        bytes memory bytesString = new bytes(32);
        uint charCount = 0;
        for (uint j = 0; j < 32; j++) {
            byte char = byte(bytes32(uint(source) * 2 ** (8 * j)));
            if (char != 0) {
                bytesString[charCount] = char;
                charCount++;
            }
        }
        bytes memory bytesStringTrimmed = new bytes(charCount);
        for (j = 0; j < charCount; j++) {
            bytesStringTrimmed[j] = bytesString[j];
        }
        return string(bytesStringTrimmed);
    }


   /*
    * 将string转化为uint的工具方法
    *
    * @param source     字符串
    *
    * @return           uint值
    */
    function stringToUint(string source) internal pure returns (uint result) {
        bytes memory b = bytes(source);
        uint i;
        result = 0;
        for (i = 0; i < b.length; i++) {
            uint c = uint(b[i]);
            if (c >= 48 && c <= 57) {
                result = result * 10 + (c - 48);
            }
        }
    }


   /*
    * 将uint转化为string的工具方法
    *
    * @param source     uint值
    *
    * @return           字符串
    */
    function uintToString(uint source) internal pure returns (string){
        if (source == 0) return "0";
        uint j = source;
        uint length;
        while (j != 0){
            length++;
            j /= 10;
        }
        bytes memory bstr = new bytes(length);
        uint k = length - 1;
        while (source != 0){
            bstr[k--] = byte(48 + source % 10);
            source /= 10;
        }
        return string(bstr);
    }


   /*
    * 将bytes转化为address的工具方法
    *
    * @param source     bytes值
    *
    * @return           address值
    */
    function bytesToAddress (bytes source) internal pure returns (address) {
        uint result = 0;
        for (uint i = 0; i < source.length; i++) {
            uint c = uint(source[i]);
            if (c >= 48 && c <= 57) {
                result = result * 16 + (c - 48);
            }
            if(c >= 65 && c<= 90) {
                result = result * 16 + (c - 55);
            }
            if(c >= 97 && c<= 122) {
                result = result * 16 + (c - 87);
            }
        }
        return address(result);
    }



}