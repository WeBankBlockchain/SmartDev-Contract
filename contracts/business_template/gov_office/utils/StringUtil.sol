pragma solidity ^0.4.25;
pragma experimental ABIEncoderV2;

import "../lib/Table.sol";

/*
* 处理字符串的工具合约
*
*/
library StringUtil {

   /*
    * 比较两个字符串是否相符
    *
    * @param string1  各字段名
    * @param string2  记录的实例
    *
    * @return        各字段值
    */

    function compareTwoString(string string1, string string2) pure internal returns (bool) {
        if (bytes(string1).length != bytes(string2).length) {
            return false;
        } else {
            return keccak256(string1) == keccak256(string2);
        }
    }
   /*
    * 得到表中指定一条记录的值
    *
    * @param fields  各字段名
    * @param fields  记录的实例
    *
    * @return        各字段值
    */
    function getEntry(string[] memory fields, Entry entry) internal view returns (string[] memory) {
        string[] memory values = new string[](fields.length);
        for (uint i = 0; i < fields.length; i++) {
            values[i] = entry.getString(fields[i]);
        }
        return values;
    }


   /*
    * 得到表中指定一条记录的值，以Json字符串格式输出
    *
    * @param fields      各字段名
    * @param primaryKey  主键值
    * @param entries     多条记录的实例
    *
    * @return            执行状态码
    * @return            记录值
    */
    function getJsonString(string[] memory fields,string primaryKey, Entries entries) internal view returns (int8, string memory) {
        string memory detail;
        if (0 == entries.size()) {
            return (int8(-2), detail);
        }
        else {
            detail = "[";
            for (uint i = 0; i < uint(entries.size()); i++) {
                string[] memory values = getEntry(fields, entries.get(int(i)));
                for (uint j = 0; j < values.length; j++) {
                    if (j == 0) {
                        detail = strConcat4(detail, "{\"primaryKey\":\"", primaryKey, "\",\"fields\":{");//这里订正了！！fields左边缺个双引号
                    }
                    detail = strConcat6(detail, "\"", fields[j], "\":\"", values[j], "\"");

                    if (j == values.length - 1) {
                        detail = strConcat2(detail, "}}");
                    } else {
                        detail = strConcat2(detail, ",");
                    }
                }
                if (i != uint(entries.size()) - 1) {
                    detail = strConcat2(detail, ",");
                }
            }
            detail = strConcat2(detail, "]");
            return (int8(1), detail);
        }
    }
    /*
    * 字符串拼接工具（后面strConcatX都为字符串拼接工具方法，X为字符串数量）
    *
    * @param str1   待拼接字符串1
    * @param str2   待拼接字符串2
    * @param str3   待拼接字符串3
    * @param str4   待拼接字符串4
    * @param str5   待拼接字符串5
    * @param str6   待拼接字符串6
    *
    * @return       拼接完成后的字符串
    */
    function strConcat8(
        string memory str1,
        string memory str2,
        string memory str3,
        string memory str4,
        string memory str5,
        string memory str6,
        string memory str7,
        string memory str8
    ) internal pure returns (string memory) {
        string[] memory strings = new string[](7);
        strings[0] = str1;
        strings[1] = str2;
        strings[2] = str3;
        strings[3] = str4;
        strings[4] = str5;
        strings[5] = str6;
        strings[6] = str7;
        strings[7] = str8;
        return strConcat(strings);
    }
   /*
    * 字符串拼接工具（后面strConcatX都为字符串拼接工具方法，X为字符串数量）
    *
    * @param str1   待拼接字符串1
    * @param str2   待拼接字符串2
    * @param str3   待拼接字符串3
    * @param str4   待拼接字符串4
    * @param str5   待拼接字符串5
    * @param str6   待拼接字符串6
    *
    * @return       拼接完成后的字符串
    */
    function strConcat7(
        string memory str1,
        string memory str2,
        string memory str3,
        string memory str4,
        string memory str5,
        string memory str6,
        string memory str7
    ) internal pure returns (string memory) {
        string[] memory strings = new string[](7);
        strings[0] = str1;
        strings[1] = str2;
        strings[2] = str3;
        strings[3] = str4;
        strings[4] = str5;
        strings[5] = str6;
        strings[6] = str7;
        return strConcat(strings);
    }

   /*
    * 字符串拼接工具（后面strConcatX都为字符串拼接工具方法，X为字符串数量）
    *
    * @param str1   待拼接字符串1
    * @param str2   待拼接字符串2
    * @param str3   待拼接字符串3
    * @param str4   待拼接字符串4
    * @param str5   待拼接字符串5
    * @param str6   待拼接字符串6
    *
    * @return       拼接完成后的字符串
    */
    function strConcat6(
        string memory str1,
        string memory str2,
        string memory str3,
        string memory str4,
        string memory str5,
        string memory str6
    ) internal pure returns (string memory) {
        string[] memory strings = new string[](6);
        strings[0] = str1;
        strings[1] = str2;
        strings[2] = str3;
        strings[3] = str4;
        strings[4] = str5;
        strings[5] = str6;
        return strConcat(strings);
    }

    function strConcat5(
        string memory str1,
        string memory str2,
        string memory str3,
        string memory str4,
        string memory str5
    ) internal pure returns (string memory) {
        string[] memory strings = new string[](5);
        strings[0] = str1;
        strings[1] = str2;
        strings[2] = str3;
        strings[3] = str4;
        strings[4] = str5;
        return strConcat(strings);
    }

    function strConcat4(
        string memory str1,
        string memory str2,
        string memory str3,
        string memory str4
    ) internal pure returns (string memory) {
        string[] memory strings = new string[](4);
        strings[0] = str1;
        strings[1] = str2;
        strings[2] = str3;
        strings[3] = str4;
        return strConcat(strings);
    }

    function strConcat3(
        string memory str1,
        string memory str2,
        string memory str3
    ) internal pure returns (string memory) {
        string[] memory strings = new string[](3);
        strings[0] = str1;
        strings[1] = str2;
        strings[2] = str3;
        return strConcat(strings);
    }

    function strConcat2(string memory str1, string memory str2) internal pure returns (string memory) {
        string[] memory strings = new string[](2);
        strings[0] = str1;
        strings[1] = str2;
        return strConcat(strings);
    }

    function strConcat(string[] memory strings) internal pure returns (string memory) {
        // 计算字节长度
        uint bLength = 0;
        for (uint i = 0; i < strings.length; i++) {
            bLength += bytes(strings[i]).length;
        }

        // 实例化字符串
        string memory result = new string(bLength);
        bytes memory bResult = bytes(result);

        // 填充字符串
        uint currLength = 0;
        for ( i = 0; i < strings.length; i++) {
            // 将当前字符串转换为字节数组
            bytes memory bs = bytes(strings[i]);
            for (uint j = 0; j < bs.length; j++) {
                bResult[currLength] = bs[j];
                currLength++;
            }
        }
        return string(bResult);
    }


   /*
    * 字符串数组拼接为字符串的工具，各字符串之间以逗号进行连接。
    *
    * @param strings     字符串数组
    *
    * @return            拼接后的字符串
    */
    function strConcatWithComma(string[] memory strings) internal pure returns (string memory) {

        uint bLength = 0;
        string memory commaString = ",";
        bytes memory oneCommaBytes = bytes(commaString);

        for (uint i = 0; i < strings.length; i++) {
            if(i > 0){
                bLength += oneCommaBytes.length;
            }
            bLength += bytes(strings[i]).length;
        }
        string memory result = new string(bLength);
        bytes memory bResult = bytes(result);
        uint currLength = 0;
        for ( i = 0; i < strings.length; i++) {
            bytes memory bs = bytes(strings[i]);
            if(i > 0){
                for(uint k=0;k < oneCommaBytes.length; k++){
                    bResult[currLength] = oneCommaBytes[k];
                    currLength++;
                }
            }
            for (uint j = 0; j < bs.length; j++) {
                bResult[currLength] = bs[j];
                currLength++;
            }
        }

        return string(bResult);
    }

}