pragma solidity ^0.4.25;
pragma experimental ABIEncoderV2;

import "./Lib2DArrayForUint256.sol";

contract TwoDArrayDemo {

    uint256[][] private array;
    uint256[][] private array2;
    uint256[] val  = [1,2];
    uint256[] val2 = [3, 4, 5];
    uint256[] val3 = [6, 7, 8, 9];

    function addAndGetValue(uint256 row, uint256 col) public view returns (uint256)  {
        array = new uint256[][](0);
        Lib2DArrayForUint256.addValue(array,val);
        Lib2DArrayForUint256.addValue(array,val2);
        // (1,1) => expected Return values:(4)
        return Lib2DArrayForUint256.getValue(array,row,col);
    }

    function firstIndexOf(uint256 key) public view returns (bool, uint256, uint256)  {
        array = new uint256[][](0);
        Lib2DArrayForUint256.addValue(array,val);
        // (2) => expected Return values:(true, 0, 0)
        return Lib2DArrayForUint256.firstIndexOf(array,key);
    }


    function setValue(uint256 row, uint256 col, uint256 key) public view returns (uint256[][]) {
        array = new uint256[][](0);
        Lib2DArrayForUint256.addValue(array,val);
        Lib2DArrayForUint256.addValue(array,val2);
        // (1, 0, 9) => expected Return values:([[1, 2] [9, 4, 5] ] )
        return Lib2DArrayForUint256.setValue(array,row,col,key);
    }

    function removeByIndex(uint256 index) public view returns (uint256[][])  {
        array = new uint256[][](0);
        Lib2DArrayForUint256.addValue(array,val);
        Lib2DArrayForUint256.addValue(array,val2);
        Lib2DArrayForUint256.addValue(array,val3);
        // 1 => expected Return values:([[1, 2] [6, 7, 8, 9] ] )
        return Lib2DArrayForUint256.removeByIndex(array,index);

    }

    function extend() public view returns (uint256[][]) {
        array = new uint256[][](0);
        array2 = new uint256[][](0);
        Lib2DArrayForUint256.addValue(array,val);
        Lib2DArrayForUint256.addValue(array,val2);
        Lib2DArrayForUint256.addValue(array2,val3);
        // expected Return values:([[1, 2] [3, 4, 5] [6, 7, 8, 9] ] )
        return Lib2DArrayForUint256.extend(array,array2);
    }
}