pragma solidity ^0.4.25;
pragma experimental ABIEncoderV2;

// 主要实现用户的购买运费险和退保的功能
contract FlightDelayInsurance {
    
    address private platform;    // 平台地址
    address private seller;      // 商家地址
    address private insurance;   // 保险公司地址
    
    uint private premium;    // 运费险
    uint private compensation;   // 赔偿金额
    uint256 private delayThreshold = 7 days; // 延误阈值
    
    uint private purchaseTime;   // 购买运费险的时间
    uint private depositTime;    // 存入赔偿金额的时间
    
    bool private purchased;      // 是否购买了运费险
    bool private deposited;      // 是否存入了金额
    
    
    mapping(address => uint256) private balances; // 用户的余额
    mapping(address => bool) private insured;    // 退运费险的用户
    mapping(address => bool) private policy;     // 已经生成保单的用户
    mapping(address => bool) private buyProduct;  // 用户已经购买了商品
    
    
    // 1.初始化需要初始化平台、商家、保险公司的地址
    constructor(address _platform,address _seller,address _insurance,uint _premium,uint _compensation) public {
        platform = _platform;
        seller = _seller;
        insurance = _insurance;
        balances[insurance] = 1000;
        
        // 初始化运费险
        premium = _premium;
        // 初始化赔偿运费险
        compensation = _compensation;
    }
    
    // 用户更新自己的余额
    function updateBalance(uint256 _amount) public returns(address,uint256){
        require(msg.sender != address(0),"当前的用户不存在");
        balances[msg.sender] += _amount;
        return (msg.sender,balances[msg.sender]);
    }
    
    
    // 2.用户简单购买商品的业务操作
    function purchaseProduct() public {
        require(!buyProduct[msg.sender],"当前用户已经购买了商品");
        buyProduct[msg.sender] = true;
        purchaseTime = now;
    }
    
    
    // 3.用户运费险购买上链的业务操作
    function purchaseInsurance() public {
        require(buyProduct[msg.sender],"当前用户未购买商品");
        require(balances[msg.sender] >= 10,"当前用户余额不足");
        
        uint256 entTime = purchaseTime + (0.5 hours * 1000);
        uint256 nowTime = now;
        if (nowTime >= entTime){
            revert("当前购买运费险时间不在范围内");
        }
        depositTime = nowTime;
        balances[msg.sender] -= premium;
        balances[insurance] += compensation;
        purchased = true;
        
    }
    
    
    // 4.保险公司存入运费险的业务操作
    function depositCompensation() public {
        require(msg.sender == insurance,"当前的用户不是保险公司");
        require(balances[msg.sender] != compensation,"当前赔偿金额不正确");
        require(now < depositTime + (2 hours * 1000),"当前存入赔偿金额时间已过期");
        deposited = true;
    }
    
    
    // 5.退保的业务操作
    function backInsurance() public {
        require(!deposited,"当前无法退保");
        balances[msg.sender] += premium;
        balances[insurance] -= compensation;
        purchased = false;
    }
    
    
    // 6.用户生成运费险保单的操作
    function generatePolicy(address _userAddress) public {
        require(deposited,"当前的赔偿金未存入，无法生成保单");
        require(msg.sender == platform,"当前的只有平台可以生成保单");
        require(!policy[_userAddress],"当前的用户已经生成了保单");
        
        policy[_userAddress] = true;
    }
    
    struct Logistic {
        uint256 logisticId;     // 物流ID
        address seller;         // 卖家
        address buyer;          // 买家
        uint256 deliveyTime;    // 发货时间
        uint256 sigTime;        // 签收时间
        uint256 backTime;       // 退货时间
        bool    isBack;         // 是否退货
        bool    isAllowed;      // 运费险是否生效
        bool    isApplyReturn;  // 是否申请退货
    }
    
    bool private isAllowedBack;         // 商家同意退货
    
    mapping(uint256 => Logistic) private logisticMap;
    
    // 添加物流信息
    function addLogistic(uint256 _logisticId,address _seller,address _buyer) public {
        require(logisticMap[_logisticId].deliveyTime == 0,"当前的物流信息已经存在");
        Logistic storage _logistic = logisticMap[_logisticId];
        _logistic.logisticId = _logisticId;
        _logistic.seller = _seller;
        _logistic.buyer = _buyer;
        _logistic.deliveyTime = now;
        _logistic.isAllowed = true;
    }
    
    
    // 获取物流信息
    function getLogisticInfo(uint256 _logisticId) public view returns(Logistic){
        return logisticMap[_logisticId];
    } 
    
    
    // 签收操作
    function signFor(uint256 _logisticId,bool _isSignFor) public {
        require(logisticMap[_logisticId].deliveyTime != 0,"当前的物流信息已经存在");
        require(logisticMap[_logisticId].buyer == msg.sender,"当前你不是买家");
        logisticMap[_logisticId].sigTime = now;
    }
    
    
    // 申请退货
    function requestBack(uint256 _logisticId) public {
        require(logisticMap[_logisticId].deliveyTime != 0,"当前的物流信息已经存在");
        require(logisticMap[_logisticId].buyer == msg.sender,"当前你不是买家");
        logisticMap[_logisticId].isApplyReturn = true;
    }
    
    
    // 商家申请通过
    function passRequestBack(uint256 _logisticId) public {
        require(logisticMap[_logisticId].deliveyTime != 0,"当前的物流信息已经存在");
        require(logisticMap[_logisticId].seller == msg.sender,"当前你不是商家");
        isAllowedBack = true;
    }
    
    
    // 判断是否存在退货时间为7天之内
    function checkPurchase(uint256 _logisticId) public returns(bool,Logistic){
        require(logisticMap[_logisticId].deliveyTime != 0,"当前的物流信息已经存在");
        require(msg.sender == platform,"当前操作只允许平台进行");
        
        Logistic memory _logistic = logisticMap[_logisticId];
        uint256 nowTime = now;
        if (now > _logistic.sigTime + (7 days * 1000)){
            _logistic.isAllowed = false;
            return(false,_logistic);
        }else {
            return(true,_logistic);
        }
        
    }
    
    
    // 这里肯定是根据物流信息进行判断是否可以理赔的
    event ClaimUser(address _userAddress,uint256 _amount);
    event ChargeInsurance(address _insuranceAddress,uint256 _amount);
    
    
    // 1.用户退货或者换货的操作
    function returnProduct(uint256 _logisticId) public {
        require(logisticMap[_logisticId].buyer == msg.sender,"当前你不是买家");
        logisticMap[_logisticId].isBack = true;
        logisticMap[_logisticId].backTime = now;  // 这一步用户就已经完成了退货操作
    }
    
    // 2.用户的理赔操作
    function claimByUser(uint256 _logisticId) public returns(bool,uint256) {
        require(logisticMap[_logisticId].buyer == msg.sender,"当前你不是买家");
        require(logisticMap[_logisticId].backTime != 0,"当前无法进行理赔操作");
        (bool status,Logistic memory _) = checkPurchase(_logisticId);
        if (status){
            balances[msg.sender] += compensation;
            emit ClaimUser(msg.sender,compensation);
            return (status,compensation);
        }else {
            return(status,0);
        }
    }
    
    
    // 3.保险公司的收保费操作
    function chargeByInsurance(uint256 _logisticId) public returns(bool,uint256) {
        require(msg.sender == insurance,"当前只有保险公司有该权限");
        (bool status,Logistic memory _) = checkPurchase(_logisticId);
        if (status){
            balances[msg.sender] += premium;
            emit ChargeInsurance(msg.sender,premium);
            return (status,premium);
        }else {
            return(status,0);
        }
    }
}