pragma solidity ^0.4.25;

import "./Goods.sol";

contract Traceability{
    // 商品信息
    struct GoodsData{
        Goods traceGoods; // 溯源商品信息
        bool valid; // 是否存在
    }
    // 商品类别
    bytes32 _category; 
    // 商品ID对应的商品信息
    mapping(uint64=>GoodsData) private _goods;
    constructor(bytes32  goodsTp) public {
        _category = goodsTp;
    }
    // 新增商品事件
    event newGoodsEvent(uint64 goodsId);
    
    /*
        描述：创建商品
        参数：
            goodsId: 商品ID
        返回值：
            Goods: 商品信息
    */
    function createGoods(uint64 goodsId) public returns(Goods){
        // 判断商品ID是否已存在
        require(!_goods[goodsId].valid, "is really exists");
        _goods[goodsId].valid = true;
        // 初始化商品信息
        Goods traceGoods = new Goods(goodsId);
        emit newGoodsEvent(goodsId);
        _goods[goodsId].traceGoods = traceGoods;
        return traceGoods;
    }
    
    /*
        描述：修改商品状态
        参数：
            goodsId: 商品ID
            goodsStatus: 商品状态
            remark: 商品摘要数据
    */
    function changeGoodsStatus(uint64 goodsId, int16 goodsStatus, string memory remark) public{
        // 判断商品是否存在
        require(_goods[goodsId].valid, "not exists");
        // 修改商品状态
         _goods[goodsId].traceGoods.changeStatus(goodsStatus, remark);
    }
      
    /*
        描述：获取商品状态
        参数：
            goodsId: 商品ID
        返回值：
            int64类型: 商品状态
    */
     function getStatus(uint64 goodsId)public view returns(int16){
         // 判断商品是否存在
         require(_goods[goodsId].valid, "not exists");
         return _goods[goodsId].traceGoods.getStatus();
    }

    /*
        描述：获取商品信息
        参数：
            goodsId: 商品ID
        返回值：
            Goods: 商品信息
    */
     function getGoods(uint64 goodsId)public view returns(Goods){
         // 判断商品是否存在
         require(_goods[goodsId].valid, "not exists");
         return _goods[goodsId].traceGoods;
    }
}
