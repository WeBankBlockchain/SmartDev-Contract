# 批量执行合约

> 学校：广东工业大学
>
> 作者：李奇龙

---

## 合约简介

1. 可实现多个交易批量执行，以实现原子性，即要么所有交易都成功执行，要么所有交易都失败。这确保了交易的一致性和可靠性。

2. 合约可以接收不同合约的地址，不同的交易参数或者其他必要的参数。这些交易可以是同一类型的或不同类型的操作。

---

## 合约描述

### 一、合约逻辑

1. 部署合约，并且设置管理员为自己
2. 合约内部有个数组存放交易的**目标合约地址以及交易参数**
3. 主要操作有两个：
   1. 调用添加交易函数，将交易push入数组
   2. 调用执行交易函数，遍历数组并执行其中的交易，当某一个交易失败时，所有交易回滚；同时创建一个数组接收交易返回的数据，若所有交易都成功，则将数据返回出去；最后清空数组内的交易内容

---

### 二、事件

* `LogAddTransaction`:记录添加交易数据到数组的事件
* `LogExecuteTransaction`:记录执行所有交易的事件
* `NewAdmin`:设置新管理员的事件

---

### 三、结构体

```solidity
struct Transaction{
        //合约地址
        address target;
        //交易参数
        bytes _calldata;
}
```

> 该结构体用于存储单个交易的**目标合约地址**以及**交易参数**

---

### 四、状态变量与存储结构

* `address private _owner`: 管理员地址
* `Transaction[] private transactions`: 存储交易数据的数组

---

### 五、修饰器

```solidity
	/*
     * @dev 修饰的函数只有管理员能执行
     */
    modifier onlyOwner() {
        require(msg.sender == _owner, "Ownable: not authorized");
        _;
    }
```

> 限制函数的执行权限

---

### 六、函数

> 合约中一共有5个函数，主要函数有2个: `addTransaction()`和`executeTransaction()`

1. `addTransaction()`函数：将交易添加入数组中

   ```solidity
   	/*
        * @dev 向交易数组中添加交易数据
        * @param _target 判断目标合约地址
        * @param signature 判断函数签名
        * @param data 函数的参数(经过ABI编码编译后)
        */
       function addTransaction(address _target,string memory signature,bytes memory data) public onlyOwner{
           //判断目标合约地址是否有效
           require(_target != address(0),"MultiTradeExecute::addTransactionException: address is invaild");
           //计算交易参数
           bytes memory _calldata = getFuncData(signature,data);
           
           //存入交易数组
           Transaction memory transaction = Transaction(_target,_calldata);
           transactions.push(transaction);
           
           emit LogAddTransaction(_target,signature,data);
       }
   ```

2. `executeTransaction()`函数：执行数组中的所有交易

   ```solidity
       /*
        * @dev 遍历数组，执行所有的交易
        */
       function executeTransaction() public onlyOwner returns(bytes[] memory){
           //获取交易数量
           uint256 length = getTransactionAmount();
           //判断数组里是否有交易
           require(length != 0,"MultiTradeExecute::executeTransactionException: transactions is empty");
           
           //创建一个用于存放返回结果的数组
           bytes[] memory returnObjects = new bytes[](length);
           //遍历数组
           for(uint256 i = 0;i < length;i++){
               Transaction memory transaction = transactions[i];
               //调用交易
               (bool isSuccess,bytes memory result) = transaction.target.call(transaction._calldata);
               //判断交易是否成功
               if(isSuccess){
                   //执行成功,将返回数据加入返回数组
                   returnObjects[i] = result;
               } else {
                   //执行失败，需要清空数组内容，重新进行批量执行
                   delete transactions;
                   revert("MultiTradeExecute::executeTransactionException: Transaction execution reverted");
               }
           }
           //清空交易数组的内容
           delete transactions;
           
           emit LogExecuteTranscation(length);
           return returnObjects;
       }
   ```

3. `getFuncData()`函数：计算交易的参数

   ```solidity
       /*
        * @dev 计算交易的参数
        * @param signature 判断函数签名
        * @param data 函数的参数(经过ABI编码编译后)
        * @return 返回交易数据
        */
       function getFuncData(string memory signature,bytes memory data) internal pure returns(bytes memory){
           return abi.encodePacked(bytes4(keccak256(bytes(signature))),data);
       }
   ```

4. `getTransactionAmount()`函数：获取交易数组里的交易数量

   ```solidity
    	/*
        * @dev 获取交易数组里的交易数量
        */
       function getTransactionAmount() public view returns(uint256){
           return transactions.length;
       }
   ```

5. `changeAdmin()`函数：修改合约管理员

   ```solidity
   	/*
        * @dev 设置新管理员
        */
       function changeAdmin(address newAdmin) public onlyOwner{
           _owner = newAdmin;
           emit NewAdmin(newAdmin);
       }
   ```