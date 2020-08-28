# LibBytes32Set.sol

LibBytes32Set 提供了存储bytes32类型的Set数据结构，支持包括add, remove, contains, get, getAll, size等方法。

## 使用方法

首先需要通过import引入LibBytes32Set类库，然后通过"."进行方法调用，如下为调用LibBytes32Set方法的例子：

```
pragma solidity ^0.4.25;

import "./LibBytes32Set.sol";

contract TestSet {
    using LibBytes32Set for LibBytes32Set.Bytes32Set;
    LibBytes32Set.Bytes32Set private bytes32Set;

    function testBytes32() public {
        bytes32Set.add(bytes32(1));
        uint256 size = bytes32Set.size();//Expected to be 1
    }

}
```


## API列表

编号 | API | API描述
---|---|---
1 | *add(Bytes32Set storage self, bytes32 value) internal* | 往Set里添加元素。
2 | *contains(Bytes32Set storage self, bytes32 value) internal view returns (bool)* | 判断Set里是否包含了元素value。
3 | *remove(Bytes32Set storage self, bytes32 value) internal* | 删除Set中的元素。
4 | *size(Bytes32Set storage self) internal view returns (uint256)* | 获取Set内元素数。
5 | *get(Bytes32Set storage self, uint256 index) internal view returns (Bytes32)* | 查询某个Set的元素。
6 | *getAll(Bytes32Set storage self) internal view returns(bytes32[])* | 返回所有元素。
7 | *destroy(Bytes32Set storage self) internal* | 销毁Set。

## API详情

### ***1. add 函数***

往Set里添加元素

#### 参数

- Bytes32Set: set容器
- bytes32: 元素

#### 返回值


#### 实例

```
pragma solidity ^0.4.25;

import "./LibBytes32Set.sol";

contract TestSet {
    using LibBytes32Set for LibBytes32Set.Bytes32Set;
    LibBytes32Set.Bytes32Set private Bytes32Set;

    function testBytes32() public {
        bytes32Set.add(bytes32(1));
    }

}
```

### ***2. contains 函数***

判断Set里是否包含了元素value。

#### 参数

- Bytes32Set: set容器
- bytes32: 元素

#### 返回值
- bool: 是否包含

#### 实例

```
    bool b = bytes32Set.contains(bytes32(1));
```

### ***3. remove 函数***

删除Set中的指定元素

#### 参数

- Bytes32Set: set容器
- bytes32: 元素

#### 返回值


#### 实例

```
    ddressSet.remove(bytes32(1));
```

### ***4. size 函数***

查询Set中的元素数量。

#### 参数

- Bytes32Set: set容器

#### 返回值
- uint256: 元素数量

#### 实例

```
    uint256 setSize = bytes32Set.size();
```

### ***5. get 函数***

查询Set中指定index的值

#### 参数

- Bytes32Set: set容器
- uint256: index

#### 返回值
- bytes32: 元素

#### 实例

```
    bytes32 value = bytes32Set.get(0);
```

### ***6. getAll 函数***

查询Set中所有的值，返回一个bytes32[]数组

#### 参数

- Bytes32Set: set容器

#### 返回值
- bytes32[]: 所有元素值

#### 实例

```
   bytes32[] values = bytes32Set.getAll();
```

### ***7. destroy 函数***

销毁Set。

#### 参数

- Bytes32Set: set容器

#### 返回值

#### 实例

```
    bytes32Set.destroy();
```
