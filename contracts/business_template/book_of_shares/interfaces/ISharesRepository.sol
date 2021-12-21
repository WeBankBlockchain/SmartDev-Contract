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

interface ISharesRepository {
    event IssueShare(
        uint256 indexed shareNumber,
        uint256 parValue,
        uint256 paidInAmount,
        uint256 qtyOfShares
    );

    event PayInCapital(
        uint256 indexed shareNumber,
        uint256 amount,
        uint256 paidInDate
    );

    event SubAmountFromShare(
        uint256 indexed shareNumber,
        uint256 parValue,
        uint256 paidInAmount
    );

    event CapIncrease(
        uint256 parValue,
        uint256 regCap,
        uint256 paidInAmount,
        uint256 paiInCap
    );

    event CapDecrease(
        uint256 parValue,
        uint256 regCap,
        uint256 paidInAmount,
        uint256 paidInCap
    );

    event DeregisterShare(uint256 indexed shareNumber, uint256 qtyOfShares);

    event UpdateShareState(uint256 indexed shareNumber, uint8 state);

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
        );

    function getRegCap() external view returns (uint256);

    function getPaidInCap() external view returns (uint256);

    function getShareNumberList() external view returns (uint256[]);

    function getQtyOfShares() external view returns (uint256);
}
