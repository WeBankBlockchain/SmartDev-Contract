# 任务38: Task挑战赛, solidity实现时间锁。
### 作者: 深职院-符博<br>
本文实现了一个简单的时间锁，实现了时间锁的开始，计时，停止和状态判断，下面来看看合约吧

## 一, 合约代码
```PowerShell
// @author const
pragma solidity ^0.4.25;
pragma experimental ABIEncoderV2;

contract TimeStock {
    
struct TimeEntity {
    uint256 id;
    uint256 startTime; // 开始时间
    uint256 stopTime; // 暂停时间
    uint256 totalTime; // 总计时
    uint256 continueTime; // 暂停后开始时间
    uint256 status; // 1 计时中 2 暂停中
    bool validate;
}

    // 需要开始才能暂停
     modifier isStart(uint256 id) {
        require(TimeEntityMapping[id].status == 1, "Does not Start timing");
        _;
    }
    
    // 需要停止才能继续
    modifier isStop(uint256 id) {
        require(TimeEntityMapping[id].status == 2, "Does not Stop timing");
        _;
    }
    
    // 判断是否存在
    modifier isExist(uint256 id) {
         require(TimeEntityMapping[id].validate == true, "Does not Exist");
        _;
    }

// 开始事件
event startEvent(uint id, string msg, uint startTime);

// 暂停事件
event stopEvent(string msg, uint startTime,  uint totalTime);


// 实体映射
mapping(uint => TimeEntity) TimeEntityMapping;

// id自增
uint id = 0;


// 开始计时
function start() public returns(bool) {
    TimeEntity memory time = TimeEntity(id, block.timestamp, 0, 0, 0, 1, true);
    TimeEntityMapping[id] = time;
    
    startEvent(id, "Start timing...", time.startTime);
    id++;
    return true;
}


// 停止计时
function stop(uint256 id) public isStart(id) returns(bool) {
    
    TimeEntityMapping[id].stopTime = block.timestamp;
    TimeEntityMapping[id].status = 2;
    
    TimeEntity storage time = TimeEntityMapping[id];
    
    uint totalTime = 0;
    if(time.continueTime > 0) {
        totalTime = time.stopTime - time.continueTime;
        TimeEntityMapping[id].totalTime += totalTime;
    }else {
       totalTime = time.stopTime - time.startTime;
       TimeEntityMapping[id].totalTime = totalTime;
    }
    
    // 发送停止事件 返回开始时间 还有总计时 用开始时间+上总计时 就可以获得记录的时间
    stopEvent("Stop timing...",time.startTime, TimeEntityMapping[id].totalTime);
    return true;
}


// 继续计时
function continueTime(uint256 id) public isStop(id) returns(bool) {
    TimeEntityMapping[id].continueTime = block.timestamp;
    TimeEntityMapping[id].status = 1;
    
    return true;
    
}


// 删除
function deleteTime(uint256 id) public isExist(id) returns(bool) {
    delete TimeEntityMapping[id];
}



// 查看状态 1 正在计时 2 停止计时
function getStatus(uint256 id) public view returns (uint256) {
    TimeEntity storage time = TimeEntityMapping[id];
    return time.status;
}
    
}


```
## 二, 合约测试
### 1，合约部署后可以调用start的方法开始计时，成功后会返回开始事件<br>
![image](https://user-images.githubusercontent.com/103564714/190415892-93435c6f-62ac-443a-85ea-e59b06c1ffd9.png)<br>
### 2, 调用stop方法停止计时，成功后返回停止事件, 这里的totalTime(总计时) + startTime(开始时间) 可以推出计时的时间 <br>
![image](https://user-images.githubusercontent.com/103564714/190416358-65cfa748-2ac0-44e8-bf6d-fd6d96545adc.png)<br>
### 3, 停止计时后我们还可以调用continueTime方法继续计时，调用成功后再调stop停止计时方法, 总计时会根据上次停止时的总计时进行累加。<br>
### continueTime方法<br>
![image](https://user-images.githubusercontent.com/103564714/190417487-25cef80f-18e1-4522-a57d-dcb1688335d5.png)<br>
### 再次调用stop方法,总计时会根据上次停止时的总计时进行累加<br>
![image](https://user-images.githubusercontent.com/103564714/190419073-97e04301-78fa-4e60-ba58-26cdac5f37ad.png)<br>
### 4, 调用deleteTime方法可以将该计时删除 getStatus方法可以判断其状态是在计时还是停止。





