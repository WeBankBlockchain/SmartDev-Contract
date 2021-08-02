# LibUint256Set.sol

LibUint256Set 提供了存储Uint256类型的Set数据结构，支持包括add, remove, contains, getAll等方法。

## 使用方法

首先需要通过import引入LibUint256Set类库，然后通过"."进行方法调用，如下为调用LibUint256Set.add方法的例子：

```
pragma solidity ^0.4.25;

import "./LibUint256Set.sol";

contract UintSetTest{

    using LibUint256Set for LibUint256Set.Uint256Set;
    LibUint256Set.Uint256Set private uintSet;

    function add() public view returns (bool) {
        return uintSet.add(1);
    }
}
```


## API列表

编号 | API | API描述
---|---|---
1 | *contains(Uint256Set storage  set, bytes32 val) internal view returns (bool)* | 判断Set里是否包含了元素value。
2 | *add(Uint256Set storage set, bytes32 val) internal view returns (bool)* | 往Set里添加元素。
3 | *remove(Uint256Set storage set, bytes32 val) internal view returns (bool)* | 删除Set中的元素。
4 | *getAll(Uint256Set storage set) internal view returns (uint256[] memory)* | 返回所有元素。
5 | *getSize(Uint256Set storage set) internal view returns (uint256)* | 返回Set中元素数。
6 | *atPosition(Uint256Set storage set, bytes32 val) internal view returns (bool, uint256)* | 返回某个元素的位置。
7 | *getByIndex(Uint256Set storage set, uint256 index) internal view returns (uint256)* | 查找某个元素。

## API详情

### ***1. contains 函数***

判断Set里是否包含了元素value

#### 参数

- set: uint256类型Set
- val: 待检查元素

#### 返回值

-bool: 是否存在， true存在，false 不存在

#### 实例

```
pragma solidity ^0.4.25;

import "./LibUint256Set.sol";

contract UintSetTest{

    using LibUint256Set for LibUint256Set.Uint256Set;
    LibUint256Set.Uint256Set private uintSet;

    function add() public view returns (bool) {
        uintSet.add(1);
        return uintSet.contains(1);
    }
}
```

### ***2. add 函数***

往Set中添加一个元素

#### 参数

- set: uint256类型Set
- val: 待加入元素

#### 返回值

- bool: 是否添加成功

#### 实例

```
pragma solidity ^0.4.25;

import "./LibUint256Set.sol";

contract UintSetTest{

    using LibUint256Set for LibUint256Set.Uint256Set;
    LibUint256Set.Uint256Set private uintSet;

    function add() public view returns (bool) {
       return uintSet.add(1);
    }
}
```

### ***3. remove 函数***

删除Set中的指定元素

#### 参数

- set: uint256类型Set
- val: 待删除元素

#### 返回值

- bool: 是否删除成功

#### 实例

```
pragma solidity ^0.4.25;

import "./LibUint256Set.sol";

contract UintSetTest{

    using LibUint256Set for LibUint256Set.Uint256Set;
    LibUint256Set.Uint256Set private uintSet;

    function remove() public view returns (bool) {
        uintSet.add(1);
        uintSet.add(2);
        uintSet.add(3);
        return uintSet.remove(3);
    }
}
```

### ***4. getAll 函数***

获取Set中的所有元素。

#### 参数

- set: uint256类型Set

#### 返回值

- uint256[]: 所有元素

#### 实例

```
pragma solidity ^0.4.25;

import "./LibUint256Set.sol";

contract UintSetTest{

    using LibUint256Set for LibUint256Set.Uint256Set;
    LibUint256Set.Uint256Set private uintSet;

    function remove() public view returns (uint256[]) {
        uintSet.add(1);
        uintSet.add(2);
        uintSet.add(3);
        return uintSet.getAll();
    }
}
```

### ***5. getSize 函数***

返回Set中元素数量

#### 参数

- set: uint256类型Set

#### 返回值
- uint256: 元素数量

#### 实例

```
pragma solidity ^0.4.25;

import "./LibUint256Set.sol";

contract UintSetTest{

    using LibUint256Set for LibUint256Set.Uint256Set;
    LibUint256Set.Uint256Set private uintSet;

    function getSize() public view returns (uint256) {
        uintSet.add(1);
        uintSet.add(2);
        uintSet.add(3);
        return uintSet.getSize();
    }
}
```

### ***6. atPosition 函数***

Set中某个元素的位置

#### 参数

- set: uint256类型Set
- val: 待检测元素

#### 返回值

- bool: 是否存在该元素
- uint256: 该元素位置

#### 实例

```
pragma solidity ^0.4.25;

import "./LibUint256Set.sol";

contract UintSetTest{

    using LibUint256Set for LibUint256Set.Uint256Set;
    LibUint256Set.Uint256Set private uintSet;

    function getSize() public view returns (uint256) {
        uintSet.add(1);
        uintSet.add(2);
        uintSet.add(3);
        return uintSet.atPosition(1);
    }
}
```

### ***6. getByIndex 函数***

获取Set中的某个元素

#### 参数

- set: uint256类型Set
- index: 元素的位置

#### 返回值

- uint256: 该位置的元素

#### 实例

```
pragma solidity ^0.4.25;

import "./LibUint256Set.sol";

contract UintSetTest{

    using LibUint256Set for LibUint256Set.Uint256Set;
    LibUint256Set.Uint256Set private uintSet;

    function getByIndex(uint256 index) public view returns (uint256) {
        uintSet.add(1);
        uintSet.add(2);
        uintSet.add(3);
        return uintSet.getByIndex(index);
    }
}
```