// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

import "../IERC721.sol";

/**
  * @title ERC-721 不可替代令牌标准，可选枚举扩展
  * @dev 请参阅 https://eips.ethereum.org/EIPS/eip-721
  * 注意：此接口的 ERC-165 标识符为 0x780e9d63。
  */
interface IERC721Enumerable is IERC721 {

    /**
      * @notice 计算该合约跟踪的 NFT
      * @return 本合约跟踪的有效 NFT 的计数，其中每个
      * 他们有一个分配的和可查询的所有者不等于零地址
      */
    function totalSupply() external view returns (uint256);

    /**
      * @notice 枚举有效的 NFT
      * @dev 如果`_index` >= `totalSupply()` 抛出。
      * @param _index 小于 `totalSupply()` 的计数器
      * @return 第 _index 个 NFT 的代币标识符，
      *（未指定排序顺序）
      */
    function tokenByIndex(uint256 _index) external view returns (uint256);

    /**
      * @notice 枚举分配给所有者的 NFT
      * @dev 如果`_index` >= `balanceOf(_owner)` 或者如果
      * `_owner` 为零地址，代表无效的 NFT。
      * @param _owner 我们对他们拥有的 NFT 感兴趣的地址
      * @param _index 小于 `balanceOf(_owner)` 的计数器
      * @return 分配给 _owner 的第 _index 个 NFT 的代币标识符，
      *（未指定排序顺序）
      */
    function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256);
}