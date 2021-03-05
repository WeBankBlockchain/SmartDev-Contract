# LibConverter.sol

LibConverter提供各类solidity数据基本类型的转换，包括uint256转uint128、uint64、uint32等，uint256转bytes，int转bytes，bytes转int等转换方法。

## 使用方法

首先需要通过import引入LibConverter类库，调用库的相关方法：

```
pragma solidity >=0.4.24 <0.6.11;

import "./LibConverter.sol"

contract test {
    
    function f() public view{
        uint256 a = 25;
        uint16 b = LibConverter.toUint16(a);
        //TODO:
    }
}
```


## API列表

编号 | API | API描述
---|---|---
1 | *toUint128(uint256 value) internal pure returns (uint128)* | 将uint256转为uint128类型
2 | *toUint64(uint256 value) internal pure returns (uint64)* | 将uint256转为uint64类型
3 | *toUint32(uint256 value) internal pure returns (uint32)* | 将uint256转为uint32类型
4 | *toUint16(uint256 value) internal pure returns (uint16)* | 将uint256转为uint16类型
5 | *toUint8(uint256 value) internal pure returns (uint8)* | 将uint256转为uint8类型
6 | *uintToBytes(uint v) internal pure returns (bytes)* | 将uint转为bytes类型
7 | *bytesToInt(bytes b) internal pure returns (int result)* | 将bytes转为int类型
8 | *intToBytes(int v) internal pure returns (bytes)* | 将int转为bytes类型

## API详情

### ***1. toUint128 方法***

将uint256转为uint128类型，如超出uint128的最大值，则报错退出。

#### 参数

- uint256：转换数

#### 返回值

- uint128：返回转换结果。

#### 实例

```
function f() public view{
    uint256 a = 25;
    uint128 b = LibConverter.toUint128(a);
    //TODO:
}
```

### ***2. toUint64 方法***

将uint256转为uint64类型，如超出uint64的最大值，则报错退出。

#### 参数

- uint256：转换数

#### 返回值

- uint64：返回转换结果。

#### 实例

```
function f() public view{
    uint256 a = 25;
    uint64 b = LibConverter.toUint64(a);
    //TODO:
}
```

### ***3. toUint32 方法***

将uint256转为uint32类型，如超出uint32的最大值，则报错退出。

#### 参数

- uint256：转换数

#### 返回值

- uint32：返回转换结果。

#### 实例

```
function f() public view{
    uint256 a = 25;
    uint32 b = LibConverter.toUint32(a);
    //TODO:
}
```

### ***4. toUint16 方法***

将uint256转为uint16类型，如超出uint16的最大值，则报错退出。

#### 参数

- uint256：转换数

#### 返回值

- uint16：返回转换结果。

#### 实例

```
function f() public view{
    uint256 a = 25;
    uint16 b = LibConverter.toUint16(a);
    //TODO:
}
```

### ***5. toUint8 方法***

将uint256转为uint8类型，如超出uint8的最大值，则报错退出。

#### 参数

- uint256：转换数

#### 返回值

- uint8：返回转换结果。

#### 实例

```
function f() public view{
    uint256 a = 25;
    uint8 b = LibConverter.toUint8(a);
    //TODO:
}
```

### ***5. toBytes 方法***

将uint256转为bytes类型。

#### 参数

- uint：转换数

#### 返回值

- bytes：转换结果

#### 实例

```
function f() public view{
    uint256 a = 25;
    bytes memory b = LibConverter.uintToBytes(a);
    //TODO:
}
```

### ***6. bytesToInt 方法***

将bytes转为uint256类型。

#### 参数

- bytes：转换字节

#### 返回值

- int：转换结果

#### 实例

```
function f() public view{
    bytes memory a = "25";
    int b = LibConverter.bytesToInt(a);
    //TODO:
}
```

### ***7. intToBytes 方法***

将int转为bytes类型。

#### 参数

- int：转换数

#### 返回值

- bytes：转换结果

#### 实例

```
function f() public view{
    int a = 25;
    bytes memory b = LibConverter.intToBytes(a);
    //TODO:
}
```
