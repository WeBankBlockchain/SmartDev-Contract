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
 
pragma solidity ^0.4.25;//版本号

import "../LibSafeMathForUint256Utils.sol";

library LibArrayForUint256Utils {

	/**
	 * @dev Searches a sortd uint256 array and returns the first element index that 
	 * match the key value, Time complexity O(log n)
	 *
	 * @param array is expected to be sorted in ascending order
	 * @param key is element 
	 *
	 * @return if matches key in the array return true,else return false 
	 * @return the first element index that match the key value,if not exist,return 0
	 */
	/**
 	* @dev 在排序的 uint256 数组中查找第一个与指定元素匹配的元素索引，时间复杂度为 O(log n)
 	* @param array 期望按升序排序的数组
 	* @param key 元素值
 	* @return 如果在数组中存在匹配的元素，则返回 true 和匹配的元素索引；如果不存在匹配的元素，则返回 false 和索引为0
 	*/
	function binarySearch(uint256[] storage array, uint256 key) internal view returns (bool, uint) {
        if(array.length == 0){
        	return (false, 0);
        }

        uint256 low = 0;
        uint256 high = array.length-1;

        while(low <= high){
        	uint256 mid = LibSafeMathForUint256Utils.average(low, high);
        	if(array[mid] == key){
        		return (true, mid);
        	}else if (array[mid] > key) {
                high = mid - 1;
            } else {
                low = mid + 1;
            }
        }

        return (false, 0);
    }
/**
	 * @dev 查找数组中第一次出现指定值的元素索引
 	* @param array 数组
	 * @param key 元素值
	 * @return 如果在数组中存在匹配的元素，则返回 true 和匹配的元素索引；如果不存在匹配的元素，则返回 false 和索引为0
	 */
    function firstIndexOf(uint256[] storage array, uint256 key) internal view returns (bool, uint256) {

    	if(array.length == 0){
    		return (false, 0);
    	}

    	for(uint256 i = 0; i < array.length; i++){
    		if(array[i] == key){
    			return (true, i);
    		}
    	}
    	return (false, 0);
    }
/**
 	* @dev 将数组元素进行反转
	 * @param array 数组
 	*/
    function reverse(uint256[] storage array) internal {
        uint256 temp;
        for (uint i = 0; i < array.length / 2; i++) {
            temp = array[i];
            array[i] = array[array.length - 1 - i];
            array[array.length - 1 - i] = temp;
        }
    }
/**
 	* @dev 比较两个数组是否相等
 	* @param a 数组 a
	 * @param b 数组 b
 	* @return 如果数组的长度不相等，则返回 false；如果数组元素不相等，则返回 false；如果数组长度和元素都相等，则返回 true
	 */
    function equals(uint256[] storage a, uint256[] storage b) internal view returns (bool){
    	if(a.length != b.length){
    		return false;
    	}
    	for(uint256 i = 0; i < a.length; i++){
    		if(a[i] != b[i]){
    			return false;
    		}
    	}
    	return true;
    }
/**
	 * @dev 根据索引从数组中移除元素
 	* @param array 数组
 	* @param index 索引
 	*/
    function removeByIndex(uint256[] storage array, uint index) internal{
    	require(index < array.length, "ArrayForUint256: index out of bounds");

        while (index < array.length - 1) {
            array[index] = array[index + 1];
            index++;
        }
        array.length--;
    }
   /**
 	* @dev 根据值从数组中移除元素
 	* @param array 数组
 	* @param value 值
 	*/ 
    function removeByValue(uint256[] storage array, uint256 value) internal{
        uint index;
        bool isIn;
        (isIn, index) = firstIndexOf(array, value);
        if(isIn){
          removeByIndex(array, index);
        }
    }
/**
	 * @dev 向数组中添加元素（如果元素不存在在数组中）
 	* @param array 数组
 	* @param value 值
	 */
    function addValue(uint256[] storage array, uint256 value) internal{
    	uint index;
        bool isIn;
        (isIn, index) = firstIndexOf(array, value);
        if(!isIn){
        	array.push(value);
        }
    }
/**
	 * @dev 将数组 b 的元素扩展到数组 a 的末尾
	 * @param a 数组 a
 	* @param b 数组 b
	*/
    function extend(uint256[] storage a, uint256[] storage b) internal {
    	if(b.length != 0){
    		for(uint i = 0; i < b.length; i++){
    			a.push(b[i]);
    		}
    	}
    }
/**
 	* @dev 数组去重
 	* @param array 数组
 	* @return 去重后的数组长度
 	*/
    function distinct(uint256[] storage array) internal returns (uint256 length) {
        bool contains;
        uint index;
        for (uint i = 0; i < array.length; i++) {
            contains = false;
            index = 0;
            uint j = i+1;
            for(;j < array.length; j++){
                if(array[j] == array[i]){
                    contains =true;
                    index = i;
                    break;
                }
            }
//两个for,对array数组循环2次，将第一次循环的第i个值与array中依次对比，如果值相等说明该元素重复，执行下面下面的去重
            if (contains) {
                for (j = index; j < array.length - 1; j++){
                    array[j] = array[j + 1];
                }
                array.length--;
                i--;
            }
        }
        length = array.length;
    }
/**
 	* @dev 对数组进行快速排序（升序）
 	* @param array 数组
 	*/
    function qsort(uint256[] storage array) internal {
        qsort(array, 0, array.length-1);
    }
/**
 	* @dev 对数组进行快速排序（升序）
 	* @param array 数组
	 */
    function qsort(uint256[] storage array, uint256 begin, uint256 end) private {
        if(begin >= end || end == uint256(-1)) return;
        uint256 pivot = array[end];

        uint256 store = begin;
        uint256 i = begin;
        for(;i<end;i++){
            if(array[i] < pivot){
                uint256 tmp = array[i];
                array[i] = array[store];
                array[store] = tmp;
                store++;
            }
        }

        array[end] = array[store];
        array[store] = pivot;

        qsort(array, begin, store-1);
        qsort(array, store+1, end);
    }
 /**
 	* @dev 返回给定uint256数组中的最大值和最大值位置
 	* @param array 待处理的uint256数组
 	* @return maxValue 为最大值，maxIndex 为最大值位置
	 */
    function max(uint256[] storage array) internal view returns (uint256 maxValue, uint256 maxIndex) {
        maxValue = array[0];
        maxIndex = 0;
        for(uint256 i = 0;i < array.length;i++){
            if(array[i] > maxValue){
                maxValue = array[i];
                maxIndex = i;
            }
        }
    }
    /**
 	* @dev 返回给定uint256数组中的最小值和最小值位置
 	* @param array 待处理的uint256数组
 	* @return minValue为最小值，minIndex为最小值位置
	 */
    function min(uint256[] storage array) internal view returns (uint256 minValue, uint256 minIndex) {
        // 预设返回值
        minValue = array[0];
        minIndex = 0;
        for(uint256 i = 0;i < array.length;i++){
            // 如果当前值比现有的最小值更小，则进行返回值的更新
            if(array[i] < minValue){
                minValue = array[i];
                minIndex = i;
            }
        }
    }

}