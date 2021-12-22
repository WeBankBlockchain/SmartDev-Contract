pragma solidity ^0.4.25;
pragma experimental ABIEncoderV2;
import "../utils/TimeUtil.sol";
import "./TableDefTools.sol";

/*
* GovDocument合约主要负责将GovCooperation审核通过的文件保存过来
*公示给所有人。可以下载验证，记录下来谁什么时候查看过并对下载次数进行更新
*/
contract GovDocument is TableDefTools{
    /*******   引入库  *******/
     using TimeUtil for *;
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
        //初始化需要用到的表。
        //公示政府文件表
        initTableStruct(t_document_struct, TABLE_DOCUMENT_NAME,TABLE_DOCUMENT_PRIMARYKEY,TABLE_DOCUMENT_FIELDS);
    }
    //

    event DownLoads_Document_EVENT(string downloadid,string applicationid,string date,string downloadsnum);//记录谁下载了什么文件，这个文件下载次数多少次
    event DateLog_Track_Event(string downloadid,string _datatype,string date);
    event Track_DatePublish(string leaderid,string usertype,string datetype,string date);
    event Public_Document(string applicationid,string fields);
    /*
    * 1.通过审核后，准备公示的文件传到这里来
    * @param _applicationid  材料id唯一主键
    * @param _fields:由上传用户的ID+文件哈希值+公示时间   拼接起来    
    * @默认最初下载次数为0次
    * @return 执行状态码
    *
    * 测试举例  参数一："1976945"  
    * 参数二："191867345212322,f44e39c1fc14dc05143eeba2065a921bbbc1bba5,2021年1月19日14点28分"
    *注册成功返回SUCCESS否则返回错误码，错误码对应的问题请参考DB
    */
    function PublicDocument(string memory _applicationid,string memory _fields) public returns(int8){
        string memory lastParams = ",0";
        string memory storeFields = StringUtil.strConcat2(_fields,lastParams);
        emit Public_Document(StringUtil.strConcat2("文件的ID为:",_applicationid),StringUtil.strConcat2("文件上传者id,哈希值以及上传时间依次为:",_fields));
        return insertOneRecord(t_document_struct,_applicationid,storeFields,false);//最后的false代表主键下记录不可重复
    }
    /*
    * 2.查看某个文件的材料内容  以数组格式返回
    * @param _applicationid  材料id唯一主键
   * 测试举例  参数一："19769451"  
    */
    function getDocumentArray(string memory _applicationid) public view returns(int8, string[]){
        return selectOneRecordToArray(t_document_struct, _applicationid, ["document_id",_applicationid]);
    }
    /*
    * 3.查看某个文件的材料内容  以JSON格式返回
    * @param _applicationid  材料id唯一主键
    */
    function getDocumentJson(string memory  _applicationid) public view returns(int8, string){
        return selectOneRecordToJson(t_document_struct,_applicationid);
    }
    /*
    * 4.查看某个文件的下载次数
    * @param _applicationid  材料id唯一主键
       * 测试举例  参数一："19769451"       
    */
    function getDownloadsNum(string memory _documentid)public view returns(uint){
        int8 retCode;
        uint DownloadsNum;
        string[] memory retArray;
        (retCode,retArray)=getDocumentArray(_documentid);
        if(retCode==int8(1)){
            DownloadsNum=TypeConvertUtil.stringToUint(retArray[3]);
            return DownloadsNum;
        }else{
            return uint(-2);
        }
        
    }
    /*
    * 5.用户下载后调用该api使得下载次数加一
    * @param _applicationid  材料id唯一主键
     * 测试举例  参数一："19769451"  
    */
    function UpdateDownloadsNum(string memory downloadsid,string memory _documentid)public returns(int8){
          // 获得当前的日期
        string memory nowDate = TimeUtil.getNowDate();
        
        uint NowDownloadsNum;
        int8 queryRetCode;
        string[] memory retArray;
        // 查看该用户记录信息
        (queryRetCode, retArray) = selectOneRecordToArray(t_document_struct, _documentid, ["document_id", _documentid]);
        NowDownloadsNum=getDownloadsNum(_documentid)+1;
         //对信用分操作完毕后。更新用户表
         string memory changedFieldsStr = getChangeFieldsString(retArray, 3, TypeConvertUtil.uintToString(NowDownloadsNum));//转换回字符串类型
    emit DownLoads_Document_EVENT(StringUtil.strConcat2("下载者的ID为:",_documentid),StringUtil.strConcat2("下载的文件为:",_documentid),StringUtil.strConcat2("下载时间为:",nowDate),StringUtil.strConcat2("下载次数为:",TypeConvertUtil.uintToString(NowDownloadsNum))); 
            return(updateOneRecord(t_document_struct,_documentid, changedFieldsStr));  
    }
    /*
    * 6.对政府开放的数据谁公开了，公开给谁看了
    * @param  _leaderid 公开的领导id
    * @param _usertype:允许查看的用户身份
    * @param _datatype:数据类型
    * @return 执行状态码
    *
    * 测试举例  参数一：""  
    * 参数二："1976945,个人,经济,人口"
    *注册成功返回SUCCESS否则返回错误码，错误码对应的问题请参考DB
    */
    function SetLogForDatePublic(string memory _leaderid,string memory _usertype,string _datatype)public returns(bool){
        //获得当前的日期
        string memory nowDate=TimeUtil.getNowDate();
        emit Track_DatePublish(StringUtil.strConcat2("公开者Id为:",_leaderid),StringUtil.strConcat2("公开数据类别为:",_datatype),StringUtil.strConcat2("公开对象为:",_usertype)
  ,StringUtil.strConcat2("公开时间为:",nowDate)); 
        return true;
    }
    /*
    * 7.对政府开放的数据公开后进行追踪。谁查看了什么信息
    * @param _downloadsid  下载者的ID
    * @param _datatype:查看了公开的XX数据
    * @默认最初下载次数为0次
    * @return 执行状态码
    *
    * 测试举例  参数一："1976945"  
    * 参数二："191867345212322,f44e39c1fc14dc05143eeba2065a921bbbc1bba5,2021年1月19日14点28分"
    *注册成功返回SUCCESS否则返回错误码，错误码对应的问题请参考DB
    */
    function SetLogForDateDownload(string memory _downloadsid,string memory _datatype)public returns(bool){
        //获得当前的日期
        string memory nowDate=TimeUtil.getNowDate();
  emit DateLog_Track_Event(StringUtil.strConcat2("查看者的ID为:",_downloadsid),StringUtil.strConcat2("查看的数据信息为:",_datatype),StringUtil.strConcat2("查看时间为:",nowDate)); 
        return true;
    }

    

}











