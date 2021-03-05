# LibMaxHeapUint256.sol

LibMaxHeapUint256提供了最大堆的实现。

## 使用方法

首先需要通过import引入类库，然后通过"."进行方法调用，如下为调用例子：

```

pragma solidity >=0.4.24 <0.6.11;

import "./LibMaxHeapUint256.sol";

contract Test {
    
    using LibMaxHeapUint256 for LibMaxHeapUint256.Heap;
    
    LibMaxHeapUint256.Heap private _heap;
    
    function insertExample(uint256 value) public returns(uint256) {
       _heap.insert(value);
    }
}
```


## API列表

编号 | API | API描述
---|---|---
1 | *insert(Heap storage heap, uint256 value) internal* | 向堆中插入一个元素
2 | *top(Heap storage heap) internal view returns (uint256)* |查询堆顶元素（最大值）
3 | *extractTop(Heap storage heap) internal returns(uint256 top)* |弹出堆顶元素（最大值）
4 | *getSize(Heap storage heap) internal view returns(uint256)* | 查询堆元素数

## API详情

### ***1. insert 函数***

向堆中插入一个元素

#### 参数

- Heap heap：堆
- uint256 value：元素

#### 实例

```
    function insertExample(uint256 value) public returns(uint256) {
       _heap.insert(value);
    }
    
```
### ***2. top 函数***

查询堆顶

#### 参数

- Heap heap：堆

#### 返回值

- uint256： 堆顶元素

#### 实例

```
    function topExample() public returns(uint256 top) {
        top = _heap.top();
    }
    
```
### ***3. extractTop 函数***

弹出堆顶元素

#### 参数

- Heap heap：堆

#### 返回值

- uint256： 堆顶元素

#### 实例

```
    function extractTopExample() public returns(uint256 top) {
        top = _heap.extractTop();
    }
```

### ***4. getSize 函数***

获取堆元素数

#### 参数

- Heap heap：堆

#### 返回值

- uint256： 堆元素数

#### 实例

```
    function getSize() public returns(uint256 size) {
        size = _heap.getSize();
    }
```