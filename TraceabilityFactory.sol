pragma solidity ^0.4.25;
pragma experimental ABIEncoderV2;

import "./Traceability.sol";

contract TraceabilityFactory{
    // 商品溯源信息
    struct GoodsTrace{
        Traceability trace; // 溯源信息
        bool valid; // 是否存在
    }
    // 商品类别对应的商品
    mapping(bytes32=>GoodsTrace) private _goodsCategory; 
	// 新增可溯源商品组事件
    event newTraceEvent(bytes32 goodsGroup);
	
    //Create traceability commodity category
    /*
        描述：创建可溯源商品类别
        参数:
            goodsGroup: 商品组
        返回值：
            Traceability: 溯源信息
    */
    function createTraceability(bytes32  goodsGroup) public returns(Traceability) {
        // 判断商标（商品组）是否存在
        require(!_goodsCategory[goodsGroup].valid,"The trademark already exists" );
        // 初始化商品组
        Traceability category = new Traceability(goodsGroup);
        _goodsCategory[goodsGroup].valid = true;
        _goodsCategory[goodsGroup].trace = category;
        emit newTraceEvent(goodsGroup);
        return category;
    }

    /*
        描述：获取可溯源商品类别信息
        参数:
            goodsGroup: 商品组
        返回值：
            Traceability: 溯源信息
    */
    function getTraceability(bytes32  goodsGroup) private view returns(Traceability) {
        // 判断商标（商品组）是否存在
        require(_goodsCategory[goodsGroup].valid,"The trademark has not exists" );
        return _goodsCategory[goodsGroup].trace;
    }

    //Create traceability products    
    /*
        描述：创建可溯源商品
        参数:
            goodsGroup: 商品组
            goodsId: 商品Id
        返回值：
            Goods: 商品信息
    */
    function createTraceGoods(bytes32  goodsGroup, uint64 goodsId) public returns(Goods) {
        // 获取可溯源商品类别信息
        Traceability category = getTraceability(goodsGroup);
        return category.createGoods(goodsId);
    }
    
    //Change product status
    /*
        描述：修改商品状态
        参数:
            goodsGroup: 商品组
            goodsId: 商品ID
            goodsStatus: 商品状态
            remark: 商品备注
        返回值：
            Traceability: 溯源信息
    */
    function changeTraceGoods(bytes32  goodsGroup, uint64 goodsId, int16 goodsStatus, string memory remark) public {
        // 获取可溯源商品类别信息
        Traceability category = getTraceability(goodsGroup);
        // 修改商品状态
        category.changeGoodsStatus(goodsId, goodsStatus, remark);
    }
    
    //Query the current status of goods
    /*
        描述：查询商品状态
        参数:
            goodsGroup: 商品组
            goodsId: 商品ID
        返回值：
            int16类型: 商品状态
    */
    function getStatus(bytes32 goodsGroup, uint64 goodsId) public view returns(int16) {
        // 获取可溯源商品类别信息
        Traceability category = getTraceability(goodsGroup);
        return category.getStatus(goodsId);
    }
    
    //The whole process of querying goods
    /*
        描述：查询商品的整个过程
        参数:
            goodsGroup: 商品组
            goodsId: 商品ID
        返回值：
            Goods.TraceData[]: 商品追踪数据
    */
    function getTraceInfo(bytes32 goodsGroup, uint64 goodsId) public view returns(Goods.TraceData[]) {
        // 获取可溯源商品类别信息
        Traceability category = getTraceability(goodsGroup);
        return category.getGoods(goodsId).getTraceInfo();
    }
    
    /*
        描述：根据商品组名生成bytes32
        参数:
            name: 商品组名
        返回值：
            bytes32类型: 商品组名对应的bytes32
    */
    function getGoodsGroup(string memory name) public pure returns (bytes32) {
        return keccak256(abi.encode(name));
    }
}