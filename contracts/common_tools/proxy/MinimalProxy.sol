// SPDX-License-Identifier: MIT
pragma solidity ^0.6.10;

contract MinimalProxy {
    
    // @title createClone           创建代理合约
    // @param `implementation`      主合约地址
    // 
    // @dev MinimalProxy 利用了 `delegatecall` 提供了一种节省部署成本的合约复制方案
    // 当合约中存在多个代理合约和一个逻辑合约时，每个代理合约存储对应的数据，
    // 所有代理合约共享单个逻辑合约的执行逻辑。
    function createClone(address implementation) internal returns(address instance) {
        assembly {
            // 加载空闲内存指针
            let ptr := mload(0x40)
            // 关于固定字节码，参考 https://blog.openzeppelin.com/deep-dive-into-the-minimal-proxy-contract/
            // 在ptr中，将构造函数字节码存入指针打包 
            mstore(ptr, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
            // 在ptr+20字节位置，将地址左移12个字节得到原始地址并存入指针打包
            mstore(add(ptr, 0x14), shl(0x60, implementation))
            // 在ptr+40字节位置，将0x5af4...存入指针打包
            mstore(add(ptr, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
           // 创建合约实例
            instance := create(0, ptr, 0x37)
        }
        // 验证合约是否创建成功
        require(instance != address(0), "MinimalProxy: create failed");
    }

}
