pragma solidity ^0.5.0;

// 预编译合约接口定义
interface ICrypto{
    //使用国密sm3算法计算指定数据的哈希;
    function sm3(bytes calldata data) external pure returns(bytes32);
    //使用keccak256算法计算指定数据的哈希;
    function keccak256Hash(bytes calldata data) external pure returns(bytes32);
    //使用sm2算法验证签名(publicKey, r, s)是否有效，验证通过返回true以及通过公钥推导出的国密账户，验证失败返回false和地址全0的账户;
    function sm2Verify(bytes32 message, bytes calldata publicKey, bytes32 r, bytes32 s) external pure returns(bool, address);
    //给定VRF输入和VRF公钥，使用基于ed25519曲线的VRF算法验证VRF证明是否有效，若VRF证明验证成功，返回true以及根据证明推导出来的VRF随机数；若VRF证明验证失败，则返回(false, 0)
    function curve25519VRFVerify(string calldata input, string calldata vrfPublicKey, string calldata vrfProof) external pure returns(bool,uint256);
}