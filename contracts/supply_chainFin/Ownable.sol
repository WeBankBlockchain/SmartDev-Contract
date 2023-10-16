// SPDX-License-Identifier: MIT
// 使用 SPDX 许可证标识，指定合约采用 MIT 许可证
// 这个合约实现了一个基本的 "Ownable" 功能，只有拥有者才能调用带有 onlyOwner 修饰器的函数，拥有者还可以通过 transferOwnership 函数将合约的所有权转移给其他地址。
pragma solidity ^0.8.0;

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
    // 声明一个名为 owner 的状态变量，用于存储合约的拥有者地址
    address public owner;

    // 声明一个事件，当所有权发生转移时会触发该事件。事件参数包括前一所有者地址和新所有者地址
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev The Ownable constructor sets the original owner of the contract to the sender account.
     */
    // 构造函数，在合约部署时将部署者的地址设置为合约的初始拥有者
    constructor() {
        owner = msg.sender;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    // 修饰器，用于限制只有合约拥有者可以调用的函数。如果不满足要求，将抛出错误信息
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    // 函数，允许当前拥有者将合约的控制权转移给新的拥有者
    function transferOwnership(address newOwner) public onlyOwner {
        // 确保新所有者地址不为零，否则将抛出错误
        require(newOwner != address(0), "New owner address cannot be zero");

        // 触发 OwnershipTransferred 事件，表示所有权已转移
        emit OwnershipTransferred(owner, newOwner);

        // 将合约的拥有者地址更新为新的所有者地址
        owner = newOwner;
    }
}
