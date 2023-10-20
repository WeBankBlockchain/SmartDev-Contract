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

library LibArrayForAddressUtils {
    function firstIndexOf(address[] storage array, address key)
        internal
        view
        returns (bool, address)
    {
        if (array.length == 0) {
            return (false, 0);
        }

        for (uint256 i = 0; i < array.length; i++) {
            if (array[i] == key) {
                return (true, i);
            }
        }
        return (false, 0);
    }

    function removeByIndex(address[] storage array, uint256 index) internal {
        require(index < array.length, "ArrayForAddress: index out of bounds");

        while (index < array.length - 1) {
            array[index] = array[index + 1];
            index++;
        }
        array.length--;
    }

    function removeByValue(address[] storage array, address value) internal {
        uint256 index;
        bool isIn;
        (isIn, index) = firstIndexOf(array, value);
        if (isIn) {
            removeByIndex(array, index);
        }
    }
}
