pragma solidity ^0.4.25;


contract Supplychain {
    enum RStatus { created, paid }
    struct receivable{
        address from;//欠款方
        address to;//收款方
        string product;//产品或金钱
        uint amount;//金额
        RStatus status;//应收账款状态    
        bool isconfirmed;//是否经第三方可信机构认证
    }

    struct Entity{
        string name;
        uint etype;//(0-企业；1-金融机构)
        bool isUsed;
    }

    uint public receivables_id = 0;
    uint[] rindex;
    address public kernelCompany;  //核心企业，有签发应收账款的权限

    //应收账款
    mapping (uint => receivable ) public receivables; 
    //实体储蓄余额
    mapping (address => uint) public balances;
    //实体详情
    mapping (address => Entity) public entitys;
    
    function supplychain(string _name) public {
        //由核心企业创建合约
        kernelCompany=msg.sender;
        balances[kernelCompany]=10000;
        entitys[msg.sender].name=_name;
        entitys[msg.sender].etype=0;
        entitys[msg.sender].isUsed=true;
    }
    /*
    描述 : 注册
    参数 ：
            _entity : 实体地址
            _name: 实体名
            _etype : 实体类型
    返回值：
            0 -注册成功
            -1 -注册失败，地址已被使用
    */
    function register(address _entity,string _name,uint _etype) public returns (int256){
        if(entitys[_entity].isUsed){
            return -1;
        }
        entitys[_entity].name=_name;
        entitys[_entity].etype=_etype;
        entitys[_entity].isUsed=true;
        if(_etype==1){
            balances[_entity]=1000000;
        }
        else{
            balances[_entity]=0;
        }
        return 0;
    }
    /*
    描述 : 签发应收账款单据 
    参数 ：
            _to : 收款方
            _product: 商品
            _amount : 金额
    返回值：
            (0,rid) -签发成功
            (-1,0) -签发失败，签发单位不是核心企业
            (-2,0) -签发失败，欠款和收款方不能是同一个实体
    */
    function create(address _to, string memory _product,uint _amount) public returns(int256,uint){
        address _from = msg.sender;
        if (_from != kernelCompany) return (-1,0);
        if (_from == _to)return (-2,0);
        uint rid=receivables_id++;
        receivables[rid]=receivable({
            from :_from,
            to :_to,//收款方
            product:_product,//产品或金钱
            amount:_amount,//金额
            status:RStatus.created,//应收账款状态    
            isconfirmed:false//是否经第三方可信机构认证
        });
        return (0,rid);
        
    }
    /*
    描述 : 转让（部分或全部）应收账款单据 
    参数 ：
            new_to : 单据接收方
            _product: 商品
            _amount : 金额
    返回值：
            (0,rid) -转让成功
            (-1,0) -转让失败，不能转让给自己
            (-2,0) -转让失败，转让金额超过拥有的最大金额（结算了的应收账款单据不能转让）
    */
    function tansfer(address new_to, string memory _product, uint _amount) public returns(int256,uint){
        address _to = msg.sender;//单据持有方发起转让
        //计算函数调用的来源地址拥有的未结算应收账款金额之和
        uint allamount = 0;
        //清空rindex数组，用于记录函数调用的来源地址拥有的未结算应收账款id
        rindex.length=0;
        //不能转让给自己
        if (_to == new_to)return (-1,0);
        for(uint i=0;i<receivables_id;i++){
            //对函数调用的来源地址拥有的未结算应收账款进行操作
            if(receivables[i].to==_to && receivables[i].status!=RStatus.paid){
                //涉及单个应收账款单据
                if(receivables[i].amount>=_amount){
                    receivables[i].amount-=_amount;
                    //全部转让，转让单据
                    if(receivables[i].amount==0){
                        receivables[i].amount=_amount;
                        receivables[i].to=new_to;
                        receivables[i].product=_product;
                        return (0,i);
                    }
                    //部分转让，拆分单据
                    else{
                        uint rid=receivables_id++;
                        receivables[rid]=receivable({
                            from :receivables[i].from,
                            to :new_to,//收款方
                            product:_product,//产品或金钱
                            amount:_amount,//金额
                            status:RStatus.created,//应收账款状态    
                            isconfirmed:receivables[i].isconfirmed//是否经第三方可信机构认证
                        });
                        return (0,rid);
                    }
                    
                }
                //计算函数调用的来源地址拥有的未结算应收账款金额之和，超过所需金额则停止计算，存储涉及的id
                else{
                    allamount+=receivables[i].amount;
                    rindex.push(i);
                    if(allamount>=_amount)break;
                }
            }
        }
        //涉及多个应收账款单据
        if(allamount>=_amount){
            //遍历rindex表，处理相应id的应收账款单据
            for(uint j = 0; j < rindex.length; j++){
                //全部转让，转让单据
                if(_amount>=receivables[rindex[j]].amount){
                    receivables[rindex[j]].to=new_to;
                    receivables[rindex[j]].product=_product;
                    _amount-=receivables[rindex[j]].amount;
                    if(j==rindex.length-1)return (0,rindex[j]);
                }
                //部分转让，拆分单据
                else{
                    receivables[rindex[j]].amount-=_amount;
                    uint rid_t=receivables_id++;
                    receivables[rid_t]=receivable({
                        from :receivables[rindex[j]].from,
                        to :new_to,//收款方
                        product:_product,//产品或金钱
                        amount:_amount,//金额
                        status:RStatus.created,//应收账款状态    
                        isconfirmed:receivables[rindex[j]].isconfirmed//是否经第三方可信机构认证
                    });
                    return (0,rid_t);
                }    
            }
        }
        //转让金额超过拥有的最大金额
        else return (-2,0);
    }
    /*
    描述 : 利用应收账款向银行融资
    参数 ：
            new_to : 单据接收方
            _amount : 金额
    返回值：
            (0,rid) -融资成功
            (-1,0) -融资失败，只能是企业向银行融资
            (-2,0) -融资失败，融资金额超过拥有的最大金额（结算了的应收账款单据不能融资，只有认证了的应收账款单据才能融资）
    */
    function financing(address new_to, uint _amount) public returns(int256,uint){
        address _to = msg.sender;//单据持有方发起融资
        //计算函数调用的来源地址拥有的未结算已认证应收账款金额之和
        uint allamount = 0;
        //清空rindex数组，用于记录函数调用的来源地址拥有的未结算已认证应收账款id
        rindex.length = 0;
        //只能是企业向银行融资
        if (entitys[_to].etype!=0 || entitys[new_to].etype!=1)return (-1,0);
        for(uint i=0;i<receivables_id;i++){
            //对函数调用的来源地址拥有的未结算已认证应收账款进行操作
            if(receivables[i].to==_to && receivables[i].status!=RStatus.paid&&receivables[i].isconfirmed){
                //涉及单个应收账款单据
                if(receivables[i].amount>=_amount){
                    receivables[i].amount-=_amount;
                    //全部融资，转让单据
                    if(receivables[i].amount==0){
                        receivables[i].amount=_amount;
                        receivables[i].to=new_to;
                        receivables[i].product="money";
                        balances[_to] += _amount;
                        balances[new_to] -= _amount;
                        return (0,i);
                    }
                    //部分融资，拆分单据
                    else{
                        uint rid=receivables_id++;
                        receivables[rid]=receivable({
                            from :receivables[i].from,
                            to :new_to,//收款方
                            product:"money",//产品或金钱
                            amount:_amount,//金额
                            status:RStatus.created,//应收账款状态    
                            isconfirmed:receivables[i].isconfirmed//是否经第三方可信机构认证
                        });
                        //储蓄金额转入和转出
                        balances[_to] += _amount;
                        balances[new_to] -= _amount;
                        return (0,rid);
                    }
                }
                //计算函数调用的来源地址拥有的未结算已认证应收账款金额之和，超过所需金额则停止计算，存储涉及的id
                else{
                    allamount+=receivables[i].amount;
                    rindex.push(i);
                    if(allamount>=_amount)break;
                }
            }
        }
        //涉及多个应收账款单据
        if(allamount>=_amount){
            //储蓄金额转入和转出
            balances[new_to] -= _amount;
            balances[_to] += _amount;
            //遍历rindex表，处理相应id的应收账款单据
            for(uint j = 0; j < rindex.length; j++){
                //全部融资，转让单据
                if(_amount>=receivables[rindex[j]].amount){
                    receivables[rindex[j]].to=new_to;
                    receivables[rindex[j]].product="money";
                    _amount-=receivables[rindex[j]].amount;
                    if(j==rindex.length-1)return (0,rindex[j]);
                }
                //部分融资，拆分单据
                else{
                    receivables[rindex[j]].amount-=_amount;
                    uint rid_t=receivables_id++;
                    receivables[rid_t]=receivable({
                        from :receivables[rindex[j]].from,
                        to :new_to,//收款方
                        product:"money",//产品或金钱
                        amount:_amount,//金额
                        status:RStatus.created,//应收账款状态    
                        isconfirmed:receivables[rindex[j]].isconfirmed//是否经第三方可信机构认证
                    });
                    return (0,rid_t);
                }    
            }
        }
        //融资金额超过拥有的最大金额
        else return (-2,0);
    }
    /*
    描述 : 应收账款支付结算
    参数 ：
            r_id : 结算账款的编号
    返回值：
            0 -结算成功
            -1 -结算失败，只有核心企业能支付结算
    */
    function settle(uint  r_id) public returns(int256){
         address cur = msg.sender;
         if(cur != kernelCompany) return -1;
         receivables[r_id].status=RStatus.paid;
         balances[cur] -= receivables[r_id].amount;
         balances[receivables[r_id].to] += receivables[r_id].amount;
         return 0;
     }

    /*
    描述 : 第三方可信机构（金融机构）确认应收账款真实性
    参数 ：
            r_id : 确认账款的编号
    返回值：
            0 -确认成功
            -1 -确认失败，只有金融机构能确认
    */
    function confirm(uint  r_id) public returns(int256){
         address cur = msg.sender;
         if(entitys[cur].etype!=1) return -1;
         receivables[r_id].isconfirmed=true;
         return 0;
     }

}