# 批量处理交易合约测试文档

> 学校：广东工业大学
>
> 作者：李奇龙

## 测试合约如下

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.10;
pragma experimental ABIEncoderV2;

contract BatchExecutionTest{
    struct User{
        string name;
        uint256 age;
    }
    
    mapping(uint256 => User) userMap;
    
    //存储数据，方便查看测试结果
    User[] userList;
    
    function setUser(uint256 id,string memory name,uint256 age) public {
        User memory user = User(name,age);
        userMap[id] = user;
        userList.push(user);
    }
    
    function getUser(uint256 id) public view returns(string memory,uint256){
        User memory user = userMap[id];
        return (user.name,user.age);
    }
    
    function getAllUser() public view returns(User[] memory){
        return userList;
    }
}
```

主要测试函数为`addTransaction()`函数和`executeTransaction()`函数

1. 首先部署`BatchExecute`合约和`BatchExecuteTest`合约

   * `BatchExecute`合约地址：`0xb2b2d643ca27739c8e40dc0642f08c45f987442c`
   * `BatchExecuteTest`合约地址：`0x3d72b855d2cc4b4feb454786c1da45b63f27f761`

2. **测试`addTransaction()`函数**

   调用`BatchExecute`合约中的`addTransaction()`函数，将`BatchExecuteTest`合约中的`setUser()`函数操作添加到交易数组当中，

   `addTransaction()`函数输入参数如下：

   * _target: `0x3d72b855d2cc4b4feb454786c1da45b63f27f761`
   * signature: `"setUser(uint256,string,uint256)"`
   * data: 该参数应该输入的是`setUser()`函数输入的参数经过ABI编码的数据
     * 原数据为`[1,"张三",18]`
     * 经过编码后为`0000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000006000000000000000000000000000000000000000000000000000000000000000120000000000000000000000000000000000000000000000000000000000000006e5bca0e4b8890000000000000000000000000000000000000000000000000000`

   调用结果如下：

   ![image-20230529233944054.png](https://s2.loli.net/2023/05/30/Ir5yESzZwKNl2Bi.png)

   ---

   重复以上操作，data参数改为`[2,"李四",34]`

   此时，调用`getTransactionAmount()`函数，返回结果为`2`,说明交易数组中有两个交易数据待执行

3. **测试`executeTransaction()`函数**

   直接调用`executeTransaction()`函数，返回结果如下：

   ![image-20230529234410744.png](https://s2.loli.net/2023/05/30/yNXApk4G98JgzRP.png)

   在`BatchExecutionTest`合约调用`getAllUser()`查看结果：

   ![image-20230529234816696.png](https://s2.loli.net/2023/05/30/3vzXHti46uD2jAC.png)

4. **测试批量交易失败的情况**

   重复第2点的操作，data参数分别为：

   * `[3,"王五",65]`
   * `[4,"陈六",47]`

   为了让交易失败，第二次执行`addTransaction()`函数时，signature参数为`setUser(uint256,string)`

   ---

   操作完`addTransaction()`函数后，调用`executeTransaction()`函数，返回结果如下：

   ![image-20230529235926788.png](https://s2.loli.net/2023/05/30/Kg4Fw2truzioUjG.png)

   > 返回的message说明批量交易中有交易执行失败了

   此时，在`BatchExecutionTest`合约调用`getAllUser()`查看结果：

   ![image-20230530000459731.png](https://s2.loli.net/2023/05/30/plMyUQ1sYetCmZT.png)

   > 结果显示，第一个交易虽然执行成功，但第二个交易执行失败，导致回滚，因此`[3,"王五",65]`的数据并没有添加进入数组中
   >
   > ***保证了批量执行交易的原子性***

