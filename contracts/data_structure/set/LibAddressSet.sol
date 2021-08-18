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


library LibAddressSet {

    struct AddressSet {
        mapping (address => uint256) indexMapping;
        address[] values;
    }

    function add(AddressSet storage self, address value) internal {
        require(value != address(0x0), "LibAddressSet: value can't be 0x0");
        require(!contains(self, value), "LibAddressSet: value already exists in the set.");
        self.values.push(value);
        self.indexMapping[value] = self.values.length;
    }

    function contains(AddressSet storage self, address value) internal view returns (bool) {
        return self.indexMapping[value] != 0;
    }

    function remove(AddressSet storage self, address value) internal {
        require(contains(self, value), "LibAddressSet: value doesn't exist.");
        uint256 toDeleteindexMapping = self.indexMapping[value] - 1;
        uint256 lastindexMapping = self.values.length - 1;
        address lastValue = self.values[lastindexMapping];
        self.values[toDeleteindexMapping] = lastValue;
        self.indexMapping[lastValue] = toDeleteindexMapping + 1;
        delete self.indexMapping[value];
        self.values.length--;
    }

    function getSize(AddressSet storage self) internal view returns (uint256) {
        return self.values.length;
    }

    function get(AddressSet storage self, uint256 index) internal view returns (address){
        return self.values[index];
    }

    function getAll(AddressSet storage self) internal view returns(address[] memory) {
    	address[] memory output = new address[](self.values.length);
    	for (uint256 i; i < self.values.length; i++){
            output[i] = self.values[i];
        }
        return output;
    }


}
