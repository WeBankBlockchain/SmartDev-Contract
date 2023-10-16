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

contract IMembersRepository {
    event AddMember(address indexed acct, uint256 qtyOfMembers);
    event RemoveMember(address indexed acct, uint256 qtyOfMembers);

    event AddShareToMember(uint256 indexed shareNumber, address indexed acct);
    event RemoveShareFromMember(
        uint256 indexed shareNumber,
        address indexed acct
    );

    event PayInCapitalToMember(address indexed acct, uint256 amount);
    event SubAmountFromMember(
        address indexed acct,
        uint256 parValue,
        uint256 paidInAmount
    );

    function isMember(address acct) external view returns (bool);

    function getMember(address acct)
        external
        view
        returns (
            uint256[],
            uint256,
            uint256
        );

    function getMemberAcctList() external view returns (address[]);

    function getQtyOfMembers() external view returns (uint256);
}
