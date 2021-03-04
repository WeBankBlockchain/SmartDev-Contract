/*
 * Copyright 2014-2019 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * */
 
pragma solidity>=0.4.24 <0.6.11;

library LibConverter {

    /**
     * @dev Returns the downcasted uint128 from uint256, reverting on
     * overflow (when the input is greater than largest uint128).
     *
     * Counterpart to Solidity's `uint128` operator.
     *
     * Requirements:
     *
     * - input must fit into 128 bits
     */
    function toUint128(uint256 value) internal pure returns (uint128) {
        require(value < 2**128, "SafeCast: value doesn\'t fit in 128 bits");
        return uint128(value);
    }

    /**
     * @dev Returns the downcasted uint64 from uint256, reverting on
     * overflow (when the input is greater than largest uint64).
     *
     * Counterpart to Solidity's `uint64` operator.
     *
     * Requirements:
     *
     * - input must fit into 64 bits
     */
    function toUint64(uint256 value) internal pure returns (uint64) {
        require(value < 2**64, "SafeCast: value doesn\'t fit in 64 bits");
        return uint64(value);
    }

    /**
     * @dev Returns the downcasted uint32 from uint256, reverting on
     * overflow (when the input is greater than largest uint32).
     *
     * Counterpart to Solidity's `uint32` operator.
     *
     * Requirements:
     *
     * - input must fit into 32 bits
     */
    function toUint32(uint256 value) internal pure returns (uint32) {
        require(value < 2**32, "SafeCast: value doesn\'t fit in 32 bits");
        return uint32(value);
    }

    /**
     * @dev Returns the downcasted uint16 from uint256, reverting on
     * overflow (when the input is greater than largest uint16).
     *
     * Counterpart to Solidity's `uint16` operator.
     *
     * Requirements:
     *
     * - input must fit into 16 bits
     */
    function toUint16(uint256 value) internal pure returns (uint16) {
        require(value < 2**16, "SafeCast: value doesn\'t fit in 16 bits");
        return uint16(value);
    }

    /**
     * @dev Returns the downcasted uint8 from uint256, reverting on
     * overflow (when the input is greater than largest uint8).
     *
     * Counterpart to Solidity's `uint8` operator.
     *
     * Requirements:
     *
     * - input must fit into 8 bits.
     */
    function toUint8(uint256 value) internal pure returns (uint8) {
        require(value < 2**8, "SafeCast: value doesn\'t fit in 8 bits");
        return uint8(value);
    }

 /**
    * @dev Convert unsigned int to c-string (bytes).
    * @param v - uint to convert.
    * @return bytes.
    */
    function uintToBytes(uint v) internal pure returns (bytes memory) {
        uint maxlength = 100; 
        bytes memory reversed = new bytes(maxlength);
        uint i = 0; 
        while (v != 0) { 
            uint8 remainder = uint8(v % 10); 
            v = v / 10; 
            reversed[i % maxlength] = byte(48 + remainder); 
            i++;
        } 
        bytes memory s = new bytes(i + 1); 
        for (uint j = 1; j <= i % maxlength; j++) { 
            s[j-1] = reversed[i - j];
        } 
        return bytes(s);
    }
    

    function bytesToInt(bytes memory b) internal pure returns (int result) {
        uint i = 0;
        uint tr = 0;
        result = 0;
        bool sign = false;
        if(b[i] == "-") {
            sign = true;
            i++;
        } else if(b[i] == "+") {
            i++;
        }
        while(uint8(b[b.length - tr - 1]) == 0x00) {
            tr++;
        }
        for (;i < b.length - tr; i++) { 
            uint8 c = uint8(b[i]); 
            if (c >= 48 && c <= 57) { 
                result *= 10;
                result = result + int(c - 48);
            }
        }
        if(sign) {
            result *= -1;
        } 
    }
    
    function intToBytes(int v) internal pure returns (bytes memory) {
        uint maxlength = 100; 
        bytes memory reversed = new bytes(maxlength);
        uint i = 0;
        uint x;
        if(v < 0)
            x = uint(-v);
        else
            x = uint(v);
        while (x != 0) { 
            uint8 remainder = uint8(x % 10); 
            x = x / 10; 
            reversed[i % maxlength] = byte(48 + remainder); 
            i++;
        }
        if(v < 0)
            reversed[(i++) % maxlength] = "-";
        bytes memory s = new bytes(i+1); 
        for (uint j = 1; j <= i % maxlength; j++) { 
            s[j - 1] = reversed[i - j];
        } 
        return bytes(s); 
    }
}

