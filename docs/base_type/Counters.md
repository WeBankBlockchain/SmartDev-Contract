# 计数器
提供只能递增或递减1的计数器。这可以用于例如 跟踪铸造的ERC721的id或计数请求id。

## API列表

编号 | API | API描述
---|---|---
1 | *current(Counter storage counter) internal view returns (uint256)* | 获取计数器当前值
2 | *increment(Counter storage counter) internal* | 计数器递增1
3 | *decrement(Counter storage counter) internal* | 计数器递减1


## API 详情

### ***1. current 函数***
获取计数器当前值
#### 参数
- Counter: 计数器本身
#### 返回值
- Counter的当前值

### ***2. increment 函数***
计数器递增1
#### 参数
- Counter: 计数器本身
#### 返回值
- 无

### ***3. decrement 函数***
计数器递减1
#### 参数
- Counter: 计数器本身
#### 返回值
- 无