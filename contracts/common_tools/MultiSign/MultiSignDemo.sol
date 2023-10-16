// SPDX-License-Identifier: UNLICENSED
/// @author Steve Jin

pragma solidity >=0.8.0;

import {MultiSign} from "./MultiSign.sol";
 
contract MultiSignDemo is MultiSign {

    event MultiSignLog(address from, address to, bytes data, address[] signers, uint signCount);

    address public owner;

    uint public signFinishedCallBackCount = 0;

    constructor(address[] memory addressParams, uint minSignaturesParam) MultiSign(addressParams, minSignaturesParam) {
        owner = msg.sender;
    }

    function signFinishedCallBack(Transaction storage transaction) override internal {
        emit MultiSignLog(transaction.from, transaction.to, transaction.data, transaction.signers, transaction.signCount);
        signFinishedCallBackCount++;
    }

}