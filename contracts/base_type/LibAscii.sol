pragma solidity ^0.4.25;

/**
 * Ascii工具类
**/
library LibAscii{

    /**
     * 字符串转ascii字符串
     *
     * @ param data  原字符串(大小写均可)
     * @ param radix 原字符串进制 仅支持10，16进制
     *
     * 例："55,16" 得出 "U" 16进制
     *     "55,10" 得出 "7" 10进制
    **/
    function str2ascii(string data, uint radix) internal pure returns (string){
        require(radix == 10 || radix == 16, "radix must only 10 or 16");

        bytes memory _data = bytes(data);

        require(_data.length % 2 == 0, "data length must be even");

        uint[] memory temp = new uint[](_data.length);

        for(uint i = 0; i < _data.length; i++) {
            uint _d = uint(_data[i]);

            require(check(_d,radix), "data can only contain 0-9,a-f,A-F");//校验字符内容

            if (_d > 96) {//a-f 97-102
                temp[i] = _d - 97 + 10;
            } else if (_d > 64) {//A-F 65-70
                temp[i] = _d - 65 + 10;
            } else {//0-9  48-57
                temp[i] = _d - 48;
            }
        }

        bytes memory result = new bytes(temp.length / 2);
        for(uint _i = 0; _i < temp.length; _i += 2) {
            result[_i / 2] = byte(temp[_i] * radix + temp[_i + 1]);
        }

        return string(result);
    }

    /**
     * ascii字符串转10进制字符串
     * 例："aa" 得出9797 10进制
    **/
    function ascii2str(string ascii) internal pure returns(string){
        bytes memory temp = bytes(ascii);
        string memory resultStr = "";
        for(uint i = 0; i<temp.length; i++){
            uint _t = uint(temp[i]);
            resultStr = concat(resultStr,uint2str(_t));
        }
        return resultStr;
    }

    //-----------HELPER METHOD--------------//

    //校验字符内容
    function check(uint _d, uint radix) internal pure returns(bool){
        if( radix == 10){//10进制 只有数字，范围48~57
            return _d > 47 && _d<58;
        }else if( radix == 16){ //16进制 除数字外，字母范围 A~F：64~70、a~f：97~102
            return (_d>47 && _d<58) || (_d>64 && _d<71) || (_d>96 && _d<103);
        }else{
            return false;
        }
    }

    //数字转字符串
    function uint2str(uint num) internal pure returns (string) {
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
            result[k--] = byte(48 + num % 10);
            num /= 10;
        }
        return string(result);
    }

    //字符串拼接
    function concat(string _a, string _b) internal pure returns (string){
        bytes memory _ba = bytes(_a);
        bytes memory _bb = bytes(_b);
        bytes memory result = new bytes(_ba.length + _bb.length);
        uint k = 0;
        for (uint i = 0; i < _ba.length; i++) result[k++] = _ba[i];
        for (i = 0; i < _bb.length; i++) result[k++] = _bb[i];
        return string(result);
    }
}