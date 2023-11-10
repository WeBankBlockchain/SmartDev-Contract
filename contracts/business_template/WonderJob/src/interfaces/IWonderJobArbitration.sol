// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Order} from "../libraries/OrderExecutor.sol";
import {UserEstimate} from "../WonderJobArbitration.sol";

interface IWonderJobArbitration {
    function initializeUserEstimate(address user) external;
    function orderValidatorCallWithFallback(address user, Order calldata params) external;
    function tryTransferCreditScore(address to, uint256 amount) external returns (bool);
    function getUserEstimate(address user) external view returns (UserEstimate memory userEstimate);
}