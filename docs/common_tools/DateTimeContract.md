# DateTimeContract.sol -v1.0

DateTimeContract.sol 基于block.timestamp 时间戳计算当前的日期，提供年份、月份、日期、小时、分钟、秒的计算函数，基于solidity 0.4.25 到0.6.10之间。

## 控制台测试
在控制台中执行，可获得以下的结果。

### 部署测试合约
```
[group:1]>  deploy DateTimeContract
transaction hash: 0x6b4fde3da4c52df181a3ce69c999a56df7d294ae0429839ad936542f333aedb0
contract address: 0x8c5295ce0f70772c538a07295069796887bee574
currentAccount: 0x22fec9d7e121960e7972402789868962238d8037
```

### 测试将时间戳进行解析
```
[group:1]> call DateTimeContract 0x8c5295ce0f70772c538a07295069796887bee574 timestampToDate 1629731615
---------------------------------------------------------------------------------------------
Return code: 0
description: transaction executed successfully
Return message: Success
---------------------------------------------------------------------------------------------
Return value size:6
Return types: (UINT, UINT, UINT, UINT, UINT, UINT)
Return values:(2021, 8, 23, 23, 13, 35)
---------------------------------------------------------------------------------------------
```

### 分别测试返回年月日
```
[group:1]>  call DateTimeContract 0x8c5295ce0f70772c538a07295069796887bee574 getYear 1629731615
---------------------------------------------------------------------------------------------
Return code: 0
description: transaction executed successfully
Return message: Success
---------------------------------------------------------------------------------------------
Return value size:1
Return types: (UINT)
Return values:(2021)
---------------------------------------------------------------------------------------------

[group:1]> call DateTimeContract 0x8c5295ce0f70772c538a07295069796887bee574 getMonth 1629731615
---------------------------------------------------------------------------------------------
Return code: 0
description: transaction executed successfully
Return message: Success
---------------------------------------------------------------------------------------------
Return value size:1
Return types: (UINT)
Return values:(8)
---------------------------------------------------------------------------------------------

[group:1]> call DateTimeContract 0x8c5295ce0f70772c538a07295069796887bee574 getDay 1629731615
---------------------------------------------------------------------------------------------
Return code: 0
description: transaction executed successfully
Return message: Success
---------------------------------------------------------------------------------------------
Return value size:1
Return types: (UINT)
Return values:(23)
---------------------------------------------------------------------------------------------

[group:1]>  call DateTimeContract 0x8c5295ce0f70772c538a07295069796887bee574 getMinute 1629731615
---------------------------------------------------------------------------------------------
Return code: 0
description: transaction executed successfully
Return message: Success
---------------------------------------------------------------------------------------------
Return value size:1
Return types: (UINT)
Return values:(13)
---------------------------------------------------------------------------------------------

[group:1]>  call DateTimeContract 0x8c5295ce0f70772c538a07295069796887bee574 getSecond 1629731615
---------------------------------------------------------------------------------------------
Return code: 0
description: transaction executed successfully
Return message: Success
---------------------------------------------------------------------------------------------
Return value size:1
Return types: (UINT)
Return values:(35)
---------------------------------------------------------------------------------------------
```



## API列表

编号 | API | API描述
---|---|---
1 | *getYear (uint timestamp ) public view returns (uint _year)* |返回年份
2 | *function getMonth (uint timestamp ) public view returns (uint _month)* |返回月份
3 | *function getDay (uint timestamp ) public view returns (uint _day)* |返回日期（那一天）
4 | *function getHour (uint timestamp ) public view returns (uint _hour)* |返回小时
5 | *function getMinute (uint timestamp ) public view returns (uint _minute)* |返回分钟
6 | *function getSecond (uint timestamp ) public view returns (uint _second)* |返回秒
7 | *function timestampToDate(uint timestamp) public view returns (uint _year, uint _month,uint _days,uint _hours , uint _minute ,uint _second)* |将参数timestamp通过计算，输出年月日时分秒

## API描述

### 1.getYear
返回年份。
 ```
 function getYear (uint timestamp ) public view returns (uint _year)
 ````
 #### 参数
 - uint timestamp :block.timestamp时间戳
 #### 返回值
 - _year ： timestamp对应的年份
 
 ### 2.getMonth
 返回月份
 ```
 function getMonth (uint timestamp ) public view returns (uint _month)
 ````
 #### 参数
 - uint timestamp :block.timestamp时间戳
 #### 返回值
 - _month ： timestamp对应的月份
 
  ### 3.getDay
  返回日期（那一天）。
 ```
 function getDay (uint timestamp ) public view returns (uint _day)
 ````
 #### 参数
 - uint timestamp :block.timestamp时间戳
 #### 返回值
 - _day ： timestamp对应的日期
 
  ### 4.getHour
 返回小时。
 ```
 function getHour (uint timestamp ) public view returns (uint _hour)
 ````
 #### 参数
 - uint timestamp :block.timestamp时间戳
 #### 返回值
 - _hour ： timestamp对应的小时
 
  ### 5.getMinute
 返回分钟。
 ```
 function getMinute (uint timestamp ) public view returns (uint _minute)
 ````
 #### 参数
 - uint timestamp :block.timestamp时间戳
 #### 返回值
 - _minute ： timestamp对应的分钟
 
  ### 6.getSecond
 返回秒。
 ```
 function getSecond (uint timestamp ) public view returns (uint _second)
 ````
 #### 参数
 - uint timestamp :block.timestamp时间戳
 #### 返回值
 - _second ： timestamp对应的秒数

### 7.timestampToDate
  
将参数timestamp通过计算，输出年月日时分秒
 ```
	function timestampToDate(uint timestamp) private view returns (uint _year, uint _month,uint _days,uint _hours , uint _minute ,uint _second)
 ````
 #### 参数
 - uint timestamp : block.timestamp时间戳
 #### 返回值
 - _year ： 年份
 - _month: 月份
 - _day: 日期
 - _hour: 小时
 - _minute: 分钟
 - _second: 秒