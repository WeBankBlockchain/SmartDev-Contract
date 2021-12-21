# Math.sol

Math.sol提供solidity内置函数不包括的指数运算、对数运算和开方运算等运算方法

## 使用方法

首先需要通过import引入Math类库，调用库的相关方法：

```
pragma solidity ^0.4.25;

import "./Math.sol";

contract MathTest{

    function sqrt(uint x) public view returns (uint){
        return Math.sqrt(x);
    }
}
```

## API列表

编号 | API | API描述
---|---|---
1 | *function sqrt(uint x) public pure returns(uint)* | 开方
2 | *function log2(uint x) public pure returns(uint)* | 以2为底对数运算
3 | *function log(uint m, uint n) public pure returns(uint)* | 以m为底,对n进行对数运算
4 | *function exp2(int n) public pure returns(uint)* | 2的n次幂
5 | *function exp(int m, int n) public pure returns(int)* | m的n次幂

## API详情

### ***1. sqrt 方法***

开方运算

#### 参数

- uint x：对x进行开方

#### 返回值

- uint：返回整数位，小数位被舍去。

#### 实例

```
    function sqrt(uint x) public view returns (uint){
        return Math.sqrt(x); // x = 4 ,return 2
    }
```

### ***2. log2 方法***

以2为底对数运算

#### 参数

- uint：参数大于0

#### 返回值

- uint：返回整数位，小数位被舍去。

#### 实例

```
    function log2(uint x) public view returns(uint) {
        return Math.log2(x); //x = 2, return 1
    }
```

### ***3. log 方法***

以m为底,对n进行对数运算

#### 参数

- uint m：以m为底
- uint n：对n进行以为m底的对数运算

#### 返回值

- uint：返回整数位，小数位被舍去。

#### 实例

```
    function log(uint m, uint n) public view returns(uint) {
        return Math.log(m, n); //m = 10, n = 100, return 2
    }
```

### ***4. exp2 方法***

2的n次幂

#### 参数

- int n: n次幂

#### 返回值

- uint：返回2的n次幂结果。

#### 实例

```
    function exp2(int n) public view returns(uint) {
        return Math.exp2(n); //n = 2, return 4
    }
```

### ***5. exp 方法***

m的n次幂

#### 参数

- int m： 操作数m
- int n： m的n次幂

#### 返回值

- int：返回m的n次幂结果。

#### 实例

```
    function exp(int m, int n) public view returns(int) {
        return Math.exp(m, n); //m = +-2, n =2, return 4; m=-2, n=1, return -2
    }
```