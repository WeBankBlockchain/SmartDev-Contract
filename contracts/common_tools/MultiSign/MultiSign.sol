// SPDX-License-Identifier: UNLICENSED
/// @author Steve Jin

pragma solidity >=0.8.0;
 
abstract contract MultiSign {

    address[] internal signers;
    uint internal transactionIdx;
    struct Transaction {
        address from;
        address to;
        bytes data;
        address[] signers;
        mapping(address=>uint) hasSign;
        uint signCount;
    }
    uint[] internal pendingTransactions;
    uint[] internal newPT;
    mapping(uint=>Transaction) internal transactions;
    uint internal minSignatures;

    modifier signerOnly() {
        bool flag = false;
        for(uint i=0; i<signers.length; i++){
            if(msg.sender == signers[i]){
                flag = true;
                break;
            }
        }
        require(flag, "Only signer are allowed to operate.");
        _;
    }

    constructor(address[] memory addressParams, uint minSignaturesParam) {
        require(minSignatures <= addressParams.length + 1, "The number of signatures cannot be greater than the signers.");
        for(uint i=0; i<addressParams.length; i++){
            require(msg.sender != addressParams[i], "Contract creator cannot be passed in as a parameter.");
        }
        signers = addressParams;
        signers.push(msg.sender);
        transactionIdx = 0;
        minSignatures = minSignaturesParam;
    }

    function showSigner() public view returns(address[] memory) {
        return signers;
    }

    function showNextTransactionIdx() public view returns(uint) {
        return transactionIdx;
    }

    function showPendingTransactions() public view returns(uint[] memory) {
        return pendingTransactions;
    }

    function transfer(address to, bytes memory data) public signerOnly returns(uint){
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

    function signTransaction(uint transactionId) public signerOnly returns(bool){
        Transaction storage transaction = transactions[transactionId];
        require(address(0) != transaction.from, "Transaction id does not exist.");
        require(msg.sender != transaction.from, "Signer cannot be initiator.");
        require(transaction.hasSign[msg.sender] != 1, "Cannot duplicate signature.");

        if(signFinished(transactionId)){
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

    function signFinished(uint transactionId) public view returns(bool){
        Transaction storage transaction = transactions[transactionId];
        if (transaction.signCount >= minSignatures) {
            return true;
        }
        return false;
    }

    function removePendingTransactions(uint transactionId) internal returns(uint[] memory) {
        delete newPT;
        for (uint i=0; i<pendingTransactions.length; i++){
            if(pendingTransactions[i] != transactionId){
                newPT.push(pendingTransactions[i]);
            }
        }
        delete pendingTransactions;
        pendingTransactions = newPT;
        delete newPT;
        return pendingTransactions;
    }

    function signFinishedCallBack(Transaction storage transaction) internal virtual;

}