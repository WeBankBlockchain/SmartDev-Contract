## 商品溯源

产品溯源是将当前先进的物联网技术、自动控制技术、自动识别技术、互联网技术结合利用，通过专业的机器设备对单件产品赋予唯一的一维码或者二维码作为防伪身份证，实现“一物一码”，然后可对产品的生产、仓储、分销、物流运输、市场稽查、销售终端等各个环节采集数据并追踪，构成产品的生产、仓储、销售、流通和服务的一个全生命周期管理



## 接口

提供了三个合约：TraceabilityFactory合约，Traceability合约，Goods合约。

TraceabilityFactory合约：对外服务的唯一接口。包含：
    - createTraceability(bytes32  goodsGroup): 创建溯源商品类，goodsGroup： 为商品类hash码
    - createTraceGoods(bytes32  goodsGroup, uint64 goodsId): 创建需要溯源的商品，goodsId：唯一标识商品的Id
    - changeTraceGoods(bytes32  goodsGroup, uint64 goodsId, int16 goodsStatus, string remark)：商品状态改变，goodsStatus：商品流转的每一个环节可以用一个状态进行标识，remark：状态变更的摘要信息
    - getStatus(bytes32 goodsGroup, uint64 goodsId): 获取商品的当前状态
	- getTraceInfo(bytes32 goodsGroup, uint64 goodsId) ：获取商品的全流程信息，包括每一个环节的状态、时间、操作员、摘要信息
## 使用示例


合约调用：

    - 创建自己的溯源商品类  createTraceability(hash("商品标识"))
    - 在商品类下创建商品    createTraceGoods(hash("商品标识"), "100000001")
    - 商品状态变更          changeTraceGoods(hash("商品标识"), "100000001", 1, "环节信息")
	- 查询商品的当前状态    getStatus(hash("商品标识"), "100000001")
	- 查询商品的全流程信息  getTraceInfo(hash("商品标识"), "100000001")






