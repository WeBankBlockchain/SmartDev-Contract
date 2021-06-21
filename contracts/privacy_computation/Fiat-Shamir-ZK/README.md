# Fiat-Shamir 零知识证明协议

## 场景介绍
一般用户在网站注册账号的时候，网站会要求用户设置一个密码，然后在后台保存这个密码，用户登录网站的时候要求再输入这个密码，与后台保存的密码进行比较，确定是否给用户登录权限，但这种时候用户的密码容易受到字典攻击，有一些安全意识的网站会加盐保存密码的hash，增加敌手穷举用户密码或撞库的难度。但用户密码保存在网站后台服务器上始终增加了泄露的风险，Fiat-Shamir零知识证明协议可以允许用户向注册的网站证明自己知道自己的密码，而不向网站泄露任何关于密码的信息。  

## Fiat-Shamir with secret password
首先Peggy（证明者，Prover）与Victor（验证者，Verifier）就公开参数（一个素数n,一个模n群的生成元g）达成共识。  
1. Peggy首先选择她的密码，然后对密码进行哈希，把结果转成整型数值x。
```
x=int(Hash(passowrd))
y=g^x mod n
```
Peggy 把y的值发给 Victor，让他保存  

2. 现在Peggy想要登录，她选择一个随机数v，计算
```
t = g^v mod n
```
然后把t的值发给Victor   

3.  Victor收到t，然后发送随机数c给Peggy  

4.  Peggy生成随机数v，计算
```
r =v -cx mod (n-1) 
```
Peggy把r发送给Victor  

5.  Victor计算
```
val=(g^r)(y^c) mod n
```
然后判断val与t是否相等，若相等，则Peggy证明了自己知道密码，然后允许Peggy登录。

## 使用  
1. 在链下使用contract_step1.py 计算 y值，然后在FiatShamir.sol中调用Step1_register 将y值登记。
2. 在链下使用contract_step2.py 计算 t值, 然后在FiatShamir.sol中调用Step2_login 传递t值。
3. 在FiatShamir.sol中调用Step3_randomchallenge 生成c值。
4. 查看c值并使用contract_step45.py 计算r值。
5. 在FiatShamir.sol中调用Step45_verify ，输入r值，输出true 或 false，表示验证通过与否。

fiat_shamir_1.py 为整个交互过程的参考代码 

## 示例
首先部署合约
```
[group:1]> deploy FiatShamir
transaction hash: 0xc45b3db5a918f5429b229483cf03c2f83d11ff9a2d1b2b8cdba2f2602f787abb
contract address: 0x6cf6561542325f82c4858bebb39c1ac6d6447737
currentAccount: 0x795bb191fc91a56ca428dd11bcaeec2fb07b5ea0
```

1. 使用contract_step1.py 计算 y值
```
bob@bob-vm:~/code/Fiat-Shamir-ZK$ python3 contract_step1.py
Password:		 Hello
Password hash(x):	 5060 	 (last 8 bits)

======Phase 1: Peggy sends y to Victor,Victor store y as Peggy' token==================
y= g^x mod P=		 2889
```
在FiatShamir.sol中调用Step1_register 将y值登记。  
```
[group:1]> call FiatShamir 0x6cf6561542325f82c4858bebb39c1ac6d6447737 Step1_register 2889
transaction hash: 0x92a78ab957a0274a0105275cf37937a76a0a53830b18eb68afa802af409c1736
---------------------------------------------------------------------------------------------
transaction status: 0x0
description: transaction executed successfully
---------------------------------------------------------------------------------------------
Receipt message: Success
Return message: Success
Return values:[]
---------------------------------------------------------------------------------------------
Event logs
Event: {}
```
2. 使用contract_step2.py 计算 t值
```
bob@bob-vm:~/code/Fiat-Shamir-ZK$ python3 contract_step2.py

======Phase 2: Peggy wants to login , She send t to Victor==================
v= 7878 	(Peggy's random value)
t=g**v % n =		 8220
```
在FiatShamir.sol中调用Step2_login 传递t值
```
[group:1]> call FiatShamir 0x6cf6561542325f82c4858bebb39c1ac6d6447737 Step2_login 8220
transaction hash: 0x7d1d489b61ce0243be09e551f8881b184f3e3e56dc91b7aac92e9d9a8a7b482b
---------------------------------------------------------------------------------------------
transaction status: 0x0
description: transaction executed successfully
---------------------------------------------------------------------------------------------
Receipt message: Success
Return message: Success
Return values:[]
---------------------------------------------------------------------------------------------
Event logs
Event: {}
```

3. 在FiatShamir.sol中调用Step3_randomchallenge 生成c值。
```
[group:1]> call FiatShamir 0x6cf6561542325f82c4858bebb39c1ac6d6447737 Step3_randomchallenge
transaction hash: 0x663469ac6e761f86b4a001906b399601f4ac315869d9fc4a0be98e3c580f5f68
---------------------------------------------------------------------------------------------
transaction status: 0x0
description: transaction executed successfully
---------------------------------------------------------------------------------------------
Receipt message: Success
Return message: Success
Return value size:1
Return types: (UINT)
Return values:(5457)
---------------------------------------------------------------------------------------------
Event logs
Event: {}
```
4. 查看c值并使用contract_step45.py 计算r值。
```
bob@bob-vm:~/code/Fiat-Shamir-ZK$ python3 contract_step45.py

======Phase 4: Peggy recieves c and calculate r=v-cx, sends r to Victor==================
c= 5457
v= 7878
r=v-cx =		 2310
```
5. 在FiatShamir.sol中调用Step45_verify ，输入r值，输出true 或 false，表示验证通过与否。
```
[group:1]> call FiatShamir 0x6cf6561542325f82c4858bebb39c1ac6d6447737 Step45_verify 2310
transaction hash: 0xd8e408bf68fd5555ff894858928d1486aab31762fe17535057c755ef1a644751
---------------------------------------------------------------------------------------------
transaction status: 0x0
description: transaction executed successfully
---------------------------------------------------------------------------------------------
Receipt message: Success
Return message: Success
Return value size:1
Return types: (BOOL)
Return values:(true)
---------------------------------------------------------------------------------------------
Event logs
Event: {}
```

## 参考文献
[1] Fiat, Amos, and Adi Shamir. "How to prove yourself: Practical solutions to identification and signature problems." Conference on the Theory and Application of Cryptographic Techniques. Springer, Berlin, Heidelberg, 1986.