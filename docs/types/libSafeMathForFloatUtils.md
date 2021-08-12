# libSafeMathForFloatUtils.sol

Solidity本不支持小数运算（浮点型），libSafeMathForFloatUtils提供了浮点型的相关计算操作，且保证数据的正确性和安全性，包括加法、减法、乘法、除法等操作。

## 使用方法

首先需要通过import引libSafeMathForFloatUtils类库，然后通过"libSafeMathForFloatUtils."进行方法调用，如下为调用相关方法的例子：

```
pragma solidity^0.4.25;
import "./libSafeMathForFloatUtils.sol";

contract testfloat {
    // dA代表a的精度，dB代表b的精度，返回值返回运算结果及其精度
    function mathTest(uint256 a, uint8 dA, uint256 b, uint8 dB, uint8 T) public pure returns(uint256, uint8) {
        if(T == 0) {
            // 加法测试
            return libSafeMathForFloatUtils.fadd(a, dA, b, dB);
        } else if (T == 1) {
            // 减法
            return libSafeMathForFloatUtils.fsub(a, dA, b, dB);
        } else if(T == 2) {
            // 乘法
            return libSafeMathForFloatUtils.fmul(a, dA, b, dB);
        } else if(T == 3) {
            // 除法
            return libSafeMathForFloatUtils.fdiv(a, dA, b, dB);
        }
    }
}
```


## API列表

编号 | API | API描述
---|---|---
1 | *fmul(uint256 a, uint8 dA, uint256 b, uint8 dB) internal pure returns (uint256 c, uint8 decimals)* | 加法操作
2 | *fmul(uint256 a, uint8 dA, uint256 b, uint8 dB) internal pure returns (uint256 c, uint8 decimals)* | 减法操作
3 | *fmul(uint256 a, uint8 dA, uint256 b, uint8 dB) internal pure returns (uint256 c, uint8 decimals)* | 乘法操作
4 | *fmul(uint256 a, uint8 dA, uint256 b, uint8 dB) internal pure returns (uint256 c, uint8 decimals)* | 除法操作


## API详情

### ***1. fadd 方法***

fadd对两个数进行加法操作，返回相加之后的结果及精度值。

#### 参数

- a：加数
- dA：加数a的精度
- b：加数
- dB：加数b的精度

#### 返回值

- uint256：返回相加的结果。
- uint8：返回结果的精度。

#### 实例

```
function f() public view{
    uint256 a = 2560000;
    uint256 b = 2000;
    (uint256 c, uint8 dC) = LibSafeMathForUint256Utils.fadd(a, 2, b, 3);
    //TODO:
}
```

### ***2. fsub 方法***

fsub对两个数进行减法操作，返回相减之后的结果。

#### 参数

- a：被减数
- dA：被减数的精度
- b：减数
- dB：减数的精度

#### 返回值

- uint256：返回相减的结果。
- uint8：返回结果的精度。

#### 实例

```
function f() public view{
    uint256 a = 2560000;
    uint256 b = 2000;
    (uint256 c, uint8 dC) = LibSafeMathForUint256Utils.fsub(a, 2, b, 3);
    //TODO:
}
```

### ***3. fmul 方法***

fmul方法对两个数进行乘法操作，返回相乘之后的结果。

#### 参数

- a：被乘数
- dA：被乘数的精度
- b：乘数
- dB：乘数的精度

#### 返回值

- uint256：返回相乘的结果。
- uint8：返回结果的精度。

#### 实例

```
function f() public view{
    uint256 a = 2560000;
    uint256 b = 2000;
    (uint256 c, uint8 dC) = LibSafeMathForUint256Utils.fmul(a, 2, b, 3);
    //TODO:
}
```

### ***4. fdiv 方法***

fdiv方法对两个数进行除法操作，返回相除之后的结果。

#### 参数

- a：被除数
- dA：被除数的精度
- b：除数
- dB：除数的精度

#### 返回值

- uint256：返回相除的结果。
- uint8：返回结果的精度。

#### 实例

```
function f() public view{
    uint256 a = 2560000;
    uint256 b = 2000;
    (uint256 c, uint8 dC) = LibSafeMathForUint256Utils.fdiv(a, 2, b, 3);
    //TODO:
}
```
