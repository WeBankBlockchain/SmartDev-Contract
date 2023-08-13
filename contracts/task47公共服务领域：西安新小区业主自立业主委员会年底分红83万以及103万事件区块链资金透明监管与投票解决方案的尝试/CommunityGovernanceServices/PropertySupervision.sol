// SPDX-License-Identifier: MIT
pragma solidity >= 0.6 < 0.9;

/*

作者：重庆电子工程职业学院 | 向键雄 杜小敏
本合约遵守FISCO BCOS开源社区开源协议，如需商用等盈利性操作请联系社区小助手
*/
import "./AccountManger.sol";



contract PropertySupervision is AccountManger{               // 物业管理监控合约

/*变量定义区*/
    string   public  PublicAccounts;                        // 账户名称
    address  public  BanlanceAddress;                       // 账户地址
    uint256  public  PropertyFees;                          // 物业费
    uint256  public  lastS;                                 // 每月执行一次的最后时间
    uint256  public  agreeNumber = 0;                       // 同意数
    uint256  public  disagreeNumber = 0;                    // 拒绝数
    uint256  public  abstainedNumber = 0;                   // 弃权数
    uint     public  index = 0;                             // 索引数
    bool createPublicAccountBool = false;                   // 是否创建公共账户
    AccountManger public accountManger;                     // 定义引用合约实体

// 构造函数 声明公共账户名称如：小区物管名 、公共账户账户地址 、 楼栋数用于确定楼栋长数量 、 可入住居民户数 、 已经入住居民户数 
    constructor(string memory _PublicAccounts,address _banlanceAddress,uint buildingNumber,uint buildingmember,uint buildingOccupants) AccountManger(buildingNumber,buildingmember, buildingOccupants)  {
        PublicAccounts = _PublicAccounts;               
        BanlanceAddress =_banlanceAddress;
        createpublicAccount(PublicAccounts,0,BanlanceAddress);
    }

/*实体定义区*/
    // 公共账户
    struct PublicAccountStruct {
        string id;                  // id 索引
        uint256 banlance;           // 账户积分
        address banlanceAddress;    // 账户地址

    }
    // 票
    struct VoteStruct {
        string  id;                    // 居民id
        bytes32  voteHash;              // 投票hash
        uint    voteNumber;            // 投票数1同意,2拒绝,3弃权
        
    }

    // 投票请求
    struct VoteRequire {
        address voteRequirer;           // 投票请求者
        bytes32 TranscationHash;        // 交易hash  
        bytes32  voteHash;               // 投票hash
        string  notes;                  // 投票备注
        bool    isVoteAbstainedBool;    // 是否允许弃权
        uint    time;                   // 发起时间
        uint    endTime;                // 截止时间
        bool    bigEvent;               // 是否为大事件

    }

    // 交易历史
    struct TranscationHistory {
        address voteRequirer;           // 投票请求者        
        bytes32 TranscationHash;     // 交易hash
        address from;               // 来自那里
        address to;                 // 去往哪里
        uint banlance;              // 账户余额
        uint time;                  // 交易时间
        bool isBuy;                 // 买
        bool isSell;                // 卖
        string notes;               // 备注
        bool isVoteEffective;       // 交易是否生效
        

    }

/*mapping定义区*/   
    mapping (string => PublicAccountStruct)  PublicAccountMapping;                     // 账户mapping
    mapping (bytes32 => TranscationHistory)  TranscationHistoryMapping;                // 交易历史记录mapping
    mapping (bytes32 => bool)                TranscationEffectiveMapping;              // 交易默认不生效
    mapping (string => bool)                 alreadyPaidPropertyFees;                  // 是否已经交过物业费
    mapping (string => bool)                 voteMapping;                              // 是否已经投过票
    mapping (string => bool)                 isVoteAbstainedMapping;                   // 本次投票是否可以弃权
    mapping (bytes32 => VoteRequire)         VoteRequireMapping;                       // 记录发起投票
    mapping (string => VoteStruct)           VoteStructMapping;                        // 投票实体
    mapping (string => bool)                 VoteStructBool;                           // 该用户本轮是否已经投票
    mapping (string => bytes32)              voteHashMapping;                          // 用于存储votehash
    mapping (bytes32 => bool)                voteIsEvent;


/*事件定义区*/
    event   payPropertyFeesEvent(string id, uint256 PropertyFees, uint mouth);         // 支付物业费事件
    event   setPropertyFeesEvent(address setAddress, uint256 Fees);                    // 设置物业费事件
    event   updatePropertyFeesEvent(address setAddress,string id, uint256 Fees);       // 更新更护余额事件
    event   GetTransactionRegulationEvent(address setAddress,bytes32 _TranscationHash);// 交易记录监管查询事件
    event   NewTranscationEvent(address setAddress,bytes32 _TranscationHash,address _from,address _to,uint _banlance,bool _isBuy,bool _isSell,string _notes);// 新增交易发送
    event   voteEvent(address setAddress,bytes32 voteHash,string _id,uint256 _voteNumber);// 投票功能事件
    event   oneVoteEvent(address setAddress,bytes32 voteHash,string _id,uint256 _voteNumber);// 一票投票功能事件
    event   voteIsAgreeEvent(bytes32 voteHash,string voteResultReturn);                 // 投票是否成功事件
    event   voteSendEvent(address _voteRequirer,bytes32 _transcationHash,bool _isVoteAbstainedBool,uint beginTime,uint _endTime,bool _bigEvent);// 发送投票事件
    event   SetTransactionRegulationEvent(address _voteRequirer,bytes32 _TranscationHash,address _from,address _to,uint _banlance,uint _time,bool _isBuy,bool _isSell);// 设置交易记录事件
    event   createpublicAccountEvent(string _id,uint _banlance,address _banlanceAddress);// 创建公共用户事件

/*数组定义区*/
    string[] public voteNumbers;                                                      // 用于存储投票数的数组
     


/*功能方法区*/

    // 缴纳物业费
    function payPropertyFees(string memory _id) public returns(bool) {
        if(block.timestamp - lastS >= 30 days){                                                // 判断每月只能执行一次
        }
        lastS = block.timestamp;                                                               // 将当前的时间设置为每月最后一次
        ResidentStruct memory  _residentStruct = residentMapping[_id];                         // 获取居民实体
        require(_residentStruct.banlance <= 0,"Insufficient balance !");                       // 判断账户余额
        _residentStruct.banlance = _residentStruct.banlance - PropertyFees;                    // 扣取物业费
        PublicAccountStruct memory _publicAccountStruct = PublicAccountMapping[PublicAccounts];// 获取公共账户实体 
        _publicAccountStruct.banlance = _publicAccountStruct.banlance + PropertyFees;          // 添加物业费
        alreadyPaidPropertyFees[_id] = true;                                                   // 标记该用户已经缴纳过本月物业费
        emit payPropertyFeesEvent(_id,PropertyFees,lastS);                                     // 触发事件
        return true;                                                                           // 返回true响应后端

    } 

    // 设置物业费
    function setPropertyFees(uint256 Fees) public  returns(bool) {                            
        PropertyFees = Fees;                                                                   // 设置新的物业费
        emit setPropertyFeesEvent(msg.sender,Fees);                                            // 触发事件
        return true;                                                                           // 返回true响应后端
    }


    // 更新账户积分余额
    function updatePropertyFees(string memory _id ,uint256 _fees) public returns(bool) {
        require(_fees < 0,"Insufficient fees !");                                            //  判断传入的余额是否为0
        ResidentStruct memory  _residentStruct = residentMapping[_id];                        // 访问居民实体
        _residentStruct.banlance = _residentStruct.banlance + _fees;                          // 修改余额内容
        emit updatePropertyFeesEvent(msg.sender,_id,_fees);
        return true;                                                                          // 返回true响应后端
    }


    // 交易记录监管查询
    function GetTransactionRegulation(bytes32  _TranscationHash) public returns(bytes32 ,address,address,uint,uint,string memory){
        require(TranscationEffectiveMapping[_TranscationHash],"Transaction sent but not effective");//确定交易是否生效
        TranscationHistory memory _transcationHistory = TranscationHistoryMapping[_TranscationHash];//获取交易结构体
        emit GetTransactionRegulationEvent(msg.sender, _TranscationHash);                           // 触发事件
        return (_transcationHistory.TranscationHash,_transcationHistory.from,_transcationHistory.to,_transcationHistory.banlance,_transcationHistory.time,_transcationHistory.notes);// 返回参数
    }

    // 新增交易发送
    function NewTranscation(address _voteRequirer ,bytes32  _TranscationHash,address _from,address _to,uint _banlance,bool _isBuy,bool _isSell,string memory _notes) public returns(bool) {
        if (_isBuy) {
            require(! _isSell,"Please clarify the transaction type !");                                           //判断是否为双选
            SetTransactionRegulation(_voteRequirer,_TranscationHash,_from, _to,_banlance,block.timestamp,_isBuy,_isSell,_notes);//加入结构体

        } else if(_isSell){
            require(! _isBuy,"Please clarify the transaction type !");                                            //判断是否为双选
            SetTransactionRegulation(_voteRequirer,_TranscationHash,_from, _to,_banlance,block.timestamp,_isBuy,_isSell,_notes);// 加入结构体
        }
        emit NewTranscationEvent(_voteRequirer,_TranscationHash,_from,_to,_banlance,_isBuy,_isSell,_notes);
        return true;

    }

    // 投票功能
    function vote(bytes32 voteHash, string memory _id, uint _voteNumber) public {
        require(! VoteStructBool[_id],"This round of voting has been completed");                       // 判断是否已经投过票
        VoteRequire memory _voteRequire = VoteRequireMapping[voteHash];                                 // 获取实体
        if (_voteNumber == 3){                                                                          // 如果投弃权票
            require(_voteRequire.isVoteAbstainedBool == true ,"Cannot abstain from voting this time");  // 判断当前事件是否可以弃权
            abstainedNumber ++;                                                                         // 如果可以弃权让弃权数自加
        }else if(_voteNumber == 2){                                                                     // 获取当前投票内容
            disagreeNumber ++;                                                                          // 让拒绝票自加
        }else if(_voteNumber == 1){                                                                     // 获取当前投票内容
            agreeNumber ++;                                                                             // 让同意票自家
        }
        VoteStruct memory _voteStruct = VoteStruct(_id, voteHash, _voteNumber);                         // 获取投票实体 
        VoteStructMapping[_id] = _voteStruct;                                                           // 将用户指定投票实体
        VoteStructBool[_id] =  true;                                                                    // 将此用户标记为以投票
        voteNumbers[index] = _id;                                                                       // 将id存入数组
        index ++;                                                                                       // 让下标自加
        emit voteEvent(msg.sender,voteHash,_id,_voteNumber);
    }

    // 一票肯定
    function oneVote(bytes32 voteHash, string memory _id, uint _voteNumber) public {
        VoteRequire memory _voteRequire = VoteRequireMapping[voteHash];                                // 获取交易信息实体
        require(_voteRequire.bigEvent,"This event cannot be confirmed with one vote");                 // 判断是否为大事件
        require(! VoteStructBool[_id],"This round of voting has been completed");                       // 判断是否已经投过票
        if (_voteNumber == 3){                                                                          // 如果投弃权票
            require(_voteRequire.isVoteAbstainedBool == true ,"Cannot abstain from voting this time");  // 判断当前事件是否可以弃权
            abstainedNumber ++;                                                                         // 如果可以弃权让弃权数自加
        }else if(_voteNumber == 2){                                                                     // 获取当前投票内容
            disagreeNumber ++;                                                                          // 让拒绝票自加
        }else if(_voteNumber == 1){                                                                     // 获取当前投票内容
            agreeNumber ++;                                                                             // 让同意票自家
        }
        VoteStruct memory _voteStruct = VoteStruct(_id, voteHash, _voteNumber);                         // 获取投票实体 
        VoteStructMapping[_id] = _voteStruct;                                                           // 将用户指定投票实体
        VoteStructBool[_id] =  true;                                                                    // 将此用户标记为以投票
        voteNumbers[index] = _id;                                                                       // 将id存入数组
        index ++;                                                                                       // 让下标自加
        emit oneVoteEvent(msg.sender,voteHash,_id,_voteNumber);
    }

    // 投票是否成功
    function voteIsAgree(bytes32 voteHash) public returns(string memory){
        VoteRequire memory _voteRequire = VoteRequireMapping[voteHash];                                // 获取交易信息实体
        string memory voteResultReturn;
        if (_voteRequire.bigEvent) {
            require(voteNumbers.length == buildingmember,"The voting has not ended yet");                   // 判断是否全员投票
            uint256 VotingAgreeResults = agreeNumber / buildingmember ** 100;                               // 投票内容扩大同样倍数用于判断
            uint256 VotingdisagreeNumberResults = disagreeNumber / buildingmember ** 100;                   // 投票内容扩大同样倍数用于判断
            uint256 VotingabstainedResults = disagreeNumber / buildingmember ** 100;                        // 投票内容扩大同样倍数用于判断
            if (VotingAgreeResults > VotingdisagreeNumberResults ){                                         // 得出最终结果，判断同意是否大于不同意
                if (VotingAgreeResults > VotingabstainedResults){                                           // 如果同意大于不同意则在判断同意是否大于弃权
                    voteResultReturn = "agree";
                    return voteResultReturn;                                                                         // 如果都符合规则，则方法会同意内容
                }else{   
                    voteResultReturn = "lose efficacy";                                                                                
                    return voteResultReturn;                                                                 // 否则返回本次投票弃权
                }
            }else if(VotingdisagreeNumberResults > VotingabstainedResults){                                 // 如果同意小于不同意，则判断是否为弃权
                voteResultReturn = "disagree";
                return voteResultReturn;                                                                          // 如果不同意大于弃权，则返回不同意    
            }else {
                voteResultReturn = "lose efficacy";
                return voteResultReturn;                                                                     // 否则返回本次投票弃权
            }
        }else if(! _voteRequire.bigEvent){
            require(voteNumbers.length == buildingNumber,"The voting has not ended yet");                   // 判断是否全员投票
            uint256 VotingAgreeResults = agreeNumber / buildingNumber ** 100;                               // 投票内容扩大同样倍数用于判断
            uint256 VotingdisagreeNumberResults = disagreeNumber / buildingNumber ** 100;                   // 投票内容扩大同样倍数用于判断
            uint256 VotingabstainedResults = disagreeNumber / buildingNumber ** 100;                        // 投票内容扩大同样倍数用于判断
            if (VotingAgreeResults > VotingdisagreeNumberResults ){                                         // 得出最终结果，判断同意是否大于不同意
                if (VotingAgreeResults > VotingabstainedResults){                                           // 如果同意大于不同意则在判断同意是否大于弃权
                    voteResultReturn = "agree";
                    return voteResultReturn;                                                                         // 如果都符合规则，则方法会同意内容
                }else{   
                    voteResultReturn = "lose efficacy";                                                                                
                    return voteResultReturn;                                                                 // 否则返回本次投票弃权
                }
            }else if(VotingdisagreeNumberResults > VotingabstainedResults){                                 // 如果同意小于不同意，则判断是否为弃权
                voteResultReturn = "disagree";
                return voteResultReturn;                                                                          // 如果不同意大于弃权，则返回不同意    
            }else {
                voteResultReturn = "lose efficacy";
                return voteResultReturn;                                                                     // 否则返回本次投票弃权
            }
        }
        
        if (! voteIsEvent[voteHash]){
            voteIsEvent[voteHash] = true;
            emit voteIsAgreeEvent(voteHash,voteResultReturn);
        }
            
    }

    
    // 发起一个投票
    function voteSend(address _voteRequirer,bytes32 _transcationHash, string memory _notes, bool _isVoteAbstainedBool,uint _endTime,bool  _bigEvent) public returns(bytes32){
        bytes32 voteHash = keccak256(abi.encodePacked(_voteRequirer,block.timestamp,_endTime));                                                                // 使用abi.encopde来生成唯一的值
        VoteRequire memory _voteRequire = VoteRequire(_voteRequirer,_transcationHash,voteHash,_notes,_isVoteAbstainedBool,block.timestamp,_endTime,_bigEvent); // 生成投票实体
        VoteRequireMapping[voteHash] = _voteRequire;                                                                                                           // 生成投票mapping
        voteHashMapping[_notes] = voteHash;                                                                                                                   // 指定mapping 用于存储votehash
        emit voteSendEvent(_voteRequirer,_transcationHash,_isVoteAbstainedBool,block.timestamp,_endTime,_bigEvent);
        return voteHash;                                                                                                                                     // 返回votehash，用于之后的使用

    }

    // 获取voteHash
    function getVoteHash(string memory _vote) public view returns(bytes32) {
        bytes32 voteHash = voteHashMapping[_vote];                                                                                                        // 获取 votehash mapping
        return voteHash;                                                                                                                                 // 返回votehash
    } 


    // 获得投票内容
    function getVote(bytes32 voteHash) public view returns(address,string memory ,bool,uint,uint) {
        VoteRequire memory _voteRequire = VoteRequireMapping[voteHash];                                                                                   //获取投票内容实体
        return(_voteRequire.voteRequirer, _voteRequire.notes, _voteRequire.isVoteAbstainedBool,_voteRequire.time,_voteRequire.endTime);                  // 返回投票内容
    }



    // 新增交易记录
    function SetTransactionRegulation(address _voteRequirer ,bytes32 _TranscationHash,address _from,address _to,uint _banlance,uint _time,bool _isBuy,bool _isSell,string memory _notes) public {
        //_TranscationHash 后续完善keccak自动生成这个hash
        TranscationEffectiveMapping[_TranscationHash] = false;            // 交易默认不生效
        TranscationHistory memory _transcationHistory = TranscationHistory(_voteRequirer,_TranscationHash,_from, _to,_banlance,_time,_isBuy,_isSell,_notes,TranscationEffectiveMapping[_TranscationHash]);//新建结构体
        TranscationHistoryMapping[_TranscationHash] = _transcationHistory;// 加入mapping
        emit SetTransactionRegulationEvent(_voteRequirer,_TranscationHash,_from,_to,_banlance,_time,_isBuy,_isSell);
    }


    // 查看公共账户资金
    function getAccountsFounds() public view returns(uint256,address) {
        PublicAccountStruct memory _publicAccountStruct = PublicAccountMapping[PublicAccounts];//获取结构体
        return (_publicAccountStruct.banlance, _publicAccountStruct.banlanceAddress);          //返回参数
    }


    // 创建初始公共账户,只允许创建一次
    function createpublicAccount(string memory _id, uint256 _banlance,address _banlanceAddress) public {
        string memory id = _id;                                 //显示赋值
        uint256 banlance = _banlance;                           //显示赋值
        address banlanceAddress = _banlanceAddress;             //显示赋值
        if (! createPublicAccountBool){                         //判断是否创建过
            PublicAccountStruct memory _publicAccountStruct = PublicAccountStruct(id,banlance,banlanceAddress);//新建结构体
            createPublicAccountBool = true;                     //将bool赋值
            PublicAccountMapping[_id] = _publicAccountStruct;   //索引指定
        } else {
            require(! createPublicAccountBool,"Public account has been created");//否则就报错
        }
        emit createpublicAccountEvent(_id,_banlance,_banlanceAddress);
    }
}