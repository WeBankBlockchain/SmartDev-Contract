pragma solidity ^0.4.25;

import "../lib/DateTimeLibrary.sol";
import "./StringUtil.sol";
import "./TypeConvertUtil.sol";

/*
* 获取当前时间的工具合约
*
*/
library TimeUtil {

    using DateTimeLibrary for uint;
    using StringUtil for *;
    using TypeConvertUtil for *;

   /*
    * 得到当下的日期及时间，分别以字符串方式输出
    *
    * @param无,直接调用
    *
    * @return dateString 当前日期字符串
    * @return timeString 当前时间字符串
    *
    */
    function getNowDateTime() internal view returns(string dateString, string timeString){
        (uint year,uint month,uint day,uint hour,uint minute,uint second) = DateTimeLibrary.timestampToDateTime(now/1000);
        string memory nowDate = StringUtil.strConcat5(
                                                    TypeConvertUtil.uintToString(year),
                                                    "-" ,
                                                    TypeConvertUtil.uintToString(month),
                                                    "-" ,
                                                    TypeConvertUtil.uintToString(day));
        string memory nowTime = StringUtil.strConcat5(
                                                    TypeConvertUtil.uintToString(hour),
                                                    ":" ,
                                                    TypeConvertUtil.uintToString(minute),
                                                    ":" ,
                                                    TypeConvertUtil.uintToString(second));
        return (nowDate, nowTime);
    }
  /*
    * 得到当下的日期及时间，以字符串方式直接输出
    *
    * @param无,直接调用
    *
    * @return dateString 当前日期字符串
    * @return timeString 当前时间字符串
    *
    */
    function getNowTime() internal view returns(string nowtimeString){
        (uint year,uint month,uint day,uint hour,uint minute,uint second) = DateTimeLibrary.timestampToDateTime(now/1000);
        string memory nowDate = StringUtil.strConcat5(
                                                    TypeConvertUtil.uintToString(year),
                                                    "-" ,
                                                    TypeConvertUtil.uintToString(month),
                                                    "-" ,
                                                    TypeConvertUtil.uintToString(day));
        string memory nowTime = StringUtil.strConcat5(
                                                    TypeConvertUtil.uintToString(hour),
                                                    ":" ,
                                                    TypeConvertUtil.uintToString(minute),
                                                    ":" ,
                                                    TypeConvertUtil.uintToString(second));
        string memory NowDefiniteTime=StringUtil.strConcat3(nowDate,'日',nowTime);
        return (NowDefiniteTime);
    }

   /*
    * 得到当下的日期，以字符串方式输出
    *
    * @param无,直接调用
    *
    * @return dateString 当前日期字符串
    * @return timeString 当前时间字符串
    *
    */
    function getNowDate() internal view returns(string dateString){
        (uint year,uint month,uint day) = DateTimeLibrary.timestampToDate(now/1000);
        string memory nowDate = StringUtil.strConcat5(
                                                    TypeConvertUtil.uintToString(year),
                                                    "-" ,
                                                    TypeConvertUtil.uintToString(month),
                                                    "-" ,
                                                    TypeConvertUtil.uintToString(day));
        return nowDate;
    }

}





