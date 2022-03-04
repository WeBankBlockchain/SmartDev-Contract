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

import "./RewardPointData.sol";
import "./BasicAuth.sol";
import "./LibSafeMath.sol";

contract RewardPointController is BasicAuth {
    using LibSafeMath for uint256;

    RewardPointData _rewardPointData;

    event LogRegister(address account);
    event LogUnregister(address account);
    event LogSend( address indexed from, address indexed to, uint256 value);

    constructor(address dataAddress) public {
        _rewardPointData = RewardPointData(dataAddress);
    }

    modifier accountExist(address addr) { 
        require(_rewardPointData.hasAccount(addr)==true && addr != address(0), "Only existed account!");
        _; 
    } 

    modifier accountNotExist(address account) { 
        require(_rewardPointData.hasAccount(account)==false, "Account already existed!");
        _; 
    } 

    modifier canUnregister(address account) { 
        require(_rewardPointData.hasAccount(account)==true && _rewardPointData.getBalance(account) == 0 , "Cann't unregister!");
        _; 
    } 

    modifier checkAccount(address sender) { 
        require(msg.sender != sender && sender != address(0), "Can't transfer to illegal address!");
        _; 
    } 

    modifier onlyIssuer() {
        require(_rewardPointData.isIssuer(msg.sender), "IssuerRole: caller does not have the Issuer role");
        _;
    }

    function register() accountNotExist(msg.sender) public returns (address) {
        _rewardPointData.setAccount(msg.sender, true);
        // init balances
        _rewardPointData.setBalance(msg.sender, 0);
        emit LogRegister(msg.sender);
    }

    function unregister() canUnregister(msg.sender) public returns (address) {
        _rewardPointData.setAccount(msg.sender, false);
        emit LogUnregister(msg.sender);
    }

    function isRegistered(address addr) public view returns (bool) {
        return _rewardPointData.hasAccount(addr);
    }

    function balance(address addr) public view returns (uint256) {
        return _rewardPointData.getBalance(addr);
    }

    function transfer(address toAddress, uint256 value) accountExist(msg.sender) accountExist(toAddress)
        public returns(bool b, uint256 balanceOfFrom, uint256 balanceOfTo) {
            uint256 balance1 = _rewardPointData.getBalance(msg.sender);
            balanceOfFrom = balance1.sub(value);
            _rewardPointData.setBalance(msg.sender, balanceOfFrom);
            uint256 balance2 = _rewardPointData.getBalance(toAddress);
            balanceOfTo = balance2.add(value);
            _rewardPointData.setBalance(toAddress, balanceOfTo);
            emit LogSend(msg.sender, toAddress, value);
            b = true;
    }

    function destroy(uint256 value) accountExist(msg.sender) public returns (bool) {
        uint256 totalAmount = _rewardPointData._totalAmount();
        totalAmount = totalAmount.sub(value);
        _rewardPointData.setTotalAmount(totalAmount);
        uint256 balance1 = _rewardPointData.getBalance(msg.sender);
        balance1 = balance1.sub(value);
        _rewardPointData.setBalance(msg.sender, balance1);
        emit LogSend( msg.sender, address(0), value);
        return true;
    }


    function issue(address account, uint256 value) public accountExist(account) returns (bool) {
        uint256 totalAmount = _rewardPointData._totalAmount();
        totalAmount = totalAmount.add(value);
        _rewardPointData.setTotalAmount(totalAmount);
        uint256 balance1 = _rewardPointData.getBalance(account);
        balance1 = balance1.add(value);
        _rewardPointData.setBalance(account, balance1);
        emit LogSend( address(0), account, value);
        return true;
    }

    function isIssuer(address account) public view returns (bool) {
        return _rewardPointData.isIssuer(account);
    }

    function addIssuer(address account) public returns (bool) {
        _rewardPointData.addIssuer(account);
        return true;
    }

    function renounceIssuer() public returns (bool) {
        _rewardPointData.renounceIssuer(msg.sender);
        return true;
    }
}

