pragma solidity ^0.4.25;//版本号
import "./LibArrayForUint256Utils.sol"; // 导入

contract ArrayDemo {
    uint[] private array; // 定义私有数组
    uint[] private array1; // 定义私有数组1
    uint[] private array2; // 定义私有数组2

    // 函数f1
    function f1() public view {
        array = new uint[](0); // 创建一个空数组
        LibArrayForUint256Utils.addValue(array, 2); // 调用库函数将2添加到数组中
        // array: {2}
    }

    // 函数f2
    function f2() public view {
        array1 = new uint[](2); // 创建一个长度为2的数组
        array2 = new uint[](2); // 创建一个长度为2的数组
        LibArrayForUint256Utils.extend(array1, array2); // 调用库函数合并数组
        // array1 length 4
    }

    // 函数f3
    function f3() public view {
        array = new uint[](2); // 创建一个长度为2的数组
        array[0] = 2; // 设置数组第一个元素为2
        array[1] = 2; // 设置数组第二个元素为2
        LibArrayForUint256Utils.distinct(array); // 调用库函数去重数组
        // array: {2}
    }
}