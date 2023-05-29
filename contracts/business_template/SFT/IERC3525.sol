// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import "./IERC721.sol";

/**
 * @title ERC-3525 Semi-Fungible Token Standard
 * @dev See https://eips.ethereum.org/EIPS/eip-3525
 * Note: the ERC-165 identifier for this interface is 0xd5358140.
 */
interface IERC3525 is IERC165, IERC721 {
    /**
     * @dev MUST emit when value of a token is transferred to another token with the same slot,
     *  including zero value transfers (_value == 0) as well as transfers when tokens are created
     *  (`_fromTokenId` == 0) or destroyed (`_toTokenId` == 0).
     * @param _fromTokenId The token id to transfer value from
     * @param _toTokenId The token id to transfer value to
     * @param _value The transferred value
     */
    event TransferValue(uint256 indexed _fromTokenId, uint256 indexed _toTokenId, uint256 _value);

    /**
     * @dev MUST emits when the approval value of a token is set or changed.
     * @param _tokenId The token to approve
     * @param _operator The operator to approve for
     * @param _value The maximum value that `_operator` is allowed to manage
     */
    event ApprovalValue(uint256 indexed _tokenId, address indexed _operator, uint256 _value);

    /**
     * @dev MUST emit when the slot of a token is set or changed.
     * @param _tokenId The token of which slot is set or changed
     * @param _oldSlot The previous slot of the token
     * @param _newSlot The updated slot of the token
     */ 
    event SlotChanged(uint256 indexed _tokenId, uint256 indexed _oldSlot, uint256 indexed _newSlot);

    /**
      * @notice 获取令牌用于值的小数位数 - 例如 6、指用户
      * 代币价值的表示可以通过将其除以 1,000,000 来计算。
      * 考虑到与第三方钱包的兼容性，该功能定义为
      * `valueDecimals()` 而不是 `decimals()` 以避免与 ERC20 代币发生冲突。
      * @return 值的小数位数
      */
    function valueDecimals() external view returns (uint8);

    /**
     * @notice Get the value of a token.
     * @param _tokenId The token for which to query the balance
     * @return The value of `_tokenId`
     */
    function balanceOf(uint256 _tokenId) external view returns (uint256);

    /**
      * @notice 获取令牌的插槽。
      * @param _tokenId 令牌的标识符
      * @return 令牌的插槽
      */
    function slotOf(uint256 _tokenId) external view returns (uint256);

 
      /**
      * @notice 允许操作员管理代币的价值，最高可达“_value”数量。
      * @dev 必须恢复，除非调用者是当前所有者、授权操作员或批准的
      * `_tokenId` 的地址。
      * 必须发出 ApprovalValue 事件。
      * @param _tokenId 要批准的令牌
      * @param _operator 待审核的运营商
      * @param _value 允许`_operator`管理的`_toTokenId`的最大值
      */
    function approve(
        uint256 _tokenId,
        address _operator,
        uint256 _value
    ) external payable;

    /**
     * @notice Get the maximum value of a token that an operator is allowed to manage.
     * @param _tokenId The token for which to query the allowance
     * @param _operator The address of an operator
     * @return The current approval value of `_tokenId` that `_operator` is allowed to manage
     */
    function allowance(uint256 _tokenId, address _operator) external view returns (uint256);

    /**
      * @notice 将值从指定令牌转移到具有相同插槽的另一个指定令牌。
      * @dev Caller 必须是当前所有者、授权操作员或已被授权的操作员
      * 批准了整个 `_fromTokenId` 或其中的一部分。
      * 如果 _fromTokenId 或 _toTokenId 为零令牌 ID 或不存在，则必须还原。
      * 如果 `_fromTokenId` 和 `_toTokenId` 的插槽不匹配，则必须恢复。
      * 如果 _value 超过 _fromTokenId 的余额或其对
      *  操作员。
      * 必须发出 `TransferValue` 事件。
      * @param _fromTokenId 从中转移价值的代币
      * @param _toTokenId 将价值转移到的代币
      * @param _value 传递的值
      */
    function transferFrom(
        uint256 _fromTokenId,
        uint256 _toTokenId,
        uint256 _value
    ) external payable;

    /**
      * @notice 将值从指定令牌转移到地址。 调用者应确认
      * `_to` 能够接收 ERC3525 代币。
      * @dev 此函数必须创建一个新的 ERC3525 令牌，该令牌具有相同的槽以供 _to 接收
      * 转移的价值。
      * 如果 _fromTokenId 为零令牌 ID 或不存在，则必须还原。
      * 如果 _to 是零地址，则必须恢复。
      * 如果 _value 超过 _fromTokenId 的余额或其对
      *  操作员。
      * 必须发出 `Transfer` 和 `TransferValue` 事件。
      * @param _fromTokenId 从中转移价值的代币
      * @param _to 将值传送到的地址
      * @param _value 传递的值
      * @return 为接收转移值的 _to 创建的新令牌的 ID
      */
    function transferFrom(
        uint256 _fromTokenId,
        address _to,
        uint256 _value
    ) external payable returns (uint256);
}