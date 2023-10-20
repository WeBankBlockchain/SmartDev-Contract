# 基于DGHV的同态加密
基本概念、学习笔记、参考内容：

> 概念、个人笔记：
>
> 1. [同态加密的原理详解与go实践](https://blog.csdn.net/weixin_43988498/article/details/118802616)
> 2. [DGHV:整数上的同态加密(1)-算法构建](https://blog.csdn.net/weixin_43988498/article/details/119459857)
> 3. [DGHV:整数上的同态加密(2)-解决噪声与构建全同态蓝图](https://blog.csdn.net/weixin_43988498/article/details/119570507)
>
> 参考：
>
> 1. 论文：[《一种基于智能合约的全同态加密方法》](https://kns.cnki.net/kcms/detail/detail.aspx?dbcode=CJFD&dbname=CJFDLAST2020&filename=AQJS202009005&v=kzaijASy61Kjw7dUtnNnML6O%25mmd2Bv886ZZ4Mq9RnlqNape%25mmd2BABO%25mmd2Bfioot2MYlYfxTEcj)
> 2. [1] M. Dijk, C. Gentry, S. Halevi, and V.Vaikuntanathan. Fully homomorphic encryption over the integers[J]. Applications of Cryptographic Techniques: Springer, Berlin, 2010, 24-43.
> 3. http://blog.sciencenet.cn/blog-411071-617182.html

> <font color='#e54d42'>**同态加密等计算量大的算法不适合在合约中计算，合约仅作为测试**</font>

# 基本设计

## 1. 随机数

我们所说的随机函数都是伪随机函数即PRF

随机函数的一般构成是：`随机种子 +  随机数生成算法`

目前有很多优秀的伪随机算法已经实现，但是在区块链智能合约上的最大困难是**区块链的封闭性**

可以将区块链看作一个封闭式的信息世界，所以不像一般网络中有丰富的熵增源.

Solidity通常采用keccak256哈希函数 作为随机数的生成器，该函数有一定的随机数性质，但是随机数生成的过程容易被攻击。

传统的随机数生成过程需要本结点的 Nonce值作为随机数种子，恶意节点会大量计算Nonce的值，直到随机事件的结果对自己有利，所以项目采用区块时间戳作为随机种子。

使用线性求余法生成随机数，再采用keccak256 Hash函数将区块时间戳与随机数合并取最终的随机数

生成公式如下：

![HUTVJl](http://xwjpics.gumptlu.work/qinniu_uPic/HUTVJl.png)

## 2. 整数上的全同态加密

![iPUQRe](http://xwjpics.gumptlu.work/qinniu_uPic/iPUQRe.png)

# 功能测试

合约实现了输入为单Bit（即m ∈ {0, 1}）的**加法同态加密**（使用对称秘钥)

### step_1 选择参数

编译、运行`syn_DGHV.go`

对于参数η，加法同态始终满足，但是乘法同态满足有要求（因为算法噪音）：

* 经测试η>=9时，乘法同态满足（小于9时不稳定，可见评估结果输出）
* 智能合约中3<=η<=5, 因为η过大会导致参数q过大无法部署合约（solidity最大为int256，没有大数操作）

```shell
go run syn_DGHV.go 5		# 参数1：η （建议>=9, 合约中<=5）
```

运行结果中包含：

* 生成的秘钥`p`
* 参数`q`

输出示例（输出包含了多组测试，选择一组参数即可）：

```shell
==============================================
p =  31
q = 42535295865117307932921825928971026418
m0 = 0, m1 = 1
解密结果：n0 = 0, n1 = 1
加法测试：0 + 1 , true
加法测试：0 + 0 , true
加法测试：1 + 1 , true
加法测试：1 + 0 , true
==============================================
乘法测试：0 * 1 , true
乘法测试：0 * 0 , true
乘法测试：1 * 1 , true
乘法测试：1 * 0 , true
==============================================
```

### step_2 部署合约，输入参数

#### 以控制台为例
```
[group:1]> deploy DGHV_Homomorphic_Encryption
deploy contract failed for  cannot encode in encodeMethodFromObject with appropriate interface ABI, cause:Arguments mismatch: arguments size, expected: 3, actual: 0

[group:1]> deploy DGHV_Homomorphic_Encryption 5 42535295865117307932921825928971026418 31
transaction hash: 0xbde9ee1278af7cf59f49fc3dda084852a3d0cf922d40c337b0b72daa063d2afc
contract address: 0x6c0ca924fb69c4bbef81d710c1b2769dc568035b
currentAccount: 0x22fec9d7e121960e7972402789868962238d8037

[group:1]> call DGHV_Homomorphic_Encryption 0x6c0ca924fb69c4bbef81d710c1b2769dc568035b encrypto 1
---------------------------------------------------------------------------------------------
Return code: 0
description: transaction executed successfully
Return message: Success
---------------------------------------------------------------------------------------------
Return value size:1
Return types: (UINT)
Return values:(1318594171818636545920576603798101818965)
---------------------------------------------------------------------------------------------

[group:1]> call DGHV_Homomorphic_Encryption 0x6c0ca924fb69c4bbef81d710c1b2769dc568035b encrypto 0
---------------------------------------------------------------------------------------------
Return code: 0
description: transaction executed successfully
Return message: Success
---------------------------------------------------------------------------------------------
Return value size:1
Return types: (UINT)
Return values:(1318594171818636545920576603798101818964)
---------------------------------------------------------------------------------------------

[group:1]> call DGHV_Homomorphic_Encryption 0x6c0ca924fb69c4bbef81d710c1b2769dc568035b decrypto 131859417181863654592057
6603798101818965
---------------------------------------------------------------------------------------------
Return code: 0
description: transaction executed successfully
Return message: Success
---------------------------------------------------------------------------------------------
Return value size:1
Return types: (UINT)
Return values:(1)
---------------------------------------------------------------------------------------------

[group:1]> call DGHV_Homomorphic_Encryption 0x6c0ca924fb69c4bbef81d710c1b2769dc568035b decrypto 131859417181863654592057
6603798101818964
---------------------------------------------------------------------------------------------
Return code: 0
description: transaction executed successfully
Return message: Success
---------------------------------------------------------------------------------------------
Return value size:1
Return types: (UINT)
Return values:(0)
---------------------------------------------------------------------------------------------

[group:1]> call DGHV_Homomorphic_Encryption 0x6c0ca924fb69c4bbef81d710c1b2769dc568035b HE_Add 13185941718186365459205766
03798101818965 1318594171818636545920576603798101818964
---------------------------------------------------------------------------------------------
Return code: 0
description: transaction executed successfully
Return message: Success
---------------------------------------------------------------------------------------------
Return value size:1
Return types: (UINT)
Return values:(1)
---------------------------------------------------------------------------------------------
```


#### 以remix IDE为例

输出初始化参数：

<img src="http://xwjpics.gumptlu.work/qinniu_uPic/MwFMIc.png" alt="MwFMIc" style="zoom:67%;" />

### Step_3 测试

<img src="http://xwjpics.gumptlu.work/qinniu_uPic/image-20210812230115286.png" alt="image-20210812230115286" style="zoom:67%;" />

1的密文为：1318594171818636545920576603798101818973

<img src="http://xwjpics.gumptlu.work/qinniu_uPic/KBUSK7.png" alt="KBUSK7" style="zoom:67%;" />

0的密文为：1318594171818636545920576603798101818962

#### 同态加法

1+0 = 1

<img src="http://xwjpics.gumptlu.work/qinniu_uPic/ns3yge.png" alt="ns3yge" style="zoom:67%;" />

1+1 = 0

<img src="http://xwjpics.gumptlu.work/qinniu_uPic/Zf6t09.png" alt="Zf6t09" style="zoom:67%;" />

0+0 = 0

<img src="http://xwjpics.gumptlu.work/qinniu_uPic/hJzStL.png" alt="hJzStL" style="zoom:67%;" />

# 拓展与改进

1. 在合约中实现字符串**大数的基本计算**就可以实现合约上的同态乘法（或许有更好的办法）

2. 虽然输入只支持1bit，但是可以通过组合电路实现高阶的计算：

   * 同态加法 等价于 逻辑异或
   * 同态乘法 等价于 逻辑与
   * 逻辑与与逻辑异或具有完备性，可以实现组合电路任意高阶计算

   （图片来自论文）

   <img src="http://xwjpics.gumptlu.work/qinniu_uPic/image-20210812230914554.png" alt="image-20210812230914554" style="zoom: 50%;" />

3. 设计电路时注意使用Bootstappable算法减少噪声，不然会时效

