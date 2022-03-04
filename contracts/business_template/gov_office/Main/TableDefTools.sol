pragma solidity ^0.4.25;
pragma experimental ABIEncoderV2;
import "../lib/Table.sol";
import "../lib/Strings.sol";
import "../utils/StringUtil.sol";
import "../utils/TypeConvertUtil.sol";
import "../lib/SafeMath.sol";
import "../utils/TimeUtil.sol";
import "./TableDefTools.sol";
/*
* 使用分布式存储下表结构、CURD工具以及预定义常数
*
*/
contract TableDefTools {

    /*******   引入库  *******/
    using Strings for *;
    using StringUtil for *;
    using TypeConvertUtil for *;
    using TimeUtil for *;
    using SafeMath for *;

    /******* 表结构体 *******/
    struct Bean {
        // 表名称
        string tableName;
        // 主键
        string primaryKey;
        // 表字段
        string[] fields;
    }

    /******* 使用到的表结构 *******/
    Bean t_user_struct;//1.用户表
    Bean t_propose_struct;//2.建言献策表
    Bean t_track_struct;//3.巡检表
    Bean t_application_struct;//4.申请文件材料
    Bean t_document_struct;//4.审核政府文件材料

    /******* 执行状态码常量 *******/
    int8 constant internal INITIAL_STATE = 0;
    int8 constant internal SUCCESS_RETURN = 1;
    int8 constant internal FAIL_RETURN = -1;
    int8 constant internal FAIL_NULL_RETURN = -2;
    int8 constant internal FAIL_ALREADY_EXIST = -3;
    int8 constant internal FAIL_INSERT = -4;
    int8 constant internal FAIL_LACK_BALANCE = -5;
    int8 constant internal FAIL_NO_REWARD = -6;

    /******* 事件状态码常量 *******/
    uint8 constant internal EVENT_GIVE_LIKES = 10;
    uint8 constant internal EVENT_OBTAIN_LIKES = 11;
    uint8 constant internal EVENT_ATTEND_LOCATION = 12;

    
    // 1.用户信息表
    // 表名称：t_user
    // 表主键：user_id 
    // 表字段：user_name,user_password,activate_time,user_type,registered_status,user_creditpoint;
    // 字段含义：
    // |------------------------------------------------|-------------------|--------------------------|--------------------|--------------------------|
    // |        用户ID（主键）                            |      用户名        |       登陆密码             |  注册时间           | 身份类别（个人/企业/行政机关）｜           
    // |------------------------------------------------|-------------------|--------------------------|--------------------|--------------------------｜
    // |  user_id 【可以采取递增】                         |     user_name     |       user_password      |    activate_time   |   user_type            | 
    // |------------------------------------------------|-------------------|--------------------------|--------------------|------------------------|
    // | 注册状态（0-未激活、1-已激活)                      |  信用积分（默认100）    | 
    // |------------------------------------------------|----------------------|
    // |        registered_status                       | user_creditpoint     | 
    // |------------------------------------------------|----------------------|
    //定义表名,表主键，以及表内包含的其他属性值
    string constant internal TABLE_USER_NAME = "t_user";
    string constant internal TABLE_USER_PRIMARYKEY = "user_id";
    string constant internal TABLE_USER_FIELDS = "user_name,user_password,activate_time,user_type,registered_status,user_creditpoint";
    // 2.建言献策表
    // 表名称：t_propose
    // 表主键：propose_id
    // 表字段：user_id,propose_content,propose_time;
    // 字段含义：
    //|------------------- |-------------------|-------------------|-------------------|
    //|    留言内容ID号（主键）|    用户ID（主键）  |      建议内容       |    留言时间        |   
    //|--------------------|-------------------|-------------------|-------------------|
    //|       propose_id   |       user_id     | propose_id_content|   propose_time   | 
    //|------------------- |-------------------|-------------------|-------------------|
    string constant internal TABLE_PROPOSE_NAME = "t_propose";
    string constant internal TABLE_PROPOSE_PRIMARYKEY = "propose_id";
    string constant internal TABLE_PROPOSE_FIELDS = "user_id,propose_content,propose_time";
    // 3.巡检表
    // 表名称：t_track
    // 表主键：user_id
    // 表字段：user_location ,arrival_time
    // 字段含义：
    // |-------------------|-------------------------------------|
    // |    用户ID          |  打卡地点           | 打卡时间        | 
    // |-------------------|--------------------|----------------|
    // |       user_id     |  user_location     | arrival_time   | 
    // |----------------------------------------｜----------------|
    string constant internal TABLE_TRACK_NAME = "t_track";
    string constant internal TABLE_TRACK_PRIMARYKEY = "user_id";
    string constant internal TABLE_TRACK_FIELDS = "user_location,arrival_time";
    // 4.政务申请审核表
    // 表名称：t_application
    // 表主键：user_id
    // 表字段：user_id,information_hash,application_time,check_hash,check_result,check_time
    // 字段含义：
    // ｜-------------------|-------------------|---------------------------------------------|-----------------｜-------------------------|------------------------------｜
    // ｜文件ID值（主键）     |    用户ID（主键）   | 申请审核的政策文件材料的哈希值          |  申请时间        ｜领导签名哈希值        ｜ 审核结果【通过or不通过】|公示时间｜       
    // ｜-------------------|-------------------|---------------------------------------------｜---------------- ｜------------------------｜---------------｜-------------｜
    // ｜application_id     |      user_id      | information_hash                            |  application_time ｜ check_hash           ｜check_result    ｜check_time   ｜
    // ｜-------------------|---------------------------------------------------------------------------------------------------------------------------------------------|
    string constant internal TABLE_APPLICATION_NAME = "t_application";
    string constant internal TABLE_APPLICATION_PRIMARYKEY = "application_id";
    string constant internal TABLE_APPLICATION_FIELDS = "user_id,information_hash,application_time,check_hash,check_result,check_time";
    // 5.政策文件表【政务申请审核通过的文件材料保存到这里来】
    // 表名称：t_document
    // 表主键：document_id
    // 表字段：user_id,documen_hash,upload_time,downloadnum
    // 字段含义：
    // |-------------------|---------------------------------------------------------------------------|
    // |    文件ID（主键） |  上传人用户ID（外键） | 文件哈希   |  上传时间      | 下载次数    
    // |-------------------|--------------------|----------------------------------|-------------------|
    // |       document_id |    user_id         | documen_hash    |upload_time     |downloadnums 
    // |-----------------------------------------------------------------------------------------------|
    string constant internal TABLE_DOCUMENT_NAME = "t_document";
    string constant internal TABLE_DOCUMENT_PRIMARYKEY = "document_id";
    string constant internal TABLE_DOCUMENT_FIELDS = "user_id,documen_hash,upload_time,downloadnum";

   /*
    * 字符串数组生成工具
    *
    * @param _fields  带解析的字符串
    *
    * @return 解析后的字符串数组
    *
    */
    function getFieldsArray(string _fields) internal pure returns(string[]){
        string[] memory arrays ;
        Strings.slice memory s = _fields.toSlice();
        Strings.slice memory delim = ",".toSlice();
        uint params_total = s.count(delim) + 1;
        arrays = new string[](params_total);
        for(uint i = 0; i < params_total; i++) {
            arrays[i] = s.split(delim).toString();
        }
        return arrays;
    }


   /*
    * 1.初始化一个表结构
    *
    * @param _tableStruct  表结构体
    * @param _tableName    表名称
    * @param _primaryKey   表主键
    * @param _fields       表字段组成的字符串（除主键）
    *
    * @return 无
    *
    */
    function initTableStruct(
        Bean storage _tableStruct,
        string memory _tableName,
        string memory _primaryKey,
        string memory  _fields)
        internal {
            TableFactory tf = TableFactory(0x1001);
            tf.createTable(_tableName, _primaryKey, _fields);
            _tableStruct.tableName = _tableName;
            _tableStruct.primaryKey = _primaryKey;
            _tableStruct.fields = new string[](0);
            Strings.slice memory s = _fields.toSlice();
            Strings.slice memory delim = ",".toSlice();
            uint params_total = s.count(delim) + 1;
            for(uint i = 0; i < params_total; i++) {
                _tableStruct.fields.push(s.split(delim).toString());
            }
    }


   /*
    * 2.打开一个表，便于后续操作该表
    *
    * @param _tableName    表名称
    *
    * @return 表
    *
    */
    function openTable(string memory _table_name) internal returns(Table) {
        TableFactory tf = TableFactory(0x1001);
        Table table = tf.openTable(_table_name);
        return table;
    }
    /*
    * 3.用户登陆并以Json格式输出用户信息
    *
    * @param _tableStruct    表结构
    * @param _primaryKey     待查记录的主键
    *
    * @return 执行状态码
    * @return 该记录的json字符串
    */
    function loginInToJson(Bean storage _tableStruct, string memory _primaryKey,string memory _userpasswordhash) internal view returns (int8, string memory) {
        // 打开表
        Table table = openTable(_tableStruct.tableName);
        Condition condition = table.newCondition();
        condition.EQ("user_id", _primaryKey);
        condition.EQ("user_password", _userpasswordhash);
        // 查询
        Entries entries = table.select(_primaryKey, condition);
        // 将查询结果解析为json字符串
        return StringUtil.getJsonString(_tableStruct.fields, _primaryKey, entries);
    }

   /*
    * 4.查询表中一条记录并以Json格式输出
    *
    * @param _tableStruct    表结构
    * @param _primaryKey     待查记录的主键
    *
    * @return 执行状态码
    * @return 该记录的json字符串
    */
    function selectOneRecordToJson(Bean storage _tableStruct, string memory _primaryKey) internal view returns (int8, string memory) {
        // 打开表
        Table table = openTable(_tableStruct.tableName);
        Condition condition = table.newCondition();
        // 查询
        Entries entries = table.select(_primaryKey, condition);
        // 将查询结果解析为json字符串
        return StringUtil.getJsonString(_tableStruct.fields, _primaryKey, entries);
    }


   /*
    * 5.查询表中一条记录并以字符串数组的格式输出
    *
    * @param _tableStruct    表结构
    * @param _primaryKey     待查记录的主键
    * @param _conditionPair  筛选条件（一个字段）
    *
    * @return 执行状态码
    * @return 该记录的字符串数组
    */
     function selectOneRecordToArray(Bean storage _tableStruct, string memory _primaryKey, string[2]  _conditionPair) internal  returns (int8, string[] memory) {
        // 打开表
        Table table = openTable(_tableStruct.tableName);
        // 查询
        Condition condition = table.newCondition();
        if(_conditionPair.length == 2){
             condition.EQ(_conditionPair[0], _conditionPair[1]);
        }
        Entries entries = table.select(_primaryKey, condition);
        // int8 statusCode = constDef.INITIAL_STATE;
        int8 statusCode = 0;
        string[] memory retContent;
        if (entries.size() > 0) {
            // statusCode = constDef.SUCCESS_RETURN;
            statusCode = 1;
            retContent = StringUtil.getEntry(_tableStruct.fields, entries.get(0));

        }else{
            statusCode = FAIL_NULL_RETURN;
            retContent = new string[](0);
        }
        return (statusCode ,retContent);
        // 将查询结果解析为json字符串

    }
    /*
    * 6.向指定表中插入一条记录
    *
    * @param _tableStruct    表结构
    * @param _primaryKey     待插记录的主键
    * @param _fields         各字段值
    * @param _isRepeatable   主键下记录是否可重复
    *
    * @return 执行状态码
    */
    function insertOneRecord(Bean storage _tableStruct, string memory _primaryKey, string memory _fields, bool _isRepeatable) internal returns (int8) {
        // require(bytes(_primaryKey).length > 0);
        // require(_fields.length == _tableStruct.fields.length);
        int8 setStatus = INITIAL_STATE;
        int8 getStatus = INITIAL_STATE;
        string memory getContent;
        string[] memory fieldsArray;
        Table table = openTable(_tableStruct.tableName);
        if(_isRepeatable){
            getStatus = FAIL_NULL_RETURN;
        }else{
            (getStatus, getContent) = selectOneRecordToJson(_tableStruct, _primaryKey);
        }
        if (getStatus == FAIL_NULL_RETURN) {
            fieldsArray = getFieldsArray(_fields);
            // 创建表记录
            Entry entry = table.newEntry();
            entry.set(_tableStruct.primaryKey, _primaryKey);
            for (uint i = 0; i < _tableStruct.fields.length; i++) {
                entry.set(_tableStruct.fields[i], fieldsArray[i]);
            }
            setStatus = FAIL_INSERT;
            //新增表记录
            if (table.insert(_primaryKey, entry) == 1) {
                setStatus = SUCCESS_RETURN;
            } else {
                setStatus = FAIL_RETURN;
            }
        } else {
            setStatus = FAIL_ALREADY_EXIST;
        }
        return  setStatus;
    }

   /*
    * 7.向指定表中更新一条记录
    *
    * @param _tableStruct    表结构
    * @param _primaryKey     待更新记录的主键
    * @param _fields         各字段值组成的字符串
    *
    * @return 执行状态码
    */
    function updateOneRecord(Bean storage _tableStruct, string memory _primaryKey, string memory _fields) internal returns(int8) {
        Table table = openTable(_tableStruct.tableName);
        string[] memory fieldsArray = getFieldsArray(_fields);
        Entry entry = table.newEntry();
        Condition condition = table.newCondition();
        entry.set(_tableStruct.primaryKey, _primaryKey);
        for (uint i = 0; i < _tableStruct.fields.length; i++) {
            entry.set(_tableStruct.fields[i], fieldsArray[i]);
        }
        int count = table.update(_primaryKey, entry, condition);
        if(count == 1){
            return SUCCESS_RETURN;
        }else{
            return FAIL_RETURN;
        }
    }
    /*
    * 8.修改各字段中某一个字段，字符串格式输出
    *
    * @param _fields  各字段值的字符串数组
    * @param index    待修改字段的位置
    * @param values   修改后的值
    *
    * @return         修改后的各字段值，并以字符串格式输出
    *
    */
    function getChangeFieldsString(string[] memory _fields, uint index, string values) public returns (string){
        string[] memory fieldsArray = _fields;
        fieldsArray[index] = values;
        return StringUtil.strConcatWithComma(fieldsArray);
    }
}
