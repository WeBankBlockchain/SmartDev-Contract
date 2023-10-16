# Solidity时间触发器实现案例

基于Solidity + Java SpringBoot 实现时间触发器案例。

## 1. 合约部署

### 1.1 部署时间触发器合约

1. 这是一个基于区块链的合约时间触发器，可以实现在指定时间触发某项任务的功能。它的作用是记录每个任务的订单号、详情、限期时间等信息，并提供 `putOrder()` 和 `trigger()` 两个接口。
2. 当调用 `putOrder()` 接口时，会将任务的详细信息保存到智能合约中，包括订单号、详情和限期时间等。这些信息保存在 `orders` 映射中，以订单号为索引。这样就可以轻松地查询和管理所有已创建的任务。
3. 当调用 `trigger()` 接口时，传入触发时间和订单号。该接口首先检查触发时间是否早于当前时间，并且订单号是否存在。如果触发时间早于当前时间，则返回false，因为任务还没有到期。如果订单号不存在，则也返回false。
4. 如果存在该订单号且触发时间晚于或等于任务限期时间，则更新订单信息，标记为 "已成功触发" 状态，同时记录实际的触发时间，并返回true。否则，返回false。
5. 需要注意的是，合约定义了六种状态来描述任务的执行情况，分别是：未触发、已成功触发、待执行、执行中、执行成功、已取消和执行失败。在触发之前，任务的状态是 "待执行"，而在任务被成功触发之后，其状态将变为 "执行中"。

总的来说，这个合约可以帮助使用者在特定的时间实现任务的自动触发，以节省人力和时间成本，提高效率。同时，由于该合约运行在区块链上，因此任务信息是不可篡改的，可以保证任务的安全性和可信度。

```solidity
pragma solidity ^0.4.25;

/*************************************************************************************************************************
合约时间触发器

由于区块链上没有时间触发器，需要由外部来触发。所以一般的时间触发都是在合约内部定义好具体的接口如下:
trigger(uint64 triggerTime,string orderNumber)

外部有一个定时任务触发器，每隔一段时间(或者检查具体的执行时间)向区块链发送调用trigger接口，一旦合约内部检查时间与blocktime满足条件
则触发对应的任务
*************************************************************************************************************************/

contract TriggerManager {
    struct Order {
        string orderNumber; //订单号
        string detail; //详情
        uint256 dueTime; //限期时间
        uint256 actualTriggerTime; //实际触发时间
        uint64 status; // 0未触发 1已成功触发 2.待执行 3.执行中 4.执行成功 5.已取消 6.执行失败
    }

    mapping(string => Order) orders; //所有订单

    function putOrder(
        string memory orderNumber,
        string memory detail,
        uint256 dueTime
    ) public returns (bool) {
        Order memory order;

        order.orderNumber = orderNumber;
        order.dueTime = dueTime;
        order.actualTriggerTime = 0;
        order.detail = detail;
        order.status = 0;

        orders[orderNumber] = order;
        return true;
    }

    function trigger(uint256 triggerTime, string memory orderNumber)
        public
        view
        returns (bool)
    {
        uint256 currentBlockTime = block.timestamp;
        if (triggerTime > currentBlockTime) {
            return false;
        }

        Order memory order = orders[orderNumber];

        if (triggerTime < order.dueTime) {
            return false;
        }

        //合约执行结果 0未触发 1已成功触发 2.待执行 3.执行中 4.执行成功 5.已取消 6.执行失败
        if (
            order.status == 1 ||
            order.status == 4 ||
            order.status == 5 ||
            order.status == 6
        ) {
            return true;
        }

        if (order.actualTriggerTime != 0) {
            return true;
        }

        order.actualTriggerTime = triggerTime;
        order.status = 1;
        return true;
    }
}
```



### 1.2 部署触发任务合约

通过一个简单的智能合约，部署并且调用我们的时间触发器合约，这个测试合约有如下几部分：

1. 定义一个执行完的任务清单数组，里面是存放每一次执行完任务添加的结果
2. 可以获取当前的时间戳，一定要是区块链上的时间戳，本地的不行，后端方便对时间戳修改
3. 调用`TriggerManager`事件触发器合约添加任务和执行任务

```solidity
pragma solidity ^0.4.25;
pragma experimental ABIEncoderV2;

import "./TriggerManager.sol";

contract Task {
    
    TriggerManager public triggerManager;
    
    string[] public tasks;
    
    // 初始化地址
    constructor(address _triggerManager) public {
        triggerManager = TriggerManager(_triggerManager);
    }
    
    // 获取当前的时间戳
    function getTime() public returns(uint256){
        return block.timestamp;
    }
    
    // 添加任务
    function addTask(uint256 dueTime,string taskName) public {
        triggerManager.putOrder(taskName, "", dueTime);
    }
    
    // 获取任务的次数
    function getTaskCount() public view returns (uint256) {
        return tasks.length;
    }

    // 获取所有的任务
    function getTasks() public view returns (string[] memory) {
        return tasks;
    }

    // 执行任务
    function trigger(string memory taskName) public {
        require(
            triggerManager.trigger(uint256(block.timestamp), taskName),
            "执行任务失败，未到时间"
        );
        // 到时间才执行
        tasks.push(taskName);
    }
    
}
```

这里的时间戳需要在后端进行计算，链上计算的时间戳会有点问题。



### 1.3 Java计算毫秒级别时间戳

可以使用 `Java` 中的 `java.util.Date` 和 `java.util.Calendar` 类来实现在毫秒级别时间戳加一分钟的操作。

首先，我们将毫秒级别的时间戳转换为 `Date` 实例。假设时间戳为 `long timestamp = 1618203382000L;`，可以使用以下代码进行转换：

```java
Date date = new Date(timestamp);
```

然后，我们需要将 `Date` 实例加上一分钟，可以使用 `Calendar` 类来完成。具体步骤如下：

1. 创建一个 `Calendar` 实例，并将其设置为 `date` 对应的时间。

```java
Calendar calendar = Calendar.getInstance();
calendar.setTime(date);
```

2. 将 `calendar` 的分钟字段加 `1`。

```java
calendar.add(Calendar.MINUTE, 1);
```

3. 获取加一分钟后的时间，这里可以使用 `calendar.getTime()` 方法来获取 `Date` 实例，然后再使用 `getTime()` 方法得到毫秒级别时间戳。

```java
long newTimestamp = calendar.getTime().getTime();
```

完整代码如下所示：

```java
long timestamp = 1618203382000L;
Date date = new Date(timestamp);
Calendar calendar = Calendar.getInstance();
calendar.setTime(date);
calendar.add(Calendar.MINUTE, 1);
long newTimestamp = calendar.getTime().getTime();

// 或者
Calendar calendar = Calendar.getInstance();
calendar.setTimeInMillis(values);
calendar.add(Calendar.HOUR,24);
long timeInMillis = instance.getTimeInMillis();
```



### 1.4 WeBASE-Front部署

1.在WeBASE-Front上部署`TriggerManager`合约，并拿到合约地址。

![image-20230412015557332](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202304120155167.webp)

2.部署Task合约，传入`TriggerManager`的合约地址。

![image-20230412015732403](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202304120157920.webp)

3.导出Java项目。

![image-20230412020553708](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202304120205182.webp)



## 2. 后端调用合约

这里我使用的是Java sdk对接fisco bcos调用合约接口。

官网的SDK文档： https://fisco-bcos-documentation.readthedocs.io/zh_CN/latest/docs/sdk/java_sdk/index.html

官网的WeBASE-Front搭建：https://webasedoc.readthedocs.io/zh_CN/latest/docs/WeBASE-Install/developer.html

使用WeBASE-Front导出的SpringBoot项目，然后加一个`TriggerController`的接口，用来调用`addTask`合约接口，包括后面的其他接口也可以使用SpringBoot完成。执行任务和查询我使用WeBASE-Front会更加清晰明了。



### 2.1 TriggerController

这里创建一个`TriggerController`用来调用合约addTask接口。

```java
/**
 * @author zyh
 * @date 2023/4/12 1:36
 */
@Slf4j
@RestController
@RequestMapping("trigger")
public class TriggerController {

    @Autowired
    private TaskService taskService;

    /**
     * 添加任务
     * @return
     * @throws Exception
     */
    @GetMapping("add")
    public String addTask() throws Exception {
        // 获取当前的时间戳加1分钟
        Long values = (Long) taskService.getTime().getValuesList().get(0);
        Calendar calendar = Calendar.getInstance();
        calendar.setTimeInMillis(values);
        calendar.add(Calendar.MINUTE,1);

        // 增加了1分钟后的时间戳
        long timeInMillis = calendar.getTimeInMillis();

        // 添加一个任务 task的名字 执行的时间
        TaskAddTaskInputBO taskInputBO = new TaskAddTaskInputBO();
        taskInputBO.setTaskName("task");
        taskInputBO.setDueTime(timeInMillis);
        taskService.addTask(taskInputBO);

        // 查看当前的日志
        log.info("+++++++当前的区块链时间戳: {}",values);
        log.info("+++++++修改后的区块链时间戳: {}",timeInMillis);

        return taskService.getTasks().getReturnObject().toString();
    }
}
```



### 2.2 调用addTask接口

GET http://localhost:8080/trigger/add

这里的时间戳进行了变化，在WeBASE-Front上调用`trigger`接口执行任务。

![image-20230412021256170](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202304120212069.webp)

这里调用`trigger`接口即可。

![image-20230412021454103](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202304122247861.webp)

返回交易成功。

![image-20230412021551636](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202304120215785.webp)

通过`getTasks`接口访问已经更新的任务清单列表。

![image-20230412021725585](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202304120217320.webp)

返回成功如下：

![image-20230412021735947](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202304120217984.webp)



### 2.3 设置定时24H触发

修改Java的`TriggerController`的`addTask`接口。

```java
        // 获取当前的时间戳
        Long values = (Long) taskService.getTime().getValuesList().get(0);
        Calendar calendar = Calendar.getInstance();
        calendar.setTimeInMillis(values);
		// 这里只需要修改设置为24小时后触发
        calendar.add(Calendar.HOUR,24);
```



### 2.4 调用addTask接口

GET http://localhost:8080/trigger/add

![image-20230412022245584](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202304120222658.webp)

这里也是调用`trigger`接口即可，返回如下回执：

![image-20230412022410258](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202304120224616.webp)

时间触发器已经生效，所以当后端设置定时器进行任务处理的时候，需要调用链上的接口，可以触发该时间触发器。
