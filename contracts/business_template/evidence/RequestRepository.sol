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

import "./Authentication.sol";

contract RequestRepository is Authentication{    
    struct SaveRequest{
        bytes32 hash;
        address creator;
        uint8 voted;
        bytes ext;
        mapping(address=>bool) status;
    }
    uint8 public _threshold;
    mapping(bytes32=>SaveRequest) private _saveRequests;
    mapping(address=>bool) private _voters;
    
    constructor(uint8 threshold, address[] memory voterArray) public{
        _threshold = threshold;
        for(uint i=0;i<voterArray.length;i++){
            _voters[voterArray[i]] = true;
        }
    }

    function createSaveRequest(bytes32 hash, address owner, bytes memory ext) public auth{
        require(_saveRequests[hash].hash == 0, "request already existed");
        _saveRequests[hash].hash = hash;
        _saveRequests[hash].creator = owner;
        _saveRequests[hash].ext = ext;
    }

    function voteSaveRequest(bytes32 hash, address voter) public auth returns (bool){
        require(_voters[voter] == true, "Not allowed to vote");
        require(_saveRequests[hash].hash == hash, "request not found");
        SaveRequest storage request = _saveRequests[hash];
        require(request.status[voter] == false, "Voter already voted");
        request.status[voter] = true;
        request.voted++;
        return true;
    }
    
    function getRequestData(bytes32 hash) public view 
      returns(bytes32, address creator, bytes memory ext, uint8 voted, uint8 threshold){
        SaveRequest storage request = _saveRequests[hash];
        require(_saveRequests[hash].hash == hash, "request not found");
        return (hash, request.creator, request.ext, request.voted, _threshold);
    }

    function deleteSaveRequest(bytes32 hash) public auth {
        require(_saveRequests[hash].hash == hash, "request not found");
        delete _saveRequests[hash];
    }
}
