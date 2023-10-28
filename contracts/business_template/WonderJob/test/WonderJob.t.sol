// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {WonderJob} from "../src/wonderJob.sol";
import {UserEstimate, WonderJobArbitration} from "../src/WonderJobArbitration.sol";
import {User} from "../src/libraries/UserManagement.sol";

contract WonderJobTest is Test {

    uint256 FORK_FIX_BLOCK_NUMBER = 1_840_530_8;
    uint256 GLOBAL_UNIX_TIMESTAMP = 1_697_978_416;

    string[5] RPC_LISTS = [
        "https://eth.llamarpc.com",         // Mainnet
        "https://arbitrum.llamarpc.com"     // Arbitrum
        "https://optimism.llamarpc.com"     // Optimism
        "https://polygon.llamarpc.com"      // Polygon
    ];
    uint256[5] FORK_RPC_LISTS;
    address userAddress;
    uint256 userAddressPrivateKey;
    address owner;

    WonderJob wonderJob;
    WonderJobArbitration IWonderJobArbitration;

    function setUp() public {
        (userAddress, userAddressPrivateKey) = makeAddrAndKey('userAddress');
        owner = makeAddr("owner");
        vm.label(owner, "owner");

        vm.startPrank(owner);
        IWonderJobArbitration = new WonderJobArbitration();
        wonderJob = new WonderJob(address(IWonderJobArbitration));
        vm.stopPrank();

        // /*========== MULIT FORK MAINNET TEST ==========**/
        //FORK_RPC_LISTS[0] = vm.createFork(RPC_LISTS[0], FORK_FIX_BLOCK_NUMBER);
        //FORK_RPC_LISTS[1] = vm.createFork(RPC_LISTS[1], FORK_FIX_BLOCK_NUMBER);
        //FORK_RPC_LISTS[2] = vm.createFork(RPC_LISTS[2], FORK_FIX_BLOCK_NUMBER);
        //FORK_RPC_LISTS[3] = vm.createFork(RPC_LISTS[3], FORK_FIX_BLOCK_NUMBER);
    }

    /*//////////////////////////////////////////////////////////////////////////
                            USER MANAGEMENT FUNCTIONS
    //////////////////////////////////////////////////////////////////////////*/
    function testCreateUser() public {
        //vm.selectFork(FORK_RPC_LISTS[0]);
        vm.warp(GLOBAL_UNIX_TIMESTAMP);
        User memory user = User(userAddress, true, false, false, GLOBAL_UNIX_TIMESTAMP);
        wonderJob.createUser(user);

        vm.startPrank(userAddress);
        user = wonderJob.getUserProfile();
        console.log("User adddress: %s", user.userAddress);
        console.log("User is a customer: %s", user.isCustomer);
        console.log("User is a serviceProvider: %s: ", user.isServiceProvider);
        console.log("User register status: %s", user.isRegistered);
        console.log("User register time: %s", user.creationTime);
        vm.stopPrank();
    }

    function testCreateUserExpectReverts() public {
        vm.warp(GLOBAL_UNIX_TIMESTAMP);
        User memory user = User(userAddress, true, true, false, GLOBAL_UNIX_TIMESTAMP);
        wonderJob.createUser(user);

        // Repeat register user
        // skip `USER_HAS_BEEN_CREATED_REVERT` reverted.
        vm.expectRevert();
        wonderJob.createUser(user);
    }

    /*//////////////////////////////////////////////////////////////////////////
                            ORDER OPERATION FUNCTIONS 
    //////////////////////////////////////////////////////////////////////////*/
    function testCreateOrder() public {
        (address createOrderUser, uint256 createOrderUserPrivateKey) = makeAddrAndKey('createOrderUser');
        vm.label(createOrderUser, "serviceProvider");
        vm.deal(createOrderUser, 1 ether);
        User memory user = User(createOrderUser, true, true, true, GLOBAL_UNIX_TIMESTAMP);
        wonderJob.createUser(user);

        uint32 orderDeadline = uint32(GLOBAL_UNIX_TIMESTAMP) + uint32(1 days);
        uint96 orderPrice = 0.1 ether;
        bytes32 ipfsLink = bytes32(bytes("https://ipfs.io/ipfs/QmNZiPk974vDsPmQii3YbrMKfi12KTSNM7XMiYyiea4VYZ/example"));
        uint256 nonce = wonderJob.getOrderNonce(createOrderUser);
        bytes32 digest = bytes32(abi.encodePacked(orderDeadline, orderPrice, ipfsLink, nonce));

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(createOrderUserPrivateKey, digest);

        vm.startPrank(createOrderUser);
        wonderJob.createOrder{value: 0.1 ether}(orderDeadline, orderPrice, ipfsLink, digest, v, r, s);
    }

    function testCreateOrderExpectReverts() public {
        (address createOrderUser, uint256 createOrderUserPrivateKey) = makeAddrAndKey('createOrderUser');
        vm.label(createOrderUser, "serviceProvider");
        vm.deal(createOrderUser, 1 ether);
        User memory user = User(createOrderUser, true, true, true, GLOBAL_UNIX_TIMESTAMP);
        wonderJob.createUser(user);

        uint32 orderDeadline = uint32(GLOBAL_UNIX_TIMESTAMP) + uint32(1 days);
        uint96 orderPrice = 0.1 ether;
        bytes32 ipfsLink = bytes32(bytes("https://ipfs.io/ipfs/QmNZiPk974vDsPmQii3YbrMKfi12KTSNM7XMiYyiea4VYZ/example"));
        uint256 nonce = wonderJob.getOrderNonce(createOrderUser);
        bytes32 digest = bytes32(abi.encodePacked(orderDeadline, orderPrice, ipfsLink, nonce));

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(createOrderUserPrivateKey, digest);

        vm.startPrank(createOrderUser);
        vm.expectRevert();
        wonderJob.createOrder{value: 0.01 ether}(orderDeadline, orderPrice, ipfsLink, digest, v, r, s);
    
    }

    function testAcceptOrder() public {
        // Create order
        (address createOrderUser, uint256 createOrderUserPrivateKey) = makeAddrAndKey('userA');
        vm.label(createOrderUser, "serviceProvider");
        vm.deal(createOrderUser, 1 ether);
        User memory user = User(createOrderUser, true, true, true, GLOBAL_UNIX_TIMESTAMP);
        wonderJob.createUser(user);

        uint32 orderDeadline = uint32(GLOBAL_UNIX_TIMESTAMP) + uint32(1 days);
        uint96 orderPrice = 0.1 ether;
        bytes32 ipfsLink = bytes32(bytes("https://ipfs.io/ipfs/QmNZiPk974vDsPmQii3YbrMKfi12KTSNM7XMiYyiea4VYZ/example"));
        uint256 nonce = wonderJob.getOrderNonce(createOrderUser);
        bytes32 digest = bytes32(abi.encodePacked(orderDeadline, orderPrice, ipfsLink, nonce));

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(createOrderUserPrivateKey, digest);

        vm.startPrank(createOrderUser);
        wonderJob.createOrder{value: 0.1 ether}(orderDeadline, orderPrice, ipfsLink, digest, v, r, s);
        uint256 orderNonce = wonderJob.getOrderNonce(createOrderUser);
        console.logUint(orderNonce);
        vm.stopPrank();

        // Accept order
        address clientUser = makeAddr("userB");
        vm.label(clientUser, "client");
        vm.deal(clientUser, 1 ether);
        User memory client = User(clientUser, true, true, true, GLOBAL_UNIX_TIMESTAMP);
        wonderJob.createUser(client);

        vm.startPrank(clientUser);
        vm.label(clientUser, "client");
        vm.deal(clientUser, 1 ether);
        wonderJob.depositEscrowFundWithClient(1 ether);
        wonderJob.acceptOrder(createOrderUser, 0);
        vm.stopPrank();
    }

    function testAcceptOrderExpectReverts() public {
        // Create order
        (address createOrderUser, uint256 createOrderUserPrivateKey) = makeAddrAndKey('acceptOrderUserB');
        vm.label(createOrderUser, "serviceProvider");
        vm.deal(createOrderUser, 1 ether);
        User memory user = User(createOrderUser, true, true, true, GLOBAL_UNIX_TIMESTAMP);
        wonderJob.createUser(user);

        uint32 orderDeadline = uint32(GLOBAL_UNIX_TIMESTAMP) + uint32(1 days);
        uint96 orderPrice = 0.1 ether;
        bytes32 ipfsLink = bytes32(bytes("https://ipfs.io/ipfs/QmNZiPk974vDsPmQii3YbrMKfi12KTSNM7XMiYyiea4VYZ/example"));
        uint256 nonce = wonderJob.getOrderNonce(createOrderUser);
        bytes32 digest = bytes32(abi.encodePacked(orderDeadline, orderPrice, ipfsLink, nonce));

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(createOrderUserPrivateKey, digest);

        vm.startPrank(createOrderUser);
        wonderJob.createOrder{value: 0.1 ether}(orderDeadline, orderPrice, ipfsLink, digest, v, r, s);
        vm.startPrank(createOrderUser);
        uint256 orderNonce = wonderJob.getOrderNonce(createOrderUser);
        console.logUint(orderNonce);
        vm.stopPrank();


        // Accept order
        address clientUser = makeAddr("acceptOrderClientB");
        vm.label(clientUser, "acceptOrderClient");
        vm.deal(clientUser, 1 ether);
        User memory client = User(clientUser, true, true, true, GLOBAL_UNIX_TIMESTAMP);
        wonderJob.createUser(client);

        vm.startPrank(clientUser);
        
        ///wonderJob.depositEscrowFundWithClient(1 ether);
        vm.expectRevert(bytes( "The user escrow fund balance is zero"));

        wonderJob.acceptOrder(createOrderUser, 0);
        vm.stopPrank();   
    }

    function testSubmitOrder() public {
        // Create Order
        address createOrderUser;
        uint256 createOrderUserPrivateKey;
        uint256 orderNonce;
        {
            (createOrderUser, createOrderUserPrivateKey) = makeAddrAndKey('acceptOrder');
            vm.label(createOrderUser, "serviceProvider");
            vm.deal(createOrderUser, 1 ether);
            User memory user = User(createOrderUser, true, true, true, GLOBAL_UNIX_TIMESTAMP);
            wonderJob.createUser(user);

            uint32 orderDeadline = uint32(GLOBAL_UNIX_TIMESTAMP) + uint32(1 days);
            uint96 orderPrice = 0.1 ether;
            bytes32 ipfsLink = bytes32(bytes("https://ipfs.io/ipfs/QmNZiPk974vDsPmQii3YbrMKfi12KTSNM7XMiYyiea4VYZ/example"));
            uint256 nonce = wonderJob.getOrderNonce(createOrderUser);
            bytes32 digest = bytes32(abi.encodePacked(orderDeadline, orderPrice, ipfsLink, nonce));

            (uint8 v, bytes32 r, bytes32 s) = vm.sign(createOrderUserPrivateKey, digest);

            vm.startPrank(createOrderUser);
            wonderJob.createOrder{value: 0.1 ether}(orderDeadline, orderPrice, ipfsLink, digest, v, r, s);
            orderNonce = wonderJob.getOrderNonce(createOrderUser);
            console.logUint(orderNonce);
            vm.stopPrank();
        }

        {
            // Accept order
            address clientUser = makeAddr("client");
            vm.label(clientUser, "client");
            vm.deal(clientUser, 1 ether);
            vm.startPrank(clientUser);
            User memory client = User(clientUser, true, true, true, GLOBAL_UNIX_TIMESTAMP);
            wonderJob.createUser(client);
            wonderJob.depositEscrowFundWithClient(1 ether);
            wonderJob.acceptOrder(createOrderUser, 0);
            // Submit order
            wonderJob.submitOrder(createOrderUser, 0);
            vm.stopPrank();
        }
    }

    function testSubmitOrderExpectReverts() public {
        // Create Order
        address createOrderUser;
        uint256 createOrderUserPrivateKey;
        uint256 orderNonce;
        {
            (createOrderUser, createOrderUserPrivateKey) = makeAddrAndKey('acceptOrder');
            vm.label(createOrderUser, "serviceProvider");
            vm.deal(createOrderUser, 1 ether);
            User memory user = User(createOrderUser, true, true, true, GLOBAL_UNIX_TIMESTAMP);
            wonderJob.createUser(user);

            uint32 orderDeadline = uint32(GLOBAL_UNIX_TIMESTAMP) + uint32(1 days);
            uint96 orderPrice = 0.1 ether;
            bytes32 ipfsLink = bytes32(bytes("https://ipfs.io/ipfs/QmNZiPk974vDsPmQii3YbrMKfi12KTSNM7XMiYyiea4VYZ/example"));
            uint256 nonce = wonderJob.getOrderNonce(createOrderUser);
            bytes32 digest = bytes32(abi.encodePacked(orderDeadline, orderPrice, ipfsLink, nonce));

            (uint8 v, bytes32 r, bytes32 s) = vm.sign(createOrderUserPrivateKey, digest);

            vm.startPrank(createOrderUser);
            wonderJob.createOrder{value: 0.1 ether}(orderDeadline, orderPrice, ipfsLink, digest, v, r, s);
            orderNonce = wonderJob.getOrderNonce(createOrderUser);
            console.logUint(orderNonce);
            vm.stopPrank();
        }

        {
            // Accept order
            address clientUser = makeAddr("client");
            vm.label(clientUser, "client");
            vm.deal(clientUser, 1 ether);
            vm.startPrank(clientUser);
            User memory client = User(clientUser, true, true, true, GLOBAL_UNIX_TIMESTAMP);
            wonderJob.createUser(client);
            wonderJob.depositEscrowFundWithClient(1 ether);
            wonderJob.acceptOrder(createOrderUser, 0);
            // Submit order
            vm.expectRevert();
            wonderJob.submitOrder(address(0), 0);
            vm.stopPrank();
        }
    }

    function testCancelOrderWithServiceProvider() public {
        // Create Order
        address createOrderUser;
        uint256 createOrderUserPrivateKey;
        uint256 orderNonce;
        {
            (createOrderUser, createOrderUserPrivateKey) = makeAddrAndKey('cancelOrderUser');
            vm.label(createOrderUser, "serviceProvider");
            vm.deal(createOrderUser, 1 ether);
            User memory user = User(createOrderUser, true, true, true, GLOBAL_UNIX_TIMESTAMP);
            wonderJob.createUser(user);

            uint32 orderDeadline = uint32(GLOBAL_UNIX_TIMESTAMP) + uint32(1 days);
            uint96 orderPrice = 0.1 ether;
            bytes32 ipfsLink = bytes32(bytes("https://ipfs.io/ipfs/QmNZiPk974vDsPmQii3YbrMKfi12KTSNM7XMiYyiea4VYZ/example"));
            uint256 nonce = wonderJob.getOrderNonce(createOrderUser);
            bytes32 digest = bytes32(abi.encodePacked(orderDeadline, orderPrice, ipfsLink, nonce));

            (uint8 v, bytes32 r, bytes32 s) = vm.sign(createOrderUserPrivateKey, digest);

            vm.startPrank(createOrderUser);
            wonderJob.createOrder{value: 0.1 ether}(orderDeadline, orderPrice, ipfsLink, digest, v, r, s);
            orderNonce = wonderJob.getOrderNonce(createOrderUser);
            console.logUint(orderNonce);
            vm.stopPrank();
        }

        {
            // Accept order
            address clientUser = makeAddr("cancelOrderClient");
            vm.label(clientUser, "client");
            vm.deal(clientUser, 1 ether);
            vm.startPrank(clientUser);
            User memory client = User(clientUser, true, true, true, GLOBAL_UNIX_TIMESTAMP);
            wonderJob.createUser(client);
            wonderJob.depositEscrowFundWithClient(1 ether);
            wonderJob.acceptOrder(createOrderUser, 0);
            // Cancel order
            wonderJob.cancelOrder(createOrderUser, 0);

            IWonderJobArbitration.getUserEstimate(clientUser);
            IWonderJobArbitration.getUserEstimate(createOrderUser);
            vm.stopPrank();
        }
    }

    function testCompleteOrder() public {
        // Create Order
        address createOrderUser;
        uint256 createOrderUserPrivateKey;
        uint256 orderNonce;
        {
            (createOrderUser, createOrderUserPrivateKey) = makeAddrAndKey('cancelOrderUser');
            vm.label(createOrderUser, "serviceProvider");
            vm.deal(createOrderUser, 1 ether);
            User memory user = User(createOrderUser, true, true, true, GLOBAL_UNIX_TIMESTAMP);
            wonderJob.createUser(user);

            uint32 orderDeadline = uint32(GLOBAL_UNIX_TIMESTAMP) + uint32(1 days);
            uint96 orderPrice = 0.1 ether;
            bytes32 ipfsLink = bytes32(bytes("https://ipfs.io/ipfs/QmNZiPk974vDsPmQii3YbrMKfi12KTSNM7XMiYyiea4VYZ/example"));
            uint256 nonce = wonderJob.getOrderNonce(createOrderUser);
            bytes32 digest = bytes32(abi.encodePacked(orderDeadline, orderPrice, ipfsLink, nonce));

            (uint8 v, bytes32 r, bytes32 s) = vm.sign(createOrderUserPrivateKey, digest);

            vm.startPrank(createOrderUser);
            wonderJob.createOrder{value: 0.1 ether}(orderDeadline, orderPrice, ipfsLink, digest, v, r, s);
            orderNonce = wonderJob.getOrderNonce(createOrderUser);
            console.logUint(orderNonce);
            vm.stopPrank();
        }

        {
            // Accept order
            address clientUser = makeAddr("cancelOrderClient");
            vm.label(clientUser, "client");
            vm.deal(clientUser, 1 ether);
            vm.startPrank(clientUser);
            User memory client = User(clientUser, true, true, true, GLOBAL_UNIX_TIMESTAMP);
            wonderJob.createUser(client);
            wonderJob.depositEscrowFundWithClient(1 ether);
            wonderJob.acceptOrder(createOrderUser, 0);
            vm.stopPrank();

            vm.startPrank(createOrderUser);
            // Complete order
            bytes32 orderId = wonderJob.getOrderId(0);
            wonderJob.completeOrder(orderId);

            IWonderJobArbitration.getUserEstimate(clientUser);
            IWonderJobArbitration.getUserEstimate(createOrderUser);
            vm.stopPrank();
        }
    }

    function testCompleteOrderWithFeeOn() public {
        // set fee
        vm.startPrank(owner);
        uint24[4] memory feeScales;
        feeScales[0] = 10;
        feeScales[1] = 5;
        feeScales[2] = 15;
        feeScales[3] = 1;
        wonderJob.setFeeConfig(feeScales, address(0));
        wonderJob.setFee(true);
        vm.stopPrank();

        // Create Order
        address createOrderUser;
        uint256 createOrderUserPrivateKey;
        uint256 orderNonce;
        {
            (createOrderUser, createOrderUserPrivateKey) = makeAddrAndKey('cancelOrderUser');
            vm.label(createOrderUser, "serviceProvider");
            vm.deal(createOrderUser, 1 ether);
            User memory user = User(createOrderUser, true, true, true, GLOBAL_UNIX_TIMESTAMP);
            wonderJob.createUser(user);

            uint32 orderDeadline = uint32(GLOBAL_UNIX_TIMESTAMP) + uint32(1 days);
            uint96 orderPrice = 0.1 ether;
            bytes32 ipfsLink = bytes32(bytes("https://ipfs.io/ipfs/QmNZiPk974vDsPmQii3YbrMKfi12KTSNM7XMiYyiea4VYZ/example"));
            uint256 nonce = wonderJob.getOrderNonce(createOrderUser);
            bytes32 digest = bytes32(abi.encodePacked(orderDeadline, orderPrice, ipfsLink, nonce));

            (uint8 v, bytes32 r, bytes32 s) = vm.sign(createOrderUserPrivateKey, digest);

            vm.startPrank(createOrderUser);
            wonderJob.createOrder{value: 0.1 ether}(orderDeadline, orderPrice, ipfsLink, digest, v, r, s);
            orderNonce = wonderJob.getOrderNonce(createOrderUser);
            console.logUint(orderNonce);
            vm.stopPrank();
        }

        {
            // Accept order
            address clientUser = makeAddr("cancelOrderClient");
            vm.label(clientUser, "client");
            vm.deal(clientUser, 1 ether);
            vm.startPrank(clientUser);
            User memory client = User(clientUser, true, true, true, GLOBAL_UNIX_TIMESTAMP);
            wonderJob.createUser(client);
            wonderJob.depositEscrowFundWithClient(1 ether);
            wonderJob.acceptOrder(createOrderUser, 0);
            vm.stopPrank();

            vm.startPrank(createOrderUser);
            // Complete order
            bytes32 orderId = wonderJob.getOrderId(0);
            wonderJob.completeOrder(orderId);

            IWonderJobArbitration.getUserEstimate(clientUser);
            IWonderJobArbitration.getUserEstimate(createOrderUser);
            vm.stopPrank();
        }
    }
}