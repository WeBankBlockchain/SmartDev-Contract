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

import "./lib/LibSafeMathForUint256Utils.sol";
import "./lib/LibArrayForUint256Utils.sol";
import "./interfaces/ISharesRepository.sol";

contract SharesRepository is ISharesRepository {
    using LibSafeMathForUint256Utils for uint256;
    using LibArrayForUint256Utils for uint256[];

    //Share 股票
    struct Share {
        uint256 shareNumber; //出资证明书编号（股票编号）
        address shareholder; //股东地址
        uint8 class; //股份类别（投资轮次）
        uint256 parValue; //票面金额（注册资本面值）
        uint256 paidInDeadline; //出资期限（时间戳）
        uint256 issueDate; //发行日期（时间戳）
        uint256 issuePrice; //发行价格（最小单位为分）
        uint256 obtainedDate; //取得日期（时间戳）
        uint256 obtainedPrice; //获取价格
        uint256 paidInDate; //实缴日期
        uint256 paidInAmount; //实缴金额
        uint8 state; //股票状态
    }

    //注册资本总额
    uint256 internal _regCap;

    //实缴出资总额
    uint256 internal _paidInCap;

    //股票编号=>股票映射
    mapping(uint256 => Share) internal _shares;

    //补票编号数组
    uint256[] internal _shareNumberList;

    function _issueShare(
        uint256 shareNumber,
        address shareholder,
        uint8 class,
        uint256 parValue,
        uint256 paidInDeadline,
        uint256 issueDate,
        uint256 issuePrice,
        uint256 obtainedDate,
        uint256 obtainedPrice,
        uint256 paidInDate,
        uint256 paidInAmount,
        uint8 state
    ) internal {
        require(shareholder != address(0), "股东地址不能为 0 ");
        require(issueDate <= now + 2 hours, "发行日不能晚于当前时间+2小时");
        require(issueDate <= paidInDeadline, "出资截止日不能早于股权发行日");
        require(
            obtainedDate == 0 || issueDate <= obtainedDate,
            "股权取得日不能早于发行日"
        );
        require(
            paidInDate == 0 || issueDate <= paidInDate,
            "实缴出资日不能早于股权发行日"
        );
        require(paidInDate <= paidInDeadline, "实缴出资日不能晚于出资截止日");

        require(paidInAmount <= parValue, "实缴出资不能超过认缴出资");

        _shares[shareNumber].shareNumber = shareNumber;
        _shares[shareNumber].shareholder = shareholder;
        _shares[shareNumber].class = class;
        _shares[shareNumber].parValue = parValue;
        _shares[shareNumber].paidInDeadline = paidInDeadline;
        _shares[shareNumber].issueDate = issueDate > 0 ? issueDate : now;
        _shares[shareNumber].issuePrice = issuePrice > 0 ? issuePrice : 1;
        _shares[shareNumber].obtainedDate = obtainedDate > 0
            ? obtainedDate
            : issueDate;
        _shares[shareNumber].obtainedPrice = obtainedPrice > 0
            ? obtainedPrice
            : issuePrice;
        _shares[shareNumber].paidInDate = paidInDate > 0 ? paidInDate : 0;
        _shares[shareNumber].paidInAmount = paidInAmount > 0 ? paidInAmount : 0;
        _shares[shareNumber].state = state > 0 ? state : 0;

        _shareNumberList.push(shareNumber);

        emit IssueShare(
            shareNumber,
            parValue,
            paidInAmount,
            _shareNumberList.length
        );
    }

    function _payInCapital(
        uint256 shareNumber,
        uint256 amount,
        uint256 paidInDate
    ) internal {
        require(
            paidInDate == 0 || paidInDate <= now + 2 hours,
            "实缴日期不能晚于当前时间+2小时"
        );

        Share storage share = _shares[shareNumber];

        require(
            paidInDate == 0 || paidInDate <= share.paidInDeadline,
            "实缴日期晚于截止日"
        );
        require(
            share.paidInAmount.add(amount) <= share.parValue,
            "实缴资金超出认缴总额"
        );

        share.paidInAmount += amount; //溢出校验已通过
        share.paidInDate = paidInDate > 0 ? paidInDate : now;

        emit PayInCapital(shareNumber, amount, share.paidInDate);
    }

    function _subAmountFromShare(
        uint256 shareNumber,
        uint256 parValue,
        uint256 paidInAmount
    ) internal {
        Share storage share = _shares[shareNumber];

        require(
            paidInAmount <= parValue && paidInAmount <= share.paidInAmount,
            "拟转让‘实缴出资’金额溢出"
        );

        share.parValue -= parValue;
        share.paidInAmount -= paidInAmount;

        emit SubAmountFromShare(shareNumber, parValue, paidInAmount);
    }

    function _deregisterShare(uint256 shareNumber) internal {
        delete _shares[shareNumber];
        _shareNumberList.removeByValue(shareNumber);

        emit DeregisterShare(shareNumber, _shareNumberList.length);
    }

    function _capIncrease(uint256 parValue, uint256 paidInAmount) internal {
        _regCap = _regCap.add(parValue);
        _paidInCap = _paidInCap.add(paidInAmount);

        emit CapIncrease(parValue, _regCap, paidInAmount, _paidInCap);
    }

    function _capDecrease(uint256 parValue, uint256 paidInAmount) internal {
        _regCap -= parValue;
        _paidInCap -= paidInAmount;

        emit CapDecrease(parValue, _regCap, paidInAmount, _paidInCap);
    }

    function _updateShareState(uint256 shareNumber, uint8 state) internal {
        Share storage share = _shares[shareNumber];
        require(share.parValue > 0, "标的股权不存在");
        share.state = state;

        emit UpdateShareState(shareNumber, state);
    }

    function getShare(uint256 shareNumber)
        external
        view
        returns (
            uint256,
            address shareholder,
            uint8 class,
            uint256 parValue,
            uint256 paidInDeadline,
            uint256 issueDate,
            uint256 issuePrice,
            uint256 obtainedDate,
            uint256 obtainedPrice,
            uint256 paidInDate,
            uint256 paidInAmount,
            uint8 state
        )
    {
        Share storage share = _shares[shareNumber];

        require(share.parValue > 0, "目标股权不存在");

        return (
            share.shareNumber,
            share.shareholder,
            share.class,
            share.parValue,
            share.paidInDeadline,
            share.issueDate,
            share.issuePrice,
            share.obtainedDate,
            share.obtainedPrice,
            share.paidInDate,
            share.paidInAmount,
            share.state
        );
    }

    function getRegCap() external view returns (uint256) {
        return _regCap;
    }

    function getPaidInCap() external view returns (uint256) {
        return _paidInCap;
    }

    function getShareNumberList() external view returns (uint256[]) {
        require(_shareNumberList.length > 0, "发行股份数量为0");
        return _shareNumberList;
    }

    function getQtyOfShares() external view returns (uint256) {
        return _shareNumberList.length;
    }
}
