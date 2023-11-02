pragma solidity ^0.4.25;

library LibSafeMathForUint256Utils {

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;  //将 a 和 b 相加，结果存储在变量 c 中
        require(c >= a, "SafeMathForUint256: addition overflow");  //检查相加结果是否溢出
        return c;  //返回相加结果
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMathForUint256: subtraction overflow");  //检查相减结果是否溢出
        uint256 c = a - b;  //将 a 和 b 相减，结果存储在变量 c 中
        return c;  //返回相减结果
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0 || b == 0) {
            return 0;  //如果 a 或 b 为 0，则乘积为 0
        }

        uint256 c = a * b;  //将 a 和 b 相乘，结果存储在变量 c 中
        require(c / a == b, "SafeMathForUint256: multiplication overflow");  //检查相乘结果是否溢出
        return c;  //返回相乘结果
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMathForUint256: division by zero");  //检查除数是否为 0
        uint256 c = a / b;  //将 a 和 b 相除，结果存储在变量 c 中
        return c;  //返回相除结果
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0, "SafeMathForUint256: modulo by zero");  //检查除数是否为 0
        return a % b;  //返回 a 对 b 取模的结果
    }

    function power(uint256 a, uint256 b) internal pure returns (uint256) {

        if(a == 0) return 0;  //如果底数 a 为 0，则结果为 0
        if(b == 0) return 1;  //如果指数 b 为 0，则结果为 1

        uint256 c = 1;  //初始化变量 c 为 1
        for(uint256 i = 0; i < b; i++){  // 循环计算底数 a 的指数次幂
            c = mul(c, a);  //将 c 乘以 a，结果重新赋值给 c
        }
        return c;  //返回底数 a 的指数次幂的结果
    }

    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a >= b ? a : b;  //返回较大的数值
    

    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;  //返回较小的数值
    }

    function average(uint256 a, uint256 b) internal pure returns (uint256) {
        return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);  //返回两个数值的平均值
    }
}