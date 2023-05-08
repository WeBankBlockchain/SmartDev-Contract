// SPDX-License-Identifier: UNLICENSED
/// @author Steve Jin

pragma solidity >=0.8.0;
pragma experimental ABIEncoderV2;

// 定义接口ICloneFactory
interface ICloneFactory {
    // 定义接口方法clone，传入原型合约地址，克隆传入的原型合约，返回新合约地址
    function clone(address prototype) external returns (address proxy);
}

// 实现接口
contract CloneFactory is ICloneFactory {
    // 实现接口方法，该方法内部使用 Solidity 的汇编语言实现了合约原型的克隆功能。具体来说，它首先将合约原型的地址转换为 20 字节的字节数组 bytes20，然后使用汇编代码创建一个新合约。创建合约的代码通过将字节数组中的地址插入到一个预先定义的字节码中来实现。
    function clone(address prototype) external override returns (address proxy) {
        bytes20 targetBytes = bytes20(prototype);
        assembly {
            let clone := mload(0x40)
            mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
            mstore(add(clone, 0x14), targetBytes)
            mstore(
                add(clone, 0x28),
                0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000
            )
            proxy := create(0, clone, 0x37)
        }
        return proxy;
    }
}
