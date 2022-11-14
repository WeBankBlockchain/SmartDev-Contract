# FISCO BCOS 国密算法使用的工具和示例合约


> 本示例是通过 FISCO BCOS 的预编译合约实现.https://fisco-bcos-documentation.readthedocs.io/zh_CN/latest/docs/manual/precompiled_contract.html
> 通过 ICrypto.sol 文件声明需要调用的预编译合约接口
> 通过 `ICrypto constant Crypto = ICrypto(address(0x5006))` 完成接口的注册和使用
>
> 注意: **0x5006** 为地址空间,必须唯一

## 示例合约
````solidity
pragma solidity ^0.5.0;

// 导入预编译合约
import "./ICrypto.sol";

contract HelloWorld{

    bytes32 hashVal;
    
    ICrypto constant Crypto = ICrypto(address(0x5006));
    
    /**
     * @return 获取 _message 的哈希
     **/ 
    function getMeessgeHash() view public returns(bytes32) {
        return hashVal;
    }

    /**
     * @notice 使用 Keccak-256 计算 _message 哈希
     * @param _message 需要计算哈希的参数
     **/
    function keccak256Hash(string memory _message) public returns(bool){
        
        hashVal = Crypto.keccak256Hash(bytes(_message));
    	return true;
    }
    
    /**
     * @notice 使用国密算法 SM3 计算 _message 哈希
     * @param _message 需要计算哈希的参数
     **/
    function sm3Hash(string memory _message) public returns (bool) {
        
        hashVal = Crypto.sm3(bytes(_message));
        return true;
    }
}
````