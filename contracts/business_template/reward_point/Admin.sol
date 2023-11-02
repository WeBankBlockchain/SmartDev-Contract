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

import "./BasicAuth.sol";
import "./RewardPointController.sol";
import "./RewardPointData.sol";


//管理合约
contract Admin is BasicAuth {
    address public _dataAddress; 
    address public _controllerAddress;

    constructor() public {
        //创建RewardPointData合约,用于存储数据
        RewardPointData data = new RewardPointData("Point of V1");
        _dataAddress = address(data);
        //创建RewardPointController 合约,提供合约控制操作的接口
        RewardPointController controller = new RewardPointController(_dataAddress);
        _controllerAddress = address(controller);
        data.upgradeVersion(_controllerAddress);
        data.addIssuer(msg.sender);
        data.addIssuer(_controllerAddress);
    }

    //升级版本
    function upgradeVersion(address newVersion) public {
        RewardPointData data = RewardPointData(_dataAddress);
        data.upgradeVersion(newVersion);
    }
    
}