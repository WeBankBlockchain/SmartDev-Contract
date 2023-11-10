// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "./interfaces/IWonderJobArbitration.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import {Order} from "./libraries/OrderExecutor.sol";

struct UserEstimate {
    uint32  creditScore;  // [32: 256] creditScore offset: 0~3
    uint32  completedOrdersCount; // [64: 256] completedOrdersCount offset: 4~7
    uint32  disputedOrdersCount;  // [96: 256] disputedOrdersCount offset: 8~11
    uint32  cancelledOrdersCount; // [128： 256] cancelledOrdersCount offset: 12~15
    uint32  totalSpent;  // [160: 256] totalSpent offset: 16~19
    uint32  totalEarned; // [192: 256] totalEarned offset: 20~23

    bool    isBlockListedUser; // isBlockListedUser offset: 24~27
    bool    initialized;
}
/*
struct Dispute {

    bool resolved;
}*/

type DisputeUser is address;

contract WonderJobArbitration is IWonderJobArbitration, Ownable {

    error UserHasInitializedUserEstimate();
    error InsufficientCreitScore(uint256 creitScore);
    error CreditScoreIsZero();

    /// @dev slot 0x00
    /// _owner slot 0x01
    address public implementation;

    /// @dev slot 0x02
    uint256 private RESOLVE_DISPUTE_FEE = 0.01 ether;
    uint256 public constant MIN_CREIT_SCORE_FALLBACK = 10;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                   😈😈 CREDIT PUNISHMENT                   */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
    uint256 public constant CANCEL_ORDER_PUNISHMENT_SCORE = 2;
    uint256 public constant TIMEOUT_ORDER_PUNISHMENT_SCORE = 5;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                      👼👼 CREDIT REWARD                    */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
    uint256 public constant FIRST_TIME_COMPLETE_ORDER_REWARD_REWARD = 5;

    uint256 public constant MIN_CREDIT_SCORE = 50;
    // 👑 WonderJob king
    uint256 public constant MAX_CREDIT_SCORE = 10000;
    uint256 public constant EXTRA_CREDIT_SCORE = 150;

    // mapping (DisputeUser => Dispute) private _userDispute;
    mapping (address anyUsers => UserEstimate) private _userEstimate;

    /// @dev The `Transfer` event signature is given by
    /// Transfer(address indexed sender, address indexed receiver, uint256 amount);
    bytes32 constant transferHash = 0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;

    constructor() Ownable(msg.sender) {}

/*
    modifier onlyWonderJobImplementation() {
        assembly {
            if iszero(caller(), sload(0)) {
                revert(0, 0)
            }
        }
        _;
    }*/

    function initializeUserEstimate(address user) public {
        UserEstimate storage userEstimate = _userEstimate[user];
        userEstimate.creditScore = uint32(MIN_CREDIT_SCORE);

        //if (userEstimate.initialized) revert UserHasInitializedUserEstimate();
        userEstimate.initialized = true;
    }

    function tryTransferCreditScore(address to, uint256 amount) public returns (bool) {
        assembly("memory-safe") {
            let memptr := mload(0x40)
            mstore(memptr, caller())
            mstore(add(memptr, 0x20), _userEstimate.slot)
            let fromSlot := keccak256(memptr, 0x40)
            let fromBalance := sload(add(fromSlot, 0))
            if lt(fromBalance, amount) {
                revert(0, 0)
            }
            if eq(caller(), to) { revert(0, 0) }

            sstore(fromSlot, sub(fromBalance, amount))

            // Reload `to` memptr
            mstore(memptr, to)
            mstore(add(memptr, 0x20), _userEstimate.slot)
            let toSlot := keccak256(memptr, 0x40)
            let toBalance := sload(add(toSlot, 0))
            sstore(toSlot, add(toBalance, amount))

            log3(0x00, 0x20, transferHash, caller(), to)
        }
        return true;
    }

    function orderValidatorCallWithFallback(address user, Order calldata params) public {
        // Skip read from memory
        UserEstimate storage currencyUserEstimate = _userEstimate[user];
        UserEstimate storage clientOrderUserEstimate = _userEstimate[params.client];
        UserEstimate storage cancelOrderUserEstimate = _userEstimate[params.cancelOrderUser];

        uint32 creditScore;
        if (currencyUserEstimate.creditScore < MIN_CREIT_SCORE_FALLBACK) revert CreditScoreIsZero();
        if (params.cancelOrderUser != address(0)) {            
            assembly {
                creditScore := and(CANCEL_ORDER_PUNISHMENT_SCORE, 0xFFFFFFFF)
            }
            // TODO: overflow-safe
            cancelOrderUserEstimate.creditScore = cancelOrderUserEstimate.creditScore >= creditScore
                ? cancelOrderUserEstimate.creditScore - creditScore
                : 0;
        }

        if (params.orderStatus & uint(0x4) != 0) {
            assembly {
                creditScore := and(TIMEOUT_ORDER_PUNISHMENT_SCORE, 0xFFFFFFFF)
            }
            clientOrderUserEstimate.creditScore = clientOrderUserEstimate.creditScore >= creditScore
                ? clientOrderUserEstimate.creditScore - creditScore
                : 0;
        }

        if (currencyUserEstimate.creditScore < MAX_CREDIT_SCORE) {
            if (user == params.serviceProvider) {
                if (clientOrderUserEstimate.completedOrdersCount == 0) {
                    assembly {
                        creditScore := and(FIRST_TIME_COMPLETE_ORDER_REWARD_REWARD, 0xFFFFFFFF)
                    }
                    unchecked {
                        clientOrderUserEstimate.creditScore += creditScore;
                    }
                }
            }
        }
    }

    function setResolveDisputeFee(uint256 newResolveDisputeFee) public onlyOwner {
        RESOLVE_DISPUTE_FEE = newResolveDisputeFee;
    }

    function getResolveDisputeFee() public view returns (uint256 fee) {
        assembly {
            fee := sload(0x02)
        }
    }

    function getUserEstimate(address user) public view returns (UserEstimate memory userEstimate) {
        userEstimate = _userEstimate[user];
    }
}
