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

library LibMinHeapUint256{

    struct Heap{
        uint256[] data;
    }

    function insert(Heap storage heap, uint256 value) internal{
        heap.data.push(value);
        uint256 idx = heap.data.length - 1;
        uint256 parent;

        while(idx > 0){
            parent = (idx - 1) / 2;
            if(heap.data[parent] <= value){
                break;
            }
            //do sift-up
            heap.data[idx] = heap.data[parent];
            heap.data[parent] = value;
            idx = parent;
        }
    }

    function top(Heap storage heap) internal view returns (uint256){
        require(heap.data.length > 0);
        return heap.data[0];
    }

    function extractTop(Heap storage heap) internal returns(uint256 top){
        require(heap.data.length > 0);
        top = heap.data[0];
        uint256 last = heap.data[heap.data.length - 1];
        heap.data.length--;

        
        heap.data[0] = last;
        uint256 index = 0;
        uint256 leftIdx;
        uint256 rightIdx;
        //Sift-down
        uint256 swapValue;
        uint256 swapIndex;
        while(index < heap.data.length){
            leftIdx = 2 * index + 1;
            rightIdx = 2 * index + 2;
            swapValue = last;
            swapIndex = index;
            if(leftIdx < heap.data.length && swapValue > heap.data[leftIdx]){
                swapValue = heap.data[leftIdx];
                swapIndex = leftIdx;
            }

            if(rightIdx < heap.data.length && swapValue > heap.data[rightIdx]){
                swapValue = heap.data[rightIdx];
                swapIndex = rightIdx;
            }

            if(swapIndex == index) break;
            heap.data[index] = swapValue;
            heap.data[swapIndex] = last;
            index = swapIndex;
        }
    }
    
    function getSize(Heap storage heap) internal view returns(uint256){
        return heap.data.length; 
    }

}
