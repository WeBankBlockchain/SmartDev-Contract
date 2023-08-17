// SPDX-License-Identifier: Apache-2.0
 
pragma solidity >=0.4.25;

library LibAddress{
    
    function isContract(address account) internal view returns(bool) {
        uint256 size;
  	//获取账户的合约代码大小
        assembly { size := extcodesize(account) }  
	//如果合约代码大小大于0，则认为该地址是一个合约地址，返回true；否则返回false
        return size > 0;    
    }

    function isEmptyAddress(address addr) internal pure returns(bool){
        return addr == address(0);
    }


    function addressToBytes(address addr) internal pure returns (bytes memory){
        bytes20 addrBytes = bytes20(uint160(addr));   //将地址addr转换为bytes20类型的变量
        bytes memory rtn = new bytes(20);
        for(uint8 i=0;i<20;i++){
            rtn[i] = addrBytes[i];   //将addrBytes中的每个字节赋值给字节数组rtn的相应位置
        }
        return rtn;  // 返回字节数组
    }
 
    
    function bytesToAddress(bytes memory addrBytes) internal pure returns (address){
        require(addrBytes.length == 20);  //断言确保字节数组的长度为20，否则抛出异常
        //Convert binary to uint160 
        uint160 intVal = 0;

        for(uint8 i=0;i<20;i++){
            intVal <<= 8; // 将intVal左移8位（相当于乘以256），为接下来的操作腾出空间
            intVal += uint8(addrBytes[i]);    //将addrBytes[i]转换为uint8类型并加到intVal上
        }
        return address(intVal);   //将字节数组转换为地址类型并返回
    }


    function addressToString(address addr) internal pure returns(string memory){
        //Convert addr to bytes
        bytes20 value = bytes20(uint160(addr));
        bytes memory strBytes = new bytes(42);
        //Encode hex prefix
        strBytes[0] = '0';
        strBytes[1] = 'x';
        //Encode bytes usig hex encoding
        for(uint i=0;i<20;i++){
            uint8 byteValue = uint8(value[i]);   // 将字节数组中的每个字节转换为 uint8 类型
            strBytes[2 + (i<<1)] = encode((byteValue >> 4) & 0x0f);   //将byteValue的前4位进行编码并赋值给字节数组的相应位置
            strBytes[3 + (i<<1)] = encode(byteValue & 0x0f);   //将byteValue的后4位进行编码并赋值给字节数组的相应位置
        }
        return string(strBytes);  //将字节数组转换为字符串并返回
    }

    function stringToAddress(string memory data) internal pure returns(address){
        bytes memory strBytes = bytes(data);  // 将字符串 data 转换为字节数组 strBytes
        // 断言确保字符串长度在39到42之间，否则抛出错误信息 "Not hex string"
	require(strBytes.length >= 39 && strBytes.length <= 42, "Not hex string");  
        //Skip prefix
        uint start = 0;
        uint bytesBegin = 0;
        if(strBytes[1] == 'x' || strBytes[1] == 'X'){
 	//如果字符串的第二个字节是'x'或'X'则将start设置为2跳过前缀
        	start = 2;
        }
        //Special case: 0xabc. should be 0x0abc
        uint160 addrValue = 0;
        uint effectPayloadLen = strBytes.length - start;  //计算有效载荷长度（strBytes的长度减去start的值）
        if(effectPayloadLen == 39){
            addrValue += decode(strBytes[start++]);   //将strBytes[start]解码并加到addrValue之上，并将start的值增加1
            bytesBegin++;
        }
        //Main loop
        for(uint i=bytesBegin;i < 20; i++){
            addrValue <<= 8;   //将addrValue左移8位（相当于乘以256为接下来的操作腾出空间
            uint8 tmp1 = decode(strBytes[start]);   //从strBytes数组中获取start位置的字节并进行解码得到 tmp1
            uint8 tmp2 = decode(strBytes[start+1]);   //从strBytes 数组中获取start+1位置的字节并进行解码得到 tmp2
            uint8 combined = (tmp1 << 4) + tmp2;    //将 tmp1 左移4位后与tmp2相加得到组合后的值
            addrValue += combined;
            start+=2;
        }
        
        return address(addrValue);
    }


    //-----------HELPER METHOD--------------//

    //num represents a number from 0-15 and returns ascii representing [0-9A-Fa-f]
    function encode(uint8 num) private pure returns(bytes1){
        //0-9 -> 0-9
        if(num >= 0 && num <= 9){
            return bytes1(num + 48);
        }
        //10-15 -> a-f
        return bytes1(num + 87);
    }
        
    //asc represents one of the char:[0-9A-Fa-f] and returns consperronding value from 0-15
    function decode(bytes1 asc) private pure returns(uint8){
        uint8 val = uint8(asc);
        //0-9
        if(val >= 48 && val <= 57){
            return val - 48;
        }
        //A-F
        if(val >= 65 && val <= 70){
            return val - 55;
        }
        //a-f
        return val - 87;
    }

}