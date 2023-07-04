## 合约代码

~~~ solidity
//SPDX-License-Identifier:MIT

pragma solidity ^0.8.0;

contract SupplyChain { //供应链应收款保理融资

    
    address public supplier; //供应商
    address public buyer;    //核心企业
    address public factoring; //保理公司

    // 定义一个结构体用于存储应收款信息
    struct Invoice {      //账单
        uint invoiceId;   //应收款编号
        uint amount;      //金额
        uint dueDate;     //到期日
        uint creataeDate; //创建日
        bool confirmed;   //是否被核心企业确认
        bool zhuanrang ;  //核心企业是否同意转让事宜
        bool transferred; //是否转移给保理公司
        bool financed;    //是否获得融资
        bool paid;       //是否结清
    }

    //定义结构体变量
    Invoice  invoice;
    //应收款账单编号
    uint public invoiceId;
    // 定义一个映射用于存储企业账户的余额
    mapping(address => uint) public balances;
    //应收款映射
    mapping(uint =>Invoice) public zhangdan; 

   
    //企业账户先赋值余额 (假定合约预存了企业账户余额，实际业务需要另外处理）
    constructor(uint _amount,address _buyer, address _supplier, address _factoring) {
        
        buyer =_buyer;
        supplier = _supplier;
        factoring = _factoring; 

        balances[buyer]  = _amount;
        balances[supplier] =_amount;
        balances[factoring]= _amount;
    
    }

    // 定义一个事件用于通知前端页面
    event InvoiceCreated(uint indexed invoiceId, address indexed supplier,  uint amount);
    event InvoiceConfirmed(uint indexed invoiceId, address indexed buyer);
    event InvoiceTransferred(uint indexed invoiceId, address indexed supplier, uint amount);
    event InvoiceFinanced(uint indexed invoiceId, address indexed finance, uint amount);
    event PaymentReceived(uint indexed invoiceId, address indexed supplier, uint amount);
    event LoanReceived(uint indexed invoiceId, address indexed supplier, uint amount);
    event PaymentMade(uint indexed invoiceId,  uint amount);
    event Settlement(uint indexed invoiceId, address indexed supplier,  uint financeFee );
    event Zhuanrang (uint indexed invoiceId, address indexed buyer);


 
     // 供应商创建应收款信息，返回应收款凭证单号
    function createInvoice(uint _amount) public  returns(uint){
        
        require(_amount > 0, " Wrong number");
        //只可以供应商创建
        require(msg.sender == supplier, "not is supplier");
        // 应收款凭证号增加
        invoiceId ++;
        // 结构体变量实例化赋值
        invoice =Invoice(invoiceId,  _amount,  block.timestamp+60 days, block.timestamp,false, false, false, false,false);
        //新创建的应收款凭证加入到映射中
        zhangdan[invoiceId]= invoice;

        // 通知前端页面
        emit InvoiceCreated(invoiceId, supplier,  _amount);

        return invoiceId;  
    }

    // 核心企业根据供应商提供的单据号确认应收款信息
    function confirmInvoice(uint _invoiceId ) public {

        // 获取指定编号的应收款信息（这个编号是上面创建的编号）
        invoice = zhangdan[_invoiceId];
        //不能超过合同期限  
        require(block.timestamp <= invoice.dueDate,"overtime");  
        // 确保只有核心企业可以确认应收款
        require(buyer == msg.sender, "Only buyer can confirm invoice");
        // 确保应收款未确认
        require(!invoice.confirmed, "Invoice already confirmed");
        // 标记应收款为已确认状态
        invoice.confirmed = true;
        zhangdan[invoiceId]= invoice;

        // 通知前端页面
        emit InvoiceConfirmed(invoiceId, msg.sender);
    }

    // 供应商将自己的应收款转让给保理公司
    function transferInvoice(uint _invoiceId ) public {
        // 获取指定编号的应收款信息
        invoice = zhangdan[_invoiceId];
        //不能超过合同期限  
        require(block.timestamp <= invoice.dueDate,"overtime");  
        // 确保只有供应商可以转让自己的应收款
        require(supplier == msg.sender, "Only supplier can transfer invoice");
        // 确保应收款已确认
        require(invoice.confirmed, "Invoice not confirmed");
        // 确保应收款未转让
        require(!invoice.transferred, "Invoice already transferred");
        // 标记应收款为已转让状态
        invoice.transferred = true;
        zhangdan[invoiceId]= invoice;
      
        // 通知前端页面
        emit InvoiceTransferred(invoiceId, supplier,  invoice.amount);

    }

    //核心企业确认转让（保理公司要求核心企业确认）
    function tongyizhuanrang(uint ) public  returns(bool){
       
        // 获取指定编号的应收款信息（这个编号可以是上面创建的编号）
        invoice = zhangdan[invoiceId];
        //不能超过合同期限 
        require(block.timestamp <= invoice.dueDate,"overtime");  
        // 只有核心企业可以确认转让事宜
        require(buyer == msg.sender, "Only buyer can confirm invoice");
        // 应收款已确认
        require(invoice.confirmed, "Invoice is not  confirmed");
        //供应商已经转让
        require(invoice.transferred,"");
        //确定核心企业未同意转让
        require(!invoice.zhuanrang,"");
        //同意转让
        invoice.zhuanrang = true;
        zhangdan[invoiceId]= invoice;

        return true;

       // 通知前端页面
       emit  Zhuanrang (invoiceId, msg.sender);

    }

    // 保理公司将贷款打到供应商的账户上
    function receiveLoan(uint _invoiceId , uint _amount) public {
        // 获取指定编号的应收款信息
        invoice = zhangdan[_invoiceId];
        require(_amount > 0, " Wrong number");
        require(_amount == invoice.amount,"amount is not");
        //不能超过合同期限
        require(block.timestamp <= invoice.dueDate,"overtime");    
        // 标的未获融资
        require(!invoice.financed, "Invoice not financed");
        //融资状态改为已融资
        invoice.financed = true;

        zhangdan[invoiceId]= invoice;
        // invoices.push(invoice);
        //调用者需是保理公司
        require(factoring == msg.sender, "only factoring can ");
        //已经同意转让
        require(invoice.zhuanrang, "zhuanrang is not");
        //检查余额
        require(balances[msg.sender] >= _amount,"yue is not");

        // 将资金打到供应商的账户上
        balances[msg.sender] -= _amount;
        balances[supplier] += _amount;
        // 通知前端页面
        emit LoanReceived(invoiceId, msg.sender, invoice.amount);
    }


    // 核心企业到期结清应收款，将资金打到保理公司账户上
    function makePayment(uint _invoiceId , uint _amount) public returns(bool ){
        // 获取指定编号的应收款信息
         invoice = zhangdan[invoiceId];
         require(_amount > 0, " Wrong number");
        require(_amount == invoice.amount,"amount is not");
        //不能超过合同期限 
        require(block.timestamp <= invoice.dueDate,"overtime");   
        // 确保只有核心企业可以结清应收款
        require(buyer == msg.sender, "Only buyer can make payment");
        // 确保应收款已确认
        require(invoice.confirmed, "Invoice not confirmed");
        //核心企业已经同意转让事宜
        require(invoice.zhuanrang, "zhuanrang is not");
        // 确保应收款已转让
        require(invoice.transferred, "Invoice not transferred");
        // 确保应收款未结清
        require(!invoice.paid, "Invoice already paid");

        //账户余额要大于转出额

        require(balances[msg.sender] >= _amount, "amount is not");


       // 核心企业将资金打到保理公司的账户上
        
        balances[factoring] += _amount;
        balances[buyer] -= _amount;
        invoice.paid = true;
        zhangdan[invoiceId]= invoice;
        //invoices.push(invoice);
        return true;

        // 通知前端页面
        emit PaymentMade(invoiceId, _amount);
    }

    
    // 供应商和保理公司结算保理费用
    function settleInvoice(uint _invoiceId ) public  returns(bool){
        // 获取指定编号的应收款信息
        invoice = zhangdan[_invoiceId];
        //不能超过合同期限
        require(block.timestamp <= invoice.dueDate,"overtime"); 
        // 判断确定已经融资了
        require(invoice.financed, "Invoice is not financed");
        require(supplier == msg.sender, "not is supplier");
        // 确保应收款已经结清
        require(invoice.paid, "Invoice is not paid");


       // 计算保理费用为总金额的6%，并将资金转入保理公司的账户上
        uint financeFee = invoice.amount*6/100;
    
        balances[factoring] += financeFee;
        balances[supplier] -= financeFee;

        return true;

        // 通知前端页面
        emit Settlement(invoiceId,  supplier, financeFee );

    }

    //查看应收款账单信息
    function getzhangdan(uint _invoiceId) view public returns(Invoice memory ){
        return zhangdan[_invoiceId];
    }

    //查询核心企业账户余额
    function getbuyer() view  public returns(uint) {
        return balances[buyer];
    }

    //查询供应商余额
    function getsupplier() view public returns(uint){
        return balances[supplier];
    }
    //查询保理公司余额
    function getfactoring() view public returns(uint){
        return balances[factoring];
    }

   
}

~~~



## 合约文档说明

供应链金融概念：

供应链金融是将供应链上的核心企业及其相关的上下游配套企业作为一个整体，以产业链为依托、以真实交易为背景、以资金调配为主线、以风险管理为保证、以实现共赢为目标，为整条供应链提供融资等整体金融解决方案。

供应链金融的意义
提高核心企业的竞争力
中小微企业融资难问题

供应链金融模式
预付款融资
存货融资、
应收账款保理。（一般情形下的应收账款融资以保理业务为主）

目前主要痛点
1、信息不透明：
2、交易的真实性：
3、货权的可控性：
4， 标的的流动性：


区块链解决方案

由于区块链技术具有：去中心化、分布式存储、有效防篡改、全程留痕、可追溯”等技术特性，通过区块链技术，能确保数据可信、互认流转，传递核心企业信用，防范履约风险，提高操作层面的效率，降低业务成本。

应收款保理融资合约流程：
首先核心企业和供应商签订供货合同，
供应商供货后提供应收账款凭证给核心企业
核心企业确认应付账款并形成债权凭证
供应商转让债权凭证给保理商
平台将核心企业的应付账款转化为数字债权凭证，上链流通。
各级供货商可以将数字债权凭证拆分转让，一部分给上一级供应商作为货款；还可以利用数字债权凭证找保理商进行贴现融资