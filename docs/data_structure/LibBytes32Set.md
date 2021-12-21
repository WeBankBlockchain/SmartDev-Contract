# LibBytes32Set.sol

LibBytes32Set 提供了存储Bytes32类型的Set数据结构，支持包括add, remove, contains, getAll等方法。

## 使用方法

首先需要通过import引入LibBytes32Set类库，然后通过"."进行方法调用，如下为调用LibBytes32Set.add方法的例子：

```
pragma solidity ^0.4.25;

import "./LibBytes32Set.sol";

contract Bytes32SetDemo{

    using LibBytes32Set for LibBytes32Set.Bytes32Set;
    LibBytes32Set.Bytes32Set private bytesSet;

    function add() public view returns (bool) {
        return bytesSet.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCF);
    }
}
```

## 控制台测试

### 部署测试合约
```
[group:1]> deploy Bytes32SetDemo
transaction hash: 0xea2a56d12eef424325d963de9895eaff84023cc79d0d302a2b3393488ba94c35
contract address: 0x265da37424917fa78740585c7b4fc58fdd59f11e
currentAccount: 0x22fec9d7e121960e7972402789868962238d8037
```

### 执行测试函数
```
[group:1]> call Bytes32SetDemo 0x265da37424917fa78740585c7b4fc58fdd59f11e add
---------------------------------------------------------------------------------------------
Return code: 0
description: transaction executed successfully
Return message: Success
---------------------------------------------------------------------------------------------
Return value size:1
Return types: (BOOL)
Return values:(true)
---------------------------------------------------------------------------------------------

[group:1]>  call Bytes32SetDemo 0x265da37424917fa78740585c7b4fc58fdd59f11e contains
---------------------------------------------------------------------------------------------
Return code: 0
description: transaction executed successfully
Return message: Success
---------------------------------------------------------------------------------------------
Return value size:1
Return types: (BOOL)
Return values:(true)
---------------------------------------------------------------------------------------------

[group:1]>  call Bytes32SetDemo 0x265da37424917fa78740585c7b4fc58fdd59f11e getAll
---------------------------------------------------------------------------------------------
Return code: 0
description: transaction executed successfully
Return message: Success
---------------------------------------------------------------------------------------------
Return value size:1
Return types: ([BYTES, BYTES, BYTES] )
Return values:([hex://0x111122223333444455556666777788889999aaaabbbbccccddddeeeeffffccca, hex://0x111122223333444455556666777788889999aaaabbbbccccddddeeeeffffcccb, hex://0x111122223333444455556666777788889999aaaabbbbccccddddeeeeffffcccc] )
---------------------------------------------------------------------------------------------

[group:1]>  call Bytes32SetDemo 0x265da37424917fa78740585c7b4fc58fdd59f11e getSize
---------------------------------------------------------------------------------------------
Return code: 0
description: transaction executed successfully
Return message: Success
---------------------------------------------------------------------------------------------
Return value size:1
Return types: (UINT)
Return values:(3)
---------------------------------------------------------------------------------------------

[group:1]>  call Bytes32SetDemo 0x265da37424917fa78740585c7b4fc58fdd59f11e getByIndex 0
---------------------------------------------------------------------------------------------
Return code: 0
description: transaction executed successfully
Return message: Success
---------------------------------------------------------------------------------------------
Return value size:1
Return types: (BYTES)
Return values:(hex://0x111122223333444455556666777788889999aaaabbbbccccddddeeeeffffccca)
---------------------------------------------------------------------------------------------

[group:1]>  call Bytes32SetDemo 0x265da37424917fa78740585c7b4fc58fdd59f11e atPosition
---------------------------------------------------------------------------------------------
Return code: 0
description: transaction executed successfully
Return message: Success
---------------------------------------------------------------------------------------------
Return value size:2
Return types: (BOOL, UINT)
Return values:(true, 2)
---------------------------------------------------------------------------------------------
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
8 | *union(Bytes32Set storage a, Bytes32Set storage b) internal view returns (bytes32[])* | 求并集。
9 | *relative(Bytes32Set storage a, Bytes32Set storage b) internal view returns (bytes32[])* | 求差集。
10 | *intersect(Bytes32Set storage a, Bytes32Set storage b) internal view returns (bytes32[])* | 求交集。


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

contract Bytes32SetDemo{

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

contract Bytes32SetDemo{

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

contract Bytes32SetDemo{

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

contract Bytes32SetDemo{

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

contract Bytes32SetDemo{

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

contract Bytes32SetDemo{

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

### ***7. getByIndex 函数***

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

contract Bytes32SetDemo{

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

### ***8. union 函数***

求两个集合的并集

#### 参数

- Bytes32Set: bytes32类型Set
- Bytes32Set: bytes32类型Set

#### 返回值

- bytes32[]: 并集元素

#### 实例

```
pragma solidity ^0.4.25;

import "./LibBytes32Set.sol";

contract Bytes32SetDemo{

    using LibBytes32Set for LibBytes32Set.Bytes32Set;
    LibBytes32Set.Bytes32Set private bytesSet;
    LibBytes32Set.Bytes32Set private bytesSet2;

    function union() public view returns (bytes32[] memory) {
        bytesSet.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCA);
        bytesSet.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCB);
        bytesSet.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCC);

        bytesSet2.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCC);
        bytesSet2.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCD);
        bytesSet2.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCE);
        return bytesSet.union(bytesSet2);
    }
}
```

### ***9. relative 函数***

求两个集合的差集

#### 参数

- Bytes32Set: bytes32类型Set
- Bytes32Set: bytes32类型Set

#### 返回值

- bytes32[]: 差集元素

#### 实例

```
pragma solidity ^0.4.25;

import "./LibBytes32Set.sol";

contract Bytes32SetDemo{

    using LibBytes32Set for LibBytes32Set.Bytes32Set;
    LibBytes32Set.Bytes32Set private bytesSet;
    LibBytes32Set.Bytes32Set private bytesSet2;

    function relative() public view returns (bytes32[] memory) {
        bytesSet.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCA);
        bytesSet.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCB);
        bytesSet.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCC);

        bytesSet2.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCC);
        bytesSet2.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCD);
        bytesSet2.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCE);
        return bytesSet.relative(bytesSet2);
    }
}
```

### ***9. intersect 函数***

求两个集合的交集

#### 参数

- Bytes32Set: bytes32类型Set
- Bytes32Set: bytes32类型Set

#### 返回值

- bytes32[]: 交集元素

#### 实例

```
pragma solidity ^0.4.25;

import "./LibBytes32Set.sol";

contract Bytes32SetDemo{

    using LibBytes32Set for LibBytes32Set.Bytes32Set;
    LibBytes32Set.Bytes32Set private bytesSet;
    LibBytes32Set.Bytes32Set private bytesSet2;

    function intersect() public view returns (bytes32[] memory) {
        bytesSet.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCA);
        bytesSet.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCB);
        bytesSet.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCC);

        bytesSet2.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCC);
        bytesSet2.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCD);
        bytesSet2.add(0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCE);
        return bytesSet.intersect(bytesSet2);
    }
}
```