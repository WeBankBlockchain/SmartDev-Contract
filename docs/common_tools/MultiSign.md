## 说明
发起一个事务后，需多方签名后才能执行该事务。

## 使用
> 参考 MultiSignDemo.sol
- 继承该合约 `MultiSign.sol`
- `constructor` 传入 `address[]`, `uint`
  - address[]: 可以签名的地址集合。
  - uint: 最小签名个数，满足这个数量时此事务完成多签。
- 重写 `signFinishedCallBack` 方法
  - 多签完成后，会回调执行此方法。

## 接口
- showSigner(): 列出所有可以签名的地址
- showNextTransactionIdx(): 列出下一个事务ID
- showPendingTransactions(): 列出所有待签名的事务ID
- transfer(address to, bytes memory data): 添加新事务，返回事务ID
- signTransaction(uint transactionId): 给事务签名，transactionId是事务ID，返回是否完成签名
- signFinished(uint transactionId): 获取事务多签完成情况，transactionId是事务ID，返回是否完成签名
- signFinishedCallBack(Transaction storage transaction): 重写此方法，完成多签后，会回调此方法

## 示例
> 参考 MultiSignDemo.sol

1. 部署 `MultiSignDemo.sol` 传入 `可以签名的地址集合`, `最小签名个数`

2. 调用 `transfer` 添加新事务

3. 其他可以签名的地址调用 `signTransaction` 给指定事务签名

4. 多签完成回调 `signFinishedCallBack` 方法
