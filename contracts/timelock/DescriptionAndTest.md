# 时间锁合约

> 学校：广东工业大学
>
> 作者：李奇龙

---

> 简介：
>
> 时间锁合约是一段代码，它通常用于限制合约中的某些操作只能在指定时间点或时间段内执行，从而增强合约的安全性和可控性。
>
> 举个例子，假如一个黑客发现了一个合约里的漏洞，准备将其他人的一些存证转入自己的账户，但由于时间锁合约将转移存证的交易到实际执行，需要有两天的等待期。在这段时间里，项目方可以找到应对方法，避免损失。

---

## 合约功能介绍

1. 发起众筹活动时，限制资金提取只能在特定的时间点或时间段内进行。
2. 在合约升级或关键操作时，限制操作只能在特定的时间窗口内进行，以便进行必要的审查和确认。
3. 限制管理员权限的修改只能在特定时间段内进行，以减少合约被恶意攻击的风险。

## 合约主要逻辑

1. 创建合约，并设置管理员为自己
2. 时间锁的三个主要功能：
    * 创建交易，并添加到时间锁映射
    * 锁定期结束后，可以执行交易
    * 后悔了的情况下，可以取消映射队列中的交易

### 事件

* `LogQueue`:创建交易并进入时间锁映射的事件
* `LogCancel`:取消交易的事件
* `LogExecute`:执行交易的事件
* `LogChangeData`:修改交易参数的事件

---

### 常量

> 由于FISCO BCOS中，solidity的`block.timestamp`变量是**以毫秒为计**的时间戳，所以需要乘1000

* `OVERTIME = 7 days * 1000`:时间锁的超时期限，可执行时间段中交易仍未被执行则超时
* `DELAY_UNIT = 1 minutes * 1000`:锁定期的时间单位

---

### 结构体

```solidity
struct Operate{
        //目标合约地址
        address target;
        //可执行时间
        uint256 executeTime;
        //函数签名
        string signature;
        //函数的参数
        bytes data;
        //是否存在
        bool isExist;
}
```

---

### 修饰器

* `operateIsExist(bytes32 hash)`:用于判断交易是否在映射当中

```solidity
modifier operateIsExist(bytes32 hash){
        require(waitGroup[hash].isExist,"TimeLock:this operate not exist");
        _;
}
```

---

### 函数

> `Timelock`合约中共有6个函数

1. `queueTransaction()`:将交易加入到映射当中

   ```solidity
   	/*
        * @dev 将操作加入到锁定的队列
        * @param delay:操作锁定时间
        * @param target:目标合约地址
        * @param signature:执行函数的签名
        * @param data:执行函数的参数(此处需要将参数转为符合标准的ABI编码传入)
        */
       function queueTransaction(uint256 delay,address target,string memory signature,bytes memory data) public onlyOwner returns(bytes32){
           //计算操作可执行的时间
           //delay为有效期转化的时间戳增加量(分钟为单位)
           uint256 executeTime = getBlockTimestamp().add(delay.mul(DELAY_UNIT));
           
           //计算操作的唯一标识
           bytes32 hash = getHash(target,signature);
           
           //加入操作映射
           Operate memory operate = Operate(target,executeTime,signature,data,true);
           waitGroup[hash] = operate;
           
           //触发事件
           emit LogQueue(hash,target,signature,executeTime,data);
           return hash;
       }
   ```

2. `cancelTransaction()`:取消映射中的交易

   ```solidity
   	/*
        * @dev 取消队列中锁定的操作
        * @param 操作的hash
        */
       function cancelTransaction(bytes32 hash) public onlyOwner operateIsExist(hash){
           //取消时间锁锁定的操作
           delete waitGroup[hash];
           emit LogCancel(hash);
       }
   ```

3. `changeData()`:修改交易中的参数

   > 只有在锁定期时才可以修改参数

   ```solidity
   	/*
        * @dev 修改队列中操作的参数
        * @notice 若不希望操作中的参数被修改，可以删除该函数
        * @param 操作的hash
        * @param 操作的参数
        */
       function changeData(bytes32 hash,bytes memory newData) public onlyOwner operateIsExist(hash){
           require(getBlockTimestamp() < waitGroup[hash].executeTime,"TimeLock:operate has surpassed time lock,cannot change data");
           waitGroup[hash].data = newData;
           
           emit LogChangeData(hash,newData);
       }
   ```

4. `executeTransaction()`:执行映射中的交易

   > * 如果还在锁定期，则无法执行
   > * 如果交易已经超时，则无法执行

   ```solidity
   	/*
        * @dev 执行可执行的操作
        * @param 操作的hash
        * @return 返回执行操作的返回结果
        */
       function executeTransaction(bytes32 hash) public operateIsExist(hash) returns(bytes memory){
           Operate memory operate = waitGroup[hash];
           //检测是否已经可以执行该操作
           require(getBlockTimestamp() >= operate.executeTime,"TimeLock:operate hasn't surpassed time lock");
           //检测该操作能执行的时间是否已经超过期限
           require(getBlockTimestamp() <= operate.executeTime.add(OVERTIME),"TimeLock:operate is overtime");
           
           //计算callData
           bytes memory callData = abi.encodePacked(bytes4(keccak256(bytes(operate.signature))),operate.data);
           //执行操作
           (bool isSuccess,bytes memory result) = operate.target.call(callData);
           //判断操作是否成功
           require(isSuccess,"TimeLock:operate failed,data error or execution reverted");
           //触发事件
           emit LogExecute(hash,operate.data,getBlockTimestamp());
           //将操作从映射中删除
           delete waitGroup[hash];
           return result;
       }
   ```

5. `getHash()`:计算生成交易的唯一标识

   ```solidity
   	/*
        * @dev 计算操作的唯一id
        */
       function getHash(address target,string memory signature) private view returns(bytes32){
           return keccak256(abi.encode(target,signature,getBlockTimestamp()));
       }
   ```

6. `getBlockTimestamp()`:获取时间戳

   ```solidity
   	/*
        * @dev 获取时间戳
        */
       function getBlockTimestamp() internal view returns(uint){
           return block.timestamp;
       }
   ```

---

## 案例测试

测试合约如下：

```solidity
pragma solidity ^0.6.10;

/*
 * @dev 时间锁测试合约测试
 */
contract TimelockTest{
    address private timelock;
    
    struct User{
        string name;
        uint256 age;
    }
    
    mapping(uint256 => User) userMap;
    
    constructor(address _timelockAddress) public {
        timelock = _timelockAddress;
    }
    
    modifier onlyTimelock(){
        require(msg.sender == timelock,"Call must come from Timelock");
        _;
    }
    
    function addUser(uint256 id,string memory name,uint256 age) public onlyTimelock{
        User memory user = User(name,age);
        userMap[id] = user;
    }
    
    function getUser(uint256 id) public view returns(string memory,uint256){
        User memory user = userMap[id];
        return (user.name,user.age);
    }
}
```

1. 首先分别部署`Timelock`合约和`TimelockTest`合约

    * `Timelock`合约地址：`0x20781f4edc9e38468aa7bc209a2e55ab749661f1`
    * `TimelockTest`合约地址：`0x627d80f412be622a71dda738093e24fda3ecca6d`

2. **测试`queueTransaction()`方法**

   调用`Timelock`合约中的`queueTransaction()`方法

    1. 分别填入一下参数：

    * delay: `5`（在测试案例中设定了5分钟的锁定期）
    * target: `0x627d80f412be622a71dda738093e24fda3ecca6d`
    * signature: `addUser(uint256,string,uint256)`
    * data:
        * 原参数为`(1,zhangsan,18)`
        * 经过ABI编码后：`00000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000000001200000000000000000000000000000000000000000000000000000000000000087a68616e6773616e000000000000000000000000000000000000000000000000`

    2. 调用结果如下：

   ![image-20230528222407099.png](https://s2.loli.net/2023/05/29/v7ngVBKQA8cDwdG.png)

   返回的交易id为`0xa3047b770290f831953d4d1aa4fc67ec21958b69d6c25b9c60466babd5cff2d1`

3. **测试`executeTransaction()`方法**

   若提前调用`executeTransaction()`函数

   返回结果如下：

   ![image-20230528222611142.png](https://s2.loli.net/2023/05/29/DzBXgvrZ28sLRAI.png)

   报异常: 该交易仍然在锁定期

   ---

   在5分钟后调用`executeTransaction()`函数

   返回结果如下：

   ![image-20230528223007115.png](https://s2.loli.net/2023/05/29/P7lEShNoesZDjCJ.png)

   在`TimelockTest`合约中调用`getUser()`函数查看结果：输入参数为1，结果如下：

   ![image-20230528223110867.png](https://s2.loli.net/2023/05/29/oI9WtjBawxMbiND.png)

4. **测试`cancelTransaction()`方法**

   重复第一步的操作，交易参数修改为(2 , 李四 , 34)，锁定期仍为5分钟

   返回的交易id为`0xd9193d77320c3dd45df15b1f317edc3d55cb7a814f30129bc19bd2783464dc4e`

   然后调用`cancelTransaction()`方法，返回结果如下：

   ![image-20230528223819325.png](https://s2.loli.net/2023/05/29/82uTh59gC6QD1cn.png)

5. **测试`changeData()`方法**

   重复第一步的操作，交易参数修改为(3 , 王五 , 21)，锁定期仍为5分钟

   返回的交易id为`0xd09f34ec2ff435b9bea0938ea6b42278aa55ce9b6e1cd7bd2e81fd69e7bc2991`

   然后调用`changeData()`方法，输入参数为(3 , 陈六 , 59)，返回结果如下：

   ![image-20230528224456565.png](https://s2.loli.net/2023/05/29/WaRKY6ld1Qu3VNe.png)

   等待5分钟后调用`executeTransaction()`并调用`getUser()`函数，返回结果如下：

   ![image-20230528224950655.png](https://s2.loli.net/2023/05/29/xFNfQyhJH3zROoT.png)
