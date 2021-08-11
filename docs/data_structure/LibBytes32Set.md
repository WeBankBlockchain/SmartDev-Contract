# LibBytes32Set.sol

LibBytes32Set 提供了存储Bytes32类型的Set数据结构，支持包括add, remove, contains, getAll等方法。

## 使用方法

首先需要通过import引入LibBytes32Set类库，然后通过"."进行方法调用，如下为调用LibBytes32Set.add方法的例子：

```
pragma solidity ^0.4.25;

import "./LibBytes32Set.sol";

contract BytesSetTest{

    using LibBytes32Set for LibBytes32Set.Bytes32Set;
    LibBytes32Set.Bytes32Set private bytesSet;

    function add() public view returns (bool) {
        return bytesSet.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCF);
    }
}
```


## API列表

编号 | API | API描述
---|---|---
1 | *contains(Bytes32Set storage  set, bytes32 val) internal view returns (bool)* | 判断Set里是否包含了元素value。
2 | *add(Bytes32Set storage set, bytes32 val) internal view returns (bool)* | 往Set里添加元素。
3 | *remove(Bytes32Set storage set, bytes32 val) internal view returns (bool)* | 删除Set中的元素。
4 | *getAll(Bytes32Set storage set) internal view returns (bytes32[] memory)* | 返回所有元素。
5 | *getSize(Bytes32Set storage set) internal view returns (uint256)* | 返回Set中元素数。
6 | *atPosition(Bytes32Set storage set, bytes32 val) internal view returns (bool, uint256)* | 返回某个元素的位置。
7 | *getByIndex(Bytes32Set storage set, uint256 index) internal view returns (bytes32)* | 查找某个元素。

## API详情

### ***1. contains 函数***

判断Set里是否包含了元素value

#### 参数

- set: byte32类型Set
- val: 待检查元素

#### 返回值

-bool: 是否存在， true存在，false 不存在

#### 实例

```
pragma solidity ^0.4.25;

import "./LibBytes32Set.sol";

contract BytesSetTest{

    using LibBytes32Set for LibBytes32Set.Bytes32Set;
    LibBytes32Set.Bytes32Set private bytesSet;

    function contains() public view returns (bool) {
        bytesSet.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCF);
        return bytesSet.contains(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCF);
    }
}
```

### ***2. add 函数***

往Set中添加一个元素

#### 参数

- set: byte32类型Set
- val: 待加入元素

#### 返回值

- bool: 是否添加成功

#### 实例

```
pragma solidity ^0.4.25;

import "./LibBytes32Set.sol";

contract BytesSetTest{

    using LibBytes32Set for LibBytes32Set.Bytes32Set;
    LibBytes32Set.Bytes32Set private bytesSet;

    function add() public view returns (bool) {
        return bytesSet.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCF);
    }
}
```

### ***3. remove 函数***

删除Set中的指定元素

#### 参数

- set: byte32类型Set
- val: 待删除元素

#### 返回值

- bool: 是否删除成功

#### 实例

```
pragma solidity ^0.4.25;

import "./LibBytes32Set.sol";

contract BytesSetTest{

    using LibBytes32Set for LibBytes32Set.Bytes32Set;
    LibBytes32Set.Bytes32Set private bytesSet;

    function remove(bytes32 del) public view returns (bool) {
        bytesSet.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCA);
        bytesSet.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCB);
        bytesSet.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCC);
        return bytesSet.remove(del);
    }
}
```

### ***4. getAll 函数***

获取Set中的所有元素。

#### 参数

- set: byte32类型Set

#### 返回值

- bytes32[]: 所有元素

#### 实例

```
pragma solidity ^0.4.25;

import "./LibBytes32Set.sol";

contract BytesSetTest{

    using LibBytes32Set for LibBytes32Set.Bytes32Set;
    LibBytes32Set.Bytes32Set private bytesSet;

    function getAll() public view returns (bytes32[]) {
        bytesSet.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCA);
        bytesSet.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCB);
        bytesSet.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCC);
        return bytesSet.getAll();
    }
}
```

### ***5. getSize 函数***

返回Set中元素数量

#### 参数

- set: byte32类型Set

#### 返回值
- uint256: 元素数量

#### 实例

```
pragma solidity ^0.4.25;

import "./LibBytes32Set.sol";

contract BytesSetTest{

    using LibBytes32Set for LibBytes32Set.Bytes32Set;
    LibBytes32Set.Bytes32Set private bytesSet;

    function getSize() public view returns (uint256) {
        bytesSet.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCA);
        bytesSet.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCB);
        bytesSet.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCC);
        return bytesSet.getSize();
    }
}
```

### ***6. atPosition 函数***

Set中某个元素的位置

#### 参数

- set: byte32类型Set
- val: 待检测元素

#### 返回值

- bool: 是否存在该元素
- uint256: 该元素位置

#### 实例

```
pragma solidity ^0.4.25;

import "./LibBytes32Set.sol";

contract BytesSetTest{

    using LibBytes32Set for LibBytes32Set.Bytes32Set;
    LibBytes32Set.Bytes32Set private bytesSet;

    function getSize() public view returns (uint256) {
        bytesSet.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCA);
        bytesSet.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCB);
        bytesSet.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCC);
        return bytesSet.atPositon(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCC);
    }
}
```

### ***6. getByIndex 函数***

获取Set中的某个元素

#### 参数

- set: byte32类型Set
- index: 元素的位置

#### 返回值

- bytes32: 该位置的元素

#### 实例

```
pragma solidity ^0.4.25;

import "./LibBytes32Set.sol";

contract BytesSetTest{

    using LibBytes32Set for LibBytes32Set.Bytes32Set;
    LibBytes32Set.Bytes32Set private bytesSet;

    function getByIndex(uint256 index) public view returns (bytes32) {
        bytesSet.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCA);
        bytesSet.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCB);
        bytesSet.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCC);
        return bytesSet.getByIndex(index);
    }
}
```