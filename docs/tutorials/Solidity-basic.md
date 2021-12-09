# Solidity 

***★知识要点★***

- 合约的编译、部署、测试
- 合约的数据类型
- 状态变量
- 函数与函数修饰符
- 数组和mapping
- 自定义结构
- 事务控制



## 1. 初识Solidity

智能合约的概念最早由*尼克·萨博*在1994年提出，受当时的计算机技术发展限制，智能合约只能停留在概念阶段。2013年，以太坊创始人Vitalik Buterin受比特币脚本启发，在以太坊白皮书中提出了智能合约的实现方式。为了编写智能合约，以太坊又专门设计了一门名为Solidity的编程语言，可以说它是第一款真正意义上的智能合约编程语言。接下来，我们将会简单了解一下Solidity，包括开发环境的说明，以及智能合约版“hello world”的实践。

###  1.1 开发环境说明

为了支持智能合约的运行，以太坊提供了EVM（Ether Virtual Machine，以太坊虚拟机），使用特定的Solc编译器可以将智能合约代码编译为EVM机器码，这些机器码可以在EVM中运行。如下图所示。

![image-20211209152955771](./assets/1-evm-run.png)

上面简单的介绍了智能合约的运行过程，通过这些介绍，我们可以得出一个结论，Solidity智能合约若想运行，需要有Solc编译器和EVM，EVM依赖于区块链节点，只要是支持EVM的区块链系统都可以作为开发节点使用，例如FISCO-BCOS或Geth；至于编译器的问题，建议使用内嵌编译器的在线IDE环境，例如WeBase-Front（微众银行提供的FISCO-BCOS节点前置服务）或Remix。这两款IDE都内嵌了EOA（以太坊外部账户），方便对智能合约的执行进行签名。
两个IDE的安装地址：
[WeBase-Front安装使用教程](https://webasedoc.readthedocs.io/zh_CN/latest/docs/WeBASE-Install/developer.html)
[Remix在线IDE](http://remix.ethereum.org/)

如果单纯学习Solidity开发，可能使用Remix也就够了，因为它内部也内嵌了EVM虚拟机，可以模拟智能合约的运行。如果要学习应用开发，则启动一个节点是有必要的。为了简化操作，下面的演示代码将使用Remix作为演示环境。

### 1.2 第一个智能合约 

通过前面的开发环境介绍，我们对智能合约有了一个基本的印象。如果把区块链比作数据库的话，智能合约类似于运行在数据库上的SQL语句，因此也可以把Solidity当作一种类似于与区块链交互的编程语言。下面，正式认识一下Solidity。

Solidity 是一门面向对象的、为实现智能合约而创建的高级编程语言。这门语言受到了 C++，Python 和 Javascript 等语言的影响，设计的目的是能在以太坊虚拟机（EVM）上运行。还需要明确的是，Solidity 是静态类型语言，支持继承、库和复杂的用户定义类型等特性。

另外，在以太坊黄皮书中，也特意强调了Solidity是一门图灵完备的编程语言，图灵完备属于专业术语，简单理解就是支持循环和条件分支处理。因此，Solidity语言当中肯定可以使用循环和条件判断语句的，关于Solidity的语法特性，我们将在后面的内容展开。接下来，让我们来看看入门Solidity的智能合约。

下面的代码中，第一行的作用是为了控制智能合约编译器的版本，pragma就是Solidity的编译控制指令，`^0.6.10`代表的含义是可以使用0.6.x的版本对该代码进行编译，也就是说0.5.x或0.7.x的编译器版本不允许编译该智能合约，符号“^”代表向上兼容。也可以使用类似`pragma solidity >0.4.99 <0.6.0;`这样的写法来表达对编译器版本的限制，这样看上去也是非常的简单明了！

> 本教程中将以0.6.10作为基础版本介绍Solidity智能合约开发。

contract是一个关键字，用来定义合约名字，它很像是某些语言里的定义了一个类（class）。hello是本合约的名字，这个合约的主要功能是向区块链系统中存储一个Msg字符串。constructor是该合约的构造函数，它必须是public的（在Solc编译0.8.x版本后，constructor将不再允许声明为），当合约部署时，执行的也就是构造函数的逻辑，该构造函数的功能就是将Msg初始化为“hello”。

```solidity
pragma solidity^0.6.10;

contract hello {
    string public Msg;
    constructor() public {
        Msg = "hello world";
    }
}
```

下面，我们尝试在Remix环境部署该合约，并测试运行效果。打开[Remix在线IDE](http://remix.ethereum.org/)，我们将会看到如下的效果。

![image-20211209161648487](./assets/2-remix.png)

这其中，左侧的【![image-20211209161852143](assets/3-file-browser.png)】按钮是文件浏览器视图，【![image-20211209162029670](assets/4-solc.png)】按钮是编译器视图，【![image-20211209162117125](assets/5-run-ev.png)】按钮是运行环境视图。

接下来，我们演示部署hello合约的操作流程。首先点击【![image-20211209161852143](assets/3-file-browser.png)】按钮，打开浏览器视图，在contracts目录位置点击【右键】，在下拉表单中选择【New File】选项。

![image-20211209162852090](assets/6-hello-1.png)

在输入框内容，输入智能合约文件的名字：hello.sol，如下图所示，然后回车创建文件成功。

![image-20211209163328868](assets/6-hello-2.png)



将之前的演示代码，粘贴到hello.sol文件中，并保存代码（Windows使用【ctrl+S】按键，macOS使用【command+S】按键），如下图所示。

![image-20211209163530043](assets/6-hello-3.png)

若要切换编译器，可以点击【![image-20211209162029670](assets/4-solc.png)】按钮，在COMPLIER下面的下拉表中选择对应的编译器版本，如下图所示。

![image-20211209163759541](C:\Users\95762\AppData\Roaming\Typora\typora-user-images\image-20211209163759541.png)

也可以在EVM版本位置选择某个特定版本，如下图所示。

![image-20211209164259421](D:\gowork\src\github.com\yekai1003\SmartDev-Contract\docs\tutorials\assets\6-hello-4.png)

默认情况后，保存代码后会自动编译，代码没有语法错误的话，就可以尝试运行了。点击【![image-20211209162117125](assets/5-run-ev.png)】按钮，可以切换到运行视图。如下图所示，点击【deploy】按钮，便可以部署该合约。

![image-20211209164615881](assets/6-hello-5.png)

部署后，可以在下面的页面看到两部分信息，一个是合约对象，一个是运行信息，如下图所示。

![image-20211209164849500](assets/6-hello-6.png)

点击合约对象前的【![image-20211209165027624](assets/6-hello-7.png)】按钮，可以展开合约对象，如下图所示。之后，点击【Msg】按钮，可以看到hello world这个字符串内容。

![image-20211209165153174](C:\Users\95762\AppData\Roaming\Typora\typora-user-images\image-20211209165153174.png)

这就是智能合约部署到测试的全部流程，不要认为这仅仅是一次字符串的打印，这背后其实涉及到了复杂的区块链技术，客户端将字节码签名后发送给节点，全网共识后，节点EVM中运行该字节码，记录下这样的字符串。

## 2. 基础语法

之前，我们介绍了一个hello智能合约的部署和测试，接下来，我们着重介绍智能合约的语法。

### 2.1 数据类型

Solidity的数据类型非常丰富，下面我们通过一个表格介绍一下。

| 类型   | 描述       | 值范围                  |
| ------ | ---------- | ----------------------- |
| string | 字符串     | "fisco-bcos","abc"      |
| bool   | 布尔值     | true或false             |
| uint   | 无符号整数 | 等价于uint256，0 ~ 2^256 |



### 2.2 状态变量与临时变量

### 2.3 函数 

### 2.4 函数修饰符

### 2.5 数组

### 2.6 mapping

### 2.7 自定义结构

### 2.8 事务控制

### 2.9 自定义修饰符

### 2.10 storage与memory





