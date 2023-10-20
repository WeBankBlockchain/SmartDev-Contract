# Lib2DArrayForUint256.sol

Lib2DArrayForUint256提供了Uint256二维数组的相关操作，包括增加新元素，删除元素，修改值，查找值，合并扩展数组等操作。

## 使用方法

首先需要通过import引Lib2DArrayForUint256类库，然后通过"."进行方法调用，如下为调用getValue方法的例子：

```
pragma solidity >=0.4.25 <0.6.11;

import "./Lib2DArrayForUint256.sol";

contract test {
    
    uint256[][] private array;
    
    function f() public returns(uint256) {
        array = new uint256[][](0);
        array = [[1,2],[3,4]];
        return Lib2DArrayForUint256.getValue(array,row,col);
    }
}
```


## API列表

编号 | API | API描述
---|---|---
1 | *addValue(uint256[][] storage array,uint256[] memory value)* | 对一个二维数组添加一个数组元素
2 | *getValue(uint256[][] storage array, uint256 row, uint256 col) internal view returns (uint256)* |查找指定位置的值
3 | *setValue(uint256[][] storage array, uint256 row, uint256 col, uint256 val) internal returns (uint256[][] memory)* |修改指定位置的值
4 | *firstIndexOf(uint256[][] storage array, uint256 val) internal view returns (bool, uint256, uint256)* | 查找第一个匹配的元素的位置
5 | *removeByIndex(uint256[][] storage array, uint256 index) internal returns(uint256[][] memory)* | 根据索引删除数组元素
6 | *extend(uint256[][] storage array1, uint256[][] storage array2) internal returns(uint256[][] memory)* | 合并两个二维数组，将第二个数组合并在第一个数组上


## API详情

### ***1. addValue 方法***

对一个二维数组增加一个数组元素，若增加的数组为空数组则退出

#### 参数

- array：二维数组
- value：一维数组

### 返回值

- 无

#### 实例

```
pragma solidity >=0.4.25 <0.6.11;

import "./Lib2DArrayForUint256.sol";

contract test {
    
    uint256[][] private array;
    
    function f() public {
        array = new uint256[][](0);
        uint256[] val  = [1,2];
        Lib2DArrayForUint256.addValue(array,val);
    }
}
```

### ***2. getValue 方法***

查找并返回指定位置的值，若位置越界不合法则退出

#### 参数

- array：二维数组
- row：值所在行
- col：值所在列

#### 返回值

- uint256：查找到的值

#### 实例

```
pragma solidity >=0.4.25 <0.6.11;

import "./Lib2DArrayForUint256.sol";

contract test {
    
    uint256[][] private array;
    
    function f() public returns(uint256) {
        array = new uint256[][](0);
        uint256[] val  = [1,2];
        Lib2DArrayForUint256.addValue(array,val);
        return Lib2DArrayForUint256.getValue(array,0,0);
    }
}
```

### ***3. setValue 方法***

修改指定位置的值，并返回修改后的二维数组，若位置越界不合法则退出

#### 参数

- array：二维数组
- row：所在行
- col：所在列
- val：修改为该值

#### 返回值

- uint256[][]: 修改后的二维数组

#### 实例

```
pragma solidity >=0.4.25 <0.6.11;

import "./Lib2DArrayForUint256.sol";

contract test {
    
    uint256[][] private array;
    
    function f() public returns(uint256[][]) {
        array = new uint256[][](0);
        uint256[] val  = [1,2];
        Lib2DArrayForUint256.addValue(array,val);
        return Lib2DArrayForUint256.setValue(array,0,0,100);
    }
}
```

### ***4. firstIndexOf 方法***

查找第一个匹配元素的位置，若存在则返回(true,row,col),若不存在则返回(false,0,0)

#### 参数

- array：二维数组
- val：待查找的元素

#### 返回值

- bool：当查找到元素，则返回true，反之返回false
- uint256：元素所在行
- uint256：元素所在列

#### 实例

```
pragma solidity >=0.4.25 <0.6.11;

import "./Lib2DArrayForUint256.sol";

contract test {
    
    uint256[][] private array;
    
    function f() public returns(bool,uint256,uint256) {
        array = new uint256[][](0);
        uint256[] val  = [1,2];
        Lib2DArrayForUint256.addValue(array,val);
        return Lib2DArrayForUint256.firstIndexOf(array,1);
    }
}
```

### ***5. removeByIndex 方法***

removeByIndex方法用于根据索引删除数组元素。当索引越界时退出。

#### 参数

- array：二维数组
- index：待删除的一维数组索引

#### 返回值

- uint256[][]: 删除指定元素后的数组

#### 实例

```
pragma solidity >=0.4.25 <0.6.11;

import "./Lib2DArrayForUint256.sol";

contract test {
    
    uint256[][] private array;
    
    function f() public returns(uint256[][]) {
        array = new uint256[][](0);
        uint256[] val  = [1,2];
        uint256[] val2 = [3,4,5];
        Lib2DArrayForUint256.addValue(array,val);
        return Lib2DArrayForUint256.removeByIndex(array,1);
    }
}
```

### ***6. extend 方法***

合并两个二维数组，

#### 参数

- array1：二维数组
- array2：二维数组

#### 返回值

- uint256: 合并后的数组

#### 实例

```
pragma solidity >=0.4.25 <0.6.11;

import "./Lib2DArrayForUint256.sol";

contract test {
    
    uint256[][] private array1;
    uint256[][] private array2;
    
    function f() public returns(uint256[][]) {

        array1 = [[1,2],[3,4]];
        array2 = [[5,6],[7,8]];
        return Lib2DArrayForUint256.extend(array1,array2);
    }
}
```