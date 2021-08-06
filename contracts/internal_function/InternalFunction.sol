pragma solidity ^0.6.10;

/**
 * @author SomeJoker
 * @title solidity 内置函数转换
 */
contract InternalFunction{  
    /**
     * @notice 根据指定的区块号获取hash(仅支持最近256个区块，且不包含当前区块)
     * @param uint256 blockNumber
     * @return bytes32  区块的hash值
     */
    function getBlockhash(uint256 blockNumber) view public returns(bytes32){
        return blockhash(blockNumber);
    }

    /**
     * @notice 获取当前区块的区块高度
     * @return uint256 区块高度
     */
    function getBlockNumber() view public returns(uint256){
        return block.number;
    }
    
    /**
     * @notice 获取当前区块的时间戳
     * @return uint256 时间戳
     */
    function getTimestamp() view public returns(uint256){
        return now;
    }
    
    /**
     *  @notice 判断地址是否是合约地址
     */
    function isContract(address addr) view public returns (bool){
        uint256 size;
        assembly {
            size := extcodesize(addr)
        }
        return size > 0;
    }

    /**
     * @notice 获取合约的代码节码
     */
    function getCodeByAddress(address addr) public view returns (bytes memory) {
        require(isContract(addr) , "addr is not a contract");
        bytes memory o_code;
        assembly {
            // 获取代码大小，这需要汇编语言
            let size := extcodesize(addr)
            // 分配输出字节数组 – 这也可以不用汇编语言来实现
            // 通过使用 o_code = new bytes（size）
            o_code := mload(0x40)
            // 包括补位在内新的“memory end”
            mstore(0x40, add(o_code, and(add(add(size, 0x20), 0x1f), not(0x1f))))
            // 把长度保存到内存中
            mstore(o_code, size)
            // 实际获取代码，这需要汇编语言
            extcodecopy(addr, add(o_code, 0x20), 0, size)
        }
        return o_code;
    }

    /**
     * @notice 根据字节码计算合约地址
     */
    function computeAddress(bytes32 salt, bytes32 bytecodeHash) public view returns (address) {
        return computeAddress(salt, bytecodeHash, address(this));
    }

    function computeAddress(
        bytes32 salt,
        bytes32 bytecodeHash,
        address deployer
    ) internal pure returns (address) {
        bytes32 _data = keccak256(abi.encodePacked(bytes1(0xff), deployer, salt, bytecodeHash));
        return address(uint160(uint256(_data)));
    }

}   