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
    heap.data.push(value); // 将新元素添加到堆的末尾
    uint256 idx = heap.data.length - 1; // 新元素的索引
    uint256 parent;

    while(idx > 0){
        parent = (idx - 1) / 2; // 计算父节点的索引
        if(heap.data[parent] <= value){ // 如果父节点的值小于等于新元素的值，则跳出循环
            break;
        }
        // 做上移操作
        heap.data[idx] = heap.data[parent]; // 新元素的位置设为父节点的位置
        heap.data[parent] = value; // 父节点位置设为新元素的值
        idx = parent; // 更新新元素的索引为父节点的索引
    }
}

function top(Heap storage heap) internal view returns (uint256){
    require(heap.data.length > 0); // 堆中必须至少有一个元素
    return heap.data[0]; // 返回堆顶元素
}

function extractTop(Heap storage heap) internal returns(uint256 top){
    require(heap.data.length > 0); // 堆中必须至少有一个元素
    top = heap.data[0]; // 获取堆顶元素
    uint256 last = heap.data[heap.data.length - 1]; // 获取堆的最后一个元素
    heap.data.length--; // 减少堆的大小
    
    
    heap.data[0] = last; // 将最后一个元素移到堆顶
    uint256 index = 0; // 当前索引
    uint256 leftIdx;
    uint256 rightIdx;
    // 下沉操作
    uint256 swapValue;
    uint256 swapIndex;
    while(index < heap.data.length){
        leftIdx = 2 * index + 1; // 计算左子节点的索引
        rightIdx = 2 * index + 2; // 计算右子节点的索引
        swapValue = last;
        swapIndex = index;
        if(leftIdx < heap.data.length && swapValue > heap.data[leftIdx]){ // 如果左子节点的值小于当前值，则进行交换
            swapValue = heap.data[leftIdx];
            swapIndex = leftIdx;
        }

        if(rightIdx < heap.data.length && swapValue > heap.data[rightIdx]){ // 如果右子节点的值小于当前值，则进行交换
            swapValue = heap.data[rightIdx];
            swapIndex = rightIdx;
        }

        if(swapIndex == index) break; // 如果没有发生交换，则跳出循环
        heap.data[index] = swapValue; // 当前位置设为交换值
        heap.data[swapIndex] = last; // 交换位置设为最后一个元素的值
        index = swapIndex; // 更新当前索引为交换位置的索引
    }
}

function getSize(Heap storage heap) internal view returns(uint256){
    return heap.data.length; // 返回堆的大小
}