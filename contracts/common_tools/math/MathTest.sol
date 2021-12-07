pragma solidity ^0.4.25;

import "./Math.sol";

contract MathTest{

    function sqrt(uint x) public view returns (uint){
        return Math.sqrt(x); // x = 4 ,return 2
    }

    function log2(uint x) public view returns(uint) {
        return Math.log2(x); //x = 2, return 1
    }

    function log(uint m, uint n) public view returns(uint) {
        return Math.log(m, n); //m = 10, n = 100, return 2
    }

    function exp2(int n) public view returns(uint) {
        return Math.exp2(n); //n = 2, return 4
    }

    function exp(int m, int n) public view returns(int) {
        return Math.exp(m, n); //m = +-2, n =2, return 4; m=-2, n=1, return -2
    }
}
