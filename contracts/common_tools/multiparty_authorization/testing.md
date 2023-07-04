# 多方授权执行交易合约测试文档

> 为了方便测试，创建了以下三个账户，地址分别如下：
>
> * `0x95662d299c081ed8b68e7f5611e5bd947e807a93`
> * `0xdbca6da0afb903f560e31fd8ed0f656f5709a88c`
> * `0x4b15b21e374fb3aa02835154701ea1dd17bc46ec`

**测试合约如下：**

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.10;

contract Test{
    address private multiAuthorization;
    
    uint256[] private nums;
    
    constructor(address _multiAuthorization) public{
        multiAuthorization = _multiAuthorization;
    }
    
    modifier onlyMultiAuthorization(){
        require(msg.sender == multiAuthorization,"exception: Caller not multiAuthorizationContract");
        _;
    }
    
    function addNum(uint256 num) public onlyMultiAuthorization{
        nums.push(num);
    }
    
    function getNums() public view returns(uint256[] memory){
        return nums;
    }
}
```

## 测试如下

1. 部署`MultipartyAuthorization`合约，构造函数参数如下：

   * `owners`: `["0x95662d299c081ed8b68e7f5611e5bd947e807a93","0xdbca6da0afb903f560e31fd8ed0f656f5709a88c"]`
   * `threshold_`: `2`

   > 初始可授权地址有2个,可执行门槛数量为2

   部署成功，`MultipartyAuthorization`合约地址为**`0x1fb8cb430039143906b6333c4cf302599c824966`**

   部署测试合约，合约地址为`0x159c76f45c07c82f6179f4360ea26b2a61014ebb`

2. 调用`createTransaction()`函数

   输入参数如下：

   * _to:`0x159c76f45c07c82f6179f4360ea26b2a61014ebb`
   * signature: `"addNum(uint256)"`
   * data: 原数据为`123`，经过ABI编码后为`000000000000000000000000000000000000000000000000000000000000007b`

   调用显示结果如下：

   ![image-20230531151416964.png](https://s2.loli.net/2023/05/31/p8Gj4SoEIuZneXg.png)

   > 调用成功，返回的交易hash为**`0x06a641581a9dfdacdc769870988b8afc06fc84963c9bbb893633d34371584b1d`**

3. 此时，调用`executeTransaction()`函数

   将交易hash作为参数传入，显示结果如下：

   ![image-20230531151643655.png](https://s2.loli.net/2023/05/31/dZzhy2TRPa4YG5Q.png)

   > 显示说明调用失败，根据报错信息：由于该交易刚创建，授权人只有一个人，不满足门槛，因此执行失败

4. 调用`confirmTransaction()`函数

   传入交易hash作为参数

   1. 首先使用创建该交易的用户调用，显示结果如下：

      ![image-20230531152320655.png](https://s2.loli.net/2023/05/31/dU4Tia59KW36heq.png)

      > 说明该地址已经授权过该交易了

   2. 使用另一个可授权地址调用

      调用成功，显示结果如下：

      ![image-20230531152446014.png](https://s2.loli.net/2023/05/31/aWlc3Xjh4bIDdpt.png)

5. 此时，再次调用`executeTransaction()`函数

   调用成功，显示结果如下：

   ![image-20230531152807882.png](https://s2.loli.net/2023/05/31/q4CaQFnGNpTEmeM.png)

   此时，在测试合约调用`getNums()`函数，查看交易是否有效

   ![image-20230531152859057.png](https://s2.loli.net/2023/05/31/uVRe8TqkAa2tsjh.png)

   > 结果显示，交易有效

6. 调用`getTransaction()`函数

   传入交易hash（依旧是上面那个hash）查看结果：

   ![image-20230531153101332.png](https://s2.loli.net/2023/05/31/Ug7WGCTZRo3NpHI.png)

   > 说明交易执行后，交易已经从交易映射中清除

   ---

   此时，重复第二点的操作，返回的交易hash为`0xa3759f807960961b76fdd22bfcce42eb311c26bd9954946bfd8048bec5ee0010`

   再次测试`getTransaction()`函数，输入参数为`0xa3759f807960961b76fdd22bfcce42eb311c26bd9954946bfd8048bec5ee0010`

   显示结果如下：

   ![image-20230531153425076.png](https://s2.loli.net/2023/05/31/kQgc6tb4ujZS8LX.png)

   > 可以发现，第一个为目标合约地址，第二个为交易的calldata，第三个为已授权的人数

7. 测试`addOwner()`函数

   输入参数为`0x4b15b21e374fb3aa02835154701ea1dd17bc46ec`，显示如下：

   ![image-20230531153732217.png](https://s2.loli.net/2023/05/31/LAyj9CRn8N5Zdag.png)

   > 调用成功，返回的交易hash为`0xa93259cf848b3d7aa21129c403a8cc29daf61988b8fb6ed5d199df6484b46d09`
   >
   > *该交易被存储在交易映射中，待该交易达到授权门槛以及执行后，新的可授权地址会被加入到可授权地址名单中*

8. 测试`resetThreshold()`函数

   在第7点，为了省略，已经授权并执行了第7点中的交易，因此现在的可授权地址有3个

   调用`resetThreshold()`函数，参数为3，显示结果如下：

   ![image-20230531161749614.png](https://s2.loli.net/2023/05/31/Xb5tAR7dOcujHh1.png)

   > 调用成功，交易hash为`0xb9f975bd9d1ff91f69a56e689d4b571a0cbb6ec355d531c108a4198739c1620e`