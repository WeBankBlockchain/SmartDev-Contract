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

//积分控制合约
contract RewardPointController is BasicAuth {
    using LibSafeMath for uint256; //引入安全加减数学运算工具类

    RewardPointData _rewardPointData; 

    event LogRegister(address account);
    event LogUnregister(address account);
    event LogSend( address indexed from, address indexed to, uint256 value);

    constructor(address dataAddress) public {
      //保存积分数据合约实例地址
      _rewardPointData = RewardPointData(dataAddress);
    }

    
    modifier accountExist(address addr) {
        //要求账户已经注册
        require(_rewardPointData.hasAccount(addr)==true && addr != address(0), "Only existed account!");
        _;
    }

    modifier accountNotExist(address account) {
        //要求账户未注册
        require(_rewardPointData.hasAccount(account)==false, "Account already existed!");
        _;
    }

    modifier canUnregister(address account) {
        //判断账户是否可以取消注册，要求账户已经注册且账户的余额是零
        require(_rewardPointData.hasAccount(account)==true && _rewardPointData.getBalance(account) == 0 , "Cann't unregister!");
        _;
    }

    modifier checkAccount(address sender) {
        //要求调用者地址非发送的目标地址,且发送的目标地址是有效的
        require(msg.sender != sender && sender != address(0), "Can't transfer to illegal address!");
        _;
    }

    modifier onlyIssuer() {
         //要求调用者是积分的发行者
        require(_rewardPointData.isIssuer(msg.sender), "IssuerRole: caller does not have the Issuer role");
        _;
    }

    //注册账户
    function register() accountNotExist(msg.sender) public {
       //保存账户地址，设置状态值为true
        _rewardPointData.setAccount(msg.sender, true);
        //初始化账号余额为0
        _rewardPointData.setBalance(msg.sender, 0);
        emit LogRegister(msg.sender);
    }

    //取消注册账户
    function unregister() canUnregister(msg.sender) public {
        //设置账户状态值为false
        _rewardPointData.setAccount(msg.sender, false);
        emit LogUnregister(msg.sender);
    }

    //判断是否已经注册
    function isRegistered(address addr) public view returns (bool) {
        return _rewardPointData.hasAccount(addr);
    }

    //查询账户的余额
    function balance(address addr) public view returns (uint256) {
        return _rewardPointData.getBalance(addr);
    }

    //转账
    function transfer(address toAddress, uint256 value) accountExist(msg.sender) accountExist(toAddress)
        public returns(bool b, uint256 balanceOfFrom, uint256 balanceOfTo) {
            //转账发送者扣减转账的金额
            uint256 balance1 = _rewardPointData.getBalance(msg.sender);
            balanceOfFrom = balance1.sub(value);
            _rewardPointData.setBalance(msg.sender, balanceOfFrom);
            //转账接收者的余额增加相应的转账金额
            uint256 balance2 = _rewardPointData.getBalance(toAddress);
            balanceOfTo = balance2.add(value);
            _rewardPointData.setBalance(toAddress, balanceOfTo);
            emit LogSend(msg.sender, toAddress, value);
            b = true;
    }

    //消耗指定的金额
    function destroy(uint256 value) accountExist(msg.sender) public returns (bool) {
        //积分总额度扣减
        uint256 totalAmount = _rewardPointData._totalAmount();
        totalAmount = totalAmount.sub(value);
        _rewardPointData.setTotalAmount(totalAmount);
        //调用者的账户余额扣减
        uint256 balance1 = _rewardPointData.getBalance(msg.sender);
        balance1 = balance1.sub(value);
        _rewardPointData.setBalance(msg.sender, balance1);
        emit LogSend( msg.sender, address(0), value);
        return true;
    }

    //发行积分
    function issue(address account, uint256 value) public accountExist(account) returns (bool) {
        //积分总额度增加发行的积分数量
        uint256 totalAmount = _rewardPointData._totalAmount();
        totalAmount = totalAmount.add(value);
        _rewardPointData.setTotalAmount(totalAmount);
        //给账户余额增加发行的积分数量
        uint256 balance1 = _rewardPointData.getBalance(account);
        balance1 = balance1.add(value);
        _rewardPointData.setBalance(account, balance1);
        emit LogSend( address(0), account, value);
        return true;
    }

    //是否是发行者
    function isIssuer(address account) public view returns (bool) {
        return _rewardPointData.isIssuer(account);
    }

    //添加发行者
    function addIssuer(address account) public returns (bool) {
        _rewardPointData.addIssuer(account);
        return true;
    }

    //撤销发行者
    function renounceIssuer() public returns (bool) {
        _rewardPointData.renounceIssuer(msg.sender);
        return true;
    }
}

