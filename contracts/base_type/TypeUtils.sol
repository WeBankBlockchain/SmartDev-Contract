// SPDX-License-Identifier: MIT
pragma solidity >=0.4.25;

/**
 * @dev 提供类型转换的工具(bytes32 bytes string uint256 address)
 * @author ashinnotfound
 */
library TypeUtils{

    /**
     * @dev bytes32转string
     * @param _origin 待转换的值
     * @param result 转换后的值
     */
    function bytes32ToString(bytes32 _origin) public pure returns (string memory result) {
        uint256 length = 32;
        // 计算实际长度
        while (length > 0 && _origin[length - 1] == 0){
            length--;
        }
        
        bytes memory resultBytes = new bytes(length);
        for (uint256 i = 0; i < length; i++){
            resultBytes[i] = _origin[i];
        }
        result = string(resultBytes);
    }

    /**
     * @dev string转bytes32
     * @param _origin 待转换的值
     * @param result 转换后的值
     */
    function stringToBytes32(string memory _origin) public pure returns (bytes32 result) {
        // 检查字符串长度是否超过32字节
        require(bytes(_origin).length <= 32, "TypeUtils::stringToBytes32Exception: Input string too long"); 

        assembly {
            result := mload(add(_origin, 32))
        }
    }

    /**
     * @dev string转bytes
     * @param _origin 待转换的值
     * @param result 转换后的值
     */
    function stringToBytes(string memory _origin) public pure returns (bytes memory result) {
        result = bytes(_origin);
    }

    /**
     * @dev bytes转string
     * @param _origin 待转换的值
     * @param result 转换后的值
     */
    function bytesToString(bytes memory _origin) public pure returns (string memory result) {
        result = string(_origin);
    }

    /**
     * @dev bytes转bytes32
     * @param _origin 待转换的值
     * @param result 转换后的值
     */
    function bytesToBytes32(bytes memory _origin) public pure returns (bytes32 result) {
        // 检查字节数组长度是否超过32字节
        require(_origin.length <= 32, "TypeUtils::bytesToBytes32Exception: Input bytes too long");

        assembly {
            result := mload(add(_origin, 32))
        }
    }

    /**
     * @dev bytes32转bytes
     * @param _origin 待转换的值
     * @param result 转换后的值
     */
    function bytes32ToBytes(bytes32 _origin) public pure returns (bytes memory result) {
        bytes memory bytesOrigin = abi.encodePacked(_origin);

        uint256 length = 32;
        // 计算实际长度
        while (length > 0 && _origin[length - 1] == 0){
            length--;
        }

        result = new bytes(length);
        for (uint256 i = 0; i < length; i++) {
            result[i] = bytesOrigin[i];
        }
    }

    /**
     * @dev address转string
     * @param _origin 待转换的值
     * @param result 转换后的值
     */
    function addressToString(address _origin) public pure returns (string memory result) {
        bytes32 bytesOrigin = bytes32(uint256(uint160(_origin)));
        bytes memory HEX = "0123456789abcdef";
        bytes memory bytesResult = new bytes(42);
        bytesResult[0] = '0';
        bytesResult[1] = 'x';
        for (uint i = 0; i < 20; i++) {
            bytesResult[2+i*2] = HEX[uint8(bytesOrigin[i + 12] >> 4)];
            bytesResult[3+i*2] = HEX[uint8(bytesOrigin[i + 12] & 0x0f)];
        }
        result = string(bytesResult);
    }

    /**
     * @dev string转address
     * @param _origin 待转换的值
     * @param result 转换后的值
     */
    function stringToAddress(string memory _origin) public pure returns (address result) {
        bytes memory strBytes = bytes(_origin);
        require(strBytes.length == 42 || strBytes.length == 40, "TypeUtils::stringToAddressException: Input string is a invalid address");

        uint256 addrBeginIndex;
        if (strBytes.length == 42){
            // 跳过 "0x" 前缀
            addrBeginIndex = 2; 
        }

        bytes memory addrBytes = new bytes(20);
        for (uint256 i = 0; i < 20; i++) {
            //在ASCII码中 48-57为0-9 65-70为A-F 97-102为a-f
            uint256 digit1 = uint256(uint8(strBytes[addrBeginIndex + i * 2])) - 48;
            require(digit1 <= 9 || (digit1 >= 17 && digit1 <= 22) || (digit1 >= 49 && digit1 <= 54), "TypeUtils::stringToAddressException: Invalid character in address string");
            uint256 digit2 = uint256(uint8(strBytes[addrBeginIndex + i * 2 + 1])) - 48;
            require(digit2 <= 9 || (digit2 >= 17 && digit2 <= 22) || (digit2 >= 49 && digit2 <= 54), "TypeUtils::stringToAddressException: Invalid character in address string");

            uint256 digit = digit1 * 16 + digit2;
            addrBytes[i] = bytes1(uint8(digit));
        }

        assembly {
            result := mload(add(addrBytes,20))
        }
    }

    /**
     * @dev bytes转address
     * @param _origin 待转换的值
     * @param result 转换后的值
     */
    function bytesToAddress(bytes memory _origin) public pure returns (address result) {
        require(_origin.length == 20, "TypeUtils::bytesToAddressException: Invalid input length");

        assembly {
            result := mload(add(_origin,20))
        }
    }

    /**
     * @dev address转bytes
     * @param _origin 待转换的值
     * @param result 转换后的值
     */
    function addressTobytes(address _origin) public pure returns (bytes memory result) {
        result = abi.encodePacked(_origin);
    }

    /**
     * @dev uint256转string
     * @param _origin 待转换的值
     * @param result 转换后的值
     */
    function uint256ToString(uint256 _origin) public pure returns (string memory result) {
        if (_origin == 0) {
            return "0";
        }
        //计算字符串长度
        uint256 length = 0;
        uint256 temp = _origin;
        while (temp != 0){
            length++;
            temp /= 10;
        }
        //赋值
        bytes memory resultBytes = new bytes(length);
        while (_origin != 0){
            resultBytes[length - 1] = bytes1(uint8(48 + _origin % 10));
            _origin /= 10;
            length--;
        }
        result = string(resultBytes);
    }

    /**
     * @dev string转uint256
     * @param _origin 待转换的值
     * @param result 转换后的值
     */
    function stringToUint256(string memory _origin) public pure returns(uint256 result) {
        bytes memory originBytes = bytes(_origin);

        for (uint256 i = 0; i < originBytes.length; i++) {
            //在ASCII码中 48-57为0-9
            uint256 number = uint256(uint8(originBytes[i])) - 48;
            require(number >= 0 && number <= 9, "TypeUtils::stringToUint256Exception: Invalid number in string");

            result = result * 10 + number;
        }

        return result;
    }

    /**
     * @dev uint256转bytes32
     * @param _origin 待转换的值
     * @param result 转换后的值
     */
    function uint256ToBytes32(uint256 _origin) public pure returns (bytes32 result) {
        result = bytes32(_origin);
    }

    /**
     * @dev bytes32转uint256
     * @param _origin 待转换的值
     * @param result 转换后的值
     */
    function bytes32ToUint256(bytes32 _origin) public pure returns (uint256 result) {
        result = uint256(_origin);
    }

    /**
     * @dev bytes转uint256
     * @param _origin 待转换的值
     * @param result 转换后的值
     */
    function bytesToUint256(bytes memory _origin) public pure returns (uint256 result) {
        require(_origin.length >= 32, "TypeUtils::bytesToUint256Exception: Invalid bytes length");

        assembly {
            result := mload(add(_origin, 32))
        }
    }

    /**
     * @dev uint256转bytes
     * @param _origin 待转换的值
     * @param result 转换后的值
     */
    function uint256ToBytes(uint256 _origin) public pure returns (bytes memory result) {
        result = abi.encodePacked(_origin);
    }
}