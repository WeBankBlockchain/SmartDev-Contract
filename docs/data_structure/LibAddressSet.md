# LibAddressSet.sol

LibAddressSet 提供了存储Address类型的Set数据结构，支持包括add, remove, contains, get, getAll, size等方法。

## 使用方法

首先需要通过import引入LibAddressSet类库，然后通过"."进行方法调用，如下为调用LibAddressSet方法的例子：

```
pragma solidity >=0.4.24 <0.6.11;

import "./LibAddressSet.sol";

contract Test {
    using LibAddressSet for LibAddressSet.AddressSet;
    LibAddressSet.AddressSet private addressSet;

    event Log(uint256 size);
    
    function testAddress() public {
        addressSet.add(address(1));
        uint256 size = addressSet.getSize();//Expected to be 1
        emit Log(size);
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

## API详情

### ***1. add 函数***

往Set里添加元素

#### 参数

- AddressSet: set容器
- address: 元素

#### 返回值


#### 实例

```
pragma solidity >=0.4.24 <0.6.11;

import "./LibAddressSet.sol";

contract Test {
    using LibAddressSet for LibAddressSet.AddressSet;
    LibAddressSet.AddressSet private addressSet;

    event Log(uint256 size);
    
    function testAddress() public {
        addressSet.add(address(1));
        uint256 size = addressSet.getSize();//Expected to be 1
        emit Log(size);
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
pragma solidity >=0.4.24 <0.6.11;

import "./LibAddressSet.sol";

contract Test {
    using LibAddressSet for LibAddressSet.AddressSet;
    LibAddressSet.AddressSet private addressSet;

    event Log(bool b);
    
    function testAddress() public {
        addressSet.add(address(1));
        emit Log(addressSet.contains(address(1)));//Expected true
    }

}
```

### ***3. remove 函数***

删除Set中的指定元素

#### 参数

- AddressSet: set容器
- address: 元素

#### 返回值


#### 实例

```
pragma solidity >=0.4.24 <0.6.11;

import "./LibAddressSet.sol";

contract Test {
    using LibAddressSet for LibAddressSet.AddressSet;
    LibAddressSet.AddressSet private addressSet;

    event Log(bool b);
    
    function testAddress() public {
        addressSet.add(address(1));
        addressSet.remove(address(1));
        emit Log(addressSet.contains(address(1)));
    }

}
```

### ***4. getSize 函数***

查询Set中的元素数量。

#### 参数

- AddressSet: set容器

#### 返回值
- uint256: 元素数量

#### 实例

```
    uint256 setSize = addressSet.getSize();
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
pragma solidity >=0.4.24 <0.6.11;

import "./LibAddressSet.sol";

contract Test {
    using LibAddressSet for LibAddressSet.AddressSet;
    LibAddressSet.AddressSet private addressSet;

    event Log(bool b);
    
    function testAddress() public returns(address) {
        addressSet.add(address(1));
        addressSet.add(address(2));
        return addressSet.get(1);//Expected be 2
    }

}
```

### ***6. getAll 函数***

查询Set中所有的值，返回一个address[]数组

#### 参数

- AddressSet: set容器

#### 返回值
- address[]: 所有元素值

#### 实例

```
pragma solidity >=0.4.24 <0.6.11;

import "./LibAddressSet.sol";

contract Test {
    using LibAddressSet for LibAddressSet.AddressSet;
    LibAddressSet.AddressSet private addressSet;

    event Log(bool b);
    
    function testAddress() public returns(address[] memory) {
        addressSet.add(address(1));
        addressSet.add(address(2));
        return addressSet.getAll();//Expected be 2
    }

}
```