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
    
    bytes32 constant private NULL = bytes32(0);
    bool constant private PREV = false;
    bool constant private NEXT = true;

    struct LinkedList{
        uint256 size;
        bytes32 head;
        bytes32 tail;
        mapping(bytes32 => Node) indexs;
    }

    struct Node{
        bytes32 prev;
        bytes32 next;
        bool exist;
    }

    function getSize(LinkedList storage self) internal view returns(uint256){
        return self.size;
    }

    function addNode(LinkedList storage self, bytes32 data) internal returns(LinkedList storage) {
        require(data != bytes32(0));
        require(!self.indexs[data].exist);
        if(self.size == 0){
            Node memory node = Node(NULL, NULL, true);
            self.size = 1;
            self.head = data;
            self.tail = data;
            self.indexs[data] = node;
        }
        else{
            Node memory newNode = Node(self.tail, NULL, true); 
            Node storage tail = extractNode(self, self.tail);
            tail.next = data;
            self.tail = data;
            self.size++;
            self.indexs[data] = newNode;
        }
        return self;
    }

    function getPrev(LinkedList storage self, bytes32 data) internal view returns(bytes32){
        Node storage node = self.indexs[data];
        require(node.exist);
        return node.prev;
    }

    function getNext(LinkedList storage self, bytes32 data) internal view returns(bytes32){
        Node storage node = self.indexs[data];
        require(node.exist);
        return node.next;
    }

    
    function removeNode(LinkedList storage self, bytes32 data) internal returns(LinkedList storage){
        Node storage node = extractNode(self, data);
        require(node.exist);
        Node storage prev = extractNode(self, node.prev);
        Node storage next = extractNode(self, node.next);
        if(prev.exist){
            prev.next = node.next;
        }
        else{
            self.head = node.next;
        }

        if(next.exist){
            next.prev = node.prev;
        }
        else{
            self.tail = node.prev;
        }
        delete self.indexs[data];
        self.size--;
        return self;
    }
    
      
    function getTail(LinkedList storage self) internal view returns(bytes32){
        return self.tail;
    }

    function getHead(LinkedList storage self) internal view returns(bytes32){
        return self.head;
    }  
    
    function extractNode(LinkedList storage self, bytes32 data) private view returns(Node storage){
        return self.indexs[data];
    }

    
    // -----------Iterative functions------------------
    function iterate_start(LinkedList storage self) internal view returns (bytes32){
        return self.head;
    }

    function can_iterate(LinkedList storage self, bytes32 data) internal view returns(bool){
        return self.indexs[data].exist;
    }

    function iterate_next(LinkedList storage self, bytes32 data) internal view returns(bytes32){
        return self.indexs[data].next;
    }
}