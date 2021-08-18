# LibString.sol

LibBits 提供了常用的位操作.基于单字节操作

## 使用方法

首先需要通过import引入LibBits类库, 以下为使用示例

```
pragma solidity >=0.4.24 <0.6.11;

import "./LibBits.sol";

contract TestBits {
    
    function f() public view returns(bytes1 ){
        bytes1 memory a = 1;
        bytes1 memory b = 5;
        bytes1 result = LibBits.add(a, b);//Expected to be 1
        return result;
    }
}
```


## API列表

编号 | API | API描述
---|---|---
1 | *and(bytes1 a, bytes1 b) internal pure returns (bytes1)* | 按位与操作
2 | *or(bytes1 a, bytes1 b) internal pure returns (bytes1)* | 或操作
3 | *xor(bytes1 a, bytes1 b) internal pure returns (bytes1)* | 异或操作
4 | *negate(bytes1 a) internal pure returns (bytes1)* | 按位取非
5 | *shiftLeft(bytes1 a, uint8 n) internal pure returns (bytes1)* | 左移
6 | *shiftRight(bytes1 a, uint8 n) internal pure returns (bytes1)* | 右移
7 | *getFirstN(bytes1 a, uint8 n) internal pure returns (bytes1)* | 获取高N位,保持在高位
8 | *getLastN(bytes1 a, uint8 n) internal pure returns (bytes1)* | 获取低位数据
9 | *allOnes() internal pure returns (bytes1)* | 所有位置为1
10 | *getBit(bytes1 a, uint8 n) internal pure returns (bool)* | 获取指定位的值
11 | *setBit(bytes1 a, uint8 n) internal pure returns (bytes1)* | 设置指定位的为1
12 | *clearBit(bytes1 a, uint8 n)  internal pure returns (bytes1)* | 清除指定位的值

## API详情

### ***1. and 方法***

按位与操作

#### 参数

- a: 单字节
- b: 单字节

#### 返回值

- bytes1：按位与的值

#### 实例

```
    function f() public view returns(bytes1){
        string memory str = "字符串";
        uint len = LibString.lenOfChars(str);//Expected to be 3
        return len;
    }
```

### ***2. or 方法***

或运算

#### 参数

- a: 单字节
- b: 单字节

#### 返回值

- bytes：或运算结果

#### 实例

```
    function f() public view returns(bytes1 ){
        bytes1 memory a = 2;
        bytes1 memory b = 5;
        bytes1 result = LibBits.or(a, b);//Expected to be 7
        return result;
    }
```

### ***3. xor 方法***

异或运算

#### 参数

- a: 单字节
- b: 单字节

#### 返回值

- 单字节: 异或运算结果

#### 实例

```
    function f() public view returns(bytes1 ){
        bytes1 memory a = 3;
        bytes1 memory b = 5;
        bytes1 result = LibBits.xor(a, b);//Expected to be 6
        return result;
    }
```

### ***4. negate 方法***

非运算/NEG

#### 参数

- a: 单字节

#### 返回值
- bytes1: 非运算结果

#### 实例

```
    function f() public view returns(bytes1){
        bytes1 r = LibBits.negate(5);//Expected to be -6
        return r;
    }
```

### ***5. shiftLeft 方法***

左移

#### 参数

- a: 单字节
- n：单字节

#### 返回值

- bytes1: 将a 左移n位

#### 实例

```
    function f() public view returns(bytes1){
        bytes1 r = LibBits.shiftLeft(2,3);//Expected to be 16
        return r;
    }
```

### ***6. shiftRight 方法***

右移

#### 参数

- a：单字节
- n：单字节

#### 返回值

- bool: 将a右移n位

#### 实例

```
      function f() public view returns(bytes1){
          bytes1 r = LibBits.shiftRight(15,3);//Expected to be 1
          return r;
      }
```

### ***7. getFirstN 方法***

获取高N位数据,保持在高位

#### 参数

- a: 单字节
- n: 单字节

#### 返回值

- bytes1: 低n位数据

#### 实例

```
  function f() public view returns(bytes1){
      bytes1 r = LibBits.getLastN(60,3);//Expected to be 4
      return r;
  }
```


### ***8. getLastN 方法***

获取低N位数据

#### 参数

- a: 字符串

#### 返回值

- bytes1: 高位数据

#### 实例

```
  function f() public view returns(bytes1){
      bool r = LibBits.getFirstN(60,3);//Expected to be 32
      return r;
  }
```


### ***9. allOnes 方法***

单字节所有位值为1

#### 参数

#### 返回值

- bytes1: 0xff

#### 实例

```
  function f() public view returns(bytes1){
      bool r = LibBits.allOnes();//Expected to be 255
      return r;
  }
```
### ***10. getBit 方法***

获取指定位置的bit值

#### 参数

- a: 单字节
- n: 单字节

#### 返回值

- bytes1: 数据a在位置n的bit值

#### 实例

```
  function f() public view returns(bytes1){
      bool r = LibBits.getBit(17,2);//Expected to be 0
      return r;
  }
```

### ***11. setBit 方法***

设置指定位置的bit值

#### 参数

- a: 单字节
- n: 单字节

#### 返回值

- bytes1: 设置后的值

#### 实例

```
  function f() public view returns(bytes1){
      bool r = LibBits.setBit(17,2);//Expected to be 19
      return r;
  }
```

### ***12. clearBit 方法***

设置指定位置的bit值

#### 参数

- a: 单字节
- n: 单字节

#### 返回值

- bytes1: 清除指定位置后的值

#### 实例

```
  function f() public view returns(bytes1){
      bool r = LibBits.clearBit(17,5);//Expected to be 1
      return r;
  }
```