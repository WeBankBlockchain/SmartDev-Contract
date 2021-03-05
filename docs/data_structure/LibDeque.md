# LibDeque.sol

LibDeque提供了双端队列。用户也可以像用栈一样使用它。

## 使用方法

首先需要通过import引入LibDeque类库，然后通过"."进行方法调用，如下为调用LibDeque方法的例子：

```
pragma solidity >=0.4.22 <0.7.0;

import "./LibDeque.sol";

contract Test{
    
    using LibDeque for LibDeque.Deque;
    
    LibDeque.Deque private _deque;
    
    event Log(uint size);
    function f() public returns(bytes32, bytes32){
        _deque.offerFirst(bytes32(uint256(1)));
        _deque.offerLast(bytes32(uint256(2)));
        emit Log(_deque.getSize());//Should be 2
        bytes32 first =_deque.pollFirst();//Shoud be 0x1
        bytes32 last = _deque.pollLast();//Should be 0x2
        emit Log(_deque.getSize());//Should be empty
        return (first, last);
    }

}

```


## API列表

编号 | API | API描述
---|---|---
1 | *getSize(Deque storage self) internal view returns(uint256)* |获取元素数
2 | *isEmpty(Deque storage self) internal view returns(bool)* |判断是否为空
3 | *offerFirst(Deque storage self, bytes32 element) internal* | 将数据存入头部
4 | *offerLast(Deque storage self, bytes32 element) internal* | 将数据存入尾部
5 | *pollFirst(Deque storage self) internal returns(bytes32 ret)* |取出头部元素
6 | *pollLast(Deque storage self) internal returns(bytes32 ret)* |取出尾部元素
7 | *peekFirst(Deque storage self) internal view returns(bytes32 ret)* |查看头部元素
8 | *peekLast(Deque storage self) internal view returns(bytes32 ret)* |查看尾部元素
9 | *push(Deque storage self, bytes32 element) internal* |入栈
10 | *pop(Deque storage self) internal returns(bytes32)* |出栈

## API详情

### ***1. getSize 函数***

查看元素数目

#### 参数

- Deque：队列

#### 返回值

- uint256： 元素数

#### 实例

```
    uint256 size = _deque.getSize();
```
### ***2. isEmpty 函数***

查看是否为空

#### 参数

- Deque：队列

#### 返回值

- bool 是否为空

#### 实例

```
    bool empty = _deque.isEmpty();
```

### ***3. offerFirst 函数***

从头部存入元素。

#### 参数

- Deque：队列
- bytes32: 元素

#### 实例

```
pragma solidity >=0.4.22 <0.7.0;

import "./LibDeque.sol";

contract Test{
    
    using LibDeque for LibDeque.Deque;
    
    LibDeque.Deque private _deque;
    
    event Log(uint size);

    function f() public{
        _deque.offerFirst(bytes32(uint256(1)));
        emit Log(_deque.getSize());//Should be 1
    }
}

```

### ***4. offerLast 函数***

从尾部存入元素。

#### 参数

- Deque：队列
- bytes32: 元素

#### 实例

```
pragma solidity >=0.4.22 <0.7.0;

import "./LibDeque.sol";

contract Test{
    
    using LibDeque for LibDeque.Deque;
    
    LibDeque.Deque private _deque;
    
    event Log(uint size);

    function f() public{
        _deque.offerLast(bytes32(uint256(2)));
        emit Log(_deque.getSize());//Should be 1
    }
}

```

### ***5. pollFirst 函数***

删除头部元素，并返回该元素。如果队列为空，则失败。

#### 参数

- Deque：队列


#### 返回值

- bytes32: 头部元素

#### 实例

```
pragma solidity >=0.4.22 <0.7.0;

import "./LibDeque.sol";

contract Test{
    
    using LibDeque for LibDeque.Deque;
    
    LibDeque.Deque private _deque;
    
    event Log(uint size);
    function f() public returns(bytes32){
        _deque.offerFirst(bytes32(uint256(1)));
        _deque.offerLast(bytes32(uint256(2)));
        bytes32 r = _deque.pollFirst();//Should be 1
        emit Log(_deque.getSize());//Should be 1
        return (r);
    }
}
```

### ***6. pollLast 函数***

删除尾部元素，并返回该元素。如果队列为空，则失败。

#### 参数

- Deque：队列

#### 返回值

- bytes32: 尾部元素

#### 实例

```
pragma solidity >=0.4.22 <0.7.0;

import "./LibDeque.sol";

contract Test{
    
    using LibDeque for LibDeque.Deque;
    
    LibDeque.Deque private _deque;
    
    event Log(uint size);
    function f() public returns(bytes32){
        _deque.offerFirst(bytes32(uint256(1)));
        _deque.offerLast(bytes32(uint256(2)));
        bytes32 r = _deque.pollLast();//Should be 2
        emit Log(_deque.getSize());//Should be 1
        return (r);
    }
}
```


### ***7. peekFirst 函数***

查看头部元素。如果队列为空，则失败。

#### 参数

- Deque：队列

#### 返回值

- bytes32: 头部元素

#### 实例

```
pragma solidity >=0.4.22 <0.7.0;

import "./LibDeque.sol";

contract Test{
    
    using LibDeque for LibDeque.Deque;
    
    LibDeque.Deque private _deque;
    
    event Log(uint size);
    function f() public returns(bytes32){
        _deque.offerFirst(bytes32(uint256(1)));
        _deque.offerLast(bytes32(uint256(2)));
        bytes32 r = _deque.peekFirst();//Should be 1
        emit Log(_deque.getSize());//Should be 2
        return (r);
    }
}
```

### ***8. peekLast 函数***

查看尾部元素。如果队列为空，则失败。

#### 参数

- Deque：队列

#### 返回值

- bytes32: 尾部元素

#### 实例

```
pragma solidity >=0.4.22 <0.7.0;

import "./LibDeque.sol";

contract Test{
    
    using LibDeque for LibDeque.Deque;
    
    LibDeque.Deque private _deque;
    
    event Log(uint size);
    function f() public returns(bytes32){
        _deque.offerFirst(bytes32(uint256(1)));
        _deque.offerLast(bytes32(uint256(2)));
        bytes32 r = _deque.peekLast();//Should be 2
        emit Log(_deque.getSize());//Should be 2
        return (r);
    }
}
```

### ***9. push 函数***

推入一个元素，就像使用栈一样。

#### 参数

- Deque：队列
- bytes32: 元素

#### 实例

```
pragma solidity >=0.4.22 <0.7.0;

import "./LibDeque.sol";

contract Test{
    
    using LibDeque for LibDeque.Deque;
    
    LibDeque.Deque private _deque;
    
    event Log(uint size);
    function f() public returns(bytes32){
        _deque.push(bytes32(uint256(1)));
        _deque.push(bytes32(uint256(2)));
        emit Log(_deque.getSize());//Should be 2
    }
}
```

### ***10. pop 函数***

弹出一个元素，就像栈一样。如果队列为空，则失败。

#### 参数

- Deque：队列

#### 返回值

- bytes32: 元素

#### 实例

```
pragma solidity >=0.4.22 <0.7.0;

import "./LibDeque.sol";

contract Test{
    
    using LibDeque for LibDeque.Deque;
    
    LibDeque.Deque private _deque;
    
    event Log(uint size);
    function f() public returns(bytes32){
        _deque.push(bytes32(uint256(1)));
        _deque.push(bytes32(uint256(2)));
        bytes32 pop = _deque.pop();//Should be 2
        emit Log(_deque.getSize());//Should be 1
        return pop;
    }
}
```


