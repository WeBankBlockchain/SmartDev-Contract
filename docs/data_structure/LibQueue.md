# LibQueue.sol

LibQueue提供了FIFO队列数据结构。

## 使用方法

首先需要通过import引入LibQueue类库，然后通过"."进行方法调用，如下为调用LibQueue方法的例子：

```
pragma solidity >=0.4.24 <0.6.11;

import "./LibQueue.sol";

contract Test {
    
    using LibQueue for LibQueue.Queue;
    
    LibQueue.Queue private queue;
    
    function f() public {
        queue.enqueue(bytes32(uint(1)));
        queue.enqueue(bytes32(uint(1)));
        bytes32 pop = queue.dequeue();//Expected to be 1
        uint size = queue.getSize();//Expected to be 1
    }
    
}
```


## API列表

编号 | API | API描述
---|---|---
1 | *enqueue(Queue storage queue, bytes32 data) public* |入队
2 | *dequeue(Queue storage queue) public returns (bytes32)* |出队
3 | *getSize(Queue storage self) internal view returns(uint256)* | 获取队列元素数
4 | *element(Queue storage queue) public view returns (bytes32)* | 查询下一个队列中的值，但不从queue中删除。

## API详情

### ***1. enqueue 函数***

入队

#### 参数

- Queue：队列
- bytes32: 元素

#### 返回值


#### 实例

```
pragma solidity >=0.4.24 <0.6.11;

import "./LibQueue.sol";

contract Test {
    
    using LibQueue for LibQueue.Queue;
    
    LibQueue.Queue private queue;
    
    function f() public returns(uint) {
        queue.enqueue(bytes32(uint(1)));
        queue.enqueue(bytes32(uint(2)));
        uint size = queue.getSize();//Expected to be 2
        return (size);
    }
    
}
```
### ***2. dequeue 函数***

出队一个元素

#### 参数

- Queue: 队列

#### 返回值

- bytes32：队列元素值

#### 实例

```
pragma solidity >=0.4.24 <0.6.11;

import "./LibQueue.sol";

contract Test {
    
    using LibQueue for LibQueue.Queue;
    
    LibQueue.Queue private queue;
    
    function f() public returns(bytes32, uint) {
        queue.enqueue(bytes32(uint(1)));
        queue.enqueue(bytes32(uint(2)));
        bytes32 head = queue.dequeue();//Expteced to be 1
        uint size = queue.getSize();//Expected to be 1
        return (head, size);
    }
    
}
```

### ***3. getSize 函数***

查询队列大小

#### 参数

- Queue: 队列

#### 返回值

- uint256: 队列大小

#### 实例

```
    uint size = queue.getSize();//Expected to be 2
```

### ***4. element 函数***

查询队列中的下一个元素，如果队列为空，则函数查询不成功。

#### 参数

- Queue: 队列

#### 返回值

- bytes32：队列元素值

#### 实例

```
pragma solidity >=0.4.24 <0.6.11;

import "./LibQueue.sol";

contract Test {
    
    using LibQueue for LibQueue.Queue;
    
    LibQueue.Queue private queue;
    
    function f() public returns(bytes32, uint) {
        queue.enqueue(bytes32(uint(1)));
        queue.enqueue(bytes32(uint(2)));
        bytes32 head = queue.element();//Expteced to be 1
        uint size = queue.getSize();//Expected to be 2
        return (head, size);
    }
    
}
```

