// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

/// anyUser => type anyUser is address;
abstract contract WonderJobFundEscrowPool is ReentrancyGuard {

    error InsufficientFunds(uint256 depositAmount);
    error EscrowFundsBalanceOfWasZero();

    uint256 public immutable MIN_ESCROW_AMOUNT;
    uint256 public constant MAX_ESCROW_AMOUNT = ~uint(0);
    uint256 public CLIENT_ESCROW_AMOUNT = 0.2 ether;

    mapping (address anyUser => mapping(bytes32 orderId => uint128 balanceAmount)) private _escrowBalanceof;
    mapping (address clientUser => uint256 balanceAmount) private _clientEscrowFundBalanceof;

    event DepositEscrowFund(address indexed sender, uint256 depositAmount);
    /// @dev I intend to complete the 'withdraw' operation, which will alter the 'isOrderComplete' status, 
    /// indicating that the order has been finalized and cannot be modified further,
    /// this action can be associated with event response using the signature information, e.g. 'orderId'.
    event WithdrowEscrowFund(address indexed sender, bytes32 indexed orderId, uint256 depositAmount);

    constructor(uint256 minEscrowAmount) {
        MIN_ESCROW_AMOUNT = minEscrowAmount; 
    }

    function _depositEscrowFund(uint128 orderPrice, bytes32 orderId) internal virtual nonReentrant returns (bool) {
        /// Checks Effects Interactions
        if (orderPrice < MIN_ESCROW_AMOUNT) revert InsufficientFunds(orderPrice);

        _escrowBalanceof[msg.sender][orderId] = orderPrice;
        emit DepositEscrowFund(msg.sender, msg.value);
        return true;
    }

    function _depositEscrowFundWithClient(uint256 escrowAmount) internal virtual nonReentrant returns (bool) {
        unchecked {
            _clientEscrowFundBalanceof[msg.sender] += escrowAmount;
        }
        emit DepositEscrowFund(msg.sender, escrowAmount);
        return true;
    }

    function getClientEscrowFundBalanceof(address client) public view returns (uint256) {
        return _clientEscrowFundBalanceof[client];
    }

    function _withdrowEscrowFund(bytes32 orderId) internal virtual nonReentrant returns (bool) {
        if (_escrowBalanceof[msg.sender][orderId] == 0) revert EscrowFundsBalanceOfWasZero();
        
        uint256 balanceOf = _escrowBalanceof[msg.sender][orderId];
        emit WithdrowEscrowFund(msg.sender, orderId, balanceOf);
        _escrowBalanceof[msg.sender][orderId] = 0;
        return true;
    }

    function _withdrowEscrowFundWithClient() internal virtual nonReentrant returns (bool) {
        uint256 balance = getClientEscrowFundBalanceof(msg.sender);
        _sendValue(msg.sender, balance);
        _clientEscrowFundBalanceof[msg.sender] = 0;
        return true;
    }

    function _sendValue(address to, uint256 amount) internal {
        assembly {
            let s := call(gas(), to, amount, 0x00, 0x00, 0x00, 0x00)
            if iszero(s) {
                mstore(0x00, 0xb1c003de) // error `InsufficientSendValue()`
                revert(0x00, 0x04)
            }
        }
    }
}
