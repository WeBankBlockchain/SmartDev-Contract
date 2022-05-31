pragma solidity ^0.8.0;

contract FuncCallContract {
    event FuncCall(
        address indexed _from,
        address indexed _origin,
        string _func,
        bytes _args
    );

    modifier LogFuncCall(string memory func) {
        uint256 len = 0;
        assembly {
            len := calldatasize() // 36
        }
        bytes memory args = new bytes(len);
        assembly {
            calldatacopy(add(args, 0x20), 0, len)
        }
        emit FuncCall(msg.sender, tx.origin, func, args);
        _;
    }
}

contract Test is FuncCallContract {
    function test(uint256 x)
        external
        LogFuncCall("test(uint256)")
        returns (uint256)
    {
        return x + 233;
    }
}
