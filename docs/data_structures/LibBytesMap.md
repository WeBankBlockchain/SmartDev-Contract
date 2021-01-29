# LibBytesMap.sol

LibBytesMap提供了基于bytes的可迭代、可查询的映射.

## 使用方法

首先需要通过import引入LibBytesMap类库，然后通过"."进行方法调用，如下为调用例子：

```
pragma solidity ^0.6.10;

import "./LibBytesMap.sol";

contract Test {
    
    using LibBytesMap for LibBytesMap.Map;
    
    LibBytesMap.Map private map;
    
    
    function f(string key, string value) public {

        map.put(bytes(key),bytes(value));
        
        
    }
```


## API列表

编号 | API | API描述
---|---|---
1 | *put(Map storage map, bytes key, bytes value) internal* | 存放键值对
2 | *getValue(Map storage map, bytes key) internal view returns(bytes)* |根据key获取value
3 | *getKey(Map storage map, uint256 index) internal view returns(bytes)* |根据游标查询key
4 | *iterate_start(Map storage self) internal pure returns (uint256)* | 枚举key的游标
5 | *can_iterate(Map storage self, uint256 idx) internal view returns(bool)* | 游标是否可用
6 | *iterate_next(Map storage self, uint256 idx) internal pure returns(uint256)* | 下一个游标值
7 | *size(Map storage self) internal view returns(uint256)* | 获得当前mapping的容量


## API详情

### ***1. put 函数***

存放键值对

#### 参数

- bytes key: 键
- bytes value：值



#### 实例

```
    function putExample(string key, string value) public {

        map.put(bytes(key),bytes(value));
        
    }
```
### ***2. getValue 函数***

查询值

#### 参数

- bytes key：键

#### 返回值

- bytes： 值

#### 实例

```
    function getExample(string key) public returns(bytes){
        bytes memory value =  map.getValue(bytes(key));
        return value;
    }
    
```
### ***3. 迭代函数 与 getKey函数***

#### 实例

```
    event Log(bytes key);
    function iterate() public {
        uint256 i = map.iterate_start();
        while(map.can_iterate(i)){
            emit Log(map.getKey(i));
            i = map.iterate_next(i);
        }
        
    }
```

### ***4. size函数***

#### 实例

```
    function iterate() public {
        uint256 i = map.size();
        
    }
```
