pragma solidity ^0.6.10;
pragma experimental ABIEncoderV2;

 struct TraceData{
        address addr;
        int16 eventType;
        uint timestamp;
        string remark;
    }

contract Goods{
   
    uint64 _goodsId;
    int16 _status;
    TraceData[] _traceData;
    
    event newStatus( address addr, int16 eventType, uint timestamp, string remark);
    
    constructor(uint64 goodsId) public{
        _goodsId = goodsId;
        _traceData.push(TraceData({addr:msg.sender, eventType:0, timestamp:now, remark:"create"}));
        emit newStatus(msg.sender, 0, now, "create");
    }
    
    function changeStatus(int16 eventType, string calldata remark) public {
        _status = eventType;
         _traceData.push(TraceData({addr:msg.sender, eventType:eventType, timestamp:now, remark:remark}));
          emit newStatus(msg.sender, eventType, now, remark);
    }
      
    function getStatus()public view returns(int16){
        return _status;
    }
    
    function getTraceInfo()public view returns(TraceData[] memory _data){
        return _traceData;
    }
}