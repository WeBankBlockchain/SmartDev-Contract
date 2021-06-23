pragma solidity ^0.4.25;

import "./Traceability.sol";

contract TraceabilityFactory{
    struct GoodsTrace{
        Traceability trace;
        bool valid;
    }
    mapping(bytes32=>GoodsTrace) private _goodsCategory;

	event newTraceEvent(bytes32 goodsGroup);
	
	//Create traceability commodity category
    function createTraceability(bytes32  goodsGroup)public returns(Traceability) {
        require(!_goodsCategory[goodsGroup].valid,"The trademark already exists" );
        Traceability category = new Traceability(goodsGroup);
        _goodsCategory[goodsGroup].valid = true;
        _goodsCategory[goodsGroup].trace = category;
        emit newTraceEvent(goodsGroup);
        return category;
    }
    
     function getTraceability(bytes32  goodsGroup)private view returns(Traceability) {
        require(_goodsCategory[goodsGroup].valid,"The trademark has not exists" );
        return _goodsCategory[goodsGroup].trace;
    }
    //Create traceability products    
    function createTraceGoods(bytes32  goodsGroup, uint64 goodsId)public returns(Goods) {
        Traceability category = getTraceability(goodsGroup);
         return category.createGoods(goodsId);
    }
    
    //Change product status
    function changeTraceGoods(bytes32  goodsGroup, uint64 goodsId, int16 goodsStatus, string memory remark)public{
         Traceability category = getTraceability(goodsGroup);
         category.changeGoodsStatus(goodsId, goodsStatus, remark);
    }
    
    //Query the current status of goods
     function getStatus(bytes32 goodsGroup, uint64 goodsId)public view returns(int16){
         Traceability category = getTraceability(goodsGroup);
         return category.getStatus(goodsId);
    }
    
    //The whole process of querying goods
     function getTraceInfo(bytes32 goodsGroup, uint64 goodsId)public view returns(Goods){
         Traceability category = getTraceability(goodsGroup);
         return category.getGoods(goodsId);
    }
}