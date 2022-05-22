pragma solidity ^0.4.25;

library LibBase64 {

    bytes constant private base64stdchars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

    /**
     * 字符串 base64 编码
     *
     * @ param data  要解码的数据
     * @ return 经 base64 返回的编码数据
     *
    **/
    function encode(string memory data) internal pure returns(string memory) {
        uint i = 0;                               
        uint j = 0;

        uint padlen = bytes(data).length; 
        if (padlen % 3 != 0) 
            padlen += (3 - (padlen % 3));

        bytes memory _bs = bytes(data);
        bytes memory _ms = new bytes(padlen);  
        
        for (i = 0; i < _bs.length; i++) {              
            _ms[i] = _bs[i];
        }
 
        // 计算编码后的字符长度
        uint res_length = (padlen / 3) * 4;           
        bytes memory res = new bytes(res_length);   
        for (i = 0; i < padlen; i += 3) {
            // 取第一字符 _ms[i] 的前 6 比特位作为 base64 字符 0 的索引
            uint c0 = uint(uint8(_ms[i])) >> 2;
            // 取 _ms[i] 的后2位，在末尾补 _ms[i+1] 的前 4 位作为 base64 字符 1 的索引
            uint c1 = (uint(uint8(_ms[i])) & 3) << 4 |  uint(uint8(_ms[i+1])) >> 4;
            // 取 _ms[i+1] 的后 4 位，在末尾补 _ms[i+2] 的前 2 位作为 base64 字符 2 的索引
            uint c2 = (uint(uint8(_ms[i+1])) & 15) << 2 | uint(uint8(_ms[i+2])) >> 6;
            // 取 _ms[i+2] 的后 6 位作为 base64 字符 3 的索引
            uint c3 = (uint(uint8(_ms[i+2])) & 63);

            res[j]   = base64stdchars[c0];
            res[j+1] = base64stdchars[c1];
            res[j+2] = base64stdchars[c2];
            res[j+3] = base64stdchars[c3];

            j += 4;
        }

        // 判断是否要补位，即 + 0 ，补位则设置索引为 64，对应 ‘=’ 字符
        if ((padlen - bytes(data).length) >= 1) { 
            res[j-1] = base64stdchars[64];
        }
        if ((padlen - bytes(data).length) >= 2) { 
            res[j-2] = base64stdchars[64];
        }

        return string(res);
    }

    /**
     * 字符串 base64 解码
     *
     * @ param data  要解码的数据
     * @ return 返回的解码数据
     *
    **/
    function decode(string memory data) internal pure returns(string memory) {
        require((bytes(data).length % 4) == 0, "Length not multiple of 4");
        bytes memory _bs = bytes(data);

        uint i = 0;
        uint j = 0;
        uint dec_length = (_bs.length / 4) * 3;
        bytes memory dec = new bytes(dec_length);

        for (; i< _bs.length; i+=4) {
            (dec[j], dec[j+1], dec[j+2]) = dencode4(
                bytes1(_bs[i]),
                bytes1(_bs[i+1]),
                bytes1(_bs[i+2]),
                bytes1(_bs[i+3])
            );
            j += 3;
        }
        while (dec[--j]==0) {}

        bytes memory res = new bytes(j+1);
        for (i=0; i<=j; i++)
            res[i] = dec[i];

        return string(res);
    }

    // 将4个base64编码字符解码为原3个字符
    function dencode4 (
        bytes1 b0, 
        bytes1 b1, 
        bytes1 b2, 
        bytes1 b3
    ) 
        private 
        pure
        returns (bytes1 a0, bytes1 a1, bytes1 a2)
    {
        uint pos0 = charpos(b0);
        uint pos1 = charpos(b1);
        uint pos2 = charpos(b2) % 64;
        uint pos3 = charpos(b3) % 64;

        // 取 b0 + b1 的前2位组成 8 比特位即 1 字节
        a0 = bytes1(uint8((pos0 << 2 | pos1 >> 4)));
        // 取 b1 后 4 位 + b2 的前 4 位组成 8 比特位即 1 字节
        a1 = bytes1(uint8(((pos1 & 15) << 4 | pos2 >> 2)));
        // 取 b2 前 2 位 + b3 组成 8 比特位即 1 字节
        a2 = bytes1(uint8(((pos2 & 3) << 6 | pos3)));
    }

    // 检查是否是 base64 字符，返回字符索引
    function charpos(bytes1 char) private pure returns (uint pos) {
        for (; base64stdchars[pos] != char; pos++) {}
        require (base64stdchars[pos] == char, "Illegal char in string");
        return pos;
    }

}