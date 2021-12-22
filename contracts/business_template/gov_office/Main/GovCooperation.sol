pragma solidity ^0.4.25;
pragma experimental ABIEncoderV2;
import "../utils/TimeUtil.sol";
import "./TableDefTools.sol";



/*
* GovCooperation模拟政府办公协作的流程
* 首先科员提交材料申请。等待上级审批是否通过，通过后公示给大众
*
*/

contract GovCooperation is TableDefTools{
    /*******   引入库  *******/
     using TimeUtil for *;
   /*
    * 构造函数，初始化使用到的表结构
    *
    * @param    无
    *
    * @return   无
    */
    constructor() public{
        //初始化需要用到的表。文件材料申请审核
        //公示政府文件表
        initTableStruct(t_application_struct, TABLE_APPLICATION_NAME, TABLE_APPLICATION_PRIMARYKEY, TABLE_APPLICATION_FIELDS);
    
    }
    //
    event APPLY_DOCUMENT_EVENT(string userid,string application_id,string date);
    
    event Track_LeaderSignature(string applicationid,string signHash,string date);//记录领导签字
    event Tack_Final_Result(string applicationid,string checkerid,string result,string date);//记录最后校验部结果
   /*
    * 1.科员提交材料。具体材料放链下，链上存放申请材料哈希值。加密算法采用的sha256目前最安全的一种算法，暂时不可能逆推
    *
    * @param _applicationid  材料id唯一主键
    * @param _fields 用户信息表各字段值拼接成的字符串包括如下：
    *                   材料提交用户ID
    *                   申请材料哈希值  
    *                   申请时间 【调用轮子自动生成】  
    *   【后三个字段, 代表 领导签字哈希值 , 审核结束时间，审核结果。最初默认值为“审批中，审批中，审批中”】后面修改        
    *
    * @return 执行状态码
    *
    * 测试举例  参数一："1976945"  
    * 参数二："1611408890,f44e39c1fc14dc05143eeba2065a921bbbc1bba5"
    *注册成功返回SUCCESS否则返回错误码，错误码对应的问题请参考DB
    */
    function applyForDocument(string memory _applicationid,string memory _userid,string memory _informationhash) public returns(int8){
         // 获得当前的日期
        string memory nowDate = TimeUtil.getNowDate();
        string memory firstTwoFields=StringUtil.strConcat5(_userid,',',_informationhash,',',nowDate);
        string memory lastFourParams = ",审核中,审核中,审核中";
        string memory storeFields = StringUtil.strConcat2(firstTwoFields,lastFourParams);
        emit APPLY_DOCUMENT_EVENT(StringUtil.strConcat2("申请人的ID号为:",_userid),StringUtil.strConcat2("材料的ID为:",_applicationid),StringUtil.strConcat2("申请时间为:",nowDate)); 
        return insertOneRecord(t_application_struct,_applicationid,storeFields,false);//最后的false代表主键下记录不可重复
    }
    /*
    * 2.查询申请材料当前状态 并以字符串数组方式输出
    *
    * @param _applicationid  材料id唯一主键
    *
    * @return 执行状态码
    * @return 该用户信息的字符串数组
    *
    * 测试举例  参数一："1976945"
    */
    function getUserApplyArray(string memory _applicationid) public view returns(int8, string[]){
        return selectOneRecordToArray(t_application_struct, _applicationid, ["application_id",_applicationid]);
    }
    /*
    * 3.查询申请材料当前状态 并以Json字符串方式输出
    *
    * @param _applicationid  材料id唯一主键
    *
    * @return 执行状态码
    * @return 该用户信息的字符串数组
    *
    * 测试举例  参数一："1976945"
    */
      function getApplyJson(string memory _applicationid) public view returns(int8, string){
        return selectOneRecordToJson(t_application_struct,_applicationid);
    }
    /*
    * 4.查询申请材料哈希值
    *
    * @param _applicationid  材料id唯一主键
    *
    * @return 哈希值
    *
    * 测试举例  参数一："1976945"
    */
    function getApplyHash(string memory _applicationid) public view returns(string){
         int8 retCode;
         string[] memory retArray;
         (retCode, retArray) = getUserApplyArray(_applicationid);
         return retArray[1];
    }
    /*
    * 4.领导签字图片信息,审核结果信息上链。具体材料放链下，链上存放申请材料哈希值。加密算法采用的sha256目前最安全的一种算法，暂时不可能逆推
    * 具体操作为修改申请表的check_hash字段
    * @param _applicationid  材料id唯一主键
    * @param checkhash 领导签字图片哈希值     
    *
    * @return 执行状态码
    *
    * 测试举例  参数一："1976945"  
    * 参数二："f88r46f6ki14dc05143eeba2065a921bbbc1bbqi5"
    *注册成功返回SUCCESS否则返回错误码，错误码对应的问题请参考DB
    */
    function checkApplyResearch(string memory _applicationid,string memory checkhash) public returns(int8){
        // 获得当前的日期
        string memory nowDate = TimeUtil.getNowDate();
          //查询用户申请信息返回状态
        int8 queryRetCode; 
        //更新用户申请保送表后返回状态
        int8 updateRetCode;
        // 数据表返回信息
        string[] memory retArray;
         // 查看该用户申请审核信息
        (queryRetCode, retArray) = selectOneRecordToArray(t_application_struct, _applicationid, ["application_id", _applicationid]);
          // 若存在该用户记录
        if(queryRetCode == SUCCESS_RETURN){
             string memory changedFieldsStr = getChangeFieldsString(retArray,3,checkhash);
             updateRetCode = (updateOneRecord(t_application_struct,_applicationid,changedFieldsStr));
            if(updateRetCode == SUCCESS_RETURN){
                //记录日志
              emit Track_LeaderSignature(StringUtil.strConcat2("材料Id为:",_applicationid),
              StringUtil.strConcat2("领导签字图片的哈希为:",checkhash),StringUtil.strConcat2("申请时间为:",nowDate)); 
               return SUCCESS_RETURN;
            }
            else{
                return FAIL_RETURN;
            }
        }else{
            return FAIL_RETURN;
        }
    }
    /*
    * 5.查询领导签字哈希值
    *
    * @param _applicationid  材料id唯一主键
    *
    * @return 领导签字哈希值
    *
    * 测试举例  参数一："1976945"  
    */
    function getLeaderSignHash(string memory _applicationid) public view returns(string){
         int8 retCode;
         string[] memory retArray;
         (retCode, retArray) = getUserApplyArray(_applicationid);
         return retArray[3];
    }
    /*
    * 6.校验部验证完以后,把是否公开结果上链。
    * @param _checkerid 校验人员id
    * @param _applicationid  材料id唯一主键
    * @param checkresult 该文件是否通过审批，公示给大众。通过/不通过：      
    *
    * @return 执行状态码
    *
    * 测试举例  参数一："186789,1976945,"通过""  

    *注册成功返回SUCCESS否则返回错误码，错误码对应的问题请参考DB
    */
    function GiveResultToUser(string _checkerid,string memory _applicationid,string memory checkresult) public returns(int8){
        //查询文件信息返回状态
        int8 queryRetCode; 
        //更新文件后返回状态
        int8 updateRetCode;
        // 数据表返回信息
        string[] memory retArray;
        // 获得当前的日期
        string memory nowDate = TimeUtil.getNowDate();
        // 查看该科员申请审核信息
        (queryRetCode, retArray) = selectOneRecordToArray(t_application_struct, _applicationid, ["application_id", _applicationid]);
         // 若存在该用户记录
        if(queryRetCode == SUCCESS_RETURN){
            //修改科员申请表中的审核时间
             string memory changedFieldsStr = getChangeFieldsString(retArray, 5, nowDate);
            //修改
            updateRetCode = (updateOneRecord(t_application_struct, _applicationid,changedFieldsStr));
            if(updateRetCode == SUCCESS_RETURN){
            string memory changedFieldsStr2 = getChangeFieldsString(retArray, 4, checkresult);
            emit Tack_Final_Result(StringUtil.strConcat2("审核人Id为:",_checkerid),StringUtil.strConcat2("审核材料id为:",_applicationid),
            StringUtil.strConcat2("审核结果为:",checkresult),StringUtil.strConcat2("审核完成时间为:",nowDate)); 
            return (updateOneRecord(t_application_struct,_applicationid,changedFieldsStr2)); 
            }
        }
        else{
            // 若不存在该科员提交记录
            return FAIL_RETURN;
        }
    }



 
    

}











