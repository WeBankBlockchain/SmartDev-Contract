# 慈善公益——智能合约解决方案

**基于区块链的慈善公益适用于需要保证捐款信息安全性和透明度的场景**，因为区块链技术具备去中心化、不可篡改、安全可靠等特点，可以确保慈善捐款信息不被篡改。同时，使用基于区块链的慈善公益系统还可以提高捐款过程中的效率和透明度，保障捐款人权益，增强慈善机构的信誉和管理能力。因此，基于区块链的慈善公益适用于各种需要捐款和资金流转的公益场景。



## 1.当前公益慈善组织面临突出问题

我进行了查阅以及调查，总结了如下几点,从知乎上查阅到：https://zhuanlan.zhihu.com/p/150063012

**信息公开程度低，监管缺乏手段**传统公益慈善组织的信息公开透明度低，监管机制缺位，公信力不足。据调查，公益组织的“资金去向与使用状况”以及“善款来源”是公众关注的焦点，而传统公益机构经常信息披露不足。从本次疫情爆发的红十字会事件来看，由于物资来源不透明、去向不可知、信息公开不及时，以及政府对慈善组织的监管手段缺乏、社会监督力量薄弱，导致红十字会公信力下降，影响了公众对公益组织的信心与支持度。



**“互联网+公益”无法解决信用问题**“互联网+公益”创新模式已经被用到实践中，但是同样面临信用风险和监管问题。随着互联网技术的发展，网络公益众筹平台如轻松筹、水滴筹、爱心筹等快速发展，一方面有效帮助了数以万计的困难群众，缓解了政府的财政压力；另一方面也暴露出一些问题，互联网的开放性特征，使得众筹平台难以对发起者与受益者的信息进行有效筛查，个别求助者虚构病情、部分平台线上业务流程不合规、用户数据被滥用、个别平台涉嫌非法筹集资金等问题频现。这不仅对捐助者的基本权益造成了侵害，同时也削弱了群众对于网络公益众筹活动的信任，制约了公益事业的可持续发展。

因此，急需一种合适的技术手段或合理的机制来解决社会民众持续增长的公益慈善需求与当前公益慈善组织公信力不足之间的矛盾。



**区块链可以实现有效的激励，具有价值优势**公益项目的参与方是不同利益主体，需要尽可能照顾各方利益，才能激发更多参与者的积极性。如在本次疫情中，存在很多社会志愿者和慈善人士。由于公益项目的非营利性，吸引各方积极参与的不再是经济利益的分配，参与方的出发点可能是同情心、家乡情、社会声誉、个人英雄主义、企业文化、社会研究等。面对参与者的不同出发点，区块链的激励相容机制可以实现多方利益的共赢，实现社会价值最大化。



整个捐赠流程：

![image-20230413012411609](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202304130124514.webp)



基于区块链的慈善公益主要包括以下业务：

1. **捐款管理**：基于区块链技术，建立一个去中心化的捐款管理系统，确保捐款信息不被篡改、数据的可靠性和安全性。捐款人可以通过区块链平台进行捐款记录的查询，以保证公示的透明度和真实性。
2. **资金用途追踪**：通过区块链技术实现对慈善捐赠资金的流向追踪和监管，确保资金的合法使用。比如，将慈善机构的账户信息与区块链相结合，建立一个跨机构的资金追踪平台，对慈善基金的使用情况进行实时监控。
3. **慈善项目管理**：为慈善活动和项目建立智能合约，实现自动化执行和程序化管理，避免了人为操作引起的错误和不公平。同时，也可以通过区块链平台发布慈善项目，方便社会各界了解并参与慈善事业。
4. **公示与评估**：在区块链平台上公示捐款信息和慈善项目进展情况，方便公众对慈善机构的评估和监督。同时可以建立一个可追溯的财务系统，使得慈善机构的账目记录和审核更加标准化和规范化。



## 2.基于FISCO BCOS的解决方案

基于FISCO BCOS的区块链平台，在慈善公益方面可以提供以下几个解决方案：

1. 透明化捐赠流程：区块链技术可以记录每一笔捐款的流向，确保捐赠资金的安全性和完整性。公众也可以通过区块链浏览器直接查看捐款进出账户，进而监督公益项目的实施过程。

2. 全民义卖：将二手物品等闲置资源进行在线交易，并将所得资金全部或部分捐给公益事业。区块链可以为义卖品拍卖价提供保证，避免出现恶意抬高价格、虚假交易情况等。

3. 慈善信用评级：在捐助时，采集捐赠者的身份信息以及他们的捐献历史，并基于此进行信用评级。这种数据存储在区块链上，使其不受一方或中心化机构的控制，并且捐赠者的信誉不会被恶意攻击或篡改。

4. 慈善数据管理：由于区块链在去中心化、所有人都能共享数据等方面的显著优势，因此还可应用于慈善数据管理。对于慈善机构来说，可以用区块链存储敏感数据，添加数据完整形式验证，在保护数据隐私基础之上，确保数据的安全和可靠性；对于公众、政府部门等用户，则可以通过去中心化的方式获取最新信息，以实现公开透明。



## 3.慈善公益架构图

![image-20230430041647708](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202304300416961.webp)



## 4.整体业务概述

1. 角色与职责：本系统分为三个角色，机构、物流商、用户。

   - `机构`：发起慈善公益活动，指定需求、目标等信息，发布活动。

   - `物流商`：提供物流服务，支持用户与机构间的货物运输及产品、捐款等相关服务。

   - `用户`：参与慈善公益活动，可按批次捐赠、参与义务劳动等方式实现公益目标。通过贡献值、捐赠额度、访问记录、评价等数据进行等级评定。

1. 用户权限和限制：系统将给每个用户分配一个初始积分，花费时从积分中扣减，根据月捐赠额、贡献值等因素计算加权等级和能力。新注册的用户需要填写完整资料，并经过身份验证，才能下单或发起项目。不同等级具有不同的权利和限制，如优先抢购特价产品、免邮、免费获得代金券、优先享受售后服务等。
2. 捐款功能：用户可以进行慈善公益捐赠，选择慈善项目并选择捐款金额、支付方式。另可查看自己的个人公益捐赠记录，并了解其去向。
3. 公益活动：覆盖社区慈善、环保公益、健康公益等多个领域，用户可以根据个人性格和慈善心情选择感兴趣的公益活动。支持筛选和分类浏览公益项目、查看详细资料和成果等。
4. 物流服务：为用户提供快递、签收、运输等多种物流服务，确保产品及时到达目的地。采用安全可靠、高效快捷的物流方式，追踪管理订单并公开物流状态信息。
5. 链上记录与溯源：系统将所有关键业务数据上链存储，并通过智能合约鉴定、加密、完整性验证等技术手段，确保数据不可篡改、审计可追溯。利用区块链技术打造完整的溯源体系，对公益捐赠进展进行实时核查，确保严谨的过程管理，最大限度地保证公益捐助的目标化和有效性。同时，系统会对公开信息进行隐私保护，实现公益信息公开但个人信息保护的目的。

![image-20230428153313443](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202304281533618.webp)



## 5.用户业务视图

1. 代理机构：本系统支持用户与多个代理机构合作，通过代理机构实现慈善捐赠管理等主要业务操作。
2. 捐款功能：用户可以在代理机构处对慈善项目进行捐款管理，并发起公益账目回收。所有公益捐赠记录将被实时记录并上链存储，确保数据可追溯、透明公开且不可篡改。
3. 物资物流服务：针对灾区物资的捐赠，代理机构会根据实际情况选择物流商进行派送至灾区。 用户可以根据查看捐赠人的记录信息，可以查看完整公益记录溯源，保证了数据的公开性，真实可信。
4. 数据防伪与维护：为避免经销分润、滥竽充数等非法行为的发生，系统采用了区块链技术进行数据防伪和维护。同时引入智能合约等先进工具，确保公益项目的可信度和高效执行。

![ee966a9c35bf7c4c2dd6077aae26a6d](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202304291710619.webp)



## 6.存储设计

### 6.1 用户存储设计

如下是一个基于区块链技术的公益慈善应用中所使用的数据结构，具体包括：**用户结构体、捐赠人结构体、申请公益物资结构体以及公益记录溯源结构体** 。

- 用户结构体包含用户的基本信息和操作记录，如用户ID、名称、地址、余额、等级、捐赠次数和历史记录；
- 捐赠人结构体用于存储捐款的相关信息，包括捐赠ID、金额、捐赠人和接收方的地址以及时间；
- 申请公益物资结构体则用于公益物资的禀议与申请，包括申请ID、描述、机构地址和所需物资清单等内容；
- 而公益记录溯源结构体则是用于记录公益项目、经费和结果的，包括公益历史ID、发起人、金额、去向、机构地址、状态、时间等。通过该结构体可以对该项目的所有捐赠人进行查询，并确保公益记录的真实性和透明度。

```solidity
    // 用户的结构体
    struct User {
        uint256 userId;          // 用户ID
        string  userName;        // 用户名称
        address userAddress;     // 用户地址
        uint256 userAmount;      // 用户的余额
        Level userLevel;         // 用户的等级
        uint256 userCount;       // 用户的捐献次数
        int     status;          // 用户的状态
        uint256[] donorList;     // 捐赠的历史记录ID
        uint256[] materialList;  // 捐赠物资交易记录ID
        uint256[] recordList;    // 集资历史记录ID
    }
    
    // 捐赠人结构体
    struct Donor {
        uint256 donorId;         // 捐赠ID
        uint256 donorAmount;     // 捐赠的金额
        address donorAddress;    // 捐赠人地址
        address donorToAddress;  // 捐赠的对方地址
        address donorToOrg;      // 捐赠的机构
        uint256 donorTime;       // 捐赠的时间
    }   
    
    // 申请公益物资结构体
    struct Material{
        uint256 meteriaId;          // 申请物资ID
        string  meterialdesc;       // 申请物资描述
        address srcAddress;         // 申请地址
        address orgAddress;         // 代理机构地址
        string[] meterialNames;     // 所有物资
    }
    
    // 公益溯源结构体 
    struct CharityRecord {
        uint256       recordId;        // 公益历史ID
        uint256       recordAmount;    // 公益金额
        uint256       overAmount;      // 已完成金额
        address       srcUser;         // 公益发起人
        string        descCharitable;  // 公益去向
        address       recordOrg;       // 公益机构
        CharityStatus recordStatus;    // 公益状态
        uint256       recordTime;      // 公益时间
        address[]     users;           // 所有捐赠人地址
    }
    
        
    // 用户的ID
    uint256 userCount;
    
    // 捐赠记录ID
    uint256 donorCount;

    // 所有用户的地址记录
    address[] users;
    
    // 所有捐赠人的记录ID
    uint256[] dornors;
    
    
    // 地址映射用户详细信息
    mapping(address => User) userMap;
    // ID映射捐赠人的详细信息
    mapping(uint256 => Donor) donorMap;

    
    // 用户的等级枚举 注册默认为等级一 一级可发起公益最高5W 二级10W 三级 20W
    enum Level {LEVEL_ONE,LEVEL_TWO,LEVEL_THREE}
    
```



### 6.2 机构存储设计

如下是公益慈善应用中所使用的机构结构体，该结构体包含的主要信息如下：

1. 机构ID和名称：代表了该机构在系统中的唯一标识符及其名称；
2. 机构地址：指机构所在的钱包账户地址；
3. 机构账户余额：记录了该机构的账户余额；
4. 机构状态：表示机构的状态；
5. 所有公益溯源集合：用于存储该机构发起的所有公益项目的信息，包括公益项目ID、捐赠人地址、公益金额、机构地址、状态等信息，以方便进行公益项目的跟踪来追溯公益资金的去向；
6. 所有公益捐赠交易ID集合：用于存储和管理与该机构相关的所有公益捐赠交易的ID，包括捐赠金额、捐赠人地址、接收者地址等信息；
7. 所有物资申请记录ID集合：用于存储和管理该机构发起的所有公益物资申请交易的ID，包括申请ID、描述、机构地址和所需物资清单等内容。

```solidity
     // 慈善机构的结构体
    struct Org {
        uint256  orgId;          // 机构ID
        string   orgName;        // 机构名称
        address  orgAddress;     // 机构的地址
        uint256  orgAmount;      // 机构的账户
        int      status;         // 机构的状态
        uint256[] recordIds;     // 机构的所有公益溯源集合
        uint256[] transactions;  // 机构的所有公益捐赠交易ID集合
        uint256[] meterials;     // 机构的所有的物资申请记录ID
    }
    
        
    // 慈善机构ID
    uint256 orgId;     
    
    // 所有机构的地址
    address[] orgs;

    // 地址映射慈善机构
    mapping(address => Org) public orgMap;  
```



### 6.3 物流商的存储设计

该结构体包含了物流公司的一些基本信息，具体如下：

1. 物流公司ID：标识该物流公司；
2. 物流公司名称：表示该物流公司在系统中的名称；
3. 物流公司地址：指该物流公司所在的钱包账户地址，该地址可以用来进行公益物资的收发和流转等操作；
4. 物流公司状态：表示物流公司的状态；

```solidity
    // 物流公司的结构体
    struct Logistics {
        uint256 logisticsId;        // 物流公司ID
        string  logisticsName;      // 物流公司名称 
        address logisticsAddress;   // 物流公司的地址
        int     status;             // 物流公司的状态
    }
    
    // 物流公司的ID
    uint256 logisticsCount;
    // 所有物流公司的地址
    address[] logisticsAddress;
    // 地址映射物流公司的详细信息
    mapping(address => Logistics) logisticsMap;
```





## 7.接口设计

### 7.1 用户接口

如下是用户的主要接口：

```solidity
	// 注册用户
    function registerUser(string memory _userName) public returns(User memory)
    
    /**
     * @dev 通过用户自发进行物资捐赠，向指定机构筹集公益物资
     * @param _orgAddress 指定机构的地址
     * @param _materDesc 捐赠物资的描述信息
     * @return 申请物资记录信息
    **/
    function raiseFunds(address _orgAddress,string memory _materDesc) public _AuthUser returns(Material)
    
    /**
     * 
     * @dev 用户签收指定交易下的捐赠物资，并更新相关的物流状态
     * @param _transactionId 待签收物资所属的交易ID
     * @param _meterialId 待签收的物资ID
     * 
    **/
    function signedGoods(uint256 _transactionId,uint256 _meterialId)
    
    
    /**
     * @dev 用户进行个人物资捐赠，并创建对应的物资捐赠交易记录
     * @param _orgAddress 捐赠的物资所属机构的地址
     * @param _toAddress 捐赠的物资目标地址
     * @param _meterName 捐赠物资名称
     * @param _isTransaport 是否需要运输：true-需要；false-不需要
     * @return 捐赠记录信息
    **/
    function donatedMaterial(address _orgAddress,address _toAddress,string memory _meterName,bool _isTransaport) public _AuthUser returns(Transaction)
    
    /**
     * @dev 用户进行个人金额捐赠，并创建对应的捐赠记录
     * @param _orgAddress 捐赠的公益慈善所属机构的地址
     * @param _toAddress 捐赠目标地址
     * @param _recordId 公益慈善记录 ID
     * @param _toAmount 捐赠的金额
     * @return 捐赠人的信息信息
    **/
    function donate(address _orgAddress ,address _toAddress,uint256 _recordId,uint256 _toAmount) public _AuthUser returns(Donor)
    
    /**
     * @dev 用户发起公益慈善项目，并新增该项目的记录信息到平台
     * @param _orgAddress 公益慈善所属机构的地址
     * @param _amount 公益慈善筹款目标金额
     * @param _desc 公益慈善项目的描述信息
     * @return 发起公益慈善记录信息
    **/
    function initiate(address _orgAddress,uint256 _amount,string _desc) public _AuthUser returns(CharityRecord)
    
    /**
     * @dev 确认发起公益时是否达到用户捐款等级的限制
     * @param _amount 用户在本次发起公益捐赠时选择的捐赠金额
    **/
    function checkLimitForInitiate(uint256 _amount) 
    
    /**
     * @dev 用户通过查询指定机构的公益项目情况，然后进行取款操作
     * @param _orgAddress 机构所属地址
     * @param _recordId 需要提取资金的公益慈善记录 ID
     * @param _amount 需要提取的资金数量
     * @return (int256, address) 若成功提取资金，则返回状态码 0 及用户地址；否则返回错误状态码 -1 和空地址
    **/
    function withdraw(address _orgAddress,uint256 _recordId,uint256 _amount) public _AuthUser returns(int256,address)
    
    // 用户查看当前的进度 更新所有的公益溯源变为已完成  后端使用定时器进行自动流
    function updateRecordPage()
    
    /**
     * @dev 分页查询当前用户的捐赠记录
     * @param _page 需要查询的页数，从 1 开始计数
     * @param _pageSize 每页需要返回的记录数量
     * @return Donor[] 返回指定页码及每页数量的捐赠记录数组
    **/
    function queryUserDonorPage(uint256 _page,uint256 _pageSize) public  returns(Donor[])
    
    
    /**
     * @dev 分页查询当前用户的公益记录
     * @param _page 需要查询的页数，从 1 开始计数
     * @param _pageSize 每页需要返回的记录数量
     * @return CharityRecord[] 返回指定页码及每页数量的公益记录数组
    **/
    function queryUserRecordPage(uint256 _page,uint256 _pageSize) public  returns(CharityRecord[])


    /**
     * @dev 分页查询当前用户的公益物资申请记录
     * @param _page 需要查询的页数，从 1 开始计数
     * @param _pageSize 每页需要返回的记录数量
     * @return Material[] 返回指定页码及每页数量的公益物资申请记录数组
    **/
    function queryUserMeterialPage(uint256 _page,uint256 _pageSize) public returns(Material[])
}
```



### 7.2 机构接口

如下是机构的主要接口：

```solidity
    // 注册慈善机构
    function registerOrg(string memory _orgName) public returns(Org memory)

    /**
     * @dev 查询指定机构的公益捐助交易信息（分页查询）
     * @param _orgAddress 机构地址
     * @param _page 查询的页数
     * @param _pageSize 每页的记录条数
     * @return 指定页码下的公益捐助交易信息数组
     * 
     **/
    function queryOrgTransactionPage(address _orgAddress,uint256 _page,uint256 _pageSize) public view  returns(Transaction[])
    
    // 查询机构的详细信息
    function queryOrg(address _orgAddress) public view returns(Org memory)
    
```



### 7.3 物流商接口

如下是物流商的主要接口：

```solidity
    
    // 注册物流公司
    function registerLogistics(string memory _logisticsName) public returns(Logistics) 
    
    
    /**
     * @dev 物流公司进行物资发货操作
     * @param _transacionId 待发送的公益捐助交易 ID
     * @return 发送后的公益捐助交易信息
     *
     **/
    function dispatch(uint256 _transacionId) public _AuthLogistic  returns(Transaction)
```



## 8.合约详细

合约的继承关系图：

![image-20230430105035276](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202304301050461.webp)



### 8.1 用户注册业务

​		在该合约中，通过创建一个名为 rolesAuth 的 Roles 对象，并调用其 addUser 函数，实现了用户注册时向该角色添加新用户的操作。在注册用户的时候会默认绑定用户的角色权限，有利于在后端进行判断。

```solidity
// 注册用户
function registerUser(string memory _userName) public returns(User memory){
    require(userMap[msg.sender].status == 0,"当前用户已经注册");
    userCount++;
    uint256 _userId = userCount;
    User storage _user = userMap[msg.sender];
    _user.userId = _userId;
    _user.userName = _userName;
    _user.userAddress = msg.sender;
    _user.userAmount = 0;
    _user.userLevel = Level.LEVEL_ONE;
    _user.userCount = 0;
    _user.status = 1;
    
    rolesAuth.addUser(msg.sender);
    emit Registered(msg.sender);
    return _user;
}
```





### 8.2 用户申请物资业务

​		用户可以向指定机构捐赠物资，并记录在链上，以便进行跟踪和查询。同时，该方法还会触发应用申请公益物资事件，通知其他相关方捐献信息的发生。公益慈善不仅限于捐款，发起人可以是用户或者是机构，我这里是用户发起公益活动，可以向灾区或者贫困地区捐赠物资，用户只需要通过我们的慈善公益平台申请该地区需要的物资，签收是本人。其他用户可以看到该公益活动，通过机构提供的物流商即可运送到灾区或者代收点地址。后端可以拿着这个订单做处理，包括接入物流系统等，以至于最后的物资溯源可以被用户查看到。

```solidity
    /**
     * @dev 通过用户自发进行物资捐赠，向指定机构筹集公益物资
     * @param _orgAddress 指定机构的地址
     * @param _materDesc 捐赠物资的描述信息
     * @return 申请物资记录信息
    **/
    function raiseFunds(address _orgAddress,string memory _materDesc) public _AuthUser returns(Material){
        
        materialCount++;
        uint256 _materialId = materialCount;
        Material storage _material = meterialMap[_materialId];
        _material.meteriaId = _materialId;
        _material.meterialdesc  = _materDesc;
        _material.srcAddress = msg.sender;
        _material.orgAddress = _orgAddress;
        
        meterials.push(_materialId);
        userMap[msg.sender].materialList.push(_materialId);
        orgMap[_orgAddress].meterials.push(_materialId);
        emit RaiseFunds(msg.sender,_materDesc);
        return _material;
    }
```





### 8.3 用户捐赠物资业务

​		用户可以向指定机构或个人捐赠物资，并创建一条与此相关的交易记录，并将其存储在链上以便日后跟踪和查询。同时，该方法还会触发捐赠物资事件，通知物流商捐献信息的发生。为公益慈善提供更加透明、高效的捐赠渠道，帮助有需要的人们获得更多的援助与帮助。用户通过代理机构进行物资的捐赠之后，产生的订单会通知物流商，物流商则会帮忙运输物资到指定灾区或者签收人地点。

```solidity
/**
 * @dev 用户进行个人物资捐赠，并创建对应的物资捐赠交易记录
 * @param _orgAddress 捐赠的物资所属机构的地址
 * @param _toAddress 捐赠的物资目标地址
 * @param _meterName 捐赠物资名称
 * @param _isTransaport 是否需要运输：true-需要；false-不需要
 * @return 捐赠记录信息
**/
function donatedMaterial(address _orgAddress,address _toAddress,string memory _meterName,bool _isTransaport) public _AuthUser returns(Transaction){
    transactionCount++;
    uint256 _transactionId = transactionCount;
    Transaction storage _transaction = transactionMap[_transactionId];
    _transaction.transactionId = _transactionId;
    _transaction.transactionTitle = "物资捐赠";
    _transaction.orgAddress = _orgAddress;
    _transaction.descAddress = _toAddress;
    _transaction.meterialName = _meterName;
    _transaction.isTransport = _isTransaport;
    _transaction.transacStatus = TransacStatus.SHIPMENT;
    _transaction.sources.push(msg.sender);
    _transaction.sources.push(_orgAddress);
    
    userMap[msg.sender].userCount++;
    transactions.push(_transactionId);
    orgMap[_orgAddress].transactions.push(_transactionId);
    emit DonatedMaterial(msg.sender,_toAddress,_meterName);
    return _transaction;
}
```



### 8.4 物流运输业务

​		解决了公益慈善中的“如何让物流公司过程更高效、透明、安全”的应用场景的痛点。物流公司可以实时更新捐赠物资的状态以及提供更多可追溯的信息，例如捐赠物资发运的时间和地点等。这将有助于增加物流过程的透明度和安全性，并使公众更有信心向公益慈善活动贡献自己的物力和智力。这里的return的返回是物流信息不存在，对后端的处理。

```solidity
/**
 * @dev 物流公司进行物资发货操作
 * @param _transacionId 待发送的公益捐助交易 ID
 * @return 发送后的公益捐助交易信息
 *
 **/
function dispatch(uint256 _transacionId) public _AuthLogistic  returns(Transaction){
    require(transactionMap[_transacionId].transacStatus == TransacStatus.SHIPMENT,"当前物流未出货");
    if (transactionMap[_transacionId].isTransport){
        Transaction storage _transacion = transactionMap[_transacionId]; 
        _transacion.transacStatus = TransacStatus.LOGISTICS;
        _transacion.sources.push(msg.sender);
        emit Dispathed(msg.sender,_transacionId);
        return _transacion;
    }
    return;
}
```





### 8.5 用户签收物资业务

​		用户可以在指定交易 ID 下签收相应的捐赠物资，并将其状态更改为已签收(TransacStatus.SIGNFOR)。同时，该方法还将更新该捐赠物资的最新持有者为当前用户，并在此基础上提高链上跟踪可追溯性。这帮助公益慈善组织、志愿者等相关方及时掌握捐赠物资的去向和使用情况，提高捐赠效率和公信力。

```solidity
/**
 * 
 * @dev 用户签收指定交易下的捐赠物资，并更新相关的物流状态
 * @param _transactionId 待签收物资所属的交易ID
 * @param _meterialId 待签收的物资ID
 * 
**/
function signedGoods(uint256 _transactionId,uint256 _meterialId) public _AuthUser {
    Transaction storage _transaction = transactionMap[_transactionId];
    require(_transaction.transacStatus == TransacStatus.LOGISTICS,"当前物资未更新物流状态");
    _transaction.transacStatus = TransacStatus.SIGNFOR;
    _transaction.sources.push(msg.sender);
    // 更新当前的用户的物资
    meterialMap[_meterialId].meterialNames.push(_transaction.meterialName);
    emit SigneFor(msg.sender,_transactionId);
}
```





### 8.6 用户发起公益捐款业务

​		该方法解决了公益慈善中的“如何便捷地发起公益慈善项目，并将其记录到平台”和“如何限制用户在对应等级的金额数量，以保证公益慈善活动的透明度与可行性”的应用场景。公益慈善机构或个人可以在平台上发起公益慈善项目，并设定项目筹资目标金额及相关描述信息。该方法将对用户账户进行等级限制，不可篡改用户的筹资金额。

```solidity
/**
 * @dev 用户发起公益慈善项目，并新增该项目的记录信息到平台
 * @param _orgAddress 公益慈善所属机构的地址
 * @param _amount 公益慈善筹款目标金额
 * @param _desc 公益慈善项目的描述信息
 * @return 发起公益慈善记录信息
**/
function initiate(address _orgAddress,uint256 _amount,string _desc) public _AuthUser returns(CharityRecord) {
    // 判断当前的用户是否存在 
    require(userMap[msg.sender].status != 0,"当前用户未注册");
    // 确认是否达到用户捐款等级的限制
    checkLimitForInitiate(_amount);
    // 新增公益记录，并设置其属性
    recordCount++;
    uint256 _recordId = recordCount;  
    CharityRecord storage _charityRecord = recordMap[_recordId];
    _charityRecord.recordId = _recordId;
    _charityRecord.recordAmount = _amount;
    _charityRecord.overAmount = 0;
    _charityRecord.srcUser = msg.sender;
    _charityRecord.descCharitable = _desc;
    _charityRecord.recordOrg =_orgAddress;
    _charityRecord.recordTime = block.timestamp;
    _charityRecord.recordStatus = CharityStatus.CROWDFUNDING;
    
    chatityRecords.push(_recordId);
    userMap[msg.sender].recordList.push(_recordId);
    orgMap[_orgAddress].recordIds.push(_recordId);
    emit Initiate(msg.sender,_recordId);
    return _charityRecord;
}

/**
 * @dev 确认发起公益时是否达到用户捐款等级的限制
 * @param _amount 用户在本次发起公益捐赠时选择的筹资金额
**/
function checkLimitForInitiate(uint256 _amount) private view {
    Level _level = queryUserLevel(msg.sender);
    uint256 _levelLimit;
    if (_level == Level.LEVEL_ONE) {
        _levelLimit = LEVEL_ONE_LIMIT;
    } else if (_level == Level.LEVEL_TWO) {
        _levelLimit = LEVEL_TWO_LIMIT;
    } else if (_level == Level.LEVEL_THREE) {
        _levelLimit = LEVEL_THREE_LIMIT;
    }
    require(_amount <= _levelLimit, "发起公益捐款金额超过等级限制");
}
```





### 8.6 用户公益捐款业务

​		用户可以在指定公益机构下进行个人金额捐赠，并创建对应的捐赠记录。该方法将自动检查用户账户余额是否充足，并将捐赠金额从用户账户中扣除。此外，还将自动更新相应的机构账户和目标地址的收款信息。注意，这里捐款也是直接账户转入代理机构，不会直接落入对方用户的账户里面，取钱也是直接通过代理机构进行取钱。

​		有助于提高公众参与公益慈善的积极性和成就感，增强公益慈善的正面能量。同时，也由于具备区块链的去中心化和不可篡改特性，避免了大规模善款管理中的信任危机和数据隐私泄露问题，进一步提高了公众对公益慈善活动的信心与支持。

```solidity
/**
 * @dev 用户进行个人金额捐赠，并创建对应的捐赠记录
 * @param _orgAddress 捐赠的公益慈善所属机构的地址
 * @param _toAddress 捐赠目标地址
 * @param _recordId 公益慈善记录 ID
 * @param _toAmount 捐赠的金额
 * @return 捐赠人的信息信息
**/
function donate(address _orgAddress ,address _toAddress,uint256 _recordId,uint256 _toAmount) public _AuthUser returns(Donor){
    // 判断当前的用户是否存在 
    require(userMap[msg.sender].status != 0,"当前用户未注册");
    // 判断当前的用户是否有足够的金额捐赠
    require(userMap[msg.sender].userAmount >= _toAmount,"当前账户余额不足");
    // 对用户的账户进行计算
    require(recordMap[_recordId].recordStatus == CharityStatus.CROWDFUNDING,"暂无公益捐赠");
    CharityRecord storage _charityRecord = recordMap[_recordId];
    uint256 finishAmount = SafeMath.add(_charityRecord.overAmount,_toAmount);
    if (_charityRecord.overAmount == _charityRecord.recordAmount || finishAmount > _charityRecord.recordAmount){
        revert("当前公益慈善已完成");
    }
    if (checkOrgIsIn(_orgAddress)){
        donorCount++;
        uint256 _donorId = donorCount;
        Donor storage _donor = donorMap[_donorId];
        _donor.donorId = _donorId;
        _donor.donorAmount = _toAmount;
        _donor.donorAddress = msg.sender;
        _donor.donorToAddress = _toAddress;
        _donor.donorToOrg = _orgAddress;
        _donor.donorTime = block.timestamp;
        // 更新用户的捐赠记录 
        userMap[msg.sender].donorList.push(_donorId);
        userMap[msg.sender].userCount++;
        if (_charityRecord.recordStatus == CharityStatus.CROWDFUNDING) {
            _charityRecord.overAmount = SafeMath.add(_charityRecord.overAmount,_toAmount);
            _charityRecord.users.push(msg.sender);
            // 更新机构的金额
            orgMap[_orgAddress].orgAmount = SafeMath.add(orgMap[_orgAddress].orgAmount,_toAmount);
        }
        
        emit Donate(msg.sender,_toAddress,_toAmount);
        return _donor;
    }
}
```





### 8.7 用户取款业务

​		用户可以查询目标机构下已发起的公益项目信息，并选择需要提取资金的公益慈善记录ID及对应金额数量，将其提取到自己的账户中。同时，该方法会校验当前用户是否为捐赠该笔公益项目的发起者，并确认目标机构与公益项目记录是否匹配，从而保障资金的安全性和透明度。

```solidity
/**
 * @dev 用户通过查询指定机构的公益项目情况，然后进行取款操作
 * @param _orgAddress 机构所属地址
 * @param _recordId 需要提取资金的公益慈善记录 ID
 * @param _amount 需要提取的资金数量
 * @return (int256, address) 若成功提取资金，则返回状态码 0 及用户地址；否则返回错误状态码 -1 和空地址
**/
function withdraw(address _orgAddress,uint256 _recordId,uint256 _amount) public _AuthUser returns(int256,address){
    require(checkOrgIsIn(_orgAddress) == true,"当前的机构不存在");
    // 查询当前的Record记录是否存在当前的地址
    CharityRecord memory _charityRecord = recordMap[_recordId];
    if (_charityRecord.recordStatus == CharityStatus.ERROR){
        revert("当前的公益状态异常");
    }
    if (_charityRecord.srcUser == msg.sender && _charityRecord.recordOrg == _orgAddress){
        userMap[msg.sender].userAmount = SafeMath.add(userMap[msg.sender].userAmount,_amount);
        orgMap[_orgAddress].orgAmount = SafeMath.sub(orgMap[_orgAddress].orgAmount,_amount);
        emit Withdraw(msg.sender,_amount);
        return (0,msg.sender);
    }else {
        return (-1,address(0));
    }

}
```





### 8.8  用户更新所有公益状态业务

​		用户可以查询自己参与过的所有公益项目记录，并且根据项目已筹资金额与目标筹资金额之间的关系，将筹资进度处于已完成状态的公益项目状态变更为已完成。

```solidity
// 用户查看当前的进度 更新所有的公益溯源变为已完成  后端使用定时器
function updateRecordPage() public {
    User memory _user = userMap[msg.sender];
    uint256[] memory recordListArr = new uint256[](_user.recordList.length);
    for (uint i = 0; i < chatityRecords.length; ++i){
        require(_user.recordList.length > 0,"当前用户没有公益记录");
        if (recordMap[chatityRecords[i]].recordId == _user.recordList[i]){
            recordListArr[i] = _user.recordList[i];
        }
    }
    for(uint j = 0; j < recordListArr.length;++j){
        if (recordMap[recordListArr[j]].overAmount == recordMap[recordListArr[j]].recordAmount){
            recordMap[recordListArr[j]].recordStatus = CharityStatus.FINISHED;
        }
    }
    emit UpdateRecordPage(msg.sender);
}
```





### 8.9 用户分页查询捐赠记录业务

​		用户可以通过指定页数及每页显示数量的方式来查询自己的捐赠记录，并返回一个指定页码范围内的包含所有捐赠记录的数组，方便用户进行查看和管理。避免用户一次性查询所有导致接口缓慢，消耗极大的gas。

```solidity
/**
 * @dev 分页查询当前用户的捐赠记录
 * @param _page 需要查询的页数，从 1 开始计数
 * @param _pageSize 每页需要返回的记录数量
 * @return Donor[] 返回指定页码及每页数量的捐赠记录数组
**/
function queryUserDonorPage(uint256 _page,uint256 _pageSize) public  returns(Donor[]){
    User memory _user = userMap[msg.sender];
    require(_user.donorList.length != 0,"当前没有捐赠记录");
    require(_page > 0, "页数不能为0");
    uint256 startIndex = (_page - 1) * _pageSize; // 计算起始索引
    uint256 endIndex = startIndex + _pageSize > _user.donorList.length ?  _user.donorList.length : startIndex + _pageSize; // 计算结束索引
    Donor[] memory donorArr = new Donor[](endIndex - startIndex);
    for (uint i = startIndex; i < endIndex; i++){
        donorArr[i - startIndex] = donorMap[_user.donorList[i]];
    }
    return donorArr;
}
```





## 9.合约业务测试

### 9.1 测试用户

- `Org`： 机构测试地址
- `Logistic`： 物流商测试地址
- `User1`： 发起公益用户测试地址
- `User2`： 参与公益用户测试地址

![image-20230430105339328](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202304301053557.webp)



### 9.2 公益捐款活动业务

1.这里需要注意的是，直接使用Org机构地址部署合约，默认创建一个机构。

![image-20230430105302464](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202304301053788.webp)



2.注册用户为张三、李四、王五。

![image-20230430105455160](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202304301054326.webp)

2.注册一个物流默认公司名为物流公司。

![image-20230430105609714](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202304301056828.webp)

3.使用User1的账户调用`initiate`函数发起一个灾区公益捐款活动，需要的资金为1000。

![image-20230430105727609](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202304301057541.webp)

得到的回执数据：

```solidity
1,1000,0,0xb92D76138d2EB560e601fCd9ca8959F9aa032dd9,灾区地震,0xD78861dE66298Ec2864Dc83480078E015e4Edccc,0,1682823358418,
```



4.使用User2调用`donate`函数向User1发起的公益活动捐款`1000`。

- 指定机构
- 指定对方地址

![image-20230430105921595](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202304301059740.webp)

得到的回执数据：

```solidity
1,
1000,
0x3B1917a4d79258688252217f33C5375E97118F68,
0xb92D76138d2EB560e601fCd9ca8959F9aa032dd9,
0xD78861dE66298Ec2864Dc83480078E015e4Edccc,
1682823471041
```



5.User1调用`updateRecordPage`函数，刷新自己的所有公益捐款活动的进度。

![image-20230430110034971](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202304301100110.webp)

6.查询当前的公益捐款进度。

![image-20230430111056375](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202304301110518.webp)

```solidity
1,
1000,
1000,
0xb92D76138d2EB560e601fCd9ca8959F9aa032dd9,
灾区地震,
0xD78861dE66298Ec2864Dc83480078E015e4Edccc,
1,										      // 已完成状态
1682824128562,
[0x3B1917a4d79258688252217f33C5375E97118F68]  // 捐赠人
```



7.User1是发起人，公益捐款活动完成，调用`withdraw`函数取款。

![image-20230430111452038](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202304301114154.webp)

8.调用`queryUserInfo`函数查询用户详细信息。

![image-20230430111624958](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202304301116065.webp)

如下回执可以查看，账户已有1000元。

![image-20230430111604459](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202304301116632.webp)



### 9.3 公益物资捐赠业务

1.User1用户调用`raiseFunds`函数即可发起公益捐赠物资活动。

- 指定Org机构

![image-20230430111949535](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202304301119670.webp)

2.User2指定机构和签收人地址，调用`donatedMaterial`函数捐赠物资。

- 指定Org机构
- 指定签收人地址

![image-20230430112042538](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202304301120689.webp)

如下是回执信息。

```solidity
1,
物资捐赠,
0xD78861dE66298Ec2864Dc83480078E015e4Edccc,
0xb92D76138d2EB560e601fCd9ca8959F9aa032dd9,
方便面,
true,
0,																						 // 物流状态
[0x3B1917a4d79258688252217f33C5375E97118F68,0xD78861dE66298Ec2864Dc83480078E015e4Edccc]  // 物资的溯源地址
```



3.物流商收到新的订单通知，调用`dispath`函数对物资进行下一步运输 。

![image-20230430112213311](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202304301122523.webp)

```solidity
1,
物资捐赠,
0xD78861dE66298Ec2864Dc83480078E015e4Edccc,
0xb92D76138d2EB560e601fCd9ca8959F9aa032dd9,
方便面,
true,
1,								// 运输中
[0x3B1917a4d79258688252217f33C5375E97118F68,0xD78861dE66298Ec2864Dc83480078E015e4Edccc,0x52eE11b761040cfa3f303c6b3799b78621481184]								// 添加了寄送人地址 机构地址 物流地址
```



4.User1用户，收到物资之后，调用`signedGoods`函数对物资进行签收处理。

![image-20230430112355481](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202304301123605.webp)

`queryUserMeterialPage`函数可以对当前用户所发起的公益活动查看历史记录，查看当前申请的物资捐赠人寄送，签收后可以查看有哪些物资。

![image-20230430112422622](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202304301124793.webp)

```solidity
1,
扶贫——四川,
0xb92D76138d2EB560e601fCd9ca8959F9aa032dd9,
0xD78861dE66298Ec2864Dc83480078E015e4Edccc,
[方便面]
```