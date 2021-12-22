pragma solidity ^0.4.25;
pragma experimental ABIEncoderV2;
import "../lib/SafeMath.sol";
import "../utils/TimeUtil.sol";
import "./TableDefTools.sol";

/*
*
* UserSuggest实现用户留言功能。针对用户留言内容会调用一次文本审核api接口，若存在违规词将会给用户扣分
* 首先查看用户是否注册，登陆。如果没有则不能留言
* 操作的表为t_suggest.
*
*/
contract Suggest is TableDefTools{
    /*******   引入库  *******/
     using TimeUtil for *;
     using SafeMath for *;
    event SUGGEST(string Proposeid,string  Userid,string _title,string SuggestContent,string time);//留言事件.留言人ID，留言标题，内容。时间
   /*
    * 构造函数，初始化使用到的表结构
    *
    * @param    无
    *
    * @return   无
    */
    constructor() public{
        //初始化需要用到的表。建言献策表
        initTableStruct(t_propose_struct, TABLE_PROPOSE_NAME, TABLE_PROPOSE_PRIMARYKEY, TABLE_PROPOSE_FIELDS);
    }
   /*
    * 1.用户留言
    *
    * @param _proposeid      留言ID号  
    * @param _userid    留言人ID
    * @param _title    留言内容标题
    * @param _content   留言内容    
    *
    * @return 执行状态码
    *
   * 测试举例  参数一："17846"  
    * 参数二："191867345212322","关于提供退役军人金融优惠措施的建议","尊敬的领导，本人通过网络知道了了去年事务部和十大银行签了优抚协议，其它省份落实的很好，希望江西省也能对接下江西银行，江西农商银行等"
    *注册成功返回SUCCESS,以及留言的句子。否则返回错误码，错误码对应的问题请参考TableDefTools写的
    */
   function suggestUser(string memory _proposeid,string memory _userid,string memory _title,string memory _content) public  returns(int8){
        //获取时间
        string memory nowDate = TimeUtil.getNowDate();
        string memory suggestfields=StringUtil.strConcat4("建议标题为:",_title,"建议内容为:",_content);
        string memory storeFields = StringUtil.strConcat5(_userid,',',suggestfields,',',nowDate);
        emit SUGGEST(StringUtil.strConcat2("留言的ID号为:",_proposeid),StringUtil.strConcat2("留言人的ID为:",_userid),
        StringUtil.strConcat2("留言标题为:",_title),StringUtil.strConcat2("留言内容为:",_content),StringUtil.strConcat2("留言时间为:",nowDate)); 
        return (insertOneRecord(t_propose_struct,_proposeid,storeFields,false));
    }
    /*
    * 2.根据留言ID号查询留言人ID号和留言内容并以Json字符串方式输出
    *
    * @param _proposeid  留言id
    *
    * @return 执行状态码 
    * @return 该用户所有留言信息的Json字符串
    *
    * 测试举例  参数一："17846"
    */
    function getSuggestRecordJson(string _proposeid) public view returns(int8, string){
        return selectOneRecordToJson(t_propose_struct, _proposeid);
    }
   /*
    * 3.据留言ID号查询留言人ID号和留言内容并以字符串数组方式输出
    *
    * @param _proposeid  留言id
    *
    * @return 执行状态码
    * @return 该留言人ID和留言内容信息的字符串数组
    *
    * 测试举例  参数一："17846"
    */
    function getSuggestRecordArray(string _proposeid) public view returns(int8, string[]){
        return selectOneRecordToArray(t_propose_struct,_proposeid, ["propose_id",_proposeid]);
    }
    /*
    * 4.根据留言ID号查看留言内容，最后通过这个内容去调用文本审核api
    *
    * @param _proposeid  留言id
    *
    * @return 留言内容
    *
    * 测试举例  参数一："17846"
    */
    function getSuggestContent(string _proposeid) public view returns(string){
         int8 retCode;
         string[] memory retArray;
         (retCode, retArray) = getSuggestRecordArray(_proposeid);
         return retArray[1];
    }
     /*
    * 5.根据留言ID号查看留言人ID号，
    *
    * @param _proposeid  留言id
    *
    * @return 留言人Id
    *
    * 测试举例  参数一："17846"
    */
    function getSuggestId(string _proposeid) public view returns(string){
         int8 retCode;
         string[] memory retArray;
         (retCode, retArray) = getSuggestRecordArray(_proposeid);
         return retArray[0];
    }

}


