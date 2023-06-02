# 金融供应链解决方案 合约案例

# 作者： 
# 江西师范大学 王江宇
# 深圳职业技术学院 张宇豪

# 1.方案设计

### 1.1 常见的金融供应链解决方案

**企业在供应链过程中资金瓶颈问题而设计的一种综合性金融服务。**它通过整合供应链各环节的数据信息，建立信用评级体系，提高供应链全流程的可控性，优化供应链管理，从而帮助企业实现资金周转，提高经营效率。一些常见的金融供应链解决方案包括：

1. **应收账款保理**：通过将企业的应收账款转让给金融机构，快速获取资金，加速流动资金，减轻企业资金压力。
2. **询价融资**：针对采购商在采购过程中需要付款的时间差，利用金融机构的资金，帮助供应商提前收到货款，最大化控制系统、客户和供应商之间的财务风险。
3. **供应链贷款**：在供应链上的所有环节，帮助企业完成与多个金融机构的贷款申请，从而更快地获取资金，并有利于稳定供应链关系。
4. **运营资本贷款**：针对企业的运营资本需求，包括现金流管理，原材料采购、发票支付等，提供资金支持，协助企业运营。

**区块链+供应链金融解决方案是针对传统供应链金融的痛点**，利用区块链前沿技术，全力打造的供应链联盟链、安全数据链、发行数字票据等系列高端产品，满足供应链金融平台各种业务需求，实现核心企业对上下流企业的信息流、资金流、物流、商流的整合和流转，解决供应链上中小企业融资难、融资成本高的问题，大幅降低供应链金融平台的风控和运营成本。

![image-20230413005121836](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202304130051265.webp)





### 1.2 给出解决方案

`针对金融供应链交易中的信任问题`，金融供应链交易中的信任问题主要涉及到**信息不对称**、**资金流转不透明**、**欺诈风险等方面**。在这种情况下，各方之间缺乏互信和良好的合作基础，很难建立长期稳定的供应链关系，阻碍了供应链金融服务的发展。

为了解决这些问题，我们采用了以下几种方法：

1. **建立开放透明的数据平台**：借助云计算、大数据等技术，建立一个开放透明的数据平台，将供应链上各个环节的交易信息、物流信息等全部记录并共享给参与方，以确保信息透明度。同时，通过区块链等技术实现数据的不可篡改性，大大增强了各方对信用评级的信任度。
2. **引入第三方信任机构**：对于供应链金融交易的信任问题，引入第三方信任机构进行信用评级和风险控制，能够有效提高供应链金融服务的交易安全性和透明度。例如，利用金融科技公司的技术和专业知识，对供应链上各个环节的参与方进行信用评估和风险控制。
3. **加强合同约束力**：在供应链金融交易中，建立完善的合同约束机制，规定各方之间的责任和义务，并加强合同的可执行性，以确保交易的合法性和安全性。此外，合同也应该明确各方的信用评级、违约责任等内容，以提高供应链金融交易的透明度和可预见性。



### 1.3 存储设计

定义结构体`receivable`用于记录应收账款详情，结构体`Entity`用于记录节点的基本信息，`receivables_id`为账单的id（自增，相当于账单数），`kernelCompany`记录核心企业address。
一个从id到应收账款详情的映射`receivables`，一个从地址到储蓄余额的映射`balances`，一个从地址到实体详情的映射`entitys`。

存储设计代码如下：
```js
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
    bool etype;//(0-企业；1-金融机构)
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
    
```



### 1.4 接口设计

- `register`
    * 功能：用于注册地址
    * 所需参数：实体地址，实体名，实体类型
    * 结果：0代表成功，1代表失败
- `create`
    * 功能：签发应收账款单据
    * 所需参数：收款方，商品，金额
    * 结果：0代表签发成功；-1代表签发失败，因为签发单位不是核心企业；-2代表签发失败，因为欠款和收款方不能是同一个实体
- `tansfer`
    * 功能：转让（部分或全部）应收账款单据
    * 所需参数：收款方，单据接收方，商品，金额
    * 结果：0代表转让成功；-1代表转让失败，因为只能是企业向银行融资；-2代表转让失败，因为转让金额超过拥有的最大金额（结算了的应收账款单据不能转让）
- `financing`
    * 功能：用于利用应收账款向银行融资
    * 所需参数：收款方，金额
    * 结果：0代表融资成功；-1代表融资失败，因为不能转让给自己；-2代表融资失败，因为融资金额超过拥有的最大金额（结算了的应收账款单据不能融资，只有认证了的应收账款单据才能融资）
- `settle`
    * 功能：应收账款支付结算
    * 所需参数：结算账款的编号
    * 结果：0代表结算成功，1代表结算失败，因为只有核心企业能支付结算
- `confirm`
    * 功能：用于第三方可信机构（金融机构）确认应收账款真实性
    * 所需参数：确认账款的编号
    * 结果：0代表确认成功，1代表确认失败，因为只有金融机构能确认

接口的定义代码如下：
```js
function register(address _entity,string _name,bool _etype) public returns (int256)

function create(address _to, string memory _product,uint _amount) public returns(int256)

function tansfer(address new_to, string memory _product, uint _amount) public returns(int256)

function financing(address new_to, uint _amount) public returns(int256)

function settle(uint  r_id) public returns(int256)

function confirm(uint  r_id) public returns(int256)
```


# 2.核心功能介绍

## 2.1 注册登陆

### 2.1.1 链端实现

将实体地址与详情结构体绑定起来，标记映射中该地址key为已用。为金融机构初始化储蓄余额**1000000**。如果地址已被使用，不能成功注册。
```solidity
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
function register(address _entity,string _name,bool _etype) public returns (int256){
    if(entitys[_entity].isUsed){
        return -1;
    }
    entitys[_entity].name=_name;
    entitys[_entity].etype=_etype;
    entitys[_entity].isUsed=true;
    if(_etype){
        balances[_entity]=1000000;
    }
    else{
        balances[_entity]=0;
    }
    return 0;
}
```


### 2.1.2 后端实现

- 注册

```python
def register(request):
  if request.method == 'POST':
    req=json.loads(request.body)
    name=req["name"]
    password=req["pwd"]
    #生成地址
    ac = Account.create(password)
    print("new address :\t", ac.address)
    print("new privkey :\t", encode_hex(ac.key))
    print("new pubkey :\t", ac.publickey)

    kf = Account.encrypt(ac.privateKey, password)
    keyfile = "{}/{}.keystore".format(client_config.account_keyfile_path, name)
    print("save to file : [{}]".format(keyfile))
    with open(keyfile, "w") as dump_f:
        json.dump(kf, dump_f)
        dump_f.close()
    print("INFO >> Read [{}] again after new account,address & keys in file:".format(keyfile))
    with open(keyfile, "r") as dump_f:
        keytext = json.load(dump_f)
        privkey = Account.decrypt(keytext, password)
        ac2 = Account.from_key(privkey)
        print("address:\t", ac2.address)
        print("privkey:\t", encode_hex(ac2.key))
        print("pubkey :\t", ac2.publickey)
        print("\naccount store in file: [{}]".format(keyfile))
        dump_f.close()
    #调用函数
    args = [ac2.address, req["name"], req["type"]]
    receipt = client.sendRawTransactionGetReceipt(Contractaddr, contract_abi, "register", args)
    print("receipt:", receipt)
    #调用成功
    if(receipt['output']=="0x0000000000000000000000000000000000000000000000000000000000000000"):
        dic={}
        dic['state']="success"
        dic['address']= ac2.address
        return JsonResponse(dic)
    return HttpResponse("error!")
```

- 登陆

```python
def login(request):
    req=json.loads(request.body)
    name=req["name"]
    password=req["pwd"]
    keyfile = "{}/{}.keystore".format(client_config.account_keyfile_path, name)
    #if the account doesn't exists
    dic={}
    if os.path.exists(keyfile) is False:
        dic['state']="no_user"
    else:
        print("name : {}, keyfile:{} ,password {}  ".format(name, keyfile, password))
        try:
            with open(keyfile, "r") as dump_f:
                keytext = json.load(dump_f)
                privkey = Account.decrypt(keytext, password)
                ac2 = Account.from_key(privkey)
                print("address:\t", ac2.address)
                print("privkey:\t", encode_hex(ac2.key))
                print("pubkey :\t", ac2.publickey)
                client_config.account_keyfile=name+".keystore"
                client_config.account_password=password
                dic={}
                dic['state']="success"
                dic['address']= ac2.address
                return JsonResponse(dic)
        except Exception as e:
            dic['state']= "pwd_error"
   return JsonResponse(dic)
```



## 2.2 签发应收账款交易上链

**主要实现了采购商品—签发应收账款交易上链。**输入收款方地址，账款交易的商品和对应金额。记录到应收账款映射中，id自增。只有函数调用的来源地址为核心企业地址时，才能成功签发，且核心企业不能向自己签发应收账款。

### 2.2.1 链端实现

```solidity
/*
描述 : 签发应收账款单据 
参数 ：
        _to : 收款方
        _product: 商品
        _amount : 金额

返回值：
        0 -签发成功
        -1 -签发失败，签发单位不是核心企业
        -2 -签发失败，欠款和收款方不能是同一个实体
*/
function create(address _to, string memory _product,uint _amount) public returns(int256){
    address _from = msg.sender;
    if (_from != kernelCompany) return -1;
    if (_from == _to)return -2;
    uint rid=receivables_id++;
    receivables[rid]=receivable({
        from :_from,
        to :_to,//收款方
        product:_product,//产品或金钱
        amount:_amount,//金额
        status:RStatus.created,//应收账款状态    
        isconfirmed:false//是否经第三方可信机构认证
    });
    return 0;
}
```

### 2.2.2 后端实现

```python
def create(request):
  if request.method == 'POST':
    req=json.loads(request.body)
    #调用函数
    keyfile = "{}/{}.keystore".format(client_config.account_keyfile_path, req["to"])
    dic={}
    if os.path.exists(keyfile) is False:
        dic['state']="no_user"
    else:
        with open(keyfile, "r") as dump_f:
            keytext = json.load(dump_f)
            print("address:\t", keytext["address"])
        args = [to_checksum_address(keytext["address"]), req["product"], req["amount"]]
        receipt = client.sendRawTransactionGetReceipt(Contractaddr, contract_abi, "create", args)
        print("receipt:", receipt)
        #调用成功
        txhash = receipt['transactionHash']
        txresponse = client.getTransactionByHash(txhash)
        inputresult = data_parser.parse_transaction_input(txresponse['input'])
        outputresult = data_parser.parse_receipt_output(inputresult['name'], receipt['output'])
        print(outputresult)
        if(outputresult[0]==-1):
            dic['state']="error(-1)"
        elif(outputresult[0]==-2):
            dic['state']="error(-2)"
        else:
            dic['state']="success"
        dic['data']=outputresult
    return JsonResponse(dic)
```



## 2.3 应收账款的转让上链

**主要实现应收账款的转让上链。**输入转让接收方地址，账款交易的商品和对应金额。分两种情况，部分转让和全部转让。全部转让直接更新金额足够的应收账款的`to`，`product`属性。部分转让需要拆分应收账款，原单据金额减少，并生成一个新的单据记录到应收账款映射中，id自增。当一个应收账款单据金额不够时，操作可能涉及多个应收账款单据。只有转让金额小于函数调用的来源地址拥有的未结算应收账款金额之和，才能成功转让，且不能转让给自己。

### 2.3.1 链端实现

```solidity
/*
描述 : 转让（部分或全部）应收账款单据 
参数 ：
        new_to : 单据接收方
        _product: 商品
        _amount : 金额

返回值：
        0 -转让成功
        -1 -转让失败，不能转让给自己
        -2 -转让失败，转让金额超过拥有的最大金额（结算了的应收账款单据不能转让）
*/
function tansfer(address new_to, string memory _product, uint _amount) public returns(int256){
    address _to = msg.sender;//单据持有方发起转让
    //计算函数调用的来源地址拥有的未结算应收账款金额之和
    uint allamount = 0;
    //清空rindex数组，用于记录函数调用的来源地址拥有的未结算应收账款id
    rindex.length=0;
    //不能转让给自己
    if (_to == new_to)return -1;
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
                    return 0;
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
                    return 0;
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
                if(j==rindex.length-1)return 0;
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
                return 0;
            }    
        }
    }
    //转让金额超过拥有的最大金额
    else return -2;
}
```

### 2.3.2 后端实现

```python
def transfer(request):
  if request.method == 'POST':
    print("now account is : "+client_config.account_keyfile)
    print("now account password is : "+client_config.account_password)
    req=json.loads(request.body)
    #调用函数
    keyfile = "{}/{}.keystore".format(client_config.account_keyfile_path, req["new_to"])
    dic={}
    if os.path.exists(keyfile) is False:
        dic['state']="no_user"
    else:
        with open(keyfile, "r") as dump_f:
            keytext = json.load(dump_f)
            print("address:\t", keytext["address"])
        args = [to_checksum_address(keytext["address"]),req["product"],req["amount"]]
        receipt = client.sendRawTransactionGetReceipt(Contractaddr, contract_abi, "tansfer", args)
        print("receipt:", receipt)
        #调用成功
        txhash = receipt['transactionHash']
        txresponse = client.getTransactionByHash(txhash)
        inputresult = data_parser.parse_transaction_input(txresponse['input'])
        outputresult = data_parser.parse_receipt_output(inputresult['name'], receipt['output'])
        print(outputresult)
        if(outputresult[0]==-1):
            dic['state']="error(-1)"
        elif(outputresult[0]==-2):
            dic['state']="error(-2)"
        else:
            dic['state']="success"
        dic['data']=outputresult
    return JsonResponse(dic)
```



## 2.4 应收账款单据向银行申请融资

**利用应收账款向银行融资上链，供应链上所有可以利用应收账款单据向银行申请融资。**类似转让。输入融资资金接收方地址和对应金额（商品默认为`money`）。分两种情况，部分融资和全部融资。全部融资直接更新金额足够的应收账款的`to`，`product`属性，将应收账款单据转让给银行。部分融资需要拆分应收账款，原单据金额减少，并生成一个新的单据记录到应收账款映射中，id自增。当一个应收账款单据金额不够时，操作可能涉及多个应收账款单据。只有融资金额小于函数调用的来源地址拥有的未结算已认证应收账款金额之和，才能成功融资，且单据转让方只能是企业（`type=false`），接收方只能是银行（`type=true`）。

### 2.4.1 链端实现

```solidity
/*
描述 : 利用应收账款向银行融资
参数 ：
        new_to : 单据接收方
        _amount : 金额

返回值：
        0 -融资成功
        -1 -融资失败，只能是企业向银行融资
        -2 -融资失败，融资金额超过拥有的最大金额（结算了的应收账款单据不能融资，只有认证了的应收账款单据才能融资）
*/
function financing(address new_to, uint _amount) public returns(int256){
    address _to = msg.sender;//单据持有方发起融资
    //计算函数调用的来源地址拥有的未结算已认证应收账款金额之和
    uint allamount = 0;
    //清空rindex数组，用于记录函数调用的来源地址拥有的未结算已认证应收账款id
    rindex.length = 0;
    //只能是企业向银行融资
    if (entitys[_to].etype || !entitys[new_to].etype)return -1;
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
                    return 0;
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
                    return 0;
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
                if(j==rindex.length-1)return 0;
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
                return 0;
            }    
        }
    }
    //融资金额超过拥有的最大金额
    else return -2;
}
```

### 2.4.2 后端实现

```python
def financing(request):
  if request.method == 'POST':
    print("now account is : "+client_config.account_keyfile)
    print("now account password is : "+client_config.account_password)
    req=json.loads(request.body)
    #调用函数
    keyfile = "{}/{}.keystore".format(client_config.account_keyfile_path, req["new_to"])
    dic={}
    if os.path.exists(keyfile) is False:
        dic['state']="no_user"
    else:
        with open(keyfile, "r") as dump_f:
            keytext = json.load(dump_f)
            print("address:\t", keytext["address"])
        args = [to_checksum_address(keytext["address"]),req["amount"]]
        receipt = client.sendRawTransactionGetReceipt(Contractaddr, contract_abi, "financing", args)
        print("receipt:", receipt)
        #调用成功
        txhash = receipt['transactionHash']
        txresponse = client.getTransactionByHash(txhash)
        inputresult = data_parser.parse_transaction_input(txresponse['input'])
        outputresult = data_parser.parse_receipt_output(inputresult['name'], receipt['output'])
        print(outputresult)
        if(outputresult[0]==-1):
            dic['state']="error(-1)"
        elif(outputresult[0]==-2):
            dic['state']="error(-2)"
        else:
            dic['state']="success"
        dic['data']=outputresult
    return JsonResponse(dic)
```



## 2.5 链上应收账款 到期支付

**实现了应收账款支付结算上链，应收账款单据到期时核心企业向下游企业支付相应的欠款**。输入待结算的的应收账款编号，将对应应收账款的状态`status`属性设为已支付。相应地增减涉及实体的储蓄余额。只有函数调用的来源地址为核心企业地址时，才能进行该操作。

### 2.5.1 链端实现

```solidity
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
```
### 2.5.2 后端实现

```python
def settle(request):
  if request.method == 'POST':
    print("now account is : "+client_config.account_keyfile)
    print("now account password is : "+client_config.account_password)
    req=json.loads(request.body)
    #调用函数
    args = [req["r_id"]]

    receipt = client.sendRawTransactionGetReceipt(Contractaddr, contract_abi, "settle", args)
    print("receipt:", receipt)
    #调用成功
    txhash = receipt['transactionHash']
    txresponse = client.getTransactionByHash(txhash)
    inputresult = data_parser.parse_transaction_input(txresponse['input'])
    outputresult = data_parser.parse_receipt_output(inputresult['name'], receipt['output'])
    print(outputresult)
    dic={}
    dic['state']=outputresult[0]
    return JsonResponse(dic)
```



## 2.6 第三方可信机构

**第三方可信机构（金融机构）确认应收账款真实性。**输入待确认的应收账款编号，将对应应收账款的`isconfirmed`属性设为true。只有金融机构（类型=true）可以对应收账款进行确认。

### 2.6.1 链端实现

```solidity
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
    if(!entitys[cur].etype) return -1;
    receivables[r_id].isconfirmed=true;
    return 0;
}
```
### 2.6.2 后端实现

```python
def confirm(request):
  if request.method == 'POST':
    print("now account is : "+client_config.account_keyfile)
    print("now account password is : "+client_config.account_password)
    req=json.loads(request.body)
    #调用函数
    args = [req["r_id"]]

    receipt = client.sendRawTransactionGetReceipt(Contractaddr, contract_abi, "confirm", args)
    print("receipt:", receipt)
    #调用成功
    txhash = receipt['transactionHash']
    txresponse = client.getTransactionByHash(txhash)
    inputresult = data_parser.parse_transaction_input(txresponse['input'])
    outputresult = data_parser.parse_receipt_output(inputresult['name'], receipt['output'])
    print(outputresult)
    dic={}
    dic['state']=outputresult[0]
    return JsonResponse(dic)
```

### 2.6.3 后端查询账单和用户余额

- 查询账单

```python
def find(request):
  if request.method == 'POST':
    print("now account is : "+client_config.account_keyfile)
    print("now account password is : "+client_config.account_password)
    req=json.loads(request.body)
    #调用函数
    args = [req["r_id"]]

    receipt = client.sendRawTransactionGetReceipt(Contractaddr, contract_abi, "receivables", args)
    print("receipt:", receipt)
    #调用成功
    txhash = receipt['transactionHash']
    txresponse = client.getTransactionByHash(txhash)
    inputresult = data_parser.parse_transaction_input(txresponse['input'])
    outputresult = data_parser.parse_receipt_output(inputresult['name'], receipt['output'])
    print(outputresult)
    dic={}
    dic['state']="success"
    dic['data']=outputresult
    return JsonResponse(dic)
```

- 查询余额

```python
def balance(request):
  if request.method == 'POST':
    print("now account is : "+client_config.account_keyfile)
    print("now account password is : "+client_config.account_password)
    req=json.loads(request.body)
    #调用函数
    keyfile = "{}/{}.keystore".format(client_config.account_keyfile_path, req["name"])
    dic={}
    if os.path.exists(keyfile) is False :
        dic['state']="no_user"
    else:
        with open(keyfile, "r") as dump_f:
            keytext = json.load(dump_f)
            print("address:\t", keytext["address"])
        args = [to_checksum_address(keytext["address"])]
        receipt = client.sendRawTransactionGetReceipt(Contractaddr, contract_abi, "balances", args)
        print("receipt:", receipt)
        #调用成功
        txhash = receipt['transactionHash']
        txresponse = client.getTransactionByHash(txhash)
        inputresult = data_parser.parse_transaction_input(txresponse['input'])
        outputresult = data_parser.parse_receipt_output(inputresult['name'], receipt['output'])
        print(outputresult)
        dic={}
        dic['state']="success"
        dic['data']=outputresult
    return JsonResponse(dic)
```



# 3. 功能测试

## 3.1 界面展示

- 登录
  ![img](https://camo.githubusercontent.com/57873588632d07cd7d9d1a65193e5d1fe1ceed5874ccec191688c04e044676fa/68747470733a2f2f63646e2e6a7364656c6976722e6e65742f67682f7368657272796a772f5374617469635265736f75726365406d61737465722f696d6167652f62632d3033302e706e67)

- 注册

![img](https://camo.githubusercontent.com/24b6df423fba322964a35300bbf22714ccfa0287a057b1cf7554a85992381fe3/68747470733a2f2f63646e2e6a7364656c6976722e6e65742f67682f7368657272796a772f5374617469635265736f75726365406d61737465722f696d6167652f62632d3033312e706e67)

- 登录后默认进入账号信息页

![img](https://camo.githubusercontent.com/da85b879fca0b1057f43934dbe7b6d999c699c21a1db9b35326f1813dedc6538/68747470733a2f2f63646e2e6a7364656c6976722e6e65742f67682f7368657272796a772f5374617469635265736f75726365406d61737465722f696d6167652f62632d3033322e706e67)

- 核心企业账户可查看应付账款

![img](https://camo.githubusercontent.com/5bf5bc20a336b0a8a12fc8854a3eb1f11313455ef5ed4bfe1c11c8a3ce58c8d3/68747470733a2f2f63646e2e6a7364656c6976722e6e65742f67682f7368657272796a772f5374617469635265736f75726365406d61737465722f696d6167652f62632d3033332e706e67)
> pyaccount 为核心企业账户

- 核心企业账户可签发单据

![img](https://camo.githubusercontent.com/c2ac4c24dbe53a7197cb708aa72cf102dd724dda604a6807d589ed929f5346b6/68747470733a2f2f63646e2e6a7364656c6976722e6e65742f67682f7368657272796a772f5374617469635265736f75726365406d61737465722f696d6167652f62632d3033342e706e67)

- 核心企业账户可支付结算

![img](https://camo.githubusercontent.com/26e664fd5756568ffbafb7f94e6fab69a2afc9c85dc1501647e2421303b5bd40/68747470733a2f2f63646e2e6a7364656c6976722e6e65742f67682f7368657272796a772f5374617469635265736f75726365406d61737465722f696d6167652f62632d3034302e706e67)

- 银行账户可查看链上的所有交易

![img](https://camo.githubusercontent.com/d2377ed280c7c318e0e2ad20dc0b4843c9faa273271a50a4fba604dc7ea8a0ad/68747470733a2f2f63646e2e6a7364656c6976722e6e65742f67682f7368657272796a772f5374617469635265736f75726365406d61737465722f696d6167652f62632d3033392e706e67)
> test4 为银行账户

- 银行账户可验证交易的真实性
  

![img](https://camo.githubusercontent.com/a3ec01134702e4d6c6988cee64efa79ffb2e849d6fe183e1c9e82f8f8e06fde0/68747470733a2f2f63646e2e6a7364656c6976722e6e65742f67682f7368657272796a772f5374617469635265736f75726365406d61737465722f696d6167652f62632d3034312e706e67)

- 下游企业账户可查看应收账款

![img](https://camo.githubusercontent.com/b0db31df399240693b421590a10780b77a61b05a27e2d2b8176468d18c64a634/68747470733a2f2f63646e2e6a7364656c6976722e6e65742f67682f7368657272796a772f5374617469635265736f75726365406d61737465722f696d6167652f62632d3033362e706e67)
> test5 为下游企业账户

- 下游企业账户可利用应收账款融资

![img](https://camo.githubusercontent.com/e26c168d8fabb7289deec86f0eb413b1af00bc2500a23fcca45cc710356dadaa/68747470733a2f2f63646e2e6a7364656c6976722e6e65742f67682f7368657272796a772f5374617469635265736f75726365406d61737465722f696d6167652f62632d3033372e706e67)


- 下游企业账户可转让应收账款

![img](https://camo.githubusercontent.com/2f4b1d5c0ee6f1db70867cb8a5439cb87d851c0fa1fca28b741c4b6a854da863/68747470733a2f2f63646e2e6a7364656c6976722e6e65742f67682f7368657272796a772f5374617469635265736f75726365406d61737465722f696d6167652f62632d3033382e706e67)




## 3.2 合约测试

1. 创建核心企业名字为jxnu

<img src="https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/image-20230424115648869.png" alt="image-20230424115648869" style="zoom:67%;" />

2. 注册公司，金融机构，其中`0-公司`，`1-金融机构`

<img src="https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/image-20230424115825918.png" alt="image-20230424115825918" style="zoom:67%;" />

<img src="https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/image-20230424115937822.png" alt="image-20230424115937822" style="zoom:67%;" />

这里注意是选择1，注册一个金融机构

<img src="https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/image-20230424120035181.png" alt="image-20230424120035181" style="zoom:67%;" />

3. 创建应收账款，账款信息：产品为`chelun` 需要的金额：`1000`

<img src="https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/image-20230424120145748.png" alt="image-20230424120145748" style="zoom:67%;" />

4. 应收账款转移，给下游企业 购买产品为车毂，价格为500。也可以选择拆分转移，但必须是小于账款金额

<img src="https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/image-20230424120248917.png" alt="image-20230424120248917" style="zoom:67%;" />

<img src="https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/image-20230424120349675.png" alt="image-20230424120349675" style="zoom:67%;" />

5. 由金融机构确定账款有效性，Id为账款序号，每进行一次交易id+1。因此我们固定id为0，1

<img src="https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/image-20230424120457985.png" alt="image-20230424120457985" style="zoom:67%;" />

<img src="https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/image-20230424120606639.png" alt="image-20230424120606639" style="zoom:67%;" />

6. 企业向金融机构融资，融资金额需小于等于账款金额，可拆分融资。

<img src="https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/image-20230424120703858.png" alt="image-20230424120703858" style="zoom:67%;" />

<img src="https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/image-20230424120739573.png" alt="image-20230424120739573" style="zoom:67%;" />

7. 完成交易，此时核心企业需要将金额转交给金融机构，成功后我们再查询一次核心企业金额

<img src="https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/image-20230424120900096.png" alt="image-20230424120900096" style="zoom:67%;" />

<img src="https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/image-20230424120929403.png" alt="image-20230424120929403" style="zoom:67%;" />
