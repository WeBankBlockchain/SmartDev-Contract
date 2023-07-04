pragma solidity ^0.6.10;

import "./Ownable.sol";
import "./SafeMath.sol";

/*
 * @author L7L9
 * @dev 时间锁合约模板
 * 将某个合约的函数操作锁定在一个时间段里，经过时间段后才可以执行该函数
 * 在该时间段中，可以取消该函数操作或者修改函数的输入参数
 * 时间锁合约可以将智能合约的某些功能锁定一段时间，可以大大改善智能合约的安全性
 */
contract Timelock is Ownable{
    using SafeMath for uint;

    //时间锁超时期限
    uint public constant OVERTIME = 7 days * 1000;

    //由于fisco中的时间戳以毫秒计,因此1000 = 1s
    uint public constant DELAY_UNIT = 1 minutes * 1000;

    struct Operate{
        //目标合约地址
        address target;
        //可执行时间
        uint256 executeTime;
        //函数签名
        string signature;
        //函数的参数
        bytes data;
        //是否存在
        bool isExist;
    }

    //添加交易锁的事件
    event LogQueue(bytes32 indexed operateHash,address indexed target,string signature,uint256 executeTime,bytes data);
    //取消时间锁的事件
    event LogCancel(bytes32 indexed operateHash);
    //执行操作的事件
    event LogExecute(bytes32 indexed operateHash,bytes data,uint executeTime);
    //修改某个操作参数的事件
    event LogChangeData(bytes32 indexed hash,bytes data);

    //等待执行的操作映射
    mapping(bytes32 => Operate) waitGroup;

    //用于判断映射中的操作是否存在
    modifier operateIsExist(bytes32 hash){
        require(waitGroup[hash].isExist,"TimeLock:this operate not exist");
        _;
    }

    /*
     * @dev 将操作加入到锁定的队列
     * @param delay:操作锁定时间
     * @param target:目标合约地址
     * @param signature:执行函数的签名
     * @param data:执行函数的参数(此处需要将参数转为符合标准的ABI编码传入)
     */
    function queueTransaction(uint256 delay,address target,string memory signature,bytes memory data) public onlyOwner returns(bytes32){
        //计算操作可执行的时间
        //delay为有效期转化的时间戳增加量(分钟为单位)
        uint256 executeTime = getBlockTimestamp().add(delay.mul(DELAY_UNIT));

        //计算操作的唯一标识
        bytes32 hash = getHash(target,signature);

        //加入操作映射
        Operate memory operate = Operate(target,executeTime,signature,data,true);
        waitGroup[hash] = operate;

        //触发事件
        emit LogQueue(hash,target,signature,executeTime,data);
        return hash;
    }

    /*
     * @dev 取消队列中锁定的操作
     * @param 操作的hash
     */
    function cancelTransaction(bytes32 hash) public onlyOwner operateIsExist(hash){
        //取消时间锁锁定的操作
        delete waitGroup[hash];
        emit LogCancel(hash);
    }

    /*
     * @dev 修改队列中操作的参数
     * @notice 若不希望操作中的参数被修改，可以删除该函数
     * @param 操作的hash
     * @param 操作的参数
     */
    function changeData(bytes32 hash,bytes memory newData) public onlyOwner operateIsExist(hash){
        require(getBlockTimestamp() < waitGroup[hash].executeTime,"TimeLock:operate has surpassed time lock,cannot change data");
        waitGroup[hash].data = newData;

        emit LogChangeData(hash,newData);
    }

    /*
     * @dev 执行可执行的操作
     * @param 操作的hash
     * @return 返回执行操作的返回结果
     */
    function executeTransaction(bytes32 hash) public operateIsExist(hash) returns(bytes memory){
        Operate memory operate = waitGroup[hash];
        //检测是否已经可以执行该操作
        require(getBlockTimestamp() >= operate.executeTime,"TimeLock:operate hasn't surpassed time lock");
        //检测该操作能执行的时间是否已经超过期限
        require(getBlockTimestamp() <= operate.executeTime.add(OVERTIME),"TimeLock:operate is overtime");

        //计算callData
        bytes memory callData = abi.encodePacked(bytes4(keccak256(bytes(operate.signature))),operate.data);
        //执行操作
        (bool isSuccess,bytes memory result) = operate.target.call(callData);
        //判断操作是否成功
        require(isSuccess,"TimeLock:operate failed,data error or execution reverted");
        //触发事件
        emit LogExecute(hash,operate.data,getBlockTimestamp());
        //将操作从映射中删除
        delete waitGroup[hash];
        return result;
    }

    /*
     * @dev 计算操作的唯一id
     */
    function getHash(address target,string memory signature) private view returns(bytes32){
        return keccak256(abi.encode(target,signature,getBlockTimestamp()));
    }

    /*
     * @dev 获取时间戳
     */
    function getBlockTimestamp() internal view returns(uint){
        return block.timestamp;
    }
}