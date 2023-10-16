## function
- 继承该合约后能够使用其`LogFuncCall`修饰器以触发想要监听的函数调用，事件中内容包括`msg.sender, tx.origin, func, args`

## usage
- 继承该合约，然后在想要监听的函数上使用`LogFuncCall`修饰器即可，如：
```solidity
contract Test is FuncCallContract {
    function test(uint256 x)
        external
        LogFuncCall("test(uint256)")
        returns (uint256)
    {
        return x + 233;
    }
}
```

## for DApps
- 该功能可以帮助DApp的开发，如果DApp需要监听某个函数调用，可通过继承该合约实现想要的功能