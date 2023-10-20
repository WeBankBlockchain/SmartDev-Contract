# LibBitOperationForByte.sol
> 在 0.8.0 之前, byte 用作为 bytes1 的别名。

LibBitOperationForByte提供solidity内置函数不包括的位操作方法，例如按位非、移位、取前/后n位等方法

## 使用方法

首先需要通过import引入LibBitOperationForByte类库，调用库的相关方法：

```
pragma solidity >=0.4.24 <0.6.11;

import "./LibBitOperationForByte.sol"

contract test {
    
    function getFirstN(bytes1 a, uint8 n) public pure returns (bytes1) {
        bytes1 res = LibBitOperationForByte.getFirstN(a, n);
        return res;
    }
}
```

## API列表

编号 | API | API描述
---|---|---
1 | *invert(bytes1 a) internal pure returns (bytes1)* | 按位非
2 | *leftShift(bytes1 a, uint n) internal pure returns (bytes1)* | 向左移动n位
3 | *rightShift(bytes1 a, uint n) internal pure returns (bytes1)* | 向右移动n位
4 | *getFirstN(bytes1 a, uint8 n) internal pure isValidLength(n) returns (bytes1)* | 取前n位
5 | *getLastN(bytes1 a, uint8 n) internal pure isValidLength(n) returns (bytes1)* | 取后n位
6 | *getBitAtPositionN(bytes1 a, uint8 n) internal pure isValidPosition(n) returns (uint8)* | 获取第n位
7 | *invertBitAtPositionN(bytes1 a, uint8 n) internal pure isValidPosition(n) returns (bytes1)* | 将第n位反转

## API详情

### ***1. invert 方法***

按位非

#### 参数

- byte：操作字节

#### 返回值

- byte：返回转换结果。

#### 实例

```
function f() public view{
    bytes1 a = 0xa1;
    bytes1 res = LibBitOperationForByte.invert(a);
    //TODO:
}
```

### ***2. leftShift 方法***

将byte向左移动n位

#### 参数

- byte：操作字节

#### 返回值

- byte：返回移位后的结果。

#### 实例

```
function f() public view{
    bytes1 a = 0xa1;
    bytes1 res = LibBitOperationForByte.leftShift(a, 2);
    //TODO:
}
```

### ***3. rightShift 方法***

将byte向右移动n位

#### 参数

- byte：操作字节

#### 返回值

- byte：返回移位后的结果。

#### 实例

```
function f() public view{
    bytes1 a = 0xa1;
    bytes1 res = LibBitOperationForByte.rightShift(a, 2);
    //TODO:
}
```

### ***4. getFirstN 方法***

获取前n位，如果n大于8，则报错退出

#### 参数

- byte： 操作字节
- uint8：获取的位数

#### 返回值

- byte：返回前n位的结果。

#### 实例

```
function f() public view{
    bytes1 a = 0xa1;
    bytes1 res = LibBitOperationForByte.getFirstN(a, 2);
    //TODO:
}
```

### ***5. getLastN 方法***

获取后n位，如果n大于8，则报错退出

#### 参数

- byte： 操作字节
- uint8：获取的位数

#### 返回值

- byte：返回后n位的结果。

#### 实例

```
function f() public view{
    bytes1 a = 0xa1;
    bytes1 res = LibBitOperationForByte.getLastN(a, 2);
    //TODO:
}
```

### ***6. getBitAtPositionN 方法***

获取第n位的值，n大于7,则报错退出

#### 参数

- byte： 操作字节
- uint8: 第n位

#### 返回值

- uint8：第n位的值

#### 实例

```
function f() public view{
    bytes1 a = 0xa1;
    bytes1 res = LibBitOperationForByte.getBitAtPositionN(a, 2);
    //TODO:
}
```

### ***7. invertBitAtPositionN 方法***

将第n位的值反转，n大于7,则报错退出

#### 参数

- byte： 操作字节
- uint8: 第n位

#### 返回值

- byte：返回转换后的结果

#### 实例

```
function f() public view{
    bytes1 a = 0xa1;
    bytes1 res = LibBitOperationForByte.invertBitAtPositionN(a, 2);
    //TODO:
}
```