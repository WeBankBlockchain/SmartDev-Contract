# LibStack.sol

LibStack提供了栈数据结构。

## 使用方法

首先需要通过import引入LibStack类库，然后通过"."进行方法调用，如下为调用LibStack方法的例子：

```

pragma solidity >=0.4.24 <0.6.11;

import "./LibStack.sol";

contract Test {
    
    using LibStack for LibStack.Stack;
    
    LibStack.Stack private stack;
    
    function f() public returns(bytes32, uint) {
        stack.push(bytes32(uint(1)));
        stack.push(bytes32(uint(2)));
        bytes32 pop = stack.pop();//Expect to be 2
        uint size = stack.getSize();//Expected to be 1
        return (pop, size);
    }
}

```


## API列表

编号 | API | API描述
---|---|---
1 | *push(Stack storage self, bytes32 data) internal* |压入一个元素
2 | *pop(Stack storage self) internal returns(bytes32)* |弹出一个元素
3 | *peek(Stack storage self) internal view returns(bytes32)* |查询栈顶元素
4 | *getSize(Stack storage self) internal view returns(uint256)* | 获取栈元素数


## API详情

### ***1. push 函数***

压入一个元素

#### 参数

- Stack：栈
- bytes32: 元素

#### 返回值


#### 实例

```
pragma solidity >=0.4.24 <0.6.11;

import "./LibStack.sol";

contract Test {
    
    using LibStack for LibStack.Stack;
    
    LibStack.Stack private stack;
    
    function f() public returns(uint ) {
        
        stack.push(bytes32(uint(2)));
        uint size = stack.getSize();//Expected to be 1
        return size;
    }
    
}
```
### ***2. pop 函数***

弹出一个元素

#### 参数

- Stack: 栈

#### 返回值

- bytes32：栈顶元素值

#### 实例

```

pragma solidity >=0.4.24 <0.6.11;

import "./LibStack.sol";

contract Test {
    
    using LibStack for LibStack.Stack;
    
    LibStack.Stack private stack;
    
    function f() public returns(bytes32, uint) {
        stack.push(bytes32(uint(1)));
        stack.push(bytes32(uint(2)));
        bytes32 pop = stack.pop();//Expect to be 2
        uint size = stack.getSize();//Expected to be 1
        return (pop, size);
    }
}

```

### ***3. peek 函数***

查询栈顶元素

#### 参数

- Stack: 栈

#### 返回值

- bytes32:栈顶元素值

#### 实例

```

pragma solidity >=0.4.24 <0.6.11;

import "./LibStack.sol";

contract Test {
    
    using LibStack for LibStack.Stack;
    
    LibStack.Stack private stack;
    
    function f() public returns(bytes32, uint) {
        stack.push(bytes32(uint(1)));
        stack.push(bytes32(uint(2)));
        bytes32 top = stack.peek();//Expect to be 2
        uint size = stack.getSize();//Expected to be 2
        return (top, size);
    }
}
```


### ***4. getSize 函数***

获取元素数

#### 参数

- Stack: 栈

#### 返回值

- uint256: 栈包含的元素数

#### 实例

```
uint256 size = stack.getSize();
```
