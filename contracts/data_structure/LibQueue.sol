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

library LibQueue{
    

    struct Queue{
        uint256 first;
        uint256 next;
        mapping(uint => bytes32) queue;

    }

    function enqueue(Queue storage queue, bytes32 data) internal {
        queue.queue[queue.next++] = data;
    }

    function dequeue(Queue storage queue) internal returns (bytes32) {
        uint256 first = queue.first;
        require(queue.next > first);  // non-empty queue

        bytes32 data = queue.queue[first];
        delete queue.queue[first];
        queue.first += 1;
        return data;
    }

    function element(Queue storage queue) internal view returns (bytes32) {
        uint256 first = queue.first;
        require(queue.next > first);  // non-empty queue
        bytes32 data = queue.queue[first];
        return data;
    }


    function getSize(Queue storage self) internal view returns(uint256){
        return self.next - self.first;
    }
}