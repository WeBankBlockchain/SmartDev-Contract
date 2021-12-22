pragma solidity ^0.4.25;
import "../utils/TimeUtil.sol";
import "../utils/StringUtil.sol";
import "./TableDefTools.sol";
pragma experimental ABIEncoderV2;
contract Track is TableDefTools{
    /*******   引入库  *******/
    using TimeUtil for *;
    using StringUtil for *;

/*
* Track实现用户打卡巡检合约
* 主要包括：1.用户打卡2.查看用户打卡记录返回字符串数组。3.查看用户打卡记录返回JSON数组
*
*/
    /*
    * 构造函数，初始化使用到的表结构
    *
    * @param    无
    *
    * @return   无
    */
    constructor() public{
        //初始化需要用到的表。数据资源表
        initTableStruct(t_track_struct, TABLE_TRACK_NAME, TABLE_TRACK_PRIMARYKEY, TABLE_TRACK_FIELDS);
    }
      //定义事件日志信息
   event TRACK_EVENT(string user_id,string user_location,string time);//用户打卡记录日志。谁在哪里什么时间打的卡
    /*
    * 1.用户打卡
    *
    * @param _userid  用户id
    * @param _location 地点名   
    * @param _time      打卡时间
    * @return 执行状态码
    *
    * 测试举例  参数一："191867345212322"  
    * 参数二："江西省人民政府","2020年1月19日15点58分29秒"
    *注册成功返回SUCCESS否则返回错误码，错误码对应的问题请参考DB
    */
    function ClockIn(string memory _userid,string memory _location,string memory _time) public returns(int8){
        string memory storeFields=StringUtil.strConcat3(_location,',',_time);
        emit TRACK_EVENT(StringUtil.strConcat2("用户ID:",_userid),StringUtil.strConcat2("打卡地点:",_location),StringUtil.strConcat2("到达时间:",_time));
        return insertOneRecord(t_track_struct,_userid,storeFields,true);
    }
    /*
    * 2.查询用户打卡记录并返回数组
    *
    * @param _userid  用户id
    *
    * @return 执行状态码
    * @return 该用户去过的地方的字符串数组
    *
    * 测试举例  参数一："191867345212322"
    */
    function getUserCityArray(string _userid) public view returns(int8, string[]){
        return selectOneRecordToArray(t_track_struct, _userid, ["user_id",_userid]);
    }
    /*
    * 3.查询用户打卡记录并以JSON方式输出
    *
    * @param _userid  用户id
    *
    * @return 执行状态码
    * @return 该用户去过的地方的JSON数组
    *
    * 测试举例  参数一："191867345212322"
    */
    function getUserCityJson(string _userid) public view returns(int8, string){
        return selectOneRecordToJson(t_track_struct,_userid);
    }


}