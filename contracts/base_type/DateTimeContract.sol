pragma solidity ^ 0.6.10;
///--------------------------------------------------------------------------------------------

/// DateTimeContract v1.0
///
/// 算法参考自https://mp.weixin.qq.com/s/bcUCYW6bt0fuLKYp4EqgNw
/// @title 时间操作合约 
/// @author jianglong,wei
/// @dev 基于block.timestamp 时间戳计算当前的日期。提供年份、月份、日期、小时、分钟、秒的计算函数
///---------------------------------------------------------------------------------------------
contract DateTimeContract {
    
    uint [] flat_year_month_day = [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]; 
    
    uint [] leap_year_month_day = [0, 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]; 
    // 3平1润,4年的秒数 
    uint constant  SECONDS_PER_FOUR_YEAR = 126230400;
    
    uint constant  SECONDS_PER_DAY = 24 * 60 * 60;
    
    uint constant  SECONDS_PER_HOUR = 60 * 60;
    
    uint constant  SECONDS_PER_MINUTE = 60;
    // 
    uint constant SECONDS_PER_YEAR_FLAT = 31536000;
    
    uint constant SECONDS_PER_YEAR_LEAP = 31622400;
    // UNIX时间戳的起始年份 
    uint  constant UNIX_TIME_YEAR = 1970;
    // 润年 
    uint constant LEAP_YEAR = 0; 
    // 平年 
    uint constant FLAT_YEAR = 1;
    // UTC东八区  偏移量 
    uint constant HOUR_OFFSET = 8;
    
    ///获取当前年份 
    function getYear (uint timestamp ) public view returns (uint _year){
        
        (_year,,,,,) = timestampToDate(timestamp);
        
    }
    
    ///获取当前月份 
    function getMonth (uint timestamp ) public view returns (uint _month ){
        
        (,_month,,,,) = timestampToDate(timestamp);
        
    }
    
    ///获取当前日期  
    function getDay (uint timestamp ) public view returns (uint _day){
        
        (,,_day,,,) = timestampToDate(timestamp);
        
    }
    
    ///获取当前xiao'shi小时  
    function getHour (uint timestamp ) public view returns (uint _hour){
        
        (,,,_hour,,) = timestampToDate(timestamp);
        
    }
    
    ///获取当前fen'zhong分钟 
    function getMinute (uint timestamp ) public view returns (uint _minute){
        
        (,,,,_minute,) = timestampToDate(timestamp);
        
    }
    
    ///获取当前miao秒  
    function getSecond (uint timestamp ) public view returns (uint _second){
        
        (,,,,,_second) = timestampToDate(timestamp);
        
    }
    
    ///获取当前时间 YYYY年MM月dd日 hh:mm:ss
    function getDateTime (uint timestamp ) public view returns (uint _datetime){
        
        (uint _year, uint _month,uint _day,uint _hour,uint _minute,uint _second) = timestampToDate(timestamp);
        
        _datetime = 0;
        
    }
    
    ///根据timestamp计算年月日时分秒，并分别返回
    function timestampToDate(uint timestamp) private view returns (uint _year, uint _month,uint _days,uint _hours , uint _minute ,uint _second){
       
        // test
        timestamp = now; 
        _second = timestamp % SECONDS_PER_MINUTE;
        _minute = (timestamp % SECONDS_PER_HOUR) / SECONDS_PER_MINUTE ;
        while (timestamp >= SECONDS_PER_FOUR_YEAR ){
            
            _year ++;
            
            timestamp -= SECONDS_PER_FOUR_YEAR;
        }
        
        _year = UNIX_TIME_YEAR + (4 * _year);
        
        if(timestamp >= SECONDS_PER_YEAR_FLAT) { 
            
            	_year ++; 
            	
            	timestamp -= SECONDS_PER_YEAR_FLAT; 
            	
            	if(timestamp >= SECONDS_PER_YEAR_FLAT) {
            	    
            		_year ++; 
            		
            		timestamp -= SECONDS_PER_YEAR_FLAT;
            		
            		if(timestamp >= SECONDS_PER_YEAR_LEAP) {
            		    
            			_year ++; 
            			
            			timestamp -= SECONDS_PER_YEAR_LEAP; 
            			
            			if(timestamp >= SECONDS_PER_YEAR_FLAT) { 
            			    
            				_year ++; 
            				
            				timestamp -= SECONDS_PER_YEAR_FLAT; 
            				
            			}  
            		} 
            	} 
    	}
    	
    	//计算或平年和或闰年  能被4整除、不能被100 整除，或者能被400整除
    	uint isLeapOrFlatYear;
    	
    	if(((_year%4 ==0) && (_year % 100 != 0)) || (_year % 400 == 0)){
    	    
    	    isLeapOrFlatYear = LEAP_YEAR;
    	    
    	}else{
    	    
    	    isLeapOrFlatYear = FLAT_YEAR;
    	    
    	}
    	
    	// 计算出不足一年剩余的天数
    	
    	_days =   timestamp / SECONDS_PER_DAY;
    	
    	// 计算时间 :余下的秒数 减去 剩余天数的秒数，除以 每小时的秒数，加上 8
    	
    	_hours = (timestamp - _days * SECONDS_PER_DAY ) / SECONDS_PER_HOUR + HOUR_OFFSET ;
    	
    	_month = 1;
    	
    	//  计算当前的月份
        for(uint i = 0; i < 12; i ++) { 
            
            if(isLeapOrFlatYear == FLAT_YEAR) {
                
                if(_days >= flat_year_month_day[i + 1]) {
                    
                    _month ++; 
                    
                    _days -= flat_year_month_day[i + 1]; 
                    
        		} 
        		}else if(isLeapOrFlatYear == LEAP_YEAR) {
        		    
        			if(_days >= leap_year_month_day[i + 1]) {
        			    
        				_month ++; 
        				
        				_days -= leap_year_month_day[i + 1]; 
        			} 
        		}  
        	}
        	
        	//  天数从0开始，加1
        	_days += 1;
     	
   }
}
