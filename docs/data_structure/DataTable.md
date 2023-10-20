# DataTable.sol

DataTable提供了基于bytes32主键的二维表、自定义类型值的可迭代、可查询的映射.

## 使用方法

首先需要通过import引入DataTable合约，然后通过"."进行方法调用，如下为调用例子：

```
示例合约  StudentsGradesDemo.sol
```


## API列表

编号 | API | API描述
---|---|---
1 | *function insertItem(bytes32 rowId, bytes32 colId, DataItem item) public* | 新增数据项
2 | *ffunction getItem(bytes32 rowId, bytes32 colId) public view returns(DataItem)* |获取数据项
3 | *function getRow(bytes32 rowId) public view returns(DataRow)* |获得数据行
4 | *function isExists(bytes32 rowId, bytes32 colId) public view returns(bool)* |判断数据项是否存在
5 | *function isExists(bytes32 rowId) public view returns(bool)* |判断行是否存在
6 | *function rowCount()public view returns(uint256)* |获取行数
7 | *function iterate_start() public view returns(Pair)* | 枚举key的游标
8 | *function can_iterate(Pair iter) public view returns(bool)* | 游标是否可用
9 | *function iterate_next(Pair iter) public view returns(Pair)* | 下一个游标值



