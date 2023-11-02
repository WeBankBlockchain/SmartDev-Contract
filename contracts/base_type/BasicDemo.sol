pragma solidity ^0.4.25;
import "./LibAddress.sol";
import "./LibConverter.sol" ;
import "./LibSafeMathForUint256Utils.sol";
contract BasicDemo {

    function safeMathDemo() public view {
        uint256 a =25;
        uint256 b =20;
        // a + b
        uint256 c = LibSafeMathForUint256Utils.add(a,b);
        // a - b
        uint256 d = LibSafeMathForUint256Utils.sub(a,b);
        // a * b
        uint256 e = LibSafeMathForUint256Utils.mul(a,b);
        // a/b
        uint256 f = LibSafeMathForUint256Utils.div(a,b);
    }

    function modPower() public view {
        uint256 a=25;
        uint256 b=20;
        // a % b
        uint256 c = LibSafeMathForUint256Utils.mod(a,b);
        // a ^ b
        uint256 d = LibSafeMathForUint256Utils.power(a,b);
    }

    function convertDemo() public view{
        uint256 a = 25;
	//转换为字节数组并赋值
        bytes memory b = LibConverter.uintToBytes(a);
    }

    function convertDemo2() public view{
        bytes memory a = "25";
	//转换为整数并赋值
        int b = LibConverter.bytesToInt(a);
    }
	//地址转换操作
    function addressDemo() public view{
        address addr = 0xE0f5206BBD039e7b0592d8918820024e2a7437b9;
	//转为字节数组赋值
        bytes memory bs=LibAddress.addressToBytes(addr);
	//设置长度为20
        bs = new bytes(20);
	//调用函数将数组转为地址
        addr = LibAddress.bytesToAddress(bs);
	//更换地址变量
        addr = 0xE0f5206BBD039e7b0592d8918820024e2a7437b9;
        string memory addrStr = LibAddress.addressToString(addr);
        string memory str="0xE0f5206BBD039e7b0592d8918820024e2a7437b9";
        addr = LibAddress.stringToAddress(str);
    }
}