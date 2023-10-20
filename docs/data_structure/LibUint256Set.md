# LibUint256Set.sol

LibUint256Set 提供了存储Uint256类型的Set数据结构，支持包括add, remove, contains, getAll等方法。

## 使用方法

首先需要通过import引入LibUint256Set类库，然后通过"."进行方法调用，如下为调用LibUint256Set.add方法的例子：

```
pragma solidity ^0.4.25;

import "./LibUint256Set.sol";

contract Uint256SetDemo{

    using LibUint256Set for LibUint256Set.Uint256Set;
    LibUint256Set.Uint256Set private uintSet;

    function add() public view returns (bool) {
        return uintSet.add(1);
    }
}
```

## 控制台测试

### 部署测试合约
```
[group:1]> deploy Uint256SetDemo
transaction hash: 0x4c88711fe9703b23cd01e633770eb57fb5f467d80b4dd802a69e64f68805b471
contract address: 0x67dd71d31bfcd20f3b959c02a23a5c87816194ff
currentAccount: 0x22fec9d7e121960e7972402789868962238d8037
```

### 执行测试函数

```
[group:1]> call Uint256SetDemo 0x67dd71d31bfcd20f3b959c02a23a5c87816194ff add
---------------------------------------------------------------------------------------------
Return code: 0
description: transaction executed successfully
Return message: Success
---------------------------------------------------------------------------------------------
Return value size:1
Return types: (BOOL)
Return values:(true)
---------------------------------------------------------------------------------------------

[group:1]> call Uint256SetDemo 0x67dd71d31bfcd20f3b959c02a23a5c87816194ff contains
---------------------------------------------------------------------------------------------
Return code: 0
description: transaction executed successfully
Return message: Success
---------------------------------------------------------------------------------------------
Return value size:1
Return types: (BOOL)
Return values:(true)
---------------------------------------------------------------------------------------------

[group:1]> call Uint256SetDemo 0x67dd71d31bfcd20f3b959c02a23a5c87816194ff getAll
---------------------------------------------------------------------------------------------
Return code: 0
description: transaction executed successfully
Return message: Success
---------------------------------------------------------------------------------------------
Return value size:1
Return types: ([UINT, UINT, UINT] )
Return values:([1, 2, 3] )
---------------------------------------------------------------------------------------------

[group:1]> call Uint256SetDemo 0x67dd71d31bfcd20f3b959c02a23a5c87816194ff remove 2
---------------------------------------------------------------------------------------------
Return code: 0
description: transaction executed successfully
Return message: Success
---------------------------------------------------------------------------------------------
Return value size:2
Return types: (BOOL, [UINT, UINT] )
Return values:(true, [1, 3] )
---------------------------------------------------------------------------------------------

[group:1]> call Uint256SetDemo 0x67dd71d31bfcd20f3b959c02a23a5c87816194ff removeAndAtPositon 2 3
---------------------------------------------------------------------------------------------
Return code: 0
description: transaction executed successfully
Return message: Success
---------------------------------------------------------------------------------------------
Return value size:2
Return types: (BOOL, UINT)
Return values:(true, 1)
---------------------------------------------------------------------------------------------

[group:1]> call Uint256SetDemo 0x67dd71d31bfcd20f3b959c02a23a5c87816194ff getSize
---------------------------------------------------------------------------------------------
Return code: 0
description: transaction executed successfully
Return message: Success
---------------------------------------------------------------------------------------------
Return value size:1
Return types: (UINT)
Return values:(3)
---------------------------------------------------------------------------------------------

[group:1]> call Uint256SetDemo 0x67dd71d31bfcd20f3b959c02a23a5c87816194ff getByIndex 2
---------------------------------------------------------------------------------------------
Return code: 0
description: transaction executed successfully
Return message: Success
---------------------------------------------------------------------------------------------
Return value size:1
Return types: (UINT)
Return values:(3)
---------------------------------------------------------------------------------------------
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
8 | *union(Uint256Set storage a, Uint256Set storage b) internal view returns (uint256[])* | 求并集。
9 | *relative(Uint256Set storage a, Uint256Set storage b) internal view returns (uint256[])* | 求差集。
10 | *intersect(Uint256Set storage a, Uint256Set storage b) internal view returns (uint256[])* | 求交集。

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

contract Uint256SetDemo{

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

contract Uint256SetDemo{

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

contract Uint256SetDemo{

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

contract Uint256SetDemo{

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

contract Uint256SetDemo{

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

contract Uint256SetDemo{

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

### ***7. getByIndex 函数***

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

contract Uint256SetDemo{

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

### ***8. union 函数***

求两个集合的并集

#### 参数

- Uint256Set: uint256类型Set
- Uint256Set: uint256类型Set

#### 返回值

- uint256[]: 交集的元素

#### 实例

```
pragma solidity ^0.4.25;

import "./LibUint256Set.sol";

contract Uint256SetDemo{

    using LibUint256Set for LibUint256Set.Uint256Set;
    LibUint256Set.Uint256Set private uintSet;
    LibUint256Set.Uint256Set private uintSet2;

    function union() public view returns (uint256[]){
        uintSet.add(1);
        uintSet.add(2);
        uintSet.add(3);
        uintSet2.add(3);
        uintSet2.add(4);
        uintSet2.add(5);
        return uintSet.union(uintSet2);
    }
}
```

### ***9. relative 函数***

求两个集合的差

#### 参数

- Uint256Set: uint256类型Set
- Uint256Set: uint256类型Set

#### 返回值

- uint256[]: 差集的元素 a-b

#### 实例

```
pragma solidity ^0.4.25;

import "./LibUint256Set.sol";

contract Uint256SetDemo{

    using LibUint256Set for LibUint256Set.Uint256Set;
    LibUint256Set.Uint256Set private uintSet;
    LibUint256Set.Uint256Set private uintSet2;

    function union() public view returns (uint256[]){
        uintSet.add(1);
        uintSet.add(2);
        uintSet.add(3);
        uintSet2.add(3);
        uintSet2.add(4);
        uintSet2.add(5);
        return uintSet.relative(uintSet2);
    }
}
```

### ***10. intersect 函数***

求两个集合的交集

#### 参数

- Uint256Set: uint256类型Set
- Uint256Set: uint256类型Set

#### 返回值

- uint256[]: 交集元素

#### 实例

```
pragma solidity ^0.4.25;

import "./LibUint256Set.sol";

contract Uint256SetDemo{

    using LibUint256Set for LibUint256Set.Uint256Set;
    LibUint256Set.Uint256Set private uintSet;
    LibUint256Set.Uint256Set private uintSet2;

    function union() public view returns (uint256[]){
        uintSet.add(1);
        uintSet.add(2);
        uintSet.add(3);
        uintSet2.add(3);
        uintSet2.add(4);
        uintSet2.add(5);
        return uintSet.intersect(uintSet2);
    }
}
```