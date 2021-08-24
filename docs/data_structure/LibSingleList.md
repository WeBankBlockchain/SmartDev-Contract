# LibSingleList.sol

LibSingleList提供了单向链表操作，包括链表更新、查询、迭代等。

## 使用方法

首先需要通过import引入LibLinkedList类库，然后通过"."进行方法调用，如下为添加元素的例子：
```
 pragma solidity ^0.4.25;
 
 import "./LibSingleList.sol";
 
 contract LibSingleListTest{
    using LibSingleList for LibSingleList.List;
    LibSingleList.List _list;
       
    function test()public{
        _list.pushBack(bytes32(1));
	}
}
```


## API列表

编号 | API | API描述
---|---|---
1 | *getSize(List storage self) internal view returns(uint256)* |获取链表元素数
2 | *isEmpty(List storage self) internal view returns(bool)* |判断是否为空
3 | *isExists(List storage self, bytes32 ele) internal view returns(bool)* | 判断是否存在
4 | *pushBack(List storage self, bytes32 ele) internal* | 添加在链表尾部
5 | *pushFront(List storage self, bytes32 ele) internal* | 添加在链表头部
6 | *getBack(List storage self) internal returns(bytes32)* | 获取尾部元素
7 | *getFront(List storage self) internal returns(bytes32)* | 获取头部元素
8 | *find(List storage self, bytes32 ele) internal returns(Iterate memory)* | 查找，返回一个迭代器， 从链表头部开始，复杂度O(n)
9 | *remove(List storage self, bytes32 ele) internal* | 删除一个元素，复杂度O(n)
10 | *remove(List storage self, Iterate memory iter) internal returns(Iterate memory)* | 删除迭代器指定节点
11 | *insertNext(List storage self, Iterate memory iter, bytes32 ele)internal* | 插入元素到迭代器后面
12 | *insertPrev(List storage self, Iterate memory iter, bytes32 ele) internal* | 插入元素到迭代器前面
13 | *begin(List storage self) internal view returns(Iterate)* | 链表迭代初始化
14 | *isEnd(List storage self, Iterate memory iter) internal view returns(bool)* | 迭代条件检查
15 | *nextNode(List storage self, Iterate memory iter) internal view returns(Iterate)* | 迭代下一个迭代器


## 测试代码

```
 pragma solidity ^0.4.25;
 
  import "./LibSingleList.sol";
 
 contract LibSingleListTest{
    using LibSingleList for LibSingleList.List;
    LibSingleList.List _list;
    
    event log(bytes32  data);
    
    function test()public{
        //3-->1-->2
        _list.pushBack(bytes32(1));
        _list.pushBack(bytes32(2));
        _list.pushFront(bytes32(3));
        require(_list.getSize() == 3,  "List size error");
        
        require(_list.getFront() == bytes32(3),  "Front node error");
        require(_list.getBack() == bytes32(2),  "back node error");
        
        var iter = _list.find(bytes32(1));
        require(iter.value == bytes32(1), "find error");
        require(iter.prevNode == bytes32(3), "list error");
        var next = _list.nextNode(iter);
        require(next.value == bytes32(2), "nextNode error");
        
        _list.remove(bytes32(3));
        require(_list.getSize() == 2,  "List size error");
        
       
        
        var curr = _list.find(bytes32(1));
        _list.insertNext(curr, bytes32(4));
        _list.insertPrev(curr, bytes32(5));
        
        require(_list.getFront() == bytes32(5),  "insert Front node error");
        require(_list.getBack() == bytes32(2),  " insert  back node error");
        require(_list.getSize() == 4,  "List size error");
        
        var beg = _list.begin();
        while(!_list.isEnd(beg)){
            if(beg.value == 4){
                //删除节点
                beg = _list.remove(beg);
            } else {
                beg = _list.nextNode(beg);
            }
        }
        
        beg = _list.begin();
        while(!_list.isEnd(beg)){
            emit log(beg.value);
            beg = _list.nextNode(beg);
        }
     }
 }
```