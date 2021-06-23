pragma solidity ^0.4.25;
pragma experimental ABIEncoderV2;

contract Goods{
    struct TraceData{
        address addr;     //Operator address
        int16 status;     //goods status
        uint timestamp;   //Operator time
        string remark;    //Digested Data
    }
    uint64 _goodsId; 
    int16 _status;   //current status
    TraceData[] _traceData;
    
    event newStatus( address addr, int16 status, uint timestamp, string remark);
    
    constructor(uint64 goodsId) public{
        _goodsId = goodsId;
        _traceData.push(TraceData({addr:msg.sender, status:0, timestamp:now, remark:"create"}));
        emit newStatus(msg.sender, 0, now, "create");
    }
    
    function changeStatus(int16 goodsStatus, string memory remark) public {
        _status = goodsStatus;
         _traceData.push(TraceData({addr:msg.sender, status:goodsStatus, timestamp:now, remark:remark}));
          emit newStatus(msg.sender, goodsStatus, now, remark);
    }
      
    function getStatus()public view returns(int16){
        return _status;
    }
    
    function getTraceInfo()public view returns(TraceData[] memory _data){
        return _traceData;
    }
}