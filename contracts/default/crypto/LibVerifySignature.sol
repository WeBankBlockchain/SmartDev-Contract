pragma solidity ^0.6.10;
/**
* @author cuiyu
* @title  数字签名验签
**/
library LibVerifySignature {
    // 参数0 验签者地址  参数1 签名者地址  参数3 消息哈希值  参数4 数字签名
    function verifySignature(address verifier, address publicKey, bytes32 hash, bytes memory signature) public pure returns (bool)
    {   
        //签名者与验签者不可相同
        require(verifier != publicKey, "invalid verifier");

        // 检查数字签名的长度是否为65字节（65 = 1 + 32 + 32）
        require(65 == signature.length, "invalid signature length!");

        // 因为需要调用ecrecover预编译函数，而ecrecover需要的参数包括数字签名的三个片段(r, s, v)
        bytes32 r; // signature的前32个字节  椭圆曲线数字签名输出
        bytes32 s; // signature的第33字节到第64字节  椭圆曲线数字签名输出
        uint8 v;   // signature的第65字节  恢复标识符，数值为27或28
        // 在椭圆曲线算法中，依靠r和s可计算出曲线上的多个点，因此会恢复出两个不同的公钥及其地址，因此需要基于v值进行选择

        string memory prefix = "\x19Ethereum Signed Message:\n32"; //前缀，可理解为ecrecover函数使用的格式要求

        // 内联汇编在处理字节运算时，具有较低的gas消耗       
        assembly {
            r := mload(add(signature, 32))         
            s := mload(add(signature, 64))
            // 在fisco bcos的EVM实现中，v在内部只是0x0或0x1，需要通过加27进行调整
            v := add(byte(0, mload(add(signature, 96))), 27) 

            if eq(or(eq(v, 27), eq(v, 28)), 0) { stop() }         
        }
        
        // ecrecover预编译函数可以计算出签名者地址，通过与publicKey进行比对，即可得到验签结果
        return (ecrecover(keccak256(abi.encodePacked(prefix, hash)), v, r, s) == publicKey);
        
    }      

}

