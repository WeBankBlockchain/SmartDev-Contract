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
    function getBlockhash(uint256 blockNumber) constant public returns(bytes32){
        return blockhash(blockNumber);
    }

    /**
     * @notice 获取当前区块的矿工地址
     * @return address 矿工地址
     */
    function getMiner() view public returns(address){
        return block.coinbase;
    }
    
    /**
     * @notice 获取当前区块的难度系数
     * @return uint256 难度系数
     */
    function getDifficulty() view public returns(uint256){
        return block.difficulty;
    }

    /**
     * @notice 获取当前区块的gasLimit
     * @return uint256 gasLimit
     */
    function getGaslimit() view public returns(uint256){
        return block.gaslimit;
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
     * @notice 获取当前区块的gasPrice
     * @return uint256 gasPrice
     */
    function getGasprice() view public returns(uint) {
        return tx.gasprice;
    }
    
    /**
     * @notice 获取某个账户的eth余额
     * @param  address account 待查询地址
     * @return uint256 eth余额
     */
    function getEthBalance(address payable account) view public returns(uint) {
        return account.balance;
    }
}