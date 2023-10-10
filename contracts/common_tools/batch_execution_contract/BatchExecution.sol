// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.10;
pragma experimental ABIEncoderV2;

/*
 * @author L7L9
 * @dev 多交易执行合约：一次性执行多个交易，保证原子性
 */
contract BatchExecution{
    //管理员地址
    address private _owner;
    
    constructor() public{
        _owner = msg.sender;
    }
    
    struct Transaction{
        //合约地址
        address target;
        //交易参数
        bytes _calldata;
    }
    
    //记录添加交易的事件
    event LogAddTransaction(address indexed target,string signature,bytes data);
    //执行交易数组里的所有交易的事件
    event LogExecuteTranscation(uint256 amount);
    //设置新管理员的事件
    event NewAdmin(address newAdmin);
    
    //存放交易数据的数组
    Transaction[] private transactions;

    /*
     * @dev 修饰的函数只有管理员能执行
     */
    modifier onlyOwner() {
        require(msg.sender == _owner, "Ownable: not authorized");
        _;
    }
    
    /*
     * @dev 向交易数组中添加交易数据
     * @param _target 判断目标合约地址
     * @param signature 判断函数签名
     * @param data 函数的参数(经过ABI编码编译后)
     */
    function addTransaction(address _target,string memory signature,bytes memory data) public onlyOwner{
        //判断目标合约地址是否有效
        require(_target != address(0),"MultiTradeExecute::addTransactionException: address is invaild");
        //计算交易参数
        bytes memory _calldata = getFuncData(signature,data);
        
        //存入交易数组
        Transaction memory transaction = Transaction(_target,_calldata);
        transactions.push(transaction);
        
        emit LogAddTransaction(_target,signature,data);
    }
    
    /*
     * @dev 遍历数组，执行所有的交易
     */
    function executeTransaction() public onlyOwner returns(bytes[] memory){
        //获取交易数量
        uint256 length = getTransactionAmount();
        //判断数组里是否有交易
        require(length != 0,"MultiTradeExecute::executeTransactionException: transactions is empty");
        
        //创建一个用于存放返回结果的数组
        bytes[] memory returnObjects = new bytes[](length);
        //遍历数组
        for(uint256 i = 0;i < length;i++){
            Transaction memory transaction = transactions[i];
            //调用交易
            (bool isSuccess,bytes memory result) = transaction.target.call(transaction._calldata);
            //判断交易是否成功
            if(isSuccess){
                //执行成功,将返回数据加入返回数组
                returnObjects[i] = result;
            } else {
                //执行失败，需要清空数组内容，重新进行批量执行
                delete transactions;
                revert("MultiTradeExecute::executeTransactionException: Transaction execution reverted");
            }
        }
        //清空交易数组的内容
        delete transactions;
        
        emit LogExecuteTranscation(length);
        return returnObjects;
    }
    
    /*
     * @dev 计算交易的参数
     * @param signature 判断函数签名
     * @param data 函数的参数(经过ABI编码编译后)
     * @return 返回交易数据
     */
    function getFuncData(string memory signature,bytes memory data) internal pure returns(bytes memory){
        return abi.encodePacked(bytes4(keccak256(bytes(signature))),data);
    }
    
    /*
     * @dev 获取交易数组里的交易数量
     */
    function getTransactionAmount() public view returns(uint256){
        return transactions.length;
    }
    
    /*
     * @dev 设置新管理员
     */
    function changeAdmin(address newAdmin) public onlyOwner{
        _owner = newAdmin;
        emit NewAdmin(newAdmin);
    }
}