// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.4.25;

library LibString{
    

    function lenOfChars(string memory src) internal pure returns(uint){
        uint i=0;
        uint length = 0;
        bytes memory string_rep = bytes(src);
        //UTF-8 skip word
        while (i<string_rep.length)
        {
            i += utf8CharBytesLength(string_rep, i);
            length++;
        }
        return length;
    }

    function lenOfBytes(string memory src) internal pure returns(uint){
        bytes memory srcb = bytes(src);
        return srcb.length;
    }
    
    
    function startWith(string memory src, string memory prefix) internal pure returns(bool){
        bytes memory src_rep = bytes(src);
        bytes memory prefix_rep = bytes(prefix);
        
        if(src_rep.length < prefix_rep.length){
            return false;
        }
        
        uint needleLen = prefix_rep.length;
        for(uint i=0;i<needleLen;i++){
            if(src_rep[i] != prefix_rep[i]) return false;
        }
        
        return true;
    }
    
    function endWith(string memory src, string memory tail) internal pure returns(bool){
        bytes memory src_rep = bytes(src);
        bytes memory tail_rep = bytes(tail);
        
        if(src_rep.length < tail_rep.length){
            return false;
        }
        uint srcLen = src_rep.length;
        uint needleLen = tail_rep.length;
        for(uint i=0;i<needleLen;i++){
            if(src_rep[srcLen-needleLen+i] != tail_rep[i]) return false;
        }
        
        return true;    
    }
    

    function equal(string memory self, string memory other) internal pure returns(bool){
        bytes memory self_rep = bytes(self);
        bytes memory other_rep = bytes(other);
        
        if(self_rep.length != other_rep.length){
            return false;
        }
        uint selfLen = self_rep.length;
        for(uint i=0;i<selfLen;i++){
            if(self_rep[i] != other_rep[i]) return false;
        }
        return true;           
    }

    function equalNocase(string memory self, string memory other) internal pure returns(bool){
        return compareNocase(self, other) == 0;
    }
    
    function empty(string memory src) internal pure returns(bool){
        bytes memory src_rep = bytes(src);
        if(src_rep.length == 0) return true;

        for(uint i=0;i<src_rep.length;i++){
            bytes1 b = src_rep[i];
            if(b != 0x20 && b != bytes1(0x09) && b!=bytes1(0x0A) && b!=bytes1(0x0D)) return false;
        }

        return true;
    }

    function concat(string memory self, string memory str) internal pure returns (string memory  _ret)  {
        _ret = new string(bytes(self).length + bytes(str).length);

        uint selfptr;
        uint strptr;
        uint retptr;
        assembly {
            selfptr := add(self, 0x20)
            strptr := add(str, 0x20)
            retptr := add(_ret, 0x20)
        }
        
        memcpy(retptr, selfptr, bytes(self).length);
        memcpy(retptr+bytes(self).length, strptr, bytes(str).length);
    }
    
    //start is char index, not bytes1 index
    function substrByCharIndex(string memory self, uint start, uint len) internal pure returns (string memory) {
        if(len == 0) return "";
        //start - bytePos
        //len - byteLen
        uint bytePos = 0;
        uint byteLen = 0;
        uint i=0;
        uint chars=0;
        bytes memory self_rep = bytes(self);
        bool startMet = false;
        //UTF-8 skip word
        while (i<self_rep.length)
        {
            if(chars == start){
                bytePos = i;
                startMet = true;
            }
            if(chars == (start + len)){
                byteLen = i - bytePos;
            }
            i += utf8CharBytesLength(self_rep, i);
            chars++;
        }
        if(chars == (start + len)){
            byteLen = i - bytePos;
        }
        require(startMet, "start index out of range");
        require(byteLen != 0, "len out of range");
        
        string memory ret = new string(byteLen);

        uint selfptr;
        uint retptr;
        assembly {
            selfptr := add(self, 0x20)
            retptr := add(ret, 0x20)
        }
        
        memcpy(retptr, selfptr+bytePos, byteLen);
        return ret;
    }

    function compare(string memory self, string memory other) internal pure returns(int8){
        bytes memory selfb = bytes(self);
        bytes memory otherb = bytes(other);
        //bytes1 by bytes1
        for(uint i=0;i<selfb.length && i<otherb.length;i++){
            bytes1 b1 = selfb[i];
            bytes1 b2 = otherb[i];
            if(b1 > b2) return 1;
            if(b1 < b2) return -1;
        }
        //and length
        if(selfb.length > otherb.length) return 1;
        if(selfb.length < otherb.length) return -1;
        return 0;
    }

    function compareNocase(string memory self, string memory other) internal pure returns(int8){
        bytes memory selfb = bytes(self);
        bytes memory otherb = bytes(other);
        for(uint i=0;i<selfb.length && i<otherb.length;i++){
            bytes1 b1 = selfb[i];
            bytes1 b2 = otherb[i];
            bytes1 ch1 = b1 | 0x20;
            bytes1 ch2 = b2 | 0x20;
            if(ch1 >= 'a' && ch1 <= 'z' && ch2 >= 'a' && ch2 <= 'z'){
                if(ch1 > ch2) return 1;
                if(ch1 < ch2) return -1;
            }
            else{
                if(b1 > b2) return 1;
                if(b1 < b2) return -1;
            }
        }

        if(selfb.length > otherb.length) return 1;
        if(selfb.length < otherb.length) return -1;
        return 0;
    }
    
    function toUppercase(string memory src) internal pure returns(string memory){
        bytes memory srcb = bytes(src);
        for(uint i=0;i<srcb.length;i++){
            bytes1 b = srcb[i];
            if(b >= 'a' && b <= 'z'){
                b &= bytes1(0xDF);// -32
                srcb[i] = b ;
            }
        }
        return src;
    }
    
    function toLowercase(string memory src) internal pure returns(string memory){
        bytes memory srcb = bytes(src);
        for(uint i=0;i<srcb.length;i++){
            bytes1 b = srcb[i];
            if(b >= 'A' && b <= 'Z'){
                b |= 0x20;
                srcb[i] = b;
            }
        }
        return src;
    }

    /**
     * Index Of
     *
     * Locates and returns the position of a character within a string
     * 
     * @param src When being used for a data type this is the extended object
     *              otherwise this is the string acting as the haystack to be
     *              searched
     * @param value The needle to search for, at present this is currently
     *               limited to one character
     * @return int The position of the needle starting from 0 and returning -1
     *             in the case of no matches found
     */
    function indexOf(string memory src, string memory value)
        internal
        pure
        returns (int) {
        return indexOf(src, value, 0);
    }

    /**
     * Index Of
     *
     * Locates and returns the position of a character within a string starting
     * from a defined offset
     * 
     * @param src When being used for a data type this is the extended object
     *              otherwise this is the string acting as the haystack to be
     *              searched
     * @param value The needle to search for, at present this is currently
     *               limited to one character
     * @param offset The starting point to start searching from which can start
     *                from 0, but must not exceed the length of the string
     * @return int The position of the needle starting from 0 and returning -1
     *             in the case of no matches found
     */
    function indexOf(string  memory src, string memory value, uint offset)
        internal
        pure
        returns (int) {
        bytes memory srcBytes = bytes(src);
        bytes memory valueBytes = bytes(value);

        assert(valueBytes.length == 1);

        for (uint i = offset; i < srcBytes.length; i++) {
            if (srcBytes[i] == valueBytes[0]) {
                return int(i);
            }
        }

        return -1;
    }

    function split(string memory src, string memory separator)
        internal
        pure
        returns (string[] memory splitArr) {
        bytes memory srcBytes = bytes(src);

        uint offset = 0;
        uint splitsCount = 1;
        int limit = -1;
        while (offset < srcBytes.length - 1) {
            limit = indexOf(src, separator, offset);
            if (limit == -1)
                break;
            else {
                splitsCount++;
                offset = uint(limit) + 1;
            }
        }

        splitArr = new string[](splitsCount);

        offset = 0;
        splitsCount = 0;
        while (offset < srcBytes.length - 1) {

            limit = indexOf(src, separator, offset);
            if (limit == - 1) {
                limit = int(srcBytes.length);
            }

            string memory tmp = new string(uint(limit) - offset);
            bytes memory tmpBytes = bytes(tmp);

            uint j = 0;
            for (uint i = offset; i < uint(limit); i++) {
                tmpBytes[j++] = srcBytes[i];
            }
            offset = uint(limit) + 1;
            splitArr[splitsCount++] = string(tmpBytes);
        }
        return splitArr;
    }

    //------------HELPER FUNCTIONS----------------
    
    function utf8CharBytesLength(bytes memory stringRep, uint ptr) internal pure returns(uint){
            
            if ((stringRep[ptr]>>7)==bytes1(0))
                return 1;
            if ((stringRep[ptr]>>5)==bytes1(0x06))
                return 2;
            if ((stringRep[ptr]>>4)==bytes1(0x0e))
                return 3;
            if ((stringRep[ptr]>>3)==bytes1(0x1e))
                return 4;
            return 1;
    }

    function memcpy(uint dest, uint src, uint len) private pure{
        // Copy word-length chunks while possible
        for(; len >= 32; len -= 32) {
            assembly {
                mstore(dest, mload(src))
            }
            dest += 32;
            src += 32;
        }

        // Copy remaining bytes
        uint mask = 256 ** (32 - len) - 1;
        assembly {
            let srcpart := and(mload(src), not(mask))
            let destpart := and(mload(dest), mask)
            mstore(dest, or(destpart, srcpart))
        }
    }
    
}