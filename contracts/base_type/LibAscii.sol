// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.4.25;

/**
 * Ascii工具类
**/
library LibAscii{

    /**
     * 单个10进制ascii字符串转字符串
     * 例："55" 得出 "U"
     *     "109" 得出 "m"
    **/
    function decAscii2str(string memory data) internal pure returns (string memory){
        uint _data = decStrToUint(data);
        require(_data < 128, "data must be 0 ~ 127");
        bytes memory result = new bytes(1);
        result[0] = bytes1(uint8(_data));
        return string(result);
    }

    /**
     * 单个16进制ascii字符串转字符串
     *
     * @ param data  原字符串(大小写均可)
     *
     * 例："55" 得出 "U"
     *     "6D" 得出 "Z"
    **/
    function hexAscii2str(string memory data) internal pure returns(string memory){
        uint _data = hexStrToUint(data);
        require(_data < 128, "data must be 0x00 ~ 0x7F");
        return decAscii2str(uint2str(_data));
    }

    /**
     * 字符串转ascii字符串
     * 例："aa" 得出9797 10进制
    **/
    function str2ascii(string memory data) internal pure returns(string memory){
        bytes memory temp = bytes(data);
        bytes memory resultStr = "";
        for(uint i = 0; i<temp.length; i++){
            uint _t = uint8(temp[i]);
            resultStr=abi.encodePacked(resultStr,uint2str(_t));
        }
        return string(resultStr);
    }

    //-----------HELPER METHOD--------------//
    
    //10字符串转int
    function decStrToUint(string memory data) internal pure returns (uint){
        bytes memory temp = bytes(data);
        uint256 result=0;
        for(uint i = temp.length; i>0; i--){
            uint _t = uint8(temp[i-1]);//ascii码的十进制
            result+=(_t-48)*(10**(temp.length-i));
        }
        return result;
    }
    
    //字符串转int
    function hexStrToUint(string memory data) internal pure returns (uint){
        bytes memory temp = bytes(data);
        uint result=0;
        for(uint i = temp.length; i>0; i--){
            uint _t = uint8(temp[i-1]);//ascii码的十进制
            uint _t1=0;
            if (_t > 96) {//a-f 97-102
                _t1 = _t - 97 + 10;
            } else if (_t > 64) {//A-F 65-70
                _t1 = _t - 65 + 10;
            } else {//0-9  48-57
                _t1 = _t - 48;
            }
            result+=_t1*(16**(temp.length-i));
        }
        return result;
    }

    //数字转字符串
    function uint2str(uint num) internal pure returns (string memory) {
        if (num == 0) return "0";
        uint temp = num;
        uint length = 0;
        while (temp != 0){
            length++;
            temp /= 10;
        }
        bytes memory result = new bytes(length);
        uint k = length - 1;
        while (num != 0){
            result[k--] = bytes1(uint8(48 + num % 10));
            num /= 10;
        }
        return string(result);
    }
} 