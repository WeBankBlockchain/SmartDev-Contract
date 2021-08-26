
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

import "./RequestRepository.sol";
import "./EvidenceRepository.sol";

contract EvidenceController{
    RequestRepository public _requestRepo;
    EvidenceRepository public _evidenceRepo;

    event CreateSaveRequest(bytes32 indexed hash, address creator);   
    event VoteSaveRequest(bytes32 indexed hash, address voter, bool complete);
    event EvidenceSaved(bytes32 indexed hash);

    constructor(uint8 threshold, address[] memory voterArray) public{
        _requestRepo = new RequestRepository(threshold, voterArray);
        _evidenceRepo = new EvidenceRepository();
    }

    modifier validateHash(bytes32 hash){
      require(hash != 0, "Not valid hash");
      _;
    }

    function createSaveRequest(bytes32 hash, bytes memory ext) public validateHash(hash){
        _requestRepo.createSaveRequest(hash, msg.sender, ext);
        emit CreateSaveRequest(hash, msg.sender);
    }

    function voteSaveRequest(bytes32 hash) public validateHash(hash) returns(bool){
        bool b = _requestRepo.voteSaveRequest(hash, msg.sender);
        if(!b) {
            return false;
        }
        (bytes32 h, address creator, bytes memory ext,  uint8 voted, uint8 threshold) =  _requestRepo.getRequestData(hash);
        bool passed = voted >= threshold;
        emit VoteSaveRequest(hash, msg.sender, passed);
        if(passed){
            _evidenceRepo.setData(hash, creator, now);
            _requestRepo.deleteSaveRequest(hash);
            emit EvidenceSaved(hash);
        }
        return true;
    }

    function getRequestData(bytes32 hash) public view 
      returns(bytes32, address creator, bytes memory ext, uint8 voted, uint8 threshold){
        return _requestRepo.getRequestData(hash);
    }

    function getEvidence(bytes32 hash) public view returns(bytes32 , address, uint){
        return _evidenceRepo.getData(hash);
    }
}
