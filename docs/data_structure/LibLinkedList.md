# LibLinkedList.sol

LibLinkedList提供了双向链表操作，包括链表更新、查询、迭代等。

## 使用方法

首先需要通过import引入LibLinkedList类库，然后通过"."进行方法调用，如下为添加元素的例子：
```
pragma solidity >=0.4.24 <0.6.11;
import "./LibLinkedList.sol";

contract Test {
    
    using LibLinkedList for LibLinkedList.LinkedList;
    
    LibLinkedList.LinkedList  self;
    
    
    function add() public{
        self.addNode(bytes32(uint(2)));
    }
}
```


## API列表

编号 | API | API描述
---|---|---
1 | *getSize(LinkedList storage self) internal view returns(uint256)* |获取链表元素数
2 | *addNode(LinkedList storage self, bytes32 data) internal* |添加元素
3 | *removeNode(LinkedList storage self, bytes32 data) internal returns(bytes32)* | 删除元素
4 | *getPrev(LinkedList storage self, bytes32 data) internal view returns(bytes32)* | 获取一个元素的前一个元素
5 | *getNext(LinkedList storage self, bytes32 data) internal view returns(bytes32)* | 获取一个元素的下一个元素
6 | *getTail(LinkedList storage self) internal view returns(bytes32)* | 获取尾部元素
7 | *getHead(LinkedList storage self) internal view returns(bytes32)* | 获取头部元素
8 | *iterate_start(LinkedList storage self) internal view returns (bytes32)* | 链表迭代初始化
9 | *can_iterate(LinkedList storage self, bytes32 data) internal view returns(bool)* | 迭代条件检查
10 | *iterate_next(LinkedList storage self, bytes32 data) internal view returns(bytes32)* | 迭代下一个元素


## API详情

### ***1. getSize 函数***

查询一个双向链表的元素数

#### 参数

- LinkedList：链表实例

#### 返回值

- uint256: 返回链表的当前元素数

#### 实例

```
uint256 size = self.getSize();
```
### ***2. addNode 函数***

addNode函数用于添加一个元素，时间复杂度O(1)

#### 参数

- LinkedList: 链表实例
- bytes32: 元素值

#### 返回值

- LinkedList: 链表实例

#### 实例

```
pragma solidity >=0.4.24 <0.6.11;
import "./LibLinkedList.sol";

contract Test {
    
    using LibLinkedList for LibLinkedList.LinkedList;
    
    LibLinkedList.LinkedList  self;
    
    event Log(uint size);
    function f() public{
        self.addNode(bytes32(uint(2)));
        uint size = self.getSize();
        emit Log(size);//Expected to be 1
    }
}
```

### ***3. removeNode 函数***

removeNode函数用于从链表中删除一个元素,时间复杂度O（1）

#### 参数

- LinkedList：链表实例
- bytes32：待删除元素

#### 返回值

- LinkedList：链表实例

#### 实例

```
pragma solidity >=0.4.24 <0.6.11;
import "./LibLinkedList.sol";

contract Test {
    
    using LibLinkedList for LibLinkedList.LinkedList;
    
    LibLinkedList.LinkedList  self;
    
    event Log(uint size);
    function f() public{
        self.addNode(bytes32(uint(2)));
        self.removeNode(bytes32(uint(2)));
        uint size = self.getSize();
        emit Log(size);//Expected to be 0
    }
}
```

### ***4. getPrev 函数***

getPrev用于取得一个元素的前一个元素。时间复杂度O（1）

#### 参数

- LinkedList：链表实例
- bytes32：当前元素值

#### 返回值

- bytes32：前一个元素值

#### 实例

```
pragma solidity >=0.4.24 <0.6.11;
import "./LibLinkedList.sol";

contract Test {
    
    using LibLinkedList for LibLinkedList.LinkedList;
    
    LibLinkedList.LinkedList  self;
    
    event Log(uint size);
    function f() public returns(bytes32){
        self.addNode(bytes32(uint(1)));
        self.addNode(bytes32(uint(2)));
        bytes32 prev = self.getPrev(bytes32(uint(2)));//Expected to be 1
        return prev;
    }
}
```

### ***5. getNext 函数***

getNext用于取得一个元素的下一个函数。时间复杂度O（1）

#### 参数

- LinkedList：链表实例
- bytes32：当前元素值

#### 返回值

- bytes32：下一个元素值

#### 实例

```
pragma solidity >=0.4.24 <0.6.11;
import "./LibLinkedList.sol";

contract Test {
    
    using LibLinkedList for LibLinkedList.LinkedList;
    
    LibLinkedList.LinkedList  self;
    
    event Log(uint size);
    function f() public returns(bytes32){
        self.addNode(bytes32(uint(1)));
        self.addNode(bytes32(uint(2)));
        bytes32 next = self.getNext(bytes32(uint(1)));//Expected to be 2
        return next;
    }
}
```

### ***6. getTail 函数***

getTail用于取得链表元素的尾部元素。时间复杂度O（1）

#### 参数

- LinkedList：链表实例

#### 返回值

- bytes32：尾部元素值

#### 实例

```
pragma solidity >=0.4.24 <0.6.11;
import "./LibLinkedList.sol";

contract Test {
    
    using LibLinkedList for LibLinkedList.LinkedList;
    
    LibLinkedList.LinkedList  self;
    
    event Log(uint size);
    function f() public returns(bytes32){
        self.addNode(bytes32(uint(1)));
        self.addNode(bytes32(uint(2)));
        bytes32 next = self.getTail();//Expected to be 2
        return next;
    }
}
```

### ***7. getHead 函数***

getHead用于取得链表元素的头部元素。时间复杂度O（1）

#### 参数

- LinkedList：链表实例

#### 返回值

- bytes32：头部元素值

#### 实例

```
pragma solidity >=0.4.24 <0.6.11;
import "./LibLinkedList.sol";

contract Test {
    
    using LibLinkedList for LibLinkedList.LinkedList;
    
    LibLinkedList.LinkedList  self;
    
    event Log(uint size);
    function f() public returns(bytes32){
        self.addNode(bytes32(uint(1)));
        self.addNode(bytes32(uint(2)));
        bytes32 next = self.getHead();//Expected to be 1
        return next;
    }
}
```

### ***8. 迭代函数***

迭代函数用于从头到尾迭代链表。

#### 实例

```
pragma solidity >=0.4.24 <0.6.11;
import "./LibLinkedList.sol";

contract Test {
    
    using LibLinkedList for LibLinkedList.LinkedList;
    
    LibLinkedList.LinkedList  self;
    
    event Log(bytes32 val);
    function f() public{
        self.addNode(bytes32(uint(1)));
        self.addNode(bytes32(uint(2)));
        self.addNode(bytes32(uint(3)));  
        bytes32 start = self.iterate_start();
        while(self.can_iterate(start)){
            emit Log(start);//Shoud be 1 ,2, 3
            start = self.iterate_next(start);
        }
    }
}
```
