# 代理执行
代理执行即代理模式的实现，主要分成三个部分
- 接口合约   
定义了可以被外部调用的方法
- 实现合约  
方法的具体内容实现
- 代理合约  
通过接口合约对实现合约的调用，并在调用前后加入一些额外的逻辑

下面以一个唱歌方法的代理调用来描述一下执行的流程
## 接口合约  
定义了一个singing 方法,入参是singer歌手  
```function singing(address singer) external;```  

## 实现合约  
实现合约实现了接口合约中的singsing方法，以记录一个日志事件来代表方法中所做的内容
```javascript
 function singing(address _singer) public override{
        emit SingLog(_singer, now);
    }
```

## 代理合约
代理合约首先在构造方法中传入被代理合约的实例，通过接口合约进行实例化和方法调用。
在代理合约中可以在具体方法执行前后进行其他的操作，这里也以两个事件代表，并且通过代理合约，对外暴露的方法名以及具体合约方法的入参，都可以起到一定的修饰作用。   
在此例中，外部看到的代理方法名是``` function proxySing() public ```,而且参数也在代理合约内部进行了处理，调用者不再传此参数。  
在某些情况下如果我们在调用一个方法前必须要做某些准备操作，又或者再调用后要做某些善后工作，都可以使用这种代理的模式。


## 测试合约
在控制台中，可以测试本代理合约。
### 创建Sing合约的实例。

```
[group:1]> deploy Sing
transaction hash: 0xa956af77a8bccbf3957e8f0f7b13e284684dc096baf2f63e88d99d9df46ee760
contract address: 0x75adfb58594242bda453f302eb695280cf856c72
currentAccount: 0x22fec9d7e121960e7972402789868962238d8037
```

### 部署代理合约
```
[group:1]> deploy SingProxy 0x75adfb58594242bda453f302eb695280cf856c72
transaction hash: 0xad6fb8b6568e3b575d5c4c4e96b0bf096c6fc5524330eaef6ba7f58dc4240436
contract address: 0x8df5416339b0b55832dabfdf44cecdd81299102c
currentAccount: 0x22fec9d7e121960e7972402789868962238d8037
```

### 调用代理合约
```
[group:1]> call SingProxy  0x8df5416339b0b55832dabfdf44cecdd81299102c proxySing
transaction hash: 0x25ecc3d8584c7e8ac8d169848a4e71a8afce7051d3aacda6b39528f58be16771
---------------------------------------------------------------------------------------------
transaction status: 0x0
description: transaction executed successfully
---------------------------------------------------------------------------------------------
Receipt message: Success
Return message: Success
Return values:[]
---------------------------------------------------------------------------------------------
Event logs
Event: {"ProxyLog":[["0x22fec9d7e121960e7972402789868962238d8037","before proxy do someting"],["0x22fec9d7e121960e7972402789868962238d8037","after proxy do someting"]]}
```

