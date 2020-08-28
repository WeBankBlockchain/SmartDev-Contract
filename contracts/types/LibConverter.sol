/*
#    Copyright (C) 2017  alianse777

#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

pragma solidity ^0.4.25;


/**
 * @dev Wrappers over Solidity's uintXX casting operators with added overflow
 * checks.
 *
 * Downcasting from uint256 in Solidity does not revert on overflow. This can
 * easily result in undesired exploitation or bugs, since developers usually
 * assume that overflows raise errors. `SafeCast` restores this intuition by
 * reverting the transaction when such an operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 *
 * Can be combined with {SafeMath} to extend it to smaller types, by performing
 * all math on `uint256` and then downcasting.
 *
 * _Available since v2.5.0._
 */
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
    function uintToBytes(uint v) internal pure returns (bytes) {
        uint maxlength = 100; 
        bytes memory reversed = new bytes(maxlength);
        uint i = 0; 
        while (v != 0) { 
            uint remainder = v % 10; 
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
    

    function bytesToInt(bytes b) internal pure returns (int result) {
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
        while(uint(b[b.length - tr - 1]) == 0x00) {
            tr++;
        }
        for (;i < b.length - tr; i++) { 
            uint c = uint(b[i]); 
            if (c >= 48 && c <= 57) { 
                result *= 10;
                result = result + int(c - 48);
            }
        }
        if(sign) {
            result *= -1;
        } 
    }
    
    function intToBytes(int v) internal pure returns (bytes) {
        uint maxlength = 100; 
        bytes memory reversed = new bytes(maxlength);
        uint i = 0;
        uint x;
        if(v < 0)
            x = uint(-v);
        else
            x = uint(v);
        while (x != 0) { 
            uint remainder = uint(x % 10); 
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

