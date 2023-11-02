/*
 * Copyright 2014-2019 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * */

pragma solidity ^0.4.25;

library LibLinkedList {

    bytes32 constant private NULL = bytes32(0); // 定义一个常量NULL，用于表示空节点
    bool constant private PREV = false; // 用于指示前一个节点
    bool constant private NEXT = true; // 用于指示后一个节点

    struct LinkedList {
        uint256 size; // 记录链表的大小
        bytes32 head; // 链表的头节点
        bytes32 tail; // 链表的尾节点
        mapping(bytes32 => Node) indexs; // 通过节点的值映射到节点对象的索引
    }

    struct Node {
        bytes32 prev; // 前一个节点的值
        bytes32 next; // 后一个节点的值
        bool exist; // 标记节点是否存在
    }

    function getSize(LinkedList storage self) internal view returns (uint256) {
        return self.size;
    }

    function addNode(LinkedList storage self, bytes32 data) internal returns (LinkedList storage) {
        require(data != bytes32(0)); // 确保添加的节点值不为空
        require(!self.indexs[data].exist); // 确保节点值在链表中不存在
        if (self.size == 0) {
            Node memory node = Node(NULL, NULL, true); // 创建一个新的节点对象
            self.size = 1; // 更新链表大小为1
            self.head = data; // 设置链表的头节点为新添加的节点
            self.tail = data; // 设置链表的尾节点为新添加的节点
            self.indexs[data] = node; // 在索引中设置新节点
        } else {
            Node memory newNode = Node(self.tail, NULL, true); // 创建一个新的节点对象
            Node storage tail = extractNode(self, self.tail); // 获取尾节点
            tail.next = data; // 尾节点的下一个节点是新添加的节点
            self.tail = data; // 更新链表的尾节点为新添加的节点
            self.size++; // 更新链表的大小
            self.indexs[data] = newNode; // 在索引中设置新节点
        }
        return self;
    }

    function getPrev(LinkedList storage self, bytes32 data) internal view returns (bytes32) {
        Node storage node = self.indexs[data]; // 获取节点对象
        require(node.exist); // 确保节点存在
        return node.prev; // 返回前一个节点的值
    }

    function getNext(LinkedList storage self, bytes32 data) internal view returns (bytes32) {
        Node storage node = self.indexs[data]; // 获取节点对象
        require(node.exist); // 确保节点存在
        return node.next; // 返回后一个节点的值
    }


    function removeNode(LinkedList storage self, bytes32 data) internal returns (LinkedList storage) {
        Node storage node = extractNode(self, data); // 获取节点对象
        require(node.exist);  //确保节点存在
        Node storage prev = extractNode(self, node.prev);  //获取前一个节点对象
        Node storage next = extractNode(self, node.next);  //获取后一个节点对象
        if (prev.exist) {
            prev.next = node.next;  //前一个节点的下一个节点更新为当前节点的下一个节点
        } else {
            self.head = node.next;  //更新链表的头节点为当前节点的下一个节点
        }

        if (next.exist) {
            next.prev = node.prev;  //后一个节点的前一个节点更新为当前节点的前一个节点
        } else {
            self.tail = node.prev;  //更新链表的尾节点为当前节点的前一个节点
        }
        delete self.indexs[data];  // 从索引中删除节点
        self.size--; //更新链表的大小
        return self;
    }


    function getTail(LinkedList storage self) internal view returns (bytes32) {
        return self.tail; //返回链表的尾节点值
    }

    function getHead(LinkedList storage self) internal view returns (bytes32) {
        return self.head; //返回链表的头节点值
    }

    function extractNode(LinkedList storage self, bytes32 data) private view returns (Node storage) {
        return self.indexs[data]; //获取索引中对应节点的对象
    }


    // -----------Iterative functions------------------
    function iterate_start(LinkedList storage self) internal view returns (bytes32) {
        return self.head; //返回链表的头节点值作为迭代的起始点
    }

    function can_iterate(LinkedList storage self, bytes32 data) internal view returns (bool) {
        return self.indexs[data].exist; //判断节点是否存在
    }

    function iterate_next(LinkedList storage self, bytes32 data) internal view returns (bytes32) {
        return self.indexs[data].next; //返回当前节点的下一个节点
    }
}