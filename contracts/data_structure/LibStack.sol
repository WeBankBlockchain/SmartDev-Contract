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

library LibStack{
    

    struct Stack{
        bytes32[] datas;
    }


    function push(Stack storage self, bytes32 data) internal{
        self.datas.push(data);
    } 

    function pop(Stack storage self) internal returns(bytes32){
        require(self.datas.length > 0);
        bytes32 data = self.datas[self.datas.length - 1];
        self.datas.length--;
        return data;
    }

    function peek(Stack storage self) internal returns(bytes32){
        require(self.datas.length > 0);
        bytes32 data = self.datas[self.datas.length - 1];
        return data;
    }
    function getSize(Stack storage self) internal view returns(uint256){
        return self.datas.length;
    }
}