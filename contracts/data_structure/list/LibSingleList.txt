 pragma solidity ^0.4.25;
library LibSingleList {
    // 定义常量NULL，初始值为bytes32类型的0
    bytes32 constant private NULL = bytes32(0);

    // 定义单链表的节点结构体
    struct ListNode {
        bytes32 nextNode; // 下一个节点的指针
        bool exist; // 节点是否存在的标志
    }

    // 定义单链表结构体
    struct List {
        mapping(bytes32 => ListNode) data; // 存储链表节点的映射表
        bytes32 header; // 链表头节点的指针
        bytes32 tail; // 链表尾节点的指针
        uint256 size; // 链表的大小
    }

    // 迭代器结构体，用于遍历链表
    struct Iterate {
        bytes32 value; // 当前节点的指针
        bytes32 prevNode; // 前一个节点的指针
    }

    // 在链表尾部插入一个元素
    function pushBack(List storage self, bytes32 ele) internal {
        // 判断元素是否已存在
        require(!self.data[ele].exist, "the element is already exists");

        // 若链表为空，则将元素设置为头节点
        if (self.size == 0) {
            addFirstNode(self, ele);
        } else {
            // 否则，在尾节点后插入新元素
            self.data[ele] = ListNode({nextNode: NULL, exist: true});
            self.data[self.tail].nextNode = ele;
            self.tail = ele;
        }

        self.size++;
    }

    // 在链表头部插入一个元素
    function pushFront(List storage self, bytes32 ele) internal {
        // 判断元素是否已存在
        require(!self.data[ele].exist, "the element is already exists");

        // 若链表为空，则将元素设置为头节点
        if (self.size == 0) {
            addFirstNode(self, ele);
        } else {
            // 否则，在头节点前插入新元素
            self.data[ele] = ListNode({nextNode: self.header, exist: true});
            self.header = ele;
        }
        self.size++;
    }

    // 删除一个元素
    function remove(List storage self, bytes32 ele) internal {
        Iterate memory iter = find(self, ele);
        if (iter.value != NULL) {
            remove(self, iter);
        }
    }

    // 查找一个元素
    function find(List storage self, bytes32 ele) internal returns (Iterate memory) {
        // 判断节点是否存在并返回对应的迭代器
        require(self.data[ele].exist, "the node is not exists");
        bytes32 prev = NULL;
        bytes32 beg = self.header;
        while (beg != NULL) {
            if (beg == ele) {
                Iterate memory iter = Iterate({value: ele, prevNode: prev});
                return iter;
            }
            prev = beg;
            beg = self.data[beg].nextNode;
        }
        return Iterate({value: NULL, prevNode: NULL});
    }

    // 删除一个节点
    function remove(List storage self, Iterate memory iter) internal returns (Iterate memory) {
        require(self.data[iter.value].exist, "the node is not exists");
        Iterate memory nextIter = Iterate({value: self.data[iter.value].nextNode, prevNode: iter.prevNode});
        if (iter.prevNode == NULL) {
            // 若删除的是头节点，则更新头指针
            self.header = self.data[iter.value].nextNode;
        } else {
            // 否则，将前一个节点的next指针指向待删除节点的下一个节点
            self.data[iter.prevNode].nextNode = self.data[iter.value].nextNode;
        }
        delete self.data[iter.value];
        if (self.header == NULL) {
            self.tail = NULL;
        }
        self.size--;
        return nextIter;
    }

    // 在某个节点之后插入一个元素
    function insertNext(List storage self, Iterate memory iter, bytes32 ele) internal {
        require(self.data[iter.value].exist, "the node is not exists");
        bytes32 next = self.data[iter.value].nextNode;
        self.data[ele] = ListNode({nextNode: next, exist: true});
        self.data[iter.value].nextNode = ele;
        if (self.tail == iter.value) {
            self.tail = ele;
        }
        self.size++;
    }

    // 在某个节点之前插入一个元素
    function insertPrev(List storage self, Iterate memory iter, bytes32 ele) internal {
        require(self.data[iter.value].exist, "the node is not exists");
        self.data[ele] = ListNode({nextNode: iter.value, exist: true});
        if (self.header == iter.value) {
            self.header = ele;
        } else {
            require(self.data[iter.prevNode].exist, "the prev node is not exists");
            self.data[iter.prevNode].nextNode = ele;
        }
        self.size++;
    }

    // 将元素作为第一个节点插入链表中
    function addFirstNode(List storage self, bytes32 ele) private {
        ListNode memory node = ListNode({nextNode: NULL, exist: true});
        self.data[ele] = node;
        self.header = ele;
        self.tail = ele;
    }

    // 获取链表尾节点的元素
    function getBack(List storage self) internal returns (bytes32) {
        require(self.size > 0, "the list is empty");
        return self.tail;
    }

    // 获取链表头节点的元素
    function getFront(List storage self) internal returns (bytes32) {
        require(self.size > 0, "the list is empty");
        return self.header;
    }

    // 获取链表大小
    function getSize(List storage self) internal view returns (uint256) {
        return self.size;
    }

    // 判断链表是否为空
    function isEmpty(List storage self) internal view returns (bool) {
        return self.size == 0;
    }

    // 判断节点是否存在
    function isExists(List storage self, bytes32 ele) internal view returns (bool) {
        return self.data[ele].exist;
    }

    // 获取链表头节点的迭代器
    function begin(List storage self) internal view returns (Iterate) {
        Iterate memory iter = Iterate({value: self.header, prevNode: NULL});
        return iter;
    }

    // 判断迭代器是否指向链表尾部
    function isEnd(List storage self, Iterate memory iter) internal view returns (bool) {
        return iter.value == NULL;
    }

    // 获取迭代器的下一个节点
    function nextNode(List storage self, Iterate memory iter) internal view returns (Iterate) {
        require(self.data[iter.value].exist, "the node is not exists");
        Iterate memory nextIter = Iterate({value: self.data[iter.value].nextNode, prevNode: iter.value});
        return nextIter;
    }
}