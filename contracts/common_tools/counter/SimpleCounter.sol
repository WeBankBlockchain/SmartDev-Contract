pragma solidity 0.4.25;

// Contract: SimpleCounter
// Description:
//      inc/dec counter by val
//      safe inc and dec with maximum uint256 and minimum 0
// Core Functions:
//      inc_val(uint x) -> (bool, uint): inc counter by x
//      dec_val(uint x) -> (bool, uint): dec counter by x
//      inc() -> (bool, uint): inc counter by 1
//      dec() -> (bool, uint): dec counter by 1

contract SimpleCounter {
    uint256 counter = 0;
    uint256 MAXVAL = 1<<256-1;

    constructor() public {
        counter = 0;
    }

    function inc_val(uint x) public returns(bool, uint) {
        if (MAXVAL - counter >= x) {
            counter += x;
            return (true, counter);
        }
        return (false, counter);
    }

    function dec_val(uint x) public returns(bool, uint) {
        if (counter - x >= 0) {
            counter -= x;
            return (true, counter);
        }
        return (false, counter);
    }

    function inc() public returns(bool, uint) {
        return inc_val(1);
    }

    function dec() public returns(bool, uint) {
        return dec_val(1);
    }

    function get() public view returns(uint) {
        return counter;
    }

}