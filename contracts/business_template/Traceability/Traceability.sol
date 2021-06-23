pragma solidity ^0.4.25;

import "./Goods.sol";

contract Traceability{
    struct GoodsData{
        Goods traceGoods;
        bool valid;
    }
    bytes32 _category;
    mapping(uint64=>GoodsData) private _goods;
    constructor(bytes32  goodsTp) public {
        _category = goodsTp;
    }
    
    event newGoodsEvent(uint64 goodsId);
    
    function createGoods(uint64 goodsId) public returns(Goods){
        require(!_goods[goodsId].valid, "is really exists");
        
        _goods[goodsId].valid = true;
        Goods traceGoods = new Goods(goodsId);
        emit newGoodsEvent(goodsId);
       _goods[goodsId].traceGoods = traceGoods;
        return traceGoods;
    }
    
    function changeGoodsStatus(uint64 goodsId, int16 goodsStatus, string memory remark) public{
        require(_goods[goodsId].valid, "not exists");
         _goods[goodsId].traceGoods.changeStatus(goodsStatus, remark);
    }
      
     function getStatus(uint64 goodsId)public view returns(int16){
         require(_goods[goodsId].valid, "not exists");
         return _goods[goodsId].traceGoods.getStatus();
    }

     function getGoods(uint64 goodsId)public view returns(Goods){
         require(_goods[goodsId].valid, "not exists");
         return _goods[goodsId].traceGoods;
    }
}
