// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.4.25;

library LibConverter {
    function toUint128(uint256 value) internal pure returns (uint128) {
        require(value < 2**128, "SafeCast: can not fit in 128 bits");
        return uint128(value);
    }

  	// 将 value 强制转换为 uint8 类型并返回 
    function toUint8(uint256 value) internal pure returns (uint8) {
        require(value < 2**8, "SafeCast: can not fit in 8 bits");
        return uint8(value);
    }

    function uintToBytes(uint v) internal pure returns (bytes memory) {
        uint maxlength = 100; 
        bytes memory reversed = new bytes(maxlength);
        uint i = 0; 
        while (v != 0) { 
            uint8 remainder = uint8(v % 10); 
            v = v/10;   //更新v的值为v除以10的整数部分
            reversed[i%maxlength] = bytes1(48+remainder);    //将余数转换为 ASCII 字符，存储在 reversed[i % maxlength] 中
            i++;
        } 
        bytes memory s = new bytes(i+1); 
        for (uintj = 1; j <= i % maxlength; j++) { 
            s[j-1] = reversed[i - j];   //将reversed中的元素反向存储到 s 中
        } 
        return bytes(s);
    }

   function bytesToInt(bytes memory b) internal pure returns (int result) {
    uint i = 0;  //初始化变量 i 为 0
    uint tr = 0;  //初始化变量 tr 为 0
    result = 0;  //初始化变量 result 为 0
    bool sign = false;  //初始化变量 sign 为 false

    if (b[i] == "-") {  //如果第一个字节是 "-"，则将 sign 置为 true，并将 i 增加 1
        sign = true;  
        i++;
    } else if (b[i] == "+") {  //如果第一个字节是 "+"，则将 i 增加 1
        i++;
    }
    
    while (uint8(b[b.length - tr - 1]) == 0x00) {  //循环判断字节数组 b 末尾的字节是否为 0x00，直到找到非零字节为止
        tr++;  // 增加 tr 的值
    }

    for (; i < b.length - tr; i++) {
        uint8 c = uint8(b[i]);
        if (c >= 48 && c <= 57) {  //判断字节 c 是否为数字的 ASCII 字符
            result *= 10;  // 将 result 乘以 10
            result = result + int8(c - 48);  //将数字字符转换为整数，并累加到 result 上
        }
    }

    if (sign) {  //如果 sign 为 true，则将 result 取负值
        result *= -1;
    }
}

function intToBytes(int v) internal pure returns (bytes memory) {
    uint maxlength = 100;  //设置最大长度为100，用于创建一个字节数组 reversed
    bytes memory reversed = new bytes(maxlength);  //创建长度为 maxlength 的字节数组 reversed
    uint i = 0;  //初始化变量 i 为 0
    uint x;  //声明变量 x，用于存储 v 的绝对值
    if (v < 0)  //如果 v 小于 0，则取 v 的绝对值并赋值给 x
        x = uint(-v);
    else
        x = uint(v);
    
    while (x != 0) {
        uint8 remainder = uint8(x % 10);  //计算 x 除以 10 的余数，并将其转换为 uint8 类型
        x = x / 10;  // 更新 x 的值为 x 除以 10 的整数部分
        reversed[i % maxlength] = bytes1(48 + remainder);  //将余数转换为 ASCII 字符，存储在 reversed[i % maxlength] 中
        i++;  // 增加 i 的值
    }
    
    if (v < 0)  // 如果 v 小于 0，则在 reversed 数组的末尾添加一个负号
        reversed[(i++) % maxlength] = "-";
        
    bytes memory s = new bytes(i + 1);  //创建长度为 i + 1 的字节数组 s

    for (uint j = 1; j <= i % maxlength; j++) {
        s[j - 1] = reversed[i - j];  //将 reversed 中的元素反向存储到 s 中
    }

    return bytes(s);  //返回字节数组 s
}