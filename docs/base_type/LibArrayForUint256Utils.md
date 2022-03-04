# LibArrayForUint256Utils.sol

LibArrayForUint256Utils提供了Uint256数组的相关操作，包括查找、比较、移除、添加、翻转、合并、去重和排序等操作。

## 使用方法

首先需要通过import引LibArrayForUint256Utils类库，然后通过"."进行方法调用，如下为调用indexOf方法的例子：

```
pragma solidity >=0.4.24 <0.6.11;

import "./LibArrayForUint256Utils.sol";

contract test {
    
    uint[] private array;
    
    function f() public returns(bool, uint) {
        array = new uint[](3);
        array[0] = 1;
        array[1] = 2;
        array[2] = 3;
        uint256 key = 3;
        bool flag;
        uint index;
        return LibArrayForUint256Utils.firstIndexOf(array, key);//Expected (true, 2)
    }
}
```


## API列表

编号 | API | API描述
---|---|---
1 | *binarySearch(uint256[] storage array, uint256 key) internal pure returns (bool, uint)* | 对一个升序的数组进行二分查找
2 | *indexOf(uint256[] storage array, uint256 key) internal pure returns (bool, uint)* |对任意数组进行查找
3 | *reverse(uint256[] storage array) internal* |对数组进行翻转操作
4 | *equals(uint256 a[], uint256 b[]) internal pure returns (bool)* | 判断两个数组是否相同
5 | *removeByIndex(uint256[] storage array, uint index) internal* | 根据索引删除数据元素
6 | *removeByValue(uint256[] storage array, uint256 value) internal* | 根据值进行数据元素删除，只删除第一个匹配的元素
7 | *addValue(uint256[] storage array, uint256 value) internal* | 当数组中不存在元素时，把元素添加在数组末尾
8 | *extend(uint256[] storage a, uint256[] storage b) internal* | 合并两个数组，将第二个数组合并在第一个数组上
9 | *distinct(uint256[] storage array) internal returns (uint256 length)* | 对数组进行去重操作
10 | *qsort(uint256[] storage array) internal pure* | 对数组进行升序排列
11 | *max(uint256[] storage array) internal view returns (uint256, uint256)* | 找出数组的最大值及index
12 | *min(uint256[] storage array) internal view returns (uint256, uint256)* | 找出数组的最小值及index


## API详情

### ***1. binarySearch 方法***

binarySearch对一个升序排列的数组进行二分查找，如果找到，则返回true，并返回第一个匹配的元素索引；反之，返回(false,0)

#### 参数

- array：升序排列的数组
- key：待查找的元素

#### 返回值

- bool：当找到元素，则返回true，反之，返回false;
- uint：当找到元素，返回第一个匹配的元素索引，反之返回0；

#### 实例

```
pragma solidity >=0.4.24 <0.6.11;

import "./LibArrayForUint256Utils.sol";

contract test {
    
    uint[] private array;
    
    function f() public returns(bool, uint) {
        array = new uint[](3);
        array[0] = 1;
        array[1] = 2;
        array[2] = 3;
        uint256 key = 3;
        bool flag;
        uint index;
        return LibArrayForUint256Utils.binarySearch(array, key);//Expected (true, 2)
    }
}
```
### ***2. firstIndexOf 方法***

对任意数组进行查找，如果找到，则返回true，并返回第一个匹配的元素索引；反之，返回(false,0)

#### 参数

- array：升序排列的数组
- key：待查找的元素

#### 返回值

- bool：当找到元素，则返回true，反之，返回false;
- uint：当找到元素，返回第一个匹配的元素索引，反之返回0；

#### 实例

```
pragma solidity >=0.4.24 <0.6.11;

import "./LibArrayForUint256Utils.sol";

contract test {
    
    uint[] private array;
    
    function f() public returns(bool, uint) {
        array = new uint[](3);
        array[0] = 1;
        array[1] = 2;
        array[2] = 3;
        uint256 key = 3;
        bool flag;
        uint index;
        return LibArrayForUint256Utils.firstIndexOf(array, key);//Expected (true, 2)
    }
}
```

### ***3. reverse 方法***

reverse方法对任意数组进行元素翻转。

#### 参数

- array：数组

#### 返回值

- 无

#### 实例

```
pragma solidity >=0.4.24 <0.6.11;

import "./LibArrayForUint256Utils.sol";

contract test {
    
    uint[] private array;
    
    function f() public  {
        array = new uint[](3);
        array[0] = 1;
        array[1] = 2;
        array[2] = 3;
        LibArrayForUint256Utils.reverse(array);//array becomes 3 2 1
    }
}
```

### ***4. equals 方法***

equals方法用于判断两个数组是否相等，当两个数组的元素完全相等时，则返回true，反之返回false。

#### 参数

- a：数组a
- b：数组b

#### 返回值

- bool：当两个数组的元素完全相等时，则返回true，反之返回false

#### 实例

```
pragma solidity >=0.4.24 <0.6.11;

import "./LibArrayForUint256Utils.sol";

contract test {
    
    uint[] private array1;
    uint[] private array2;
    
    function f() public returns(bool) {
        array1 = new uint[](3);
        array1[0] = 1;
        array1[1] = 2;
    
        array2 = new uint[](3);
        array2[0] = 1;
        array2[1] = 2;    
        return LibArrayForUint256Utils.equals(array1, array2);
    }
}
```

### ***5. removeByIndex 方法***

removeByIndex方法用于根据索引删除数组元素。当数据越界时报错，当元素不存在时，数组保持不变。

#### 参数

- array：数组
- index：待删除的元素索引

#### 返回值

- 无

#### 实例

```
pragma solidity >=0.4.24 <0.6.11;

import "./LibArrayForUint256Utils.sol";

contract test {
    
    uint[] private array;

    function f() public returns(uint) {
        array = new uint[](3);
        array[0] = 1;
        array[1] = 2;
        array[2] = 3;
        LibArrayForUint256Utils.removeByIndex(array,0);
        return array.length;//Expect 2
    }
}
```

### ***6. removeByValue 方法***

removeByValue方法用于根据元素值删除数组元素。当数据越界时报错，当元素不存在时，数组保持不变，只删除第一个匹配的元素。

#### 参数

- array：数组
- value：待删除的元素值

#### 返回值

- 无

#### 实例

```
pragma solidity >=0.4.24 <0.6.11;

import "./LibArrayForUint256Utils.sol";

contract test {
    
    uint[] private array;

    function f() public returns(uint) {
        array = new uint[](3);
        array[0] = 1;
        array[1] = 2;
        array[2] = 2;
        LibArrayForUint256Utils.removeByValue(array,2);
        return array.length;//Expect 2
    }
}
```

### ***7. addValue 方法***

addValue方法用于向数组中添加元素，且保持数组的元素唯一。当数组中已存在当前值，则不进行添加。

#### 参数

- array：数组
- value：待添加的元素

#### 返回值

- 无

#### 实例

```
pragma solidity >=0.4.24 <0.6.11;

import "./LibArrayForUint256Utils.sol";

contract test {
    
    uint[] private array;

    function f() public returns(uint) {
        array = new uint[](0);
        LibArrayForUint256Utils.addValue(array,2);
        return array.length;//Expect 1
    }
}
```

### ***8. extend 方法***

extend方法用于合并两个数组，将第二个数组中的元素按照顺序追加到第一个数组后面。

#### 参数

- a：被追加数组
- b：待追加数组

#### 返回值

- 无

#### 实例

```
pragma solidity >=0.4.24 <0.6.11;

import "./LibArrayForUint256Utils.sol";

contract test {
    
    uint[] private array;
    uint[] private array2;

    function f() public returns(uint) {
        array = new uint[](2);
        array2 = new uint[](2);
        LibArrayForUint256Utils.extend(array,array2);
        return array.length;//Expect 4
    }
}
```

### ***9. distinct 方法***

distinct方法用于对数组进行去重操作。

#### 参数

- array：数组

#### 返回值

- 无

#### 实例

```
pragma solidity >=0.4.24 <0.6.11;

import "./LibArrayForUint256Utils.sol";

contract test {
    
    uint[] private array;

    function f() public returns(uint) {
        array = new uint[](3);
        array[0] = 2;
        array[1] = 2;
        array[2] = 2;
        LibArrayForUint256Utils.distinct(array);
        return array.length;//Expect 1
    }
}
```

### ***10. qsort 方法***

qsort方法用于对数组进行快速排序。

#### 参数

- array：数组

#### 返回值

- 无

#### 实例

```
pragma solidity >=0.4.24 <0.6.11;

import "./LibArrayForUint256Utils.sol";

contract test {
    
    uint[] private array;

    function f() public returns(uint,uint,uint) {
        array = new uint[](3);
        array[0] = 3;
        array[1] = 2;
        array[2] = 1;
        LibArrayForUint256Utils.qsort(array);
        return (array[0], array[1], array[2]);//expect 1,2,3
    }
}
```

### ***11. max 方法***

对任意数组进行查找最大值，并返回最大值所在的index

#### 参数

- array：待查找的数组

#### 返回值

- uint256：最大值;
- uint256：最大值的index；

#### 实例

```
pragma solidity >=0.4.24 <0.6.11;

import "./LibArrayForUint256Utils.sol";

contract test {
    
    uint[] private array;

    function f() public returns(uint, uint) {
        array = new uint[](3);
        array[0] = 3;
        array[1] = 2;
        array[2] = 1;
        return LibArrayForUint256Utils.max(array);//3 , 0
    }
}
```

### ***12. min 方法***

对任意数组进行查找最小值，并返回最小值所在的index

#### 参数

- array：待查找的数组

#### 返回值

- uint256：最小值;
- uint256：最小值的index；

#### 实例

```
pragma solidity >=0.4.24 <0.6.11;

import "./LibArrayForUint256Utils.sol";

contract test {
    
    uint[] private array;

    function f() public returns(uint, uint) {
        array = new uint[](3);
        array[0] = 3;
        array[1] = 2;
        array[2] = 1;
        return LibArrayForUint256Utils.min(array);//1 , 2
    }
}
```