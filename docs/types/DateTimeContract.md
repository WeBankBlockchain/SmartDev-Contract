# DateTimeContract.sol -v1.0
*DateTimeContract.sol 基于block.timestamp 时间戳计算当前的日期，提供年份、月份、日期、小时、分钟、秒的计算函数。*
*合约基于solidity0.6.10编写。*
## API列表

编号 | API | API描述
---|---|---
1 | *getYear (uint timestamp ) public view returns (uint _year)* |返回年份
2 | *function getMonth (uint timestamp ) public view returns (uint _month)* |返回月份
3 | *function getDay (uint timestamp ) public view returns (uint _day)* |返回日期（那一天）
4 | *function getHour (uint timestamp ) public view returns (uint _hour)* |返回小时
5 | *function getMinute (uint timestamp ) public view returns (uint _minute)* |返回分钟
6 | *function getSecond (uint timestamp ) public view returns (uint _second)* |返回秒
7 | *function getDateTime (uint timestamp ) public view returns (uint _year, uint _month,uint _days,uint _hours , uint _minute ,uint _second)* |分别返回年月日时分秒
8 | *function timestampToDate(uint timestamp) private view returns (uint _year, uint _month,uint _days,uint _hours , uint _minute ,uint _second)* |timestampToDate()是一个private函数，将参数timestamp通过计算，输出年月日时分秒

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
 
  ### 7.getDateTime
 分别返回年月日时分秒。
 ```
 function getDateTime (uint timestamp ) public view returns (uint _year, uint _month,uint _days,uint _hours , uint _minute ,uint _second)
 ````
 #### 参数
 - uint timestamp :block.timestamp时间戳
 #### 返回值
 - _year ： 年份
 - _month: 月份
 - _day: 日期
 - _hour: 小时
 - _minute: 分钟
 - _second: 秒

### 8.timestampToDate
  
timestampToDate()是一个private函数，将参数timestamp通过计算，输出年月日时分秒
  
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