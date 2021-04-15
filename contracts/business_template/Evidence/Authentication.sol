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

contract Authentication{
    address public _owner;
    mapping(address=>bool) private _acl;

    constructor() public{
      _owner = msg.sender;
    } 

    modifier onlyOwner(){
      require(msg.sender == _owner, "Not admin");
      _;
    }

    modifier auth(){
      require(msg.sender == _owner || _acl[msg.sender]==true, "Not authenticated");
      _;
    }

    function allow(address addr) public onlyOwner{
      _acl[addr] = true;
    }

    function deny(address addr) public onlyOwner{
      _acl[addr] = false;
    }
}
