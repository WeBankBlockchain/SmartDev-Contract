# LibSafeMathForUint256Utils.sol

LibSafeMathForUint256Utils提供了Uint256类型的相关计算操作，且保证数据的正确性和安全性，包括加法、减法、乘法、除法、取模、乘方、最大值、最小值和平均数等操作。

## 使用方法

首先需要通过import引LibSafeMathForUint256Utils类库，然后通过"."进行方法调用，如下为调用add方法的例子：

```
pragma solidity >=0.4.24 <0.6.11;

import "./LibSafeMathForUint256Utils.sol"

contract test {
    
    function f() public view{
        uint256 a = 25;
        uint256 b = 20;
        uint256 c = LibSafeMathForUint256Utils.add(a,b);
        //TODO:
    }
}
```


## API列表

编号 | API | API描述
---|---|---
1 | *add(uint256 a, uint256 b) internal pure returns (uint256)* | 加法操作
2 | *sub(uint256 a, uint256 b) internal pure returns (uint256)* | 减法操作
3 | *mul(uint256 a, uint256 b) internal pure returns (uint256)* | 乘法操作
4 | *div(uint256 a, uint256 b) internal pure returns (uint256)* | 除法操作
5 | *mod(uint256 a, uint256 b) internal pure returns (uint256)* | 取模操作
6 | *power(uint256 a, uint256 b) internal pure returns (uint256)* | 乘方操作
7 | *max(uint256 a, uint256 b) internal pure returns (uint256)* | 取最大值操作
8 | *min(uint256 a, uint256 b) internal pure returns (uint256)* | 取最小值操作
9 | *average(uint256 a, uint256 b) internal pure returns (uint256)* | 求平均数操作

## API详情

### ***1. add 方法***

add对两个数进行加法操作，返回相加之后的结果。

#### 参数

- a：加数
- b：加数

#### 返回值

- uint256：返回相加的结果。

#### 实例

```
function f() public view{
    uint256 a = 25;
    uint256 b = 20;
    uint256 c = LibSafeMathForUint256Utils.add(a,b);
    //TODO:
}
```

### ***2. sub 方法***

sub对两个数进行减法操作，返回相减之后的结果。

#### 参数

- a：被减数
- b：减数

#### 返回值

- uint256：返回相减的结果。

#### 实例

```
function f() public view{
    uint256 a = 25;
    uint256 b = 20;
    uint256 c = LibSafeMathForUint256Utils.sub(a,b);
    //TODO:
}
```

### ***3. mul 方法***

mul方法对两个数进行乘法操作，返回相乘之后的结果。

#### 参数

- a：被乘数
- b：乘数

#### 返回值

- uint256：返回相乘的结果。

#### 实例

```
function f() public view{
    uint256 a = 25;
    uint256 b = 20;
    uint256 c = LibSafeMathForUint256Utils.mul(a,b);
    //TODO:
}
```

### ***4. div 方法***

div方法对两个数进行除法操作，返回相除之后的结果。

#### 参数

- a：被除数
- b：除数

#### 返回值

- uint256：返回相除的结果。

#### 实例

```
function f() public view{
    uint256 a = 25;
    uint256 b = 20;
    uint256 c = LibSafeMathForUint256Utils.div(a,b);
    //TODO:
}
```

### ***5. mod 方法***

mod方法对两个数进行取模操作，返回取模之后的结果。

#### 参数

- a：被取模的数
- b：模值

#### 返回值

- uint256：返回取模的结果。

#### 实例

```
function f() public view{
    uint256 a = 25;
    uint256 b = 20;
    uint256 c = LibSafeMathForUint256Utils.mod(a,b);
    //TODO:
}
```

### ***5. power 方法***

power方法对两个数进行乘方操作，返回乘方之后的结果。

#### 参数

- a：基数
- b：乘方值

#### 返回值

- uint256：返回乘方的结果。

#### 实例

```
function f() public view{
    uint256 a = 25;
    uint256 b = 20;
    uint256 c = LibSafeMathForUint256Utils.power(a,b);
    //TODO:
}
```

### ***6. max 方法***

max方法对两个数进行比较，返回最大值。

#### 参数

- a：数值1
- b：数值2

#### 返回值

- uint256：返回最大值。

#### 实例

```
function f() public view{
    uint256 a = 25;
    uint256 b = 20;
    uint256 c = LibSafeMathForUint256Utils.max(a,b);
    //TODO:
}
```

### ***7. min 方法***

min方法对两个数进行比较，返回最小值。

#### 参数

- a：数值1
- b：数值2

#### 返回值

- uint256：返回最小值。

#### 实例

```
function f() public view{
    uint256 a = 25;
    uint256 b = 20;
    uint256 c = LibSafeMathForUint256Utils.mix(a,b);
    //TODO:
}
```

### ***8. average 方法***

average方法对两个数求平均值，返回平均值。

#### 参数

- a：数值1
- b：数值2

#### 返回值

- uint256：返回平均值。

#### 实例

```
function f() public view{
    uint256 a = 25;
    uint256 b = 20;
    uint256 c = LibSafeMathForUint256Utils.average(a,b);
    //TODO:
}
```
