pragma solidity ^0.4.25;

import "./LibSafeMath.sol";

contract TestSafeMath {
  using LibSafeMath for uint256;

  function testAdd(uint256 a, uint256 b) external returns (uint256 c) {
        //c = LibSafeMath.add(a,b);
        c = a.add(b);
  }
}