pragma solidity ^0.4.25;

import "./LibAddressSet.sol";

contract AddressSetDemo {
    using LibAddressSet for LibAddressSet.AddressSet;
    LibAddressSet.AddressSet private addressSet;

    event Log(uint256 size);

    function testAddress() public {
        //添加元素；
        addressSet.add(address(1));
        // {1}
        // 查询set容器数量
        uint256 size = addressSet.getSize();
        require(size == 1);
        // 获取指定index的元素
        address addr = addressSet.get(0);
        require(addr == (address(1));
        // 返回set中所有的元素
        addressSet.getAll();
        // {0x1}
        // 判断元素是否存在
        bool contains = addressSet.contains(address(1));
        require(contains== true);
        // 删除元素
        addressSet.remove(address(1));
    }
}
