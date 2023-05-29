// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

import "../IERC721.sol";

/**
  * @title ERC-721 不可替代令牌标准，可选元数据扩展
  * @dev 请参阅 https://eips.ethereum.org/EIPS/eip-721
  * 注意：此接口的 ERC-165 标识符为 0x5b5e139f。
  */
interface IERC721Metadata is IERC721 {
    /**
     * @notice A descriptive name for a collection of NFTs in this contract
     */
    function name() external view returns (string memory);

    /**
     * @notice An abbreviated name for NFTs in this contract
     */
    function symbol() external view returns (string memory);

    /**
      * @notice 给定资产的独特统一资源标识符 (URI)。
      * @dev 如果 _tokenId 不是有效的 NFT 则抛出。 URI 在 RFC 中定义
      * 3986. URI 可能指向符合“ERC721
      * 元数据 JSON 模式”。
      */
    function tokenURI(uint256 _tokenId) external view returns (string memory);
}