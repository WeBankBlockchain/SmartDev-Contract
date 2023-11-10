// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {User, UserManagement} from "./libraries/UserManagement.sol";
import {OrderExecutor, Order} from "./libraries/OrderExecutor.sol";
import {OrderFeeFulfil} from "./libraries/LibOrderFee.sol";
import {WonderJobFundEscrowPool} from "./WonderJobFundEscrowPool.sol";
import {ECDSA} from "./utils/ECDSA.sol";
import "./interfaces/IWonderJobArbitration.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

/// *********************************************************************************************************
/// *                                                                                                       *
/// *                                                                                                       *
/// *     $$\      $$\                           $$\                        $$$$$\           $$\            *
/// *     $$ | $\  $$ |                          $$ |                       \__$$ |          $$ |           *
/// *     $$ |$$$\ $$ | $$$$$$\  $$$$$$$\   $$$$$$$ | $$$$$$\   $$$$$$\        $$ | $$$$$$\  $$$$$$$\       *
/// *     $$ $$ $$\$$ |$$  __$$\ $$  __$$\ $$  __$$ |$$  __$$\ $$  __$$\       $$ |$$  __$$\ $$  __$$\      *
/// *     $$$$  _$$$$ |$$ /  $$ |$$ |  $$ |$$ /  $$ |$$$$$$$$ |$$ |  \__|$$\   $$ |$$ /  $$ |$$ |  $$ |     *
/// *     $$$  / \$$$ |$$ |  $$ |$$ |  $$ |$$ |  $$ |$$   ____|$$ |      $$ |  $$ |$$ |  $$ |$$ |  $$ |     *
/// *     $$  /   \$$ |\$$$$$$  |$$ |  $$ |\$$$$$$$ |\$$$$$$$\ $$ |      \$$$$$$  |\$$$$$$  |$$$$$$$  |     *
/// *     \__/     \__| \______/ \__|  \__| \_______| \_______|\__|       \______/  \______/ \_______/      *
/// *                                                                                                       *
/// *                                                                                                       *
/// *********************************************************************************************************
error UserHasNoAuthorization();
error InvalidSignature(bytes32 signatureHash);
error OrderInModify();
error OrderAccepted();
error InvalidOrderNonce(uint256 orderNonce);
error InvalidOrderClient();
error InsufficientEscrowAmount(uint128 escrowAmount);
error ClientIsTakeOrder();
error OrderException();

contract WonderJobV2 is WonderJobFundEscrowPool, Initializable, OwnableUpgradeable {

    using ECDSA for bytes32;
    using OrderExecutor for *;
    using UserManagement for UserManagement.UsersOperation;
    using OrderFeeFulfil for OrderFeeFulfil.FeeConfig;
    
    IWonderJobArbitration public immutable WonderJobArbitration;
    UserManagement.UsersOperation private _usersOperation;
    OrderExecutor.OrderGenerator private _orderGenerator;
    OrderExecutor.UserOrders private _userOrders;
    OrderFeeFulfil.FeeConfig public feeConfig;

    constructor(address IWonderJobArbitrationAddress) WonderJobFundEscrowPool(1e14) initializer {
        __Ownable_init(msg.sender);
        WonderJobArbitration = IWonderJobArbitration(IWonderJobArbitrationAddress);
        // feeConfig.initialize();
    }


    uint256 public signatureInProgress = 1;
    /// @dev High rise point => Avoid identical signature replay attacks.
    /// See https://twitter.com/nl__park/status/1680936278303580160
    modifier signatureInProgressLocker() {
        require(signatureInProgress == 1, "Signature is inn progress");
        signatureInProgress = 2;
        _;
        signatureInProgress = 1;
    }

    function createUser(User calldata user) public {
        _usersOperation.createUser(user);
        WonderJobArbitration.initializeUserEstimate(user.userAddress);
    }

    function createOrder(
        uint32 orderDeadline,
        uint96 orderPrice, 
        bytes32 ipfsLink,
        bytes32 hash,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external payable signatureInProgressLocker {
        if (!_usersOperation.getUserCustomer(_msgSender()) || !_usersOperation.getUserServiceProvider(_msgSender())) revert UserHasNoAuthorization();
        if (msg.value < orderPrice) revert InsufficientFunds(msg.value);

        uint256 nonce = getOrderNonce(_msgSender());

        if (_userOrders.getOrderServiceProvider(_msgSender(), nonce, hash) != address(0)) revert OrderException();
        if (_msgSender() != hash.recover(v, r, s)) revert InvalidSignature(hash);
        _userOrders._createOrder(
            _orderGenerator,
            nonce,
            _msgSender(),
            orderDeadline,
            orderPrice,
            ipfsLink,
            hash
        );

        _depositEscrowFund(orderPrice, hash);
    }

    function acceptOrder(address serviceProvider, uint256 orderNonce) external {
        if (orderNonce > getOrderNonce(serviceProvider)) revert InvalidOrderNonce(orderNonce);
        bytes32 orderId = _userOrders.getOrderId(serviceProvider, orderNonce);
        if (_userOrders.getOrderServiceProvider(
                serviceProvider, 
                orderNonce,
                orderId
            ) == address(0)
            || _userOrders.getOrderServiceProvider(
                serviceProvider,
                orderNonce, 
                orderId
            ) != serviceProvider
        ) revert OrderException();

        if (!_usersOperation.getUserCustomer(_msgSender())) revert UserHasNoAuthorization();
        if (_userOrders.getOrderStatus(serviceProvider, orderNonce, orderId) & uint8(0x4) != 0) revert OrderInModify();
        if (_userOrders.getOrderClient(serviceProvider, orderNonce, orderId) != address(0)) revert OrderAccepted();
        
        require(getClientEscrowFundBalanceof() > 0, "The user escrow fund balance is zero");
        _userOrders.acceptOrder(serviceProvider, orderNonce, orderId, _msgSender());
    }

    function depositEscrowFundWithClient(uint128 escrowAmount) external payable {
        uint256 balance = getClientEscrowFundBalanceof();
        if (balance + escrowAmount < MIN_ESCROW_AMOUNT) revert InsufficientEscrowAmount(escrowAmount);
        _depositEscrowFundWithClient(escrowAmount);
    }

    function submitOrder(address serviceProvider, uint256 orderNonce) external {
        bytes32 orderId = _userOrders.getOrderId(serviceProvider, orderNonce);
        if (_userOrders.getOrderServiceProvider(
                serviceProvider,
                orderNonce,
                orderId
            ) == address(0)
            || _userOrders.getOrderServiceProvider(
                serviceProvider,
                orderNonce,
                orderId
            ) != serviceProvider
        ) revert OrderException();

        if (!_usersOperation.getUserCustomer(msg.sender)) revert UserHasNoAuthorization();
        if (_userOrders.getOrderStatus(serviceProvider, orderNonce, orderId) & uint8(0x4) != 0) revert OrderInModify();
        if (_userOrders.getOrderClient(serviceProvider, orderNonce, orderId) != msg.sender) revert InvalidOrderClient();

        _userOrders.modiflyOrderStatus(serviceProvider, orderNonce, orderId, uint8(0x1));
    }

    function cancelOrder(address serviceProvider, uint256 orderNonce) external {
        bytes32 orderId = _userOrders.getOrderId(serviceProvider, orderNonce);
        if (_userOrders.getOrderStatus(serviceProvider, orderNonce, orderId) & uint8(0x4) != 0) revert OrderInModify();

        _userOrders.setCancelOrderUser(serviceProvider, orderNonce, orderId, msg.sender);
        if (
            msg.sender == serviceProvider
            && msg.sender == _userOrders.getOrderServiceProvider(
                serviceProvider,
                orderNonce,
                orderId
            )
        ) _withdrowEscrowFund(orderId);

        Order memory order = _userOrders.getOrderSituationByServiceProvider(serviceProvider, orderNonce, orderId);
        WonderJobArbitration.orderValidatorCallWithFallback(msg.sender, order);
    }

    /// @dev Make the function implement 'payable' to eliminate-boundary-checks
    /// require(msg.value >= 0)
    /// The caller must be serviceProvider.
    function completeOrder(address serviceProvider, bytes32 orderId) external payable {
        require(msg.sender == serviceProvider, "The caller must be service provider");
        uint256 completeRewardAmount;
        //  _orderGenerator.getOrderNonce(serviceProvider)-1 => 0 - 1 = 0(safe overflow)
        Order memory order = _userOrders.getOrderSituationByServiceProvider(serviceProvider, _orderGenerator.getOrderNonce(serviceProvider) - 1, orderId);
        if (feeConfig.getFeeOn()) {
            uint256 feeAmount;
            unchecked { // Exercise caution with precision loss issue.
                feeAmount = (
                    order.totalPrice * feeConfig.getFeeScale()) / feeConfig.getfeeDecimal() == 1
                        ? (order.totalPrice * feeConfig.getFeeScale() / OrderFeeFulfil.MINIMUM_PERCENT_PRECISION)
                        : (order.totalPrice * feeConfig.getFeeScale() / OrderFeeFulfil.MAXIMUM_PERCENT_PRECISION); 
                completeRewardAmount = order.totalPrice - feeAmount;
            }
            _sendValue(feeConfig.getFeeTo(), feeAmount);
        } else {
            completeRewardAmount = order.totalPrice;
        }
        _withdrowEscrowFund(orderId);
        _sendValue(order.client, completeRewardAmount);
        WonderJobArbitration.orderValidatorCallWithFallback(msg.sender, order);
    }
    
    function withdrowEscrowFundWithClient() external {
        if (_usersOperation.getTakeOrder(msg.sender)) revert ClientIsTakeOrder();
        _withdrowEscrowFundWithClient();
    }

    function setFee(bool enable) public onlyOwner {
        if (enable) feeConfig.setFeeOn(msg.sender); else feeConfig.setFilpFeeOn(msg.sender);
    }

    function setFeeConfig(uint24[4] memory feeScales, address feeTo) external onlyOwner {
        feeConfig.setFeeScale(feeScales, msg.sender, feeTo != address(0) ? feeTo : msg.sender);
    }

    function getOrderNonce(address user) public view returns (uint256) {
        return _orderGenerator.getOrderNonce(user);
    }

    function getOrderId(uint256 orderNonce) public view returns (bytes32) {
        return _userOrders.getOrderId(msg.sender, orderNonce);
    }

    function getUserProfile() public view returns (User memory _user) {
        User memory user_ = User({
            userAddress: msg.sender,
            isCustomer: _usersOperation.getUserCustomer(msg.sender),
            isServiceProvider: _usersOperation.getUserServiceProvider(msg.sender),
            isRegistered: _usersOperation.getUserRegisterStatus(msg.sender),
            creationTime: _usersOperation.getUserCreationTime(msg.sender)
        });

        assembly {
            _user := user_
        }
    }
    receive() external payable {}
}