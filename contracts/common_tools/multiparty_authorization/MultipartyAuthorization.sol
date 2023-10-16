// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.10;

/*
 * @author L7L9
 * @dev 多方授权执行交易合约
 * 锁定交易，只有多方授权后才能执行交易
 */
contract MultipartyAuthorization{
    struct Transaction{
        //交易目的合约地址
        address to;
        //交易参数
        bytes _calldata;
        //被授权人数
        uint256 confirmCount;
        //授权地址映射(防止同一个账户反复授权)
        mapping(address => bool) isConfirmed;
        //判断交易是否存在
        bool isExisted;
    }
    
    //可授权账户的数量
    uint256 private ownerCount;
    //可执行门槛，至少需要有threshold个人签名才能执行交易
    uint256 private threshold;
    //判断地址是否为可授权账户
    mapping(address => bool) isOwner;
    //存放交易的映射
    mapping(bytes32 => Transaction) transactions;
    
    //创建交易的事件
    event CreateTx(address indexed to,address indexed creator,bytes _calldata);
    //授权交易的事件
    event ConfirmTx(address indexed authorizer,bytes32 indexed txHash);
    //执行交易的事件
    event ExecuteTx(address indexed caller,bytes32 indexed txHash,uint256 confirmCount,bytes _calldata);
    //添加可执行地址的事件
    event AddOwner(address newOwner);
    //重新设置门槛的事件
    event ResetThreshold(uint256 threshold_);
    
    /*
     * @dev 修饰的函数只有可执行账户可以调用
     */
    modifier onlyOwners(){
        require(isOwner[msg.sender],"MultipartyAuthorization::permissionException: Caller is not owner");
        _;
    }
    
    /*
     * @dev 部署合约时初始化可授权账户以及可执行门槛
     * @param owners_ 可授权账户
     * @param threshold_ 可执行门槛数量
     */
    constructor(address[] memory owners_,uint256 threshold_) public{
        //调用初始化函数
        initializeOwnersAndThreshold(owners_,threshold_);
    }
    
    /*
     * @dev 创建交易
     * @param _to 目标合约地址
     * @param signature 函数签名
     * @param data 交易参数
     * @return 返回交易hash
     */
    function createTransaction(address _to,string memory signature,bytes memory data)public onlyOwners returns(bytes32){
        bytes32 txHash = getTxHash(_to,signature,data);
        //判断该交易是否存在
        require(!transactions[txHash].isExisted,"MultipartyAuthorization::createException: transaction has existed");
        
        //计算calldata
        bytes memory callData = abi.encodePacked(bytes4(keccak256(bytes(signature))),data);
        
        Transaction memory transaction = Transaction({
            to: _to,
            _calldata: callData,
            confirmCount: 1,
            isExisted: true
        });

        transactions[txHash] = transaction;
        transactions[txHash].isConfirmed[msg.sender] = true;
        
        emit CreateTx(_to,msg.sender,data);
        
        return txHash;
    }
    
    /*
     * @dev 授权交易
     * @param txHash 交易hash
     */
    function confirmTransaction(bytes32 txHash) public onlyOwners{
        Transaction memory transaction = transactions[txHash];
        //判断交易是否存在
        require(transaction.isExisted,"MultipartyAuthorization::confirmException: Transaction doesn't exist");
        //判断该账户是否已经授权过该交易
        require(!transactions[txHash].isConfirmed[msg.sender],"MultipartyAuthorization::confirmException: This owner has confirmed");
        
        transaction.confirmCount++;
        transactions[txHash].isConfirmed[msg.sender] = true;
        
        transactions[txHash] = transaction;
        
        emit ConfirmTx(msg.sender,txHash);
    }
    
    /*
     * @dev 执行交易
     * @param txHash 交易hash
     * @return 返回执行交易的结果
     */
    function executeTransaction(bytes32 txHash) public onlyOwners returns(bytes memory){
        Transaction memory transaction = transactions[txHash];
        //判断交易是否存在
        require(transaction.isExisted,"MultipartyAuthorization::executeException: Transaction doesn't exist");
        //判断交易授权人数是否超过门槛
        require(transaction.confirmCount >= threshold,"MultipartyAuthorization::executeException: Transaction confirmCount not enough");
        
        (bool isSuccess,bytes memory result) = transaction.to.call(transaction._calldata);
        //无论是否执行成功都需要重置交易
        delete transactions[txHash];
        //判断是否执行成功
        if(isSuccess){
            emit ExecuteTx(msg.sender,txHash,transaction.confirmCount,transaction._calldata);
            
            return result;
        } else {
            revert("MultipartyAuthorization::executeException: Transaction execution reverted");
        }
    }
    
    /*
     * @dev 添加可执行账户
     * @param _newOwner 想要添加的账户
     * @return 返回交易hash
     */
    function addOwner(address _newOwner) public onlyOwners returns(bytes32 txHash){
        //判断是否已经是可授权账户
        require(!isOwner[_newOwner],"MultipartyAuthorization::addOwnerException: already is owner");
        //判断该地址是否有效
        require(_newOwner != address(0) && _newOwner != address(this),"MultipartyAuthorization::addOwnerException: address is invaild");
        
        bytes memory data = abi.encode(_newOwner);
        //添加可执行账户需要多方授权才能添加
        txHash = createTransaction(address(this),"_addOwner(address)",data);
    }
    
    /*
     * @dev 添加可执行账户
     * @param _newOwner 想要添加的账户
     */
    function _addOwner(address _newOwner) public {
        require(msg.sender == address(this),"MultipartyAuthorization::addOwnerException: Cannot be called directly");
        ++ownerCount;
        isOwner[_newOwner] = true;
        
        emit AddOwner(_newOwner);
    }
    
    /*
     * @dev 重新设置门槛数量
     * @param threshold_ 新的门槛数量
     * @return 交易hash
     */
    function resetThreshold(uint256 threshold_) public onlyOwners returns(bytes32 txHash){
        //判断是否相等，若相等则没必要重新设置
        require(threshold_ != threshold,"MultipartyAuthorization::resetThresholdException: new threshold is equal to the old");
        //门槛数量不可以大于可授权账户的数量
        require(threshold_ <= ownerCount,"MultipartyAuthorization::resetThresholdException: threshold exceeds ownerCount");
        //门槛要至少大于1
        require(threshold_ > 1,"MultipartyAuthorization::resetThresholdException: threshold at least greater than 1");
        
        bytes memory data = abi.encode(threshold_);
        //添加可执行账户需要多方授权才能添加
        txHash = createTransaction(address(this),"_resetThreshold(uint256)",data);
    }
    
    /*
     * @dev 重新设置门槛数量
     * @param threshold_ 新的门槛数量
     */
    function _resetThreshold(uint256 threshold_) public{
        require(msg.sender == address(this),"MultipartyAuthorization::resetThresholdException: Cannot be called directly");
        threshold = threshold_;
        emit ResetThreshold(threshold_);
    }
    
    /*
     * @dev 初始化可授权账户以及可执行门槛
     * @param owners_ 可授权账户
     * @param threshold_ 可执行门槛数量
     */
    function initializeOwnersAndThreshold(address[] memory owners_,uint256 threshold_) internal {
        //门槛数量不可以大于可授权账户的数量
        require(threshold_ <= owners_.length,"MultipartyAuthorization::initializeException: threshold exceeds ownerCount");
        //门槛要至少大于1
        require(threshold_ > 1,"MultipartyAuthorization::initializeException: threshold at least greater than 1");
        
        //遍历owners数组
        for(uint256 i = 0;i < owners_.length;i++){
            //多签账户不能为0或者合约本身
            require(owners_[i] != address(0) && owners_[i] != address(this) && !isOwner[owners_[i]],
            "MultipartyAuthorization::initializeException: address is invaild");
            
            isOwner[owners_[i]] = true;
        }
        //设置多签账户数量
        ownerCount = owners_.length;
        //设置门槛数量
        threshold = threshold_;
    }
    
    /*
     * @dev 计算交易的hash
     * @param _to 目的合约地址
     * @param signature 函数签名
     * @param data 交易参数
     */
    function getTxHash(address _to,string memory signature,bytes memory data) internal pure returns(bytes32){
        return keccak256(abi.encodePacked(_to,signature,data));
    }
    
    /*
     * @dev 根据交易hash查询交易的详情
     * @param txHash 交易hash
     * @return 交易目的合约地址
     * @return 交易参数
     * @return 已经授权的人数
     */
    function getTransaction(bytes32 txHash) public view returns(address,bytes memory,uint256){
        Transaction memory transaction = transactions[txHash];
        //判断交易是否存在
        require(transaction.isExisted,"MultipartyAuthorization::queryException: Transaction doesn't exist");
        
        return (transaction.to,transaction._calldata,transaction.confirmCount);
    }
}