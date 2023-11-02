pragma solidity ^0.4.25;
pragma experimental ABIEncoderV2;

contract Goods{
    struct TraceData{
        address addr;     //Operator address 操作者地址
        int16 status;     //goods status 商品状态
        uint timestamp;   //Operator time 操作时间
        string remark;    //Digested Data 摘要数据
    }
    uint64 _goodsId; // 商品ID
    int16 _status;   // 商品状态
    TraceData[] _traceData; // 商品溯源过程信息
    // 新增商品状态事件
    event newStatus( address addr, int16 status, uint timestamp, string remark);
    
    constructor(uint64 goodsId) public{
        _goodsId = goodsId;
        // 添加商品的溯源信息
        _traceData.push(TraceData({addr:tx.origin, status:0, timestamp:now, remark:"create"}));
        emit newStatus(tx.origin, 0, now, "create");
    }

    /*
        描述：修改商品状态
        参数：
            goodsStatus: 商品状态
        返回值：
            remark: 商品摘要数据
    */
    function changeStatus(int16 goodsStatus, string memory remark) public {
        _status = goodsStatus;
        // 添加商品的溯源信息（操作者地址、商品状态、当前时间戳、摘要信息）
         _traceData.push(TraceData({addr:tx.origin, status:goodsStatus, timestamp:now, remark:remark}));
          emit newStatus(tx.origin, goodsStatus, now, remark);
    }
      
     /*
        描述：获取商品状态
        返回值：
            int16类型: 商品状态
    */  
    function getStatus()public view returns(int16){
        return _status;
    }
    
     /*
        描述：获取商品溯源过程信息
        返回值：
            _data: 商品溯源过程信息
    */
    function getTraceInfo()public view returns(TraceData[] memory _data){
        return _traceData;
    }
}
