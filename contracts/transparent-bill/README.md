# transparent-bill

透明票据区块链系统

![alt](./tmp.svg)

A<-->B之间的业务，对承兑方是透明的。
承兑方只负责承兑token

1.B添加自己的签名地址到合约

2.付款（存款）承兑商

3.将票据和对票据的签名给A

4.A拿着票据和签名去合约验证

5.验证通过就得到票据价值的token

6.将token拿到找承兑兑换法币

7.承兑商去区块链验证token有效

8.承兑法币给A

票据可以在区块链上可信流转，并保证了业务的隐私透明。


### bcos java 操作日志
```sh
[group0]: /apps> deploy Bill.sol:BillBcos -l /apps/bill/v0.3
deploy contract with link, link path: /apps/bill/v0.3
transaction hash: 0xaca64aacd31d88edeabf462c0df4bf3159b848d490911446d1a7d5d18002e724
contract address: 0x0102e8b6fc8cdf9626fddc1c3ea8c1e79b3fce94
currentAccount: 0xf2151716e97f1f7c1c1351695d0886e07d8b0ca5
link path: /apps/bill/v0.3

[group0]: /apps> call /apps/bill/v0.3 signer
---------------------------------------------------------------------------------------------
Return code: 0
description: transaction executed successfully
Return message: Success
---------------------------------------------------------------------------------------------
Return value size:1
Return types: (ADDRESS)
Return values:(0x0000000000000000000000000000000000000000)
---------------------------------------------------------------------------------------------

[group0]: /apps> call /apps/bill/v0.3 setSigner 0x96D5063BF28048321213a083F4bc2BDB89cc0E19
transaction hash: 0x96e41db47f3f4be0547f23e6c80f944e15ce8d5f0e4bd58e2e7f20ae2aa4a78f
---------------------------------------------------------------------------------------------
transaction status: 0
description: transaction executed successfully
---------------------------------------------------------------------------------------------
Receipt message: Success
Return message: Success
Return value size:0
Return types: ()
Return values:()
---------------------------------------------------------------------------------------------

[group0]: /apps> call /apps/bill/v0.3 verify 10000 0x644af107be6b352e86e1cad9d0084b32fbc0ca27dcdd12d8416641c4ae9fe3f754c
6248c7a393be43f34e18201a64a4944b3a69243f62954bf96d08dbd617e681c
---------------------------------------------------------------------------------------------
Return code: 0
description: transaction executed successfully
Return message: Success
---------------------------------------------------------------------------------------------
Return value size:1
Return types: (ADDRESS)
Return values:(0x96d5063bf28048321213a083f4bc2bdb89cc0e19)
---------------------------------------------------------------------------------------------

[group0]: /apps>
```

## 文件
- accounts 存放测试使用的bcos账户文件，pem格式
- contracts 合约文件
- test 测试脚本