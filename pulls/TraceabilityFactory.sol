pragma solidity ^0.6.10;
pragma experimental ABIEncoderV2;


import "Traceability.sol";

contract TraceabilityFactory{
    struct GoodsTrace{
        Traceability trace;
        bool valid;
    }
    mapping(bytes32=>GoodsTrace) private _goodsCategory;

	event newTraceEvent(bytes32 goodsTp);
	//获取溯源商品类
    function createTraceability(bytes32  goodsTp)public returns(Traceability) {
        require(!_goodsCategory[goodsTp].valid,"The trademark already exists" );
        Traceability category = new Traceability(goodsTp);
        _goodsCategory[goodsTp].valid = true;
        _goodsCategory[goodsTp].trace = category;
        emit newTraceEvent(goodsTp);
        return category;
    }
    
     function getTraceability(bytes32  goodsTp)private view returns(Traceability) {
        require(_goodsCategory[goodsTp].valid,"The trademark has not exists" );
        return _goodsCategory[goodsTp].trace;
    }
    //创建溯源商品    
    function createTraceGoods(bytes32  goodsTp, uint64 goodsId)public returns(Goods) {
        Traceability category = getTraceability(goodsTp);
         return category.createGoods(goodsId);
    }
    
    //更改溯源商品
    function changeTraceGoods(bytes32  goodsTp, uint64 goodsId, int16 eventType, string calldata remark)public{
         Traceability category = getTraceability(goodsTp);
         category.changeGoodsStatus(goodsId, eventType, remark);
    }
    
    //查询商品状态
     function getStatus(bytes32 goodsTp, uint64 goodsId)public view returns(int16){
         Traceability category = getTraceability(goodsTp);
         return category.getStatus(goodsId);
    }
    
    //查询商品全流程
     function getTraceInfo(bytes32 goodsTp, uint64 goodsId)public view returns(TraceData[] memory _data){
         Traceability category = getTraceability(goodsTp);
         return category.getTraceInfo(goodsId);
    }
}