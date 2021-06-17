## 土豪发红包背景说明

发红包是现实中常见的一种生活方式，本方案是将原本发红包使用的现金，替换成了ERC20标准的token。

## 场景说明

具体业务场景也可以是商家发放的优惠券，代金券等等。

## 接口

提供了3+2个合约：其中3个合约为目前标准化合约，分别是IERC20接口，mytoken（token的一个模拟实现），SafeMath（安全计算库），另外2个合约是主要逻辑合约，redpacket合约和proxy合约。其中proxy合约是对外接受统一的token授权服务，为辅助合约，redpacket为发红包合约。

proxy合约：接受外部token授权的唯一接口。包含：
    - setTokenAddr(address _addr): 设置token合约地址，_addr为一个已经部署的token合约地址
    - transfer(address _from, address _to, uint256 _value): 转账合约，完成抢红包动作时的转账操作
    - addr()：返回本合约地址
    - balanceOf(address _who): 获取用户的token余额
    - allowance(address _from): 获取_from授权给本合约的额度

redpacket合约：红包合约。包含：
    - getProxy(): 获取proxy地址
    - transfer(address _from, address _to, uint256 _value): 转账合约，完成抢红包动作时的转账操作
    - sendRedPacket(uint256 c, bool ok, address addr, uint256 amount)：发红包动作，c代表数量，ok代表是否等额，addr为要发送的红包token地址，amount代表红包数量
    - grabRedpacket(): 抢红包动作


## 使用示例

假如现在要执行一个发红包、抢红包动作，整个过程如下：

合约初始化：

    - token合约已经部署，并且“土豪”用户已经拥有一定数量的token
    - 部署redpacket合约
    
    
合约调用：

    - 利用redpacket合约获取proxy地址，在token合约中“土豪”调用approve给proxy地址
    - “土豪”在redpacket合约中执行sendRedPacket，指定红包的数量、方式、token地址以及金额
    - 其他用户执行grabRedpacket抢红包