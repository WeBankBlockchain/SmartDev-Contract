// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {OrderFeeFulfil} from "./LibOrderFee.sol";

struct Order {
    address client; // [160: 256]
    uint8   orderStatus; // [8: 256]       1000: publish 0100: modifly 0010: timeout 0001. submit 
    uint8   isOrderComplete; // [16: 256]   1: complete 2: in complete
    uint32  launchTime; // [48: 256]
    uint32  deadline;   // [80: 256]
    address serviceProvider; // [240: 256]

    bytes32 ipfsLink;       // Include a background or description.
    uint96 totalPrice;     // [96: 256]
    address cancelOrderUser; // [256: 256]
}

library OrderExecutor {

    using OrderFeeFulfil for *;
    uint256 private constant ORDER_STATUS_PUBLISH = 1 << 23;
    uint256 private constant ORDER_STATUS_MODIFLY = 1 << 22;
    uint256 private constant ORDER_STATUS_TIMEOUT = 1 << 21;
    uint256 private constant ORDER_STATUS_SUBMIT  = 1 << 20; 

    /// @dev Share slot 5, just like[error ORDER_REPEAT_CREATE(); error ORDER_NOT_FOUND()...]
    bytes4 private constant ORDER_REPEAT_CREATE    = 0x917996a0;
    bytes4 private constant ORDER_NOT_FOUND        = 0xb06cb8c9;
    bytes4 private constant ORDER_STATUS_REVERT    = 0x87504b96;
    bytes4 private constant ORDER_DELEGATED        = 0x2e035803;
    bytes4 private constant ORDER_EXPIRED          = 0x7811aa55;
    bytes4 private constant ORDER_PAYMENT_REVERT   = 0x1c5f2823;
    bytes4 private constant ORDER_CANNOT_DELEGATE  = 0x694d4867;
    bytes4 private constant ORDER_CANNOT_MODIFY    = 0x6a0aed0d;

    struct OrderGenerator {
        uint256 allGenerateOrderCount;
        mapping (address anyUsers => uint256 nonces) orderNonces;
    }

    struct UserOrders {
        mapping (address anyUsers => mapping(uint256 orderNonce => mapping (bytes32 orderId => Order))) orders;
        mapping (address anyUsers => mapping(uint256 orderNonce => bytes32 orderId)) orderIds;
    }

    event CreateOrder(address indexed publisher, uint256 indexed orderDeadline, uint256 indexed orderStatus, uint256 orderNonce);

    function initialize(OrderFeeFulfil.FeeConfig storage self, address initializeOwner, uint24 feeScale, uint24 feeMinScale, uint24 feeMaxScale, uint24 feeDecimal) internal {
        uint24[4] memory feeScales;
        feeScales[0] = feeScale;
        feeScales[1] = feeMinScale;
        feeScales[2] = feeMaxScale;
        feeScales[3] = feeDecimal;
        self.setFeeScale(feeScales, initializeOwner, initializeOwner);
        self.setFeeOn(initializeOwner);
    }

    function _createOrder(
        UserOrders storage self,
        OrderGenerator storage orderGenerator,
        uint256 orderNonce,
        address user,
        uint32 _deadline,
        uint96 _totalPrice,
        bytes32 _ipfsLink,
        bytes32 _signatureHash
    ) internal {
        // Ignore temporary memory request operation.
        // Order memory order = {...}
        self.orders[user][orderNonce][_signatureHash] = Order({
            client: address(0),
            orderStatus: uint8(ORDER_STATUS_PUBLISH),
            isOrderComplete: 2,
            launchTime: uint32(block.timestamp),
            deadline: _deadline,
            serviceProvider: user,
            totalPrice: _totalPrice,
            cancelOrderUser: address(0),
            ipfsLink: _ipfsLink
        });

        // End <= start
        if (_deadline <= block.timestamp) {
            assembly("memory-safe") {
                mstore(0x00, ORDER_EXPIRED)
                revert(0x00, 0x04)
            }
        }

        self.orderIds[user][orderNonce] = _signatureHash;
        incrementOrderNonces(orderGenerator, user); 
        emit CreateOrder(user, _deadline, 1, orderNonce);
    }

    function incrementOrderNonces(OrderGenerator storage self, address user) internal {
        ++self.orderNonces[user];
    }

    function acceptOrder(UserOrders storage self, address user, uint256 orderNonce, bytes32 orderId, address _client) internal {
        self.orders[user][orderNonce][orderId].client = _client;
    }

    function setCancelOrderUser(UserOrders storage self, address user, uint256 orderNonce, bytes32 orderId, address _cancelOrderUser) internal {
        self.orders[user][orderNonce][orderId].cancelOrderUser = _cancelOrderUser;
    }

    function modiflyOrderStatus(UserOrders storage self, address user, uint256 orderNonce, bytes32 orderId, uint8 status) internal {
        bool success = true;
        if (self.orders[user][orderNonce][orderId].serviceProvider != user) success = false;
        if (self.orders[user][orderNonce][orderId].isOrderComplete == 1) success = false;
        Order storage order = self.orders[user][orderNonce][orderId];
        
        uint8 currentStatus = order.orderStatus;
        assembly("memory-safe") {
            if iszero(iszero(and(currentStatus, ORDER_STATUS_PUBLISH))) {
                mstore(0x00, ORDER_CANNOT_MODIFY)
                revert(0x00, 0x04)
            }
            
            if iszero(iszero(and(currentStatus, ORDER_STATUS_TIMEOUT))) {
                mstore(0x00, ORDER_EXPIRED)
                revert(0x00, 0x04)
            }
        }

        order.orderStatus = status;
    }

    function getfeeDecimal(OrderFeeFulfil.FeeConfig storage self) internal view returns (uint256 feeDecimal) {
        (feeDecimal,,,,,,) = self._getFeeConfigParams();
    }
    
    function getFeeScale(OrderFeeFulfil.FeeConfig storage self) internal view returns (uint256 feeScale) {
        (, feeScale,,,,,) = self._getFeeConfigParams();
    }

    function getFeeOn(OrderFeeFulfil.FeeConfig storage self) internal view returns (bool feeOn) {
        (,,,,, feeOn,) = self._getFeeConfigParams();
    }

    function getFeeTo(OrderFeeFulfil.FeeConfig storage self) internal view returns (address feeTo) {
        (,,,,,, feeTo) = self._getFeeConfigParams();
    }

    function getOrderSituationByServiceProvider(UserOrders storage self, address user, uint256 orderNonce, bytes32 orderId) internal view returns (Order memory order) {
        order = self.orders[user][orderNonce][orderId];
    }

    function getOrderNonce(OrderGenerator storage self, address user) internal view returns (uint256 nonce) {
        nonce = self.orderNonces[user];
    }

    function getOrderId(UserOrders storage self, address user, uint256 orderNonce) internal view returns (bytes32 orderId) {
        orderId = self.orderIds[user][orderNonce];
    }

    function getOrderStatus(UserOrders storage self, address user, uint256 orderNonce, bytes32 orderId) internal view returns (uint8 orderStatus) {
        orderStatus = self.orders[user][orderNonce][orderId].orderStatus;
    }

    function getOrderClient(UserOrders storage self, address user, uint256 orderNonce, bytes32 orderId) internal view returns (address client) {
        client = self.orders[user][orderNonce][orderId].client;
    }

    function getOrderServiceProvider(UserOrders storage self, address user, uint256 orderNonce, bytes32 orderId) internal view returns (address serviceProvider) {
        serviceProvider = self.orders[user][orderNonce][orderId].serviceProvider;
    }
}
