pragma solidity >=0.4.25 <=0.6.10;

///--------------------------------------------------------------------------------------------
/// DateTimeContract v1.0
/// 算法参考自https://mp.weixin.qq.com/s/bcUCYW6bt0fuLKYp4EqgNw
/// @title 时间操作合约
/// @author jianglong,wei
/// @dev 基于block.timestamp 时间戳计算当前的日期，提供年份、月份、日期、小时、分钟、秒的计算函数
///---------------------------------------------------------------------------------------------
contract DateTimeContract {
    uint256[] flat_year_month_day = [
        0,
        31,
        28,
        31,
        30,
        31,
        30,
        31,
        31,
        30,
        31,
        30,
        31
    ];
    uint256[] leap_year_month_day = [
        0,
        31,
        29,
        31,
        30,
        31,
        30,
        31,
        31,
        30,
        31,
        30,
        31
    ];

    uint256 constant SECONDS_PER_FOUR_YEAR = 126230400;
    uint256 constant SECONDS_PER_DAY = 24 * 60 * 60;
    uint256 constant SECONDS_PER_HOUR = 60 * 60;
    uint256 constant SECONDS_PER_MINUTE = 60;
    uint256 constant SECONDS_PER_YEAR_FLAT = 31536000;
    uint256 constant SECONDS_PER_YEAR_LEAP = 31622400;
    uint256 constant UNIX_TIME_YEAR = 1970;
    uint256 constant LEAP_YEAR = 0;
    uint256 constant FLAT_YEAR = 1;
    uint256 constant HOUR_OFFSET = 8;

    function getYear(uint256 timestamp) public view returns (uint256 _year) {
        (_year, , , , , ) = timestampToDate(timestamp);
    }

    function getMonth(uint256 timestamp) public view returns (uint256 _month) {
        (, _month, , , , ) = timestampToDate(timestamp);
    }

    function getDay(uint256 timestamp) public view returns (uint256 _day) {
        (, , _day, , , ) = timestampToDate(timestamp);
    }

    function getHour(uint256 timestamp) public view returns (uint256 _hour) {
        (, , , _hour, , ) = timestampToDate(timestamp);
    }

    function getMinute(uint256 timestamp)
        public
        view
        returns (uint256 _minute)
    {
        (, , , , _minute, ) = timestampToDate(timestamp);
    }

    function getSecond(uint256 timestamp)
        public
        view
        returns (uint256 _second)
    {
        (, , , , , _second) = timestampToDate(timestamp);
    }

    ///get date time according to timestamp(like block.timestamp)
    function timestampToDate(uint256 timestamp)
        public
        view
        returns (
            uint256 _year,
            uint256 _month,
            uint256 _days,
            uint256 _hours,
            uint256 _minute,
            uint256 _second
        )
    {
        _second = timestamp % SECONDS_PER_MINUTE;
        _minute = (timestamp % SECONDS_PER_HOUR) / SECONDS_PER_MINUTE;
        while (timestamp >= SECONDS_PER_FOUR_YEAR) {
            _year++;
            timestamp -= SECONDS_PER_FOUR_YEAR;
        }
        _year = UNIX_TIME_YEAR + (4 * _year);
        if (timestamp >= SECONDS_PER_YEAR_FLAT) {
            _year++;
            timestamp -= SECONDS_PER_YEAR_FLAT;
            if (timestamp >= SECONDS_PER_YEAR_FLAT) {
                _year++;
                timestamp -= SECONDS_PER_YEAR_FLAT;
                if (timestamp >= SECONDS_PER_YEAR_LEAP) {
                    _year++;
                    timestamp -= SECONDS_PER_YEAR_LEAP;
                    if (timestamp >= SECONDS_PER_YEAR_FLAT) {
                        _year++;
                        timestamp -= SECONDS_PER_YEAR_FLAT;
                    }
                }
            }
        }
        uint256 isLeapOrFlatYear;
        if (((_year % 4 == 0) && (_year % 100 != 0)) || (_year % 400 == 0)) {
            isLeapOrFlatYear = LEAP_YEAR;
        } else {
            isLeapOrFlatYear = FLAT_YEAR;
        }

        // compute days left
        _days = timestamp / SECONDS_PER_DAY;

        // compute hours
        _hours =
            (timestamp - _days * SECONDS_PER_DAY) /
            SECONDS_PER_HOUR +
            HOUR_OFFSET;
        _month = 1;

        //  compute month
        for (uint256 i = 0; i < 12; i++) {
            if (isLeapOrFlatYear == FLAT_YEAR) {
                if (_days >= flat_year_month_day[i + 1]) {
                    _month++;
                    _days -= flat_year_month_day[i + 1];
                }
            } else if (isLeapOrFlatYear == LEAP_YEAR) {
                if (_days >= leap_year_month_day[i + 1]) {
                    _month++;
                    _days -= leap_year_month_day[i + 1];
                }
            }
        }
        _days += 1;
    }
}
