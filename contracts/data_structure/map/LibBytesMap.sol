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

library LibBytesMap{

    struct Map{
        mapping(bytes => uint256) index;  // 使用映射类型将字节数组映射到无符号整数
        bytes[] keys;  // 用于存储所有的键
        bytes[] values;  // 用于存储所有的值
    }

    function put(Map storage map, bytes memory key, bytes memory value) internal {
        uint256 idx = map.index[key];  // 获取键在索引中的位置
        if(idx == 0){  // 如果键不存在
            map.keys.push(key);  // 将键添加到keys数组末尾
            map.values.push(value);  
            map.index[key] = map.keys.length;  // 更新索引映射关系
        }
        else{  // 如果键已经存在
            map.values[idx - 1] = value;  // 更新对应的值
        }
    }

    function getKey(Map storage map, uint256 index) internal view returns(bytes memory){
        require(map.keys.length > index);  // 索引必须在有效范围内
        bytes memory key = map.keys[index - 1];  // 获取对应索引的键
        return key;
    }    

    function getValue(Map storage map, bytes memory key) internal view returns(bytes memory){
        uint256 idx = map.index[key];  // 获取键在索引中的位置
        bytes memory value = map.values[idx - 1];  // 获取对应位置的值
        return value;
    }

    function getSize(Map storage self) internal view returns(uint256) {
        return self.keys.length;  
    
    // -----------迭代函数------------------
    function iterate_start(Map storage self) internal pure returns (uint256){
        return 1;  // 迭代起始索引为1
    }

    function can_iterate(Map storage self, uint256 idx) internal view returns(bool){
        return self.keys.length >= idx;  

    function iterate_next(Map storage self, uint256 idx) internal pure returns(uint256){
        return idx+1; 
    
    function getKeyByIndex(Map storage map, uint256 idx) internal view returns(bytes memory){
        bytes memory key = map.keys[idx - 1];  // 根据索引获取对应键
        return key;
    }
}