# LibBits.sol

LibBits 提供了常用的位操作.基于单字节操作

## 使用方法

首先需要通过import引入LibBits类库, 以下为使用示例

```
pragma solidity >=0.4.24 <0.6.11;

import "./LibBits.sol";

contract TestBits {
    
    function testAnd() public view returns(bytes1 ){
        bytes1 a = 1;
        bytes1 b = 5;
        bytes1 result = LibBits.and(a, b);//Expected to be 1
        return result;
    }
}
```

## 控制台测试
在控制台中执行，可获得以下的结果。

### 部署测试合约
```
deploy TestBits
transaction hash: 0xf2c94c9905d70350df1ce324613b4757ddde5162047d1bb679e0e195232a9db9
contract address: 0x02cc48aeab40785f6c3b2dc3b3fe71742e9a18e0
currentAccount: 0x22fec9d7e121960e7972402789868962238d8037
```

### 测试所有函数
按照顺序测试12个函数：

```
[group:1]> call TestBits 0x02cc48aeab40785f6c3b2dc3b3fe71742e9a18e0 testAnd
---------------------------------------------------------------------------------------------
Return code: 0
description: transaction executed successfully
Return message: Success
---------------------------------------------------------------------------------------------
Return value size:1
Return types: (BYTES)
Return values:(hex://0x01)
---------------------------------------------------------------------------------------------

[group:1]> call TestBits 0x02cc48aeab40785f6c3b2dc3b3fe71742e9a18e0 testOr
---------------------------------------------------------------------------------------------
Return code: 0
description: transaction executed successfully
Return message: Success
---------------------------------------------------------------------------------------------
Return value size:1
Return types: (BYTES)
Return values:(hex://0x07)
---------------------------------------------------------------------------------------------

[group:1]>  call TestBits 0x02cc48aeab40785f6c3b2dc3b3fe71742e9a18e0 testXor
---------------------------------------------------------------------------------------------
Return code: 0
description: transaction executed successfully
Return message: Success
---------------------------------------------------------------------------------------------
Return value size:1
Return types: (BYTES)
Return values:(hex://0x06)
---------------------------------------------------------------------------------------------

[group:1]>  call TestBits 0x02cc48aeab40785f6c3b2dc3b3fe71742e9a18e0 testNegate
---------------------------------------------------------------------------------------------
Return code: 0
description: transaction executed successfully
Return message: Success
---------------------------------------------------------------------------------------------
Return value size:1
Return types: (BYTES)
Return values:(hex://0xfa)
---------------------------------------------------------------------------------------------

[group:1]>  call TestBits 0x02cc48aeab40785f6c3b2dc3b3fe71742e9a18e0 testShiftLeft
---------------------------------------------------------------------------------------------
Return code: 0
description: transaction executed successfully
Return message: Success
---------------------------------------------------------------------------------------------
Return value size:1
Return types: (BYTES)
Return values:(hex://0x10)
---------------------------------------------------------------------------------------------

[group:1]>  call TestBits 0x02cc48aeab40785f6c3b2dc3b3fe71742e9a18e0 testShiftLeft
---------------------------------------------------------------------------------------------
Return code: 0
description: transaction executed successfully
Return message: Success
---------------------------------------------------------------------------------------------
Return value size:1
Return types: (BYTES)
Return values:(hex://0x10)
---------------------------------------------------------------------------------------------

[group:1]>  call TestBits 0x02cc48aeab40785f6c3b2dc3b3fe71742e9a18e0 testShiftRight
---------------------------------------------------------------------------------------------
Return code: 0
description: transaction executed successfully
Return message: Success
---------------------------------------------------------------------------------------------
Return value size:1
Return types: (BYTES)
Return values:(hex://0x01)
---------------------------------------------------------------------------------------------

[group:1]>  call TestBits 0x02cc48aeab40785f6c3b2dc3b3fe71742e9a18e0 testGetLastN
---------------------------------------------------------------------------------------------
Return code: 0
description: transaction executed successfully
Return message: Success
---------------------------------------------------------------------------------------------
Return value size:1
Return types: (BYTES)
Return values:(hex://0x04)
---------------------------------------------------------------------------------------------

[group:1]>  call TestBits 0x02cc48aeab40785f6c3b2dc3b3fe71742e9a18e0 getFirstN
---------------------------------------------------------------------------------------------
Return code: 0
description: transaction executed successfully
Return message: Success
---------------------------------------------------------------------------------------------
Return value size:1
Return types: (BYTES)
Return values:(hex://0x20)
---------------------------------------------------------------------------------------------

[group:1]>  call TestBits 0x02cc48aeab40785f6c3b2dc3b3fe71742e9a18e0 testAllOnes
---------------------------------------------------------------------------------------------
Return code: 0
description: transaction executed successfully
Return message: Success
---------------------------------------------------------------------------------------------
Return value size:1
Return types: (BYTES)
Return values:(hex://0xff)
---------------------------------------------------------------------------------------------

[group:1]> call TestBits 0x02cc48aeab40785f6c3b2dc3b3fe71742e9a18e0 testGetBit
---------------------------------------------------------------------------------------------
Return code: 0
description: transaction executed successfully
Return message: Success
---------------------------------------------------------------------------------------------
Return value size:1
Return types: (BOOL)
Return values:(true)
---------------------------------------------------------------------------------------------

[group:1]> call TestBits 0x02cc48aeab40785f6c3b2dc3b3fe71742e9a18e0 testSetBit
---------------------------------------------------------------------------------------------
Return code: 0
description: transaction executed successfully
Return message: Success
---------------------------------------------------------------------------------------------
Return value size:1
Return types: (BYTES)
Return values:(hex://0x13)
---------------------------------------------------------------------------------------------

[group:1]> call TestBits 0x02cc48aeab40785f6c3b2dc3b3fe71742e9a18e0 testClearBit
---------------------------------------------------------------------------------------------
Return code: 0
description: transaction executed successfully
Return message: Success
---------------------------------------------------------------------------------------------
Return value size:1
Return types: (BYTES)
Return values:(hex://0x01)
---------------------------------------------------------------------------------------------

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
    function testAnd() public view returns(bytes1 ){
        bytes1 a = 1; // 0x001
        bytes1 b = 5; // 0x101
        bytes1 result = LibBits.and(a, b);//Expected to be 1, 0x001
        return result;
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
    function testOr() public view returns(bytes1 ){
        bytes1 a = 2; // 0x010
        bytes1 b = 5; // 0x101
        bytes1 result = LibBits.or(a, b);//Expected to be 7, 0x111
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
    function testXor() public view returns(bytes1 ){
        bytes1 a = 3; // 0x011
        bytes1 b = 5; // 0x101
        bytes1 result = LibBits.xor(a, b); //Expected to be 6, 0x110
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
    function testNegate() public view returns(bytes1){
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
    function testShiftLeft() public view returns(bytes1){
        bytes1 r = LibBits.shiftLeft(2,3);//Expected to be 16, 0x00000010 -> 0x00010000
        return r;
    }
```

### ***6. shiftRight 方法***

右移

#### 参数

- a：单字节
- n：单字节

#### 返回值

- bytes1: 将a右移n位

#### 实例

```
      function testShiftRight() public view returns(bytes1){
          bytes1 r = LibBits.shiftRight(15,3);//Expected to be 1, 0x00001111 -> 0x00000001
          return r;
      }
```

### ***7. getLastN 方法***

获取高N位数据,保持在高位

#### 参数

- a: 单字节
- n: 单字节

#### 返回值

- bytes1: 低n位数据

#### 实例

```
  function testGetLastN() public view returns(bytes1){
      bytes1 r = LibBits.getLastN(60,3);//Expected to be 4 0x00111100 -> 0x00000100
      return r;
  }
```


### ***8. getFirstN 方法***

获取低N位数据

#### 参数

- a: 字符串

#### 返回值

- bytes1: 高位数据

#### 实例

```
  function getFirstN() public view returns(bytes1){
      byte r = LibBits.getFirstN(60,3);//Expected to be 32,  0x00111100 -> 0x00100000
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
  function testAllOnes() public view returns(bytes1){
      byte r = LibBits.allOnes();//Expected to be 255
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
    function testGetBit() public view returns(bool){
        bool r = LibBits.getBit(3,2);//Expected to be 1
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
  function testSetBit() public view returns(bytes1){
      byte r = LibBits.setBit(17,2);//Expected to be 19, 0x00010001 -> 0x00010011
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
  function testClearBit() public view returns(bytes1){
      byte r = LibBits.clearBit(17,5);//Expected to be 1
      return r;
  }
```