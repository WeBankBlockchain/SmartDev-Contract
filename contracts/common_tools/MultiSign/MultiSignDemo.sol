@@ -1,25 +1,39 @@
//简而言之，这段代码定义了一个名为 MultiSignDemo 的 Solidity 智能合约，它继承了 MultiSign 合约的功能。它引入了一个名为 MultiSignLog 的事件，用于记录与交易相关的信息，并在签名过程完成时跟踪回调次数。合约构造函数初始化了所有者的地址，并从父合约设置了必要的参数。覆盖的 signFinishedCallBack 函数在交易签名过程完成时触发一个事件，并增加回调次数的计数。

// SPDX-License-Identifier: UNLICENSED
/// @author Steve Jin

// 声明这段代码适用的 Solidity 版本范围
pragma solidity >=0.8.0;

// 从文件 "MultiSign.sol" 导入 MultiSign 合约
import {MultiSign} from "./MultiSign.sol";

// 定义一个名为 MultiSignDemo 的合约，该合约继承自 MultiSign 合约
contract MultiSignDemo is MultiSign {

// 声明一个事件 MultiSignLog，当特定动作发生时会触发这个事件
event MultiSignLog(address from, address to, bytes data, address[] signers, uint signCount);

// 声明一个公共状态变量 owner，用于存储合约所有者的地址
address public owner;

// 声明一个公共状态变量，用于跟踪签名完成回调的调用次数
uint public signFinishedCallBackCount = 0;

// MultiSignDemo 合约的构造函数
// 它接受一个地址数组和所需签名的最小数量作为参数
constructor(address[] memory addressParams, uint minSignaturesParam) MultiSign(addressParams, minSignaturesParam) {
    // 将合约的所有者设置为部署者（发送者）的地址
    owner = msg.sender;
}

// 内部函数，覆盖 MultiSign 合约中的 signFinishedCallBack 函数
function signFinishedCallBack(Transaction storage transaction) override internal {
    // 触发 MultiSignLog 事件，记录有关已完成交易的信息
    emit MultiSignLog(transaction.from, transaction.to, transaction.data, transaction.signers, transaction.signCount);
    
    // 增加 signFinishedCallBackCount 变量的计数
    signFinishedCallBackCount++;
}
}
