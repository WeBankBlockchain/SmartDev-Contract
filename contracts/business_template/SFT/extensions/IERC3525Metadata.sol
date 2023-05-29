// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

import "../IERC3525.sol";
import "./IERC721Metadata.sol";

/**
  * @title ERC-3525 Semi-Fungible Token Standard，元数据的可选扩展
  * @dev 任何想要支持统一资源标识符查询的合约的接口
  * (URI) 用于 ERC3525 合约以及指定插槽。
  * 由于与存储在智能合约中的数据相比，存储在智能合约中的数据具有更高的可靠性
  * 中心化系统，建议元数据，包括`contractURI`、`slotURI`和
  * `tokenURI`，直接返回JSON格式，而不是返回url指向
  * 存储在集中式系统中的任何资源。
  * 请参阅 https://eips.ethereum.org/EIPS/eip-3525
  * 注意：此接口的 ERC-165 标识符为 0xe1600902。
  */
interface IERC3525Metadata is IERC3525, IERC721Metadata {
    /**
      * @notice 返回当前 ERC3525 合约的统一资源标识符 (URI)。
      * @dev 这个函数应该以 JSON 格式返回这个合约的 URI，以
      * 标题`data:application/json;`。
      * 有关合约 URI 的 JSON 架构，请参阅 https://eips.ethereum.org/EIPS/eip-3525。
      * @return 当前ERC3525合约的JSON格式URI
      */
    function contractURI() external view returns (string memory);

    /**
      * @notice 返回指定插槽的统一资源标识符 (URI)。
      * @dev 这个函数应该以 JSON 格式返回 `_slot` 的 URI，从 header 开始
      *`数据：应用程序/json；`。
      * 有关插槽 URI 的 JSON 架构，请参阅 https://eips.ethereum.org/EIPS/eip-3525。
      * @return `_slot` 的 JSON 格式 URI
      */
    function slotURI(uint256 _slot) external view returns (string memory);
}