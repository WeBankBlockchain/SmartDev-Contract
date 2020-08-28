# LibAddressSet.sol

LibAddressSet 提供了存储Address类型的Set数据结构，支持包括add, remove, contains, get, getAll, size等方法。

## 使用方法

首先需要通过import引入LibAddressSet类库，然后通过"."进行方法调用，如下为调用LibAddressSet方法的例子：

```
pragma solidity ^0.4.25;

import "./LibAddressSet.sol";

contract TestSet {
    using LibAddressSet for LibAddressSet.AddressSet;
    LibAddressSet.AddressSet private addressSet;

    function testAddress() public {
        addressSet.add(address(1));
        uint256 size = addressSet.size();//Expected to be 1
    }

}
```


## API列表

编号 | API | API描述
---|---|---
1 | *add(AddressSet storage self, address value) internal* | 往Set里添加元素。
2 | *contains(AddressSet storage self, address value) internal view returns (bool)* | 判断Set里是否包含了元素value。
3 | *remove(AddressSet storage self, address value) internal* | 删除Set中的元素。
4 | *size(AddressSet storage self) internal view returns (uint256)* | 获取Set内元素数。
5 | *get(AddressSet storage self, uint256 index) internal view returns (address)* | 查询某个Set的元素。
6 | *getAll(AddressSet storage self) internal view returns(address[])* | 返回所有元素。
7 | *destroy(Bytes32Set storage self) internal* | 销毁Set。

## API详情

### ***1. add 函数***

往Set里添加元素

#### 参数

- AddressSet: set容器
- address: 元素

#### 返回值


#### 实例

```
pragma solidity ^0.4.25;

import "./LibAddressSet.sol";

contract TestSet {
    using LibAddressSet for LibAddressSet.AddressSet;
    LibAddressSet.AddressSet private addressSet;

    function testAddress() public {
        addressSet.add(address(1));
    }

}
```

### ***2. contains 函数***

判断Set里是否包含了元素value。

#### 参数

- AddressSet: set容器
- address: 元素

#### 返回值
- bool: 是否包含

#### 实例

```
    bool b = addressSet.contains(address(1));
```

### ***3. remove 函数***

删除Set中的指定元素

#### 参数

- AddressSet: set容器
- address: 元素

#### 返回值


#### 实例

```
    ddressSet.remove(address(1));
```

### ***4. size 函数***

查询Set中的元素数量。

#### 参数

- AddressSet: set容器

#### 返回值
- uint256: 元素数量

#### 实例

```
    uint256 setSize = addressSet.size();
```

### ***5. get 函数***

查询Set中指定index的值

#### 参数

- AddressSet: set容器
- uint256: index

#### 返回值
- address: 元素

#### 实例

```
    address value = addressSet.get(0);
```

### ***6. getAll 函数***

查询Set中所有的值，返回一个address[]数组

#### 参数

- AddressSet: set容器

#### 返回值
- address[]: 所有元素值

#### 实例

```
   address[] values = addressSet.getAll();
```

### ***7. destroy 函数***

销毁Set。

#### 参数

- AddressSet: set容器

#### 返回值

#### 实例

```
    addressSet.destroy();
```
