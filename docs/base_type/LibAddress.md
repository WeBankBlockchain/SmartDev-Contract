# LibAddress.sol

LibAddress提供了address数据类型的基本操作，相关API列表如下。

## 使用方法

首先需要通过import引入LibAddresss类库，然后通过"."进行方法调用，如下为调用isEmptyAddress方法的例子：

```
pragma solidity >=0.4.24 <0.6.11;

import "./LibAddress.sol"

contract test {
    
    function f(address account) returns(bool) {
        if(!LibAddress.isEmptyAddress(account)) {
            //TODO
        }
    }
}
```


## API列表

编号 | API | API描述
---|---|---
1 | *isContract(address account) internal view returns(bool)* | 判断地址是否为合约地址
2 | *isEmptyAddress(address addr) internal pure returns(bool)* |判断地址是否为空地址
3 | *addressToBytes(address addr) internal pure returns (bytes memory)* |将address转化为bytes类型
4 | *bytesToAddress(bytes addrBytes) internal pure returns (address)* | 将bytes类型转化为地址类型
5 | *addressToString(address addr) internal pure returns(string)* | 将地址类型转化为string类型
6 | *stringToAddress(string data) internal returns(address)* | 将string类型转化为address类型

## API详情

### ***1. isContract 方法***

isContract方法用于判断一个address是否为合约地址。

#### 参数

- account：地址

#### 返回值

- bool：返回bool型，当为合约账户地址时，返回true，反之，返回false。

#### 实例

```
address myContract = 0xE0f5206BBD039e7b0592d8918820024e2a7437b9;
if(LibAddress.isContract(myContract)){
    //TODO:
}
```
### ***2. isEmptyAddress 方法***

isEmptyAddress方法用于判断一个address是否为空地址。

#### 参数

- addr：地址

#### 返回值

- bool：返回bool型，当为空地址时，返回true，反之，返回false。

#### 实例

```
    
address addr = address(0);
if(!LibAddress.isEmptyAddress(addr)){
    //TODO:
}
```
### ***3. addressToBytes 方法***

addressToBytes方法可以把一个地址类型转化为bytes类型。

#### 参数

- addr：地址

#### 返回值

- bytes：返回转化后的bytes值。

#### 实例

```
address addr = 0xE0f5206BBD039e7b0592d8918820024e2a7437b9;
bytes memory bs = LibAddress.addressToBytes(addr);
//TODO:
```

### ***4. bytesToAddress 方法***

bytesToAddress方法可以把一个bytes类型转化为address类型。

#### 参数

- bytes：字节数组。要求20字节。

#### 返回值

- address：返回转化后的address值。

#### 实例

```
bytes memory bs = new bytes(20);
address addr = LibAddress.bytesToAddress(bs);
//TODO:
```

### ***5. addressToString 方法***

addressToString方法可以把一个address类型转化为string类型。

#### 参数

- addr：地址

#### 返回值

- string：返回转化后的string值。

#### 实例

```
address addr = 0xE0f5206BBD039e7b0592d8918820024e2a7437b9;
string memory addrStr = LibAddress.addressToString(addr);
//TODO:
```

### ***6. stringToAddress 方法***

stringToAddress方法可以把一个string类型转化为address类型。

#### 参数

- string：字符串

#### 返回值

- address：返回转化后的address值。

#### 实例

```
string memory str = "0xE0f5206BBD039e7b0592d8918820024e2a7437b9";
address addr = LibAddress.stringToAddress(str);
//TODO:
```

