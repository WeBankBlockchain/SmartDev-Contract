// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.16 < 0.9.0;

import './LibSafeMathForUint256Utils.sol';

contract DGHV_Homomorphic_Encryption {

    // 随机数参数
    uint private m = 100;       // 线性求余迭代次数
    uint private k = 3877;      // 乘数
    uint private b = 29573;     // 增量

    // DGHV参数
    uint256 private eta;        // 安全参数
    uint256 private q;
    uint256 private p;          // 密钥

    constructor(uint _eta, uint _q, uint _p) public {
        require(_p % 2 == 1);   // 密钥必须是一个大奇数
        eta = _eta;
        q = _q;
        p = _p;
    }

    // 使用线性求余的随机数生成器
    function randomGen(uint range, uint seed) private view returns (uint) {
        require(range > 0);
        uint LCG_random_num =  LCG(seed, range);
        return uint(keccak256(abi.encodePacked(block.timestamp, LCG_random_num))) % range;
    }

    function LCG(uint _seed, uint range) private view returns(uint) {
        uint val = _seed;
        for (uint256 index = 0; index < m; index++) {
            //TODO 内联汇编优化计算
            val = (LibSafeMathForUint256Utils.add(LibSafeMathForUint256Utils.mul(k, val), b)) % range;
        }
        return val;
    }       

    // 同态加密
    function encrypto(uint8 _m) public view returns (uint) {
        require(_m == 0 || _m == 1);
        // 生成随机数r
        uint r = randomGen(8, block.timestamp%1000);
        return LibSafeMathForUint256Utils.add(LibSafeMathForUint256Utils.add(_m, 2*r), LibSafeMathForUint256Utils.mul(p, q));
    }

    // 同态解密
    function decrypto(uint _c) public view returns (uint) {
        return LibSafeMathForUint256Utils.mod(LibSafeMathForUint256Utils.mod(_c, p), 2);
    }

    // 同态加法
    function HE_Add(uint _c1, uint _c2) public view returns(uint) {
        return decrypto(LibSafeMathForUint256Utils.add(_c1, _c2));
    }

    // 同态乘法(可能会溢出)
    function HE_Mul(uint _c1, uint _c2) public view returns(uint){
        return decrypto(LibSafeMathForUint256Utils.mul(_c1, _c2));
    }


}
