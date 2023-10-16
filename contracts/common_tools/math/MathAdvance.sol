pragma solidity ^0.4.25;

/**
* @author wpzczbyqy <weipengzhen@czbyqy.com>
* @description  数学方法：开方、指数运算、对数运算，暂时保留到整数位且为截取而不是四舍五入
**/

library MathAdvance {
    /**
    *开方
    *@param  x, 对x进行开方
    *@return uint 返回整数位，小数位舍弃
    **/
    function sqrt(uint x) public pure returns(uint) {
        uint z = (x + 1 ) / 2;
        uint y = x;
        while(z < y){
            y = z;
            z = ( x / z + z ) / 2;
        }
        return y;
    }

    /**
    *以2为底的对数运算
    *@param  x, 对x进行以2为底的对数运算
    *@return uint 返回整数位，小数位舍弃
    **/
    function log2(uint x) public pure returns(uint) {
        for(int i = 0; ;i++) {
            if(exp2(i) <= x && exp2(i+1) > x){
                return uint(i);
            }
        }
        return 0;
    }

    /**
    *以任意数为底的对数运算
    *@param  m, 以m底
    *@param  n, 对n进行以m为底的对数运算
    *@return uint 返回整数位，小数位舍弃
    **/
    function log(uint m, uint n) public pure returns(uint) {
        for(int i = 0; ;i++) {
            if(uint(exp(int(m),i)) <= n && uint(exp(int(m), i+1)) > n){
                return uint(i);
            }
        }
        return 0;
    }

    /**
    *2的N次幂运算
    *@param  n, 对n进行以m为底的对数运算
    *@return uint 返回结果
    **/
    function exp2(int n) public pure returns(uint) {
        if (n >= 0){
            return uint((1 << n));
        }
        return 0;
    }

    /**
   *m的n次幂运算
   *@param  m, int类型
   *@param  n, int类型 对m进行以n次幂运算
   *@return int 返回结果
   **/
    function exp(int m, int n) public pure returns(int) {
        if(n < 0){
            return 0;
        }

        if(m > 0){
            return int(uint(m) ** uint(n));
        }

        if(n % 2 == 0){
            return int(uint(-m) ** uint(n));
        }
        return int(-uint(-m) ** uint(n));
    }
}
