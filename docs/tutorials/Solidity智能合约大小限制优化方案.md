# Solidity智能合约大小限制优化方案

> 作者：深圳职业技术大学 陈俊杰
>
> 开源导师：张宇豪

## 1、什么是合约大小限制？

通过该链接可以查看到https://eips.ethereum.org/EIPS/eip-170，EIP-170推出了合约代码大小限制。

智能合约的大小限制在 24.576 kb。 对于作为 Solidity 开发者的您来说，这意味着当您向合约中添加越来越多的功能时，在某个时候您会达到极限，并且在部署时会看到错误：

> 警告：合约代码大小超过 24576 字节（Spurious Dragon 分叉中引入的限制）。 该合约可能无法在主网上部署。 请考虑启用优化器（其“运行”值较低！），关闭 revert 字符串，或使用库。

引入这一限制是为了防止拒绝服务 (DOS) 攻击。 任何对合约的调用从矿工费上来说都是相对便宜的。 然而，根据被调用合约代码的大小（从磁盘读取代码、预处理代码、将数据添加到 Merkle 证明），合约调用对以太坊节点的影响会不成比例地增加。 每当您出现这样的情况，攻击者只需要很少的资源就能给别人造成大量的工作，您就有可能遭受 DOS 攻击。



如下是超过了24576bytes大小的智能合约，无法进行部署，会提示如下内容：

![image-20230830220946005](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202308302209132.png)



## 2、较好的优化方案

### 2.1、合约拆分

"合约拆分"是一种常见的设计模式，也被称为拆分式智能合约设计模式。这种模式将一个复杂的智能合约分解为多个较小且独立的合约，每个合约负责处理不同的功能或逻辑，以提高代码的可读性、可维护性和安全性。

合约拆分的设计模式有助于降低单个合约的复杂度，并提供更好的模块化和代码重用性。通过将不同的功能逻辑放置在不同的合约中，开发人员可以更清晰地组织和管理合约代码。例如，可以将数据管理逻辑与业务逻辑分开，将权限控制逻辑与交易执行逻辑分开等等。

> 拆分合约我们需要考虑如下问题：
>
> - 哪些函数属于同一类？ 每一组函数最好能在自己的合约中。
> - 哪些函数不需要读取合约状态或仅需要读取状态的特定子集？
> - 合约的存储和功能是否可以分开？

一个存储和功能的超出大小的伪Solidity代码如下：

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract overflow {
	// 存储变量
	uint256 public UserID = 1;		
    uint256 public ProductID = 1;
    
    uint256[] public UserIDList;
    uint256[] public ProductIDList;
    
    event UserRegistered(address userAddress,uint256 _registerTime);
  
  	......
  	
  	// 功能函数
    function register(address _userAddress,string memory _userName) public{
    	......
    }
    function login(address _userAddress,string memory _userName) public{
    	......
    }
    
    ......
}
```

假如上面的代码已经超出了 24576 字节，我们可以使用如下方式进行优化：

> 注意：这样拆分之后，我们的主合约就变成了B合约

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract A {
	// 存储变量
	uint256 public UserID = 1;		
    uint256 public ProductID = 1;
    
    uint256[] public UserIDList;
    uint256[] public ProductIDList;
    
    event UserRegistered(address userAddress,uint256 _registerTime);
  
  	......
}


// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "./A.sol";
contract B is A{
  	// 功能函数
    function register(address _userAddress,string memory _userName) public{
    	......
    }
    function login(address _userAddress,string memory _userName) public{
    	......
    }
    ......
}
```



### 2.2、使用库

将功能代码移出存储空间的一个简单方法是使用库。 不要将库函数声明为内部函数，因为这些函数将在编译过程中直接被添加到合约中。 但是，如果您使用公共函数，那么这些函数事实上将在一个单独的库合约中。 可以考虑使用命令 `using for`，使库的使用更加方便。

```solidity
import "./LibString.sol";
contract Delivery{
	// 使用LibString库合约
    using LibString for *;
   
}
```



### 2.3、移除函数

在智能合约种，即函数在一定程度上会增加合约的大小。

- **外部函数**：为了方便起见，我们常常添加大量视图函数。 这完全没有问题，直到您遇到大小限制。 然后，您可能需要真正考虑，移除绝对必要以外的所有内容。
- **内部函数**：您也可以移除内部/ 私有函数，只要函数只被调用一次，就可以简单地内联代码。

> > > > 注意： 避免一个合约中太多的函数调用。





### 2.4、避免额外的变量

主要通过简化代码逻辑和删除冗余步骤来缩小合约的大小。优化后的代码具有更高的可读性和更高效的执行效果。

1. 删除了冗余代码：原代码中，将用户信息存储到了临时变量 `user` 中，然后再将临时变量中的数据赋值给 `username` 和 `userAddress`。优化后的代码直接从 `userMap` 中获取用户信息并返回，省去了临时变量的使用。
2. 缩小了合约的大小：通过删除冗余代码和简化逻辑，优化后的代码减少了不必要的内存使用和指令执行，从而减小了合约的大小。

```solidity
// 这是一个简单的根据用户的ID查询用户的信息
function get(uint userId) returns (string memory,address) {
    User memory user = userMap[userId];
    string username = user.name;
    string userAddress = user.userAddress;
    return (username, userAddress);
}
```

我们可以修改成如下：

```solidity
function get(uint userId) returns (string memory,address) {
    return (userMap[userId].name, userMap[userId].userAddress);
}
```



### 2.5 、缩短错误信息

我们在使用require的时候，去判断一个条件是否成立，并对不成立的条件抛出异常信息，我们可以将错误信息尽量缩短。

> 注意： 尽量少使用中文的信息

```solidity
require(msg.sender == owner, "Only the owner of this contract can call this function");
```

优化如下：

```solidity
require(msg.sender == owner, "Only owner can call");
```



### 2.6、避免将结构体传递给函数

不将结构体传递给函数,而是直接传递所需参数,又节省了 0.1kb。

1. 减少了中间变量：原代码中，在 `get` 函数中定义了一个临时变量 `user` 并将其赋值为 `userMap[userId]`，然后将临时变量传递给 `_get` 函数进行处理。优化后的代码直接在 `get` 函数中获取 `userMap[userId]` 的对应属性值，并将其作为参数传递给 `_get` 函数。
2. 使用 `memory` 修饰符：优化后的代码在函数声明和返回值类型中使用了 `memory` 修饰符，以明确指定字符串类型的数据存储在内存中，而不是存储在存储器中。这样可以减少合约的存储开销，并提高执行效率。
3. 引入私有 `_get` 函数：优化后的代码引入了一个私有 `_get` 函数，用于封装具体的逻辑，并将之前合约中的复杂性分解为两个更简单的函数。这样可以提高代码的可读性和可维护性。

```solidity
// 通过User结构体去传值
function get(uint userId) returns (string memory,address) {
	User memory user = userMap[userId];
    return _get(user);
}

function _get(User memory user) private view returns(string memory,address) {
    return (user.name, user.userAddress);
}
```

优化之后代码如下：

```solidity
function get(uint userId) returns (string memory,address) {
    return _get(userMap[userId].name,userMap[userId].userAddress);
}

function _get(string memory _name,address _address) private view returns(string memory,address) {
    return (_name,_address);
}
```



### 2.7、声明函数和变量的正确可见性

1. 函数可见性：合约中的函数可见性包括 `public`、`external`、`internal` 和 `private` 四种。默认情况下，函数的可见性是 `public`，这意味着函数可以被任何人调用。但是，如果将函数标记为 `external`，则函数只能从合约之外进行调用，这可以减少合约的大小。对于仅在合约内部使用的辅助函数，将其可见性设置为 `private` 或 `internal` 可以限制函数的访问范围，减少合约体积。
2. 变量可见性：合约中的变量可见性可以是 `public`、`internal` 或 `private`。将变量声明为 `public` 会自动生成一个 getter 函数，使得其他合约或外部调用者可以直接读取变量值。然而，生成的 getter 函数会增加合约的大小。如果不需要公开访问变量，可以将变量的可见性设置为 `internal` 或 `private`，以避免生成额外的 getter 函数。
3. 函数参数和返回值的可见性：在函数定义中，如果参数或返回值的类型是复杂结构（如结构体或数组），则需要考虑它们的可见性。将参数和返回值声明为 `memory` 或 `calldata` 类型，可以确保它们在函数调用期间只存在于内存或外部调用数据区，而不会占用合约的存储空间。
4. 优化代码结构：合理组织合约中的函数和变量，将相关功能放在一起，并将不需要公开访问的辅助函数设置为 `private`。这样做可以提高代码的可读性，同时减少合约的大小。

> 总结： 
>
> - 函数或变量仅从外部调用？ 那么，将他们声明为 `external` 而不是 `public`。
> - 函数或变量仅从合约内调用？ 那么，将它们声明为 `private` 或 `internal` 而不是 `public`。



### 2.8、移除修改器

下面的代码中使用了修饰器（modifier）来添加对函数的前置条件进行检查。修饰器是一种可重用的代码块，可以在函数执行之前或之后附加额外的逻辑。然而，这个代码结构对合约的大小可能产生重大影响，以下是详细说明：

1. 修饰器复制逻辑：修饰器本质上是一个函数，但它会在被修饰函数执行之前被调用。在上面的示例中，`checkStuff` 是一个修饰器函数。当我们在 `doSomething` 函数上附加 `checkStuff` 修饰器时，实际上会将修饰器中的逻辑复制到 `doSomething` 函数中。这会增加合约的大小，因为在每个使用了修饰器的函数中都会包含修饰器的逻辑。
2. 修饰器复制带来的重复代码：当多个函数使用相同的修饰器时，修饰器中的逻辑会被复制到每个函数中。这导致了大量的代码重复，增加了合约的大小。如果修饰器中的逻辑发生变化，需要同时修改所有使用该修饰器的函数。
3. 函数调用开销：使用修饰器会引入额外的函数调用开销。在调用被修饰函数之前，需要先调用修饰器函数。这会导致函数调用堆栈的增加，可能降低合约的执行效率。

> 为了减小合约的大小，可以考虑以下优化措施：
>
> 1. 将修饰器中的逻辑直接内联到每个使用它的函数中，而不是复制修饰器的逻辑。这样可以避免重复代码和增加合约大小。尽管可能会导致代码冗余，但对于合约规模较小的情况，这种方式对可读性和维护性的影响可以忽略不计。
> 2. 如果多个函数共享相同的前置条件检查逻辑，可以将这些逻辑提取到一个独立的函数中，并在每个函数内部调用该函数。这样可以避免修饰器带来的额外复制和重复代码，并且仍然可以实现代码的可读性和可维护性。

```solidity
modifier checkStuff() {}

function doSomething() checkStuff {}
```

修改如下：

```solidity
function checkStuff() private {}

function doSomething() { checkStuff(); }
```



## 3、减少Gas消耗的方案

1. 避免重复计算：在合约中，如果某个计算结果在多个地方都会被使用到，可以考虑将其计算结果存储在变量中，以避免重复计算。这样可以减少计算的次数，从而减少 gas 消耗。
2. 减少存储操作：存储操作（写入合约状态）通常比计算操作更耗费 gas。尽量避免频繁的状态改变，可以将一些不经常需要修改的数据存储在局部变量中而非状态变量中。另外，考虑使用 mapping 替代数组来存储大量数据，因为 mapping 在访问和更新时的 gas 消耗相对较低。
3. 优化循环结构：循环是消耗 gas 的重要因素之一。要减少循环的 gas 消耗，可以考虑以下几点：
   - 尽量避免在循环内部进行状态改变操作，这样可以减少状态改变的次数。
   - 尽量减小循环的迭代次数，例如通过使用更高效的算法或数据结构。
   - 考虑使用 `view` 或 `pure` 关键字标记那些不会修改状态的函数，这样可以避免在循环体内对这些函数进行多次调用。

1. 使用 calldata 替代 memory：在函数参数和返回值传递时，可以考虑使用 `calldata` 关键字来声明参数和返回值。`calldata` 数据区域比 `memory` 更省 gas，因为它不需要复制数据到内存中。
2. 数据压缩和优化：对于合约中的一些大型数据结构或字符串，可以考虑采用数据压缩或优化技术，以减少存储空间和 gas 消耗。
3. 避免不必要的外部调用和交互：外部调用和交互通常会消耗较多的 gas。确保只在必要的情况下进行外部调用，并通过合约间的本地调用来减少 gas 消耗。
4. 使用合适的数据类型和算法：合约中的数据类型选择和算法实现可以显著影响 gas 消耗。选择适当的数据类型和算法，避免不必要的转换和计算操作。
5. 使用视图函数：对于不需要修改状态的函数，应该使用 `view` 或 `pure` 关键字进行标记。这样的函数不会消耗任何 gas，因为它们不会对状态进行修改。
6. 避免循环过程中的 require 和 revert：在循环过程中避免使用 `require` 和 `revert`，因为这些操作会消耗较多的 gas。可以在循环结束后进行一次检查和处理。



> 总结：如上的内容都很明确的说明了，如何减少合约文件的大小，以及减少gas消耗，希望读者可以写出更好的合约。