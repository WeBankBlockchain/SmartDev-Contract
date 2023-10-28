pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {WonderJobArbitration, UserEstimate} from "../src/WonderJobArbitration.sol";

contract WonderJobArbitrationTest is Test {

    WonderJobArbitration internal wonderJobArbitration;

    function setUp() public {
        wonderJobArbitration = new WonderJobArbitration();
    }

    function testInitializeUserEstimate() public {
        address user = makeAddr("user");
        vm.label(user, "user");
        vm.prank(user);
        wonderJobArbitration.initializeUserEstimate(user);
        UserEstimate memory userEstimate = wonderJobArbitration.getUserEstimate(user);
        // Initialize creidit score success.
        // userEstimate ← tuple(50, 0, 0, 0, 0, 0, false, true)
        assertEq(userEstimate.creditScore, 50);
    }

    function testTryTransferCreditScore() public {
        address from = makeAddr("from");
        vm.label(from, "from");   
        address to = makeAddr("to");
        vm.label(to, "to");
        wonderJobArbitration.initializeUserEstimate(from);
        wonderJobArbitration.initializeUserEstimate(to);

        vm.startPrank(from);
        wonderJobArbitration.tryTransferCreditScore(to, 50);
        UserEstimate memory fromEstimate = wonderJobArbitration.getUserEstimate(from);
        assertEq(fromEstimate.creditScore, 0);
        vm.stopPrank();

        vm.startPrank(to);
        UserEstimate memory toEstimate = wonderJobArbitration.getUserEstimate(to);
        assertEq(toEstimate.creditScore, 100);
        vm.stopPrank();
    }

    function testGetUserEstimate() public {
        address user = makeAddr("user");
        vm.label(user, "user");
        vm.prank(user);
        UserEstimate memory userEstimate = wonderJobArbitration.getUserEstimate(user);
        console.log("*##### User estimate situation ######*");
        console.logUint(userEstimate.creditScore);
        console.logUint(userEstimate.completedOrdersCount);
        console.logUint(userEstimate.disputedOrdersCount);
        console.logUint(userEstimate.cancelledOrdersCount);
        console.logUint(userEstimate.totalSpent);
        console.logUint(userEstimate.totalEarned);
    }

    function testGetResolveDisputeFee() public {
        uint256 fee = wonderJobArbitration.getResolveDisputeFee();
        assertEq(fee, 0.01 ether);
    }
}