/*
 * Copyright 2021 LI LI of JINGTIAN & GONGCHENG.
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

import "./interfaces/IMembersRepository.sol";
import "./lib/LibSafeMathForUint256Utils.sol";
import "./lib/LibArrayForUint256Utils.sol";
import "./lib/LibArrayForAddressUtils.sol";

contract MembersRepository is IMembersRepository {
    using LibSafeMathForUint256Utils for uint256;
    using LibArrayForUint256Utils for uint256[];
    using LibArrayForAddressUtils for address[];

    // 股东
    struct Member {
        uint256[] sharesInHand; //持有的股票编号
        uint256 regCap; //注册资本
        uint256 paidInCap; //实缴资本
    }

    // 账号 => 股东 映射
    mapping(address => Member) internal _members;

    // 股东名册
    address[] internal _memberAcctList;

    function _isMember(address acct) internal view returns (bool) {
        if (acct == address(0)) {
            return false;
        }
        bool exist;
        uint256 index;
        (exist, index) = _memberAcctList.firstIndexOf(acct);
        return exist;
    }

    function _addMember(address acct, uint8 maxQtyOfMembers) internal {
        bool exist;
        uint256 index;
        (exist, index) = _memberAcctList.firstIndexOf(acct);
        if (!exist) {
            require(_memberAcctList.length < maxQtyOfMembers, "股东人数溢出");
            _memberAcctList.push(acct);

            emit AddMember(acct, _memberAcctList.length);
        }
    }

    function _addShareToMember(
        address acct,
        uint256 shareNumber,
        uint256 parValue,
        uint256 paidInAmount
    ) internal {
        _members[acct].sharesInHand.push(shareNumber);
        _members[acct].regCap = _members[acct].regCap.add(parValue);
        _members[acct].paidInCap = _members[acct].paidInCap.add(paidInAmount);

        emit AddShareToMember(shareNumber, acct);
    }

    function _payInCapitalToMember(address acct, uint256 amount) internal {
        _members[acct].paidInCap += amount;

        emit PayInCapitalToMember(acct, amount);
    }

    function _subAmountFromMember(
        address acct,
        uint256 parValue,
        uint256 paidInAmount
    ) internal {
        _members[acct].regCap -= parValue;
        _members[acct].paidInCap -= paidInAmount;

        emit SubAmountFromMember(acct, parValue, paidInAmount);
    }

    function _removeShareFromMember(
        address acct,
        uint256 shareNumber,
        uint256 parValue,
        uint256 paidInAmount
    ) internal {
        if (_members[acct].regCap == parValue) {
            delete _members[acct];
            _memberAcctList.removeByValue(acct);

            emit RemoveMember(acct, _memberAcctList.length);
        } else {
            _subAmountFromMember(acct, parValue, paidInAmount);
            _members[acct].sharesInHand.removeByValue(shareNumber);

            emit RemoveShareFromMember(shareNumber, acct);
        }
    }

    function isMember(address acct) external view returns (bool) {
        return _isMember(acct);
    }

    function getMember(address acct)
        external
        view
        returns (
            uint256[],
            uint256,
            uint256
        )
    {
        require(_members[acct].regCap != 0, "目标股东不存在");
        Member storage member = _members[acct];
        return (member.sharesInHand, member.regCap, member.paidInCap);
    }

    function getMemberAcctList() external view returns (address[]) {
        require(_memberAcctList.length > 0, "股东人数为0");
        return _memberAcctList;
    }

    function getQtyOfMembers() external view returns (uint256) {
        return _memberAcctList.length;
    }
}
