pragma solidity ^0.4.25;

import "./MathAdvance.sol";

contract MathAdvanceTest{

    function sqrt(uint x) public view returns (uint){
        return MathAdvance.sqrt(x); // x = 4 ,return 2
    }

    function log2(uint x) public view returns(uint) {
        return MathAdvance.log2(x); //x = 2, return 1
    }

    function log(uint m, uint n) public view returns(uint) {
        return MathAdvance.log(m, n); //m = 10, n = 100, return 2
    }

    function exp2(int n) public view returns(uint) {
        return MathAdvance.exp2(n); //n = 2, return 4
    }

    function exp(int m, int n) public view returns(int) {
        return MathAdvance.exp(m, n); //m = +-2, n =2, return 4; m=-2, n=1, return -2
    }
}
