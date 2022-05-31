/*
SPDX-License-Identifier: Apache-2.0
*/
pragma solidity >0.5.11;
contract counter {
    //计数器mapper,以bytes32作为计数器key，uint256为当前计数器的技术值
    mapping(bytes32=>uint256) CounterOf;
    //counter 计数器id，operator 操作人地址，time 操作时间，preVal 操作前的值，finalVal 操作后的值
    event counterAddLog(bytes32 indexed counter,address indexed operator,uint time,uint preVal,uint finalVal);
    //计数器+1操作，需要传递计数器id，执行成功后，会提示计数前与计数后的值
    function counterAdd(bytes32 _countid)public returns(uint256 , uint256 ){
        //获取当前计数器计数值，用户结果返回，方便用户对结果进行核验
        uint256 preVal =  CounterOf[_countid];
        //计数器val加1
        CounterOf[_countid] += 1;
        emit counterAddLog(_countid,msg.sender,block.timestamp,preVal,CounterOf[_countid]);
        return (preVal,CounterOf[_countid]);
    }
    //计数器-1操作，需要传递计数器id，执行成功后，会提示计数前与计数后的值
    function counterSub(bytes32 _countid)public returns(uint256 , uint256 ){
        //获取当前计数器计数值，用户结果返回，方便用户对结果进行核验
        uint256 preVal =  CounterOf[_countid];
        if(preVal>0){
            //计数器val减1
            CounterOf[_countid] -= 1;
        }else{
            CounterOf[_countid]=0;
        }
        
        emit counterAddLog(_countid,msg.sender,block.timestamp,preVal,CounterOf[_countid]);
        return (preVal,CounterOf[_countid]);
    }
    //根据计数器id返回计数器当前的计数值
    function getCounter(bytes32 _countid)public view returns(uint256){
        return  CounterOf[_countid];
    }
    //计数器归零
    function counterClear(bytes32 _countid)public returns(uint256 , uint256 ){
        //获取当前计数器计数值，用户结果返回，方便用户对结果进行核验
        uint256 preVal =  CounterOf[_countid];
        CounterOf[_countid] = 0;
        emit counterAddLog(_countid,msg.sender,block.timestamp,preVal,CounterOf[_countid]);
        return (preVal,CounterOf[_countid]);
    }
}