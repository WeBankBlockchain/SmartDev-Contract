# Solidity Assembly 内联汇编

> 学校：深职院
>
> 作者：钟胜宇

## 1. 什么是内联汇编?

内联汇编是一种在底层访问以太坊虚拟机的语言，由于编译器无法对汇编语句进行检查，所以 Solidity 提供的很多重要安全特性都没办法作用于汇编。写汇编代码相对比较困难，很多时候只有在处理一些相对复杂的问题时才需要使用它，并且开发者需要明确知道自己要做什么。

在合约的内部使用汇编，是在合约内部包含 `assembly` 关键字进行编写的，在 Solidity `inline assembly`(内联汇编) 中的语言被称为 Yul。Yul除了在 Solidity 之中作为 inline assembly 的一部分，也能当作独立的直译语言能够被编译成 bytecode 给不同的后端。

## 2. Yul语言的介绍

官网地址： https://docs.soliditylang.org/zh/latest/yul.html

上面说到内联汇编中的语言被称为Yul，可以简单的看一下官网的Yul语言的案例和语法就可以。

![image-20230528224900766](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202305282249947.webp)



## 3. 合约中内联汇编支持的指令

1. `add/sub/mul/div/mod`: 加、减、乘、除和取模运算。
2. `sdiv/smod`: 有符号整数除法和取模运算。
3. `exp`: 指数运算，计算 e 的 x 次方。
4. `and/or/xor/not`: 位运算 and、or、xor和not操作。
5. `shl/shr/sar`: 位移运算，左移、右移和算术右移操作。
6. `lt/gt/slt/sgt/eq`: 比较运算，小于、大于、有符号小于、有符号大于和等于操作。
7. `address/balance/selfdestruct`: 地址相关操作，获取当前合约地址、查询某个地址持有的以太币数量和销毁当前合约自身。
8. `extcodesize/extcodecopy`: 获取外部合约的代码大小并复制其代码到指定内存位置。
9. `mload/mstore/mstore8`: 内存读写操作，读取指定地址处的内存、将数据存入指定地址处的内存和将一个字节存入指定地址处的内存。
10. `gas`: 查询剩余的gas数量。



## 4. 内联汇编的基本格式

通过 `assembly {}` 包裹代码。并且内部每一行语句不需要使用`;`显示的标注结束。Assembly 也支持注释，可以使用 `//` 和 `/* */` 来进行注释。

let 指令执行如下任务：

- 创建一个新的堆栈槽位
- 为变量保留该槽位
- 当到达代码块结束时自动销毁该槽位

let 指令在汇编代码块中定义的变量，在代码块外部是无法访问的，内部代码块可以访问外部的代码块的内容。

```solidity
pragma solidity 0.4.25;

contract Test {
    function test() public view returns (uint256) {
        assembly {
            let x := 1
        }
        assembly {
        	// 当前的x是无法访问的
            let y := x 
        }
    }
}
```



## 5. 内联汇编合约案例基本使用

定义了一个名为 `Test` 的合约，其中包含了一个名为 `addAssembly` 的公共函数。这个函数接受两个 uint256 类型的参数 `_x` 和 `_y`，并返回一个元组 `(uint256,uint256)`。

- 这个函数使用了内联汇编 `assembly` 来计算 `_x` 和 `_y` 的和，并获取当前可用的 gas 数量。

- 定义了两个 `uint256` 类型的变量，分别为 `result` 和 `remainingGas`。然后，在 `assembly` 块中，调用了内置的 `add` 函数将 `_x` 和 `_y` 相加的结果赋值给 `result` 变量。

- 使用 `gas()` 操作获取当前可用的 gas 数量，并将其赋值给变量 `remainingGas`。

- 返回 `(result, remainingGas)` 元组来输出计算结果和剩余的 gas 数量。

```solidity
pragma solidity 0.4.25;

contract Test {
    
    function addAssembly(uint256 _x, uint256 _y) public returns (uint256,uint256) {
        uint256 result;
        uint256 remainingGas;
        assembly {
            // add(_x, _y) 是计算 x + y 的结果
            // := 是将 x + y 的结果赋值给变量 result
            result := add(_x, _y)
            
            // 查询剩余的gas
            remainingGas := gas()
        }
        return (result,remainingGas);
    }
}
```



### 5.1 第一个内联汇编案例

> #### 使用WeBASE-Front部署合约

- 将合约部署到WeBASE-Front中
- 调用addAssembly函数

> 但是有一些地址的余额这些就无法调用，需要更换成以太坊上部署solidity

![image-20230528224324862](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202305282243092.webp)

![image-20230528224431430](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202305282244520.webp)

查看交易回执：

- 30是内联汇编调用add指令相加后得到的结果
- 299978109是当前剩余的gas

![image-20230528224504398](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202305282245512.webp)







### 5.2 位运算案例

`and/or/xor/not`: 位运算 and、or、xor和not操作。

```solidity
contract BitwiseExample {
    function and(uint256 a, uint256 b) public pure returns (uint256) {
        uint256 result;
        assembly {
            result := and(a, b) // 位与操作，将 a 和 b 的二进制位分别进行与操作并返回结果
        }
        return result;
    }

    function or(uint256 a, uint256 b) public pure returns (uint256) {
        uint256 result;
        assembly {
            result := or(a, b) // 位或操作，将 a 和 b 的二进制位分别进行或操作并返回结果
        }
        return result;
    }

    function xor(uint256 a, uint256 b) public pure returns (uint256) {
        uint256 result;
        assembly {
            result := xor(a, b) // 位异或操作，将 a 和 b 的二进制位分别进行异或操作并返回结果
        }
        return result;
    }

    function not(uint256 a) public pure returns (uint256) {
        uint256 result;
        assembly {
            result := not(a) // 位非操作，将 a 的二进制位取反并返回结果
        }
        return result;
    }
}
```

在WeBASE-Front上部署BitwiseExample合约调用and函数测试。

![image-20230528231524988](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202305282315092.webp)

![image-20230528231557848](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202305282315958.webp)



### 5.3 比较运算案例

`lt/gt/slt/sgt/eq`: 比较运算，小于、大于、有符号小于、有符号大于和等于操作。

```solidity
pragma solidity ^0.4.25;

contract ComparisonExample {
    function lt(uint256 a, uint256 b) public pure returns (bool) {
        bool result;
        assembly {
            result := lt(a, b) // 比较 a 是否小于 b，若成立则返回 true，否则返回 false
        }
        return result;
    }

    function gt(uint256 a, uint256 b) public pure returns (bool) {
        bool result;
        assembly {
            result := gt(a, b) // 比较 a 是否大于 b，若成立则返回 true，否则返回 false
        }
        return result;
    }

    function eq(uint256 a, uint256 b) public pure returns (bool) {
        bool result;
        assembly {
            result := eq(a, b) // 比较 a 是否等于 b，若成立则返回 true，否则返回 false
        }
        return result;
    }
}
```

在WeBASE-Front上部署ComparisonExample合约调用eq函数测试。

![image-20230528232431517](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202305282324617.webp)

如下是交易回执：

![image-20230528232442366](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202305282324475.webp)

如上其他的内联编码的指令也是一样使用。