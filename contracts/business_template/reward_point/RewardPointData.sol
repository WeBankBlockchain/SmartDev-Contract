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
import "./IssuerRole.sol";

//积分数据合约
contract RewardPointData is BasicAuth, IssuerRole {

    mapping(address => uint256) private _balances;  //保证注册账号数据
    mapping(address => bool) private _accounts; //保存账户余额数据
    uint256 public _totalAmount; //发行积分总额
    string public _description;  //描述信息
    address _latestVersion;  //最新的版本

    constructor(string memory description) public {
        _description = description;
    }

    modifier onlyLatestVersion() {
       require(msg.sender == _latestVersion);
        _;
    }

    //升级版本
    function upgradeVersion(address newVersion) public {
        require(msg.sender == _owner);
        _latestVersion = newVersion;
    }
    

    //设置账户的积分余额
    function setBalance(address a, uint256 value) onlyLatestVersion public returns (bool) {
        _balances[a] = value;
        return true;
    }

    //设置账户的状态值为true，代表已经注册
    function setAccount(address a, bool b) onlyLatestVersion public returns (bool) {
        _accounts[a] = b;
        return true;
    }

    //设置积分总额度
    function setTotalAmount(uint256 amount) onlyLatestVersion public returns (bool) {
        _totalAmount = amount;
        return true;
    }

    //获取账户的状态，及积分余额
    function getAccountInfo(address account) public view returns (bool, uint256) {
        return (_accounts[account], _balances[account]);
    }

    //返回账户是否已经注册
    function hasAccount(address account) public view returns(bool) {
         return _accounts[account];
    }

   //获取账户的余额
    function getBalance(address account) public view returns (uint256) {
        return _balances[account];
    }
   
}

