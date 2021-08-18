# Map.sol

Map提供了基于bytes32主键、自定义类型值的可迭代、可查询的映射.

## 使用方法

首先需要通过import引入Map合约，然后通过"."进行方法调用，如下为调用例子：

```
pragma solidity >=0.4.24 <0.6.11;

import "./Map.sol";

contract MyData is DataItem{
    string name;
	int16 age;
	constructor(string n, int16 a){
         name = n;
		 age = a;
    }
}

contract Test {
    
    Map _map; 
    constructor(){
         _map = new Map();
    }
     
    event Log(uint256 size);
	event LogKey(bytes32 key);
    function f() public {
        string memory name = "张三";
		_map.insert(bytes32("10001"), new MyData(name, 32));
        emit Log(_map.getSize());
		//遍历
        for(Pair item = _map.iterate_start(); _map.can_iterate(item);item = _map.iterate_next(item)){
            emit LogKey(item.getKey());
			MyData data = MyData(item.getValue());
		}
    }
}
```


## API列表

编号 | API | API描述
---|---|---
1 | *function insert(bytes32 key, DataItem value)public* | 新增键值对
2 | *function getValue(bytes32 key)public view returns(DataItem)* |根据key获取value
3 | *function getSize()public view returns(uint256)* |获得当前mapping的容量
4 | *function isEmpty() public view returns(bool)* |是否为空
5 | *function isExists(bytes32 key) public view returns(bool)* |判断键值是否存在
6 | *function iterate_start() public view returns(Pair)* | 枚举key的游标
7 | *function can_iterate(Pair iter) public view returns(bool)* | 游标是否可用
8 | *function iterate_next(Pair iter) public view returns(Pair)* | 下一个游标值



