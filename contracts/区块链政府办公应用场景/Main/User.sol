pragma solidity ^0.4.25;
pragma experimental ABIEncoderV2;
import "../lib/SafeMath.sol";
import "../utils/TimeUtil.sol";
import "../utils/StringUtil.sol";
import "../utils/TypeConvertUtil.sol";
import "./TableDefTools.sol";



/*
* User实现用户的链上信息管理，本合约主要是针对用户表进行的一系列操作。后面的留言表以及资源表会用到积分管理，因此需要引用本合约
* 以Table的形式进行存储。主要包含功能有:1.用户注册2.查看用户是否注册3.查看用户信用积分4.用户登陆5.对用户信用积分进行管理
* 首先看用户是否已经在链上注册信息，若未注册，则可以进行注册。
* 用户注册实际上是在合约用户信息表中插入一条记录，描述该用户的详细情况。
* 用户处于已注册状态才会有记录信息，因此，注册后方可使用其他板块功能。
*
*/
contract NewUser is TableDefTools{
    /*******   引入库  *******/
     using TimeUtil for *;
     using SafeMath for *;
     using TypeConvertUtil for *;
     using StringUtil for *;
   /*
    * 构造函数，初始化使用到的表结构
    *
    * @param    无
    *
    * @return   无
    */
    constructor() public{
        //初始化需要用到的表。用户信息表
        initTableStruct(t_user_struct, TABLE_USER_NAME, TABLE_USER_PRIMARYKEY, TABLE_USER_FIELDS);
    }
    // 事件
    event REGISTER_USER_EVENT(string userid,string usertype,string activatetime); //注册用户事件.记录注册人身份，类型，注册时间
    event DEL_CREDITPOINT_EVENT(string user_id,string grade,string time); //扣分时间，扣分人id、扣分数、扣分时间
    event ADD_CREDITPOINT_EVENT(string user_id,string grade,string time);
   /*
    * 1.用户注册
    *
    * @param _userid  用户id
    * @param _fields 用户信息表各字段值拼接成的字符串（除最后三个字段；用逗号分隔。最后三个字段分别是注册时间【根据注册时间生成】,注册状态
    注册后这个值默认为1，信用积分默认为100分），包括如下：
    *                   用户ID(主键)
    *                   用户名   
    *                   登陆密码
    *                   注册时间
    *                   注册状态[1代表已注册，0代表为注册]
    *                   信用积分                 
    *
    * @return 执行状态码
    *
    * 测试举例  参数一："191867345212322"  
    * 参数二："江会文","123456","个人"
    *注册成功返回SUCCESS否则返回错误码，错误码对应的问题请参考DB
    */
    function activateUser(string memory _userid,string memory _username,string memory _userpassword, string memory _usertype) public  returns(int8){
                 // 获得当前的时间
        string memory _passwordhash=TypeConvertUtil.bytes32ToString(sha256(abi.encode(_userid,_userpassword)));
        string memory nowDate = TimeUtil.getNowDate();
        string memory firstFiveParams=StringUtil.strConcat7(_username,',',_passwordhash,',',nowDate,',',_usertype);
        string memory lastTwoParams = "1,100";
        string memory storeFields = StringUtil.strConcat3(firstFiveParams,',',lastTwoParams);
        emit REGISTER_USER_EVENT(StringUtil.strConcat2("注册人的ID为:",_userid),StringUtil.strConcat2("注册人身份为:",_usertype),StringUtil.strConcat2("注册时间为:",nowDate)); 
        return insertOneRecord(t_user_struct,_userid,storeFields,false);//最后的false代表主键下记录不可重复
    }

   /*
    * 2.查询用户是否已经注册
    *
    * @param _userid  用户id
    *
    * @return 注册状态，1为已注册，0为未注册
    *
    * 测试举例  参数一："191867345212322"

    */
    function isUserActivated(string memory _userid) public view returns (string) {
         int8 retCode;
         string[] memory retArray;
         (retCode, retArray) = getUserRecordArray(_userid);
         return retArray[4];
    }
    /*
    * 3.查询用户的身份类别
    *
    * @param _userid  用户id
    *
    * @return 用户身份类别
    *
    * 测试举例  参数一："191867345212322"
    */
    function getUserType(string _userid) public view returns (string) {
         int8 retCode;
         string[] memory retArray;
         (retCode, retArray) = getUserRecordArray(_userid);
         return retArray[3];
    }      

   /*
    * 4.查询用户信用积分。返回uint类型
    *
    * @param _userid  用户id
    *
    * @return 用户信用积分值
    *
    * 测试举例  参数一："191867345212322"
    */
    function getUserCreditNum(string _userid) public view returns (uint) {
         int8 retCode;
         uint UserCreditNum;
         string[] memory retArray;
         (retCode, retArray) = getUserRecordArray(_userid);
         if(retCode == SUCCESS_RETURN){
            UserCreditNum=TypeConvertUtil.stringToUint(retArray[5]);
                return UserCreditNum;
         }else{
             return uint(-1);
         }
    }
    /*
    * 5.用户登陆
    *
    * @param userid  用户id
    * @param  userpassword  用户密码
    * @return 用户所有信息并以JSON格式返回
    *
    * 测试举例  参数一："191867345212322,123456"
    */
    function Login(string memory _userid,string memory _userpassword) public view returns (int8,string) {
         string memory _passwordhash=TypeConvertUtil.bytes32ToString(sha256(abi.encode(_userid,_userpassword)));
         return loginInToJson(t_user_struct,_userid,_passwordhash);
    }
    /*
    * 6.查询用户信息并以字符串数组方式输出
    *
    * @param _userid  用户id
    *
    * @return 执行状态码
    * @return 该用户信息的字符串数组
    *
    * 测试举例  参数一："191867345212322"
    */
    function getUserRecordArray(string userid) public view returns(int8, string[]){
        return selectOneRecordToArray(t_user_struct, userid, ["user_id",userid]);
    }
    /*
    *  7.向用户表进行积分管理操作 
    *
    * @param _primaryKey    用户ID,唯一主键
    * @param _integral      需要进行增加/扣除的分值
    * @param _opcode         操作符：为1加分，为0扣分.根据用户发言好坏决定它是否会被扣分
    * @return 执行状态码
    *测试举例  参数一："191867345212322",5,1
    */
    function updateUserIntegral(string memory _userid, uint _integral,int8 _opcode) public returns(int8) {
        // 该用户当前信用积分值
        uint userHasIntegral;
        // 该用户更新后的信用积分值
        uint userNowIntegral;
        // 查询用户信息返回状态
        int8 queryRetCode;
        // 更新用户信息返回状态
        int8 updateRetCode;
        // 数据表返回信息
        string[] memory retArray;
        // 获得当前的时间
        string memory updateTime= TimeUtil.getNowDate();
        // 查看该用户记录信息
        (queryRetCode, retArray) = selectOneRecordToArray(t_user_struct, _userid, ["user_id", _userid]);
         //该用户存在
        //将用户信用积分转换为整数进行操作
            userHasIntegral =getUserCreditNum(_userid);
         // 更新用户信用积分，对积分进行对应加分/减分操作。
            if(_opcode==0){ //为0 扣分
                userNowIntegral=SafeMath.sub(userHasIntegral,_integral);//调用Safemath的减法操作，避免溢出问题
                //记录日志
                 emit DEL_CREDITPOINT_EVENT(StringUtil.strConcat2("扣分人的ID为:",_userid),StringUtil.strConcat2("当前信用积分值:",TypeConvertUtil.uintToString(userNowIntegral)),StringUtil.strConcat2("信用积分更新时间为:",updateTime));
            }else{ //加分
                userNowIntegral=SafeMath.add(userHasIntegral,_integral);
            
                emit ADD_CREDITPOINT_EVENT(StringUtil.strConcat2("加分人的ID为:",_userid),StringUtil.strConcat2("当前信用积分值:",TypeConvertUtil.uintToString(userNowIntegral)),StringUtil.strConcat2("信用积分更新时间为:",updateTime));
            }
            //对信用分操作完毕后。更新用户表
             string memory changedFieldsStr = getChangeFieldsString(retArray,5, TypeConvertUtil.uintToString(userNowIntegral));//转换回字符串类型
            return(updateOneRecord(t_user_struct, _userid, changedFieldsStr));    
    }   
}



