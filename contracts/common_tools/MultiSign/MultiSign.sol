@@ -1,61 +1,89 @@
//这个合约实现了一个多签名逻辑，确保在一定数量的签名者对交易进行签名后，交易才能被执行。签名者可以使用 signTransaction 函数对交易进行签名，当达到最小签名要求时，交易将被标记为已完成。这是一个常用的多签名合约模式，用于确保多个授权者的参与。注意，这只是合约的逻辑分析，实际应用中还需要进行测试和适当的安全性评估。

// SPDX-License-Identifier: UNLICENSED
// 合约许可声明：此合约未受许可，没有特定的使用许可。
// 作者：Steve Jin
// 合约作者注释：此合约的作者是Steve Jin。

pragma solidity >=0.8.0;

// 引入Solidity版本声明：此合约需要Solidity版本大于或等于0.8.0。

// 这是一个抽象合约，定义了多签名合约的核心逻辑和数据结构
abstract contract MultiSign {

    // 存储多签名合约的签名者地址数组
    address[] internal signers;

    // 用于跟踪交易索引，每次提交交易后递增
    uint internal transactionIdx;

    // 用于存储交易信息的结构体，包括交易发起者、接收者、数据、签名者数组、已签名标记、签名数等信息
    struct Transaction {
        address from;
        address to;
        bytes data;
        address[] signers;
        mapping(address => uint) hasSign;
        uint signCount;
    }

    // 存储待处理交易的交易ID数组
    uint[] internal pendingTransactions;

    // 辅助数组，在处理待处理交易时使用
    uint[] internal newPT;

    // 用于存储交易ID与对应的交易信息之间的映射
    mapping(uint => Transaction) internal transactions;

    // 要求的最小签名数
    uint internal minSignatures;

    // 修饰符，限制只有合约中的签名者才能执行受限函数
    modifier signerOnly() {
        bool flag = false;
        for (uint i = 0; i < signers.length; i++) {
            if (msg.sender == signers[i]) {
                flag = true;
                break;
            }
        }
        require(flag, "Only signers are allowed to operate.");
        _;
    }

    // 构造函数，初始化多签名合约。构造函数接受一个签名者地址数组和最小签名数作为参数
    constructor(address[] memory addressParams, uint minSignaturesParam) {
        // 要求最小签名数不大于签名者地址数组长度加1
        require(minSignaturesParam <= addressParams.length + 1, "The number of signatures cannot be greater than the signers.");
        for (uint i = 0; i < addressParams.length; i++) {
            // 确保合约创建者不会被传递为参数
            require(msg.sender != addressParams[i], "Contract creator cannot be passed in as a parameter.");
        }
        signers = addressParams;
        signers.push(msg.sender); // 将合约创建者添加为签名者之一
        transactionIdx = 0;
        minSignatures = minSignaturesParam;
    }

    // 公开函数，返回签名者的地址数组
    function showSigner() public view returns (address[] memory) {
        return signers;
    }

    // 公开函数，返回下一个可用的交易ID
    function showNextTransactionIdx() public view returns (uint) {
        return transactionIdx;
    }

    // 公开函数，返回待处理交易的交易ID数组
    function showPendingTransactions() public view returns (uint[] memory) {
        return pendingTransactions;
    }

    // 公开函数，用于创建一个新的交易。将交易信息添加到 transactions 映射中，将交易ID添加到 pendingTransactions 数组中
    function transfer(address to, bytes memory data) public signerOnly returns (uint) {
        uint transactionId = transactionIdx;
        Transaction storage transaction = transactions[transactionId];
        transaction.from = msg.sender;
        transaction.to = to;
        transaction.data = data;
        transaction.signers.push(msg.sender);
        transaction.hasSign[msg.sender] = 0;
        transaction.signCount = 1;
        pendingTransactions.push(transactionId);
        transactionIdx++;
        return transactionId;
    }

    // 公开函数，签名者使用此函数对特定交易进行签名。如果达到了最小签名要求，交易将被标记为已完成
    function signTransaction(uint transactionId) public signerOnly returns (bool) {
        Transaction storage transaction = transactions[transactionId];
        require(address(0) != transaction.from, "Transaction id does not exist.");
        require(msg.sender != transaction.from, "Signer cannot be initiator.");
        require(transaction.hasSign[msg.sender] != 1, "Cannot duplicate signature.");

        if (signFinished(transactionId)) {
            transaction.signers.push(msg.sender);
            transaction.hasSign[msg.sender] = 1;
            transaction.signCount++;
            return true;
        }

        transaction.signers.push(msg.sender);
        transaction.hasSign[msg.sender] = 1;
        transaction.signCount++;

        if (transaction.signCount >= minSignatures) {
            removePendingTransactions(transactionId);
            signFinishedCallBack(transaction);
            return true;
        }
        return false;
    }

    // 公开函数，检查特定交易是否已达到要求的最小签名数
    function signFinished(uint transactionId) public view returns (bool) {
        Transaction storage transaction = transactions[transactionId];
        if (transaction.signCount >= minSignatures) {
            return true;
        }
        return false;
    }

    // 内部函数，用于移除已完成的待处理交易
    function removePendingTransactions(uint transactionId) internal returns (uint[] memory) {
        delete newPT;
        for (uint i = 0; i < pendingTransactions.length; i++) {
            if (pendingTransactions[i] != transactionId) {
                newPT.push(pendingTransactions[i]);
            }
        }
        delete pendingTransactions;
        pendingTransactions = newPT;
        delete newPT;
        return pendingTransactions;
    }

    // 内部虚函数，用于在交易完成时执行回调操作。这个函数应该在继承合约中被实现
    function signFinishedCallBack(Transaction storage transaction) internal virtual;
}
