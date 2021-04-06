# LibString.sol

LibString提供了常用的字符串操作。这些操作是基于字符的，而非字节。

## 使用方法

首先需要通过import引入LibString类库, 以下为使用示例

```
pragma solidity >=0.4.24 <0.6.11;

import "./LibString.sol";

contract TestString {
    
    function f() public view returns(uint ){
        string memory str = "字符串";
        uint len = LibString.lenOfChars(str);//Expected to be 3
        return len;
    }
}
```


## API列表

编号 | API | API描述
---|---|---
1 | *lenOfChars(string src) internal pure returns(uint)* | 获取字符个数
2 | *lenOfBytes(string src) internal pure returns(uint)* | 获取字节个数
3 | *startWith(string src, string prefix) internal pure returns(bool)* | 前缀串判断
4 | *endWith(string src, string tail) internal pure returns(bool)* | 尾缀串判断
5 | *equal(string self, string other)* | 两字符串是否相等
6 | *equalNocase(string self, string other)* | 两字符串是否相等, 忽视大小写
7 | *empty(string src) public pure returns(bool)* | 字符串是否为空
8 | *concat(string self, string str) public returns (string _ret)* | 字符串拼接
9 | *substrByCharIndex(string self, uint start, uint len) public returns (string)* | 取子字符串，下标是字符下标
10 | *compare(string self, string other) internal pure returns (int)* | 比较两个字符串的大小
11 | *compareNocase(string self, string other) internal pure returns (int)* | 比较两个字符串的大小，忽视大小写
12 | *toUppercase(string src) internal pure returns(string)* | 转换为大写
13 | *toLowercase(string src) internal pure returns(string)* | 转换为小写
14 | *indexOf(string src, string value) internal pure returns (int)* | 查找字符串中是否含有子字符串
15 | *indexOf(string src, string value, uint offset) internal pure returns (int)* | 查找字符串中是否含有子字符串
16 | *split(string src, string separator) internal pure returns (string[])* | 字符串根据分隔符拆分成数组

## API详情

### ***1. lenOfChars 方法***

获取一个字符串所包含的字符数量

#### 参数

- src: 字符串

#### 返回值

- uint256：字符个数

#### 实例

```
    function f() public view returns(uint ){
        string memory str = "字符串";
        uint len = LibString.lenOfChars(str);//Expected to be 3
        return len;
    }
```

### ***2. lenOfBytes 方法***

获取一个字符串所包含的字节数量

#### 参数

- src: 字符串

#### 返回值

- uint256：字节个数

#### 实例

```
    function f() public view returns(uint ){
        string memory str = "字符串";
        uint len = LibString.lenOfBytes(str);//Expected to be 9
        return len;
    }
```

### ***3. startWith 方法***

startWith用于判断一个字符串是否为另一个字符串的前缀串

#### 参数

- src：字符串
- prefix：子串

#### 返回值

- bool: prefix是否为src的前缀串

#### 实例

```
    function f() public view returns(bool){
        bool r = LibString.startWith("abcd","ab");//Expected to be true
        return r;
    }
```

### ***4. endWith 方法***

endWith用于测试一个字符串是否为另一个字符串的尾缀串

#### 参数

- src: 字符串
- tail：子串

#### 返回值

- bool: tail是否为src的尾缀串

#### 实例

```
    function f() public view returns(bool){
        bool r = LibString.startWith("abcd","cd");//Expected to be true
        return r;
    }
```

### ***5. equal 方法***

用于判断两个字符串是否相等。

#### 参数

- self：字符串
- other：字符串

#### 返回值

- bool: 两个字符串是否相等

#### 实例

```
    function f() public view returns(bool){
        bool r = LibString.equal("abcd","abcd");//Expected to be true
        return r;
    }
```

### ***6. equalNocase 方法***

用于判断两个字符串是否相等。忽视大小写

#### 参数

- self：字符串
- other：字符串

#### 返回值

- bool: 两个字符串是否相等。忽视大小写

#### 实例

```
    function f() public view returns(bool){
        bool r = LibString.equalNocase("abcd","ABCD");//Expected to be true
        return r;
    }
```

### ***7. empty 方法***

判断字符串是否为空串

#### 参数

- src: 待判断串

#### 返回值

- bool: 该字符串是否为空串

#### 实例

```
    function f() public returns(bool, bool){
        
        bool r1 = LibString.empty("abcd");//Expected to be false
        bool r2 = LibString.empty("");//Expected to be true
        //TODO:
        return (r1,r2);
    }
```

### ***8. concat 方法***

该方法连接两个字符串，并得到一个新的字符串。

#### 参数

- self：当前字符串
- str：另一个字符串

#### 返回值

- string: 拼接所得字符串

#### 实例

```
    function f() public returns(string memory){
        string memory s1 = "ab";
        string memory s2 = "cd";
        return LibString.concat(s1,s2);//Exptected to be abcd
    }
```

### ***9. substrByCharIndex方法***

substrByCharIndex方法用于提取子字符串。

#### 参数

- self：当前字符串
- start：子串起点字符的下标
- end: 字串的字符长度

#### 返回值

- string: 子串

#### 实例

```
    function f() public returns(string memory) {
        string memory full = "完整字符串";
        string memory sub = LibString.substrByCharIndex(full ,2, 3);//Expected to be 字符串
        return sub;
    }
```

### ***10. compare 方法***

用于判断两个字符串的大小。

#### 参数

- self：字符串
- other：字符串

#### 返回值

- int8: -1：左值小于右边，0：相等，1-左值大于右边

#### 实例

```
    function f() public view returns(int8){
        
        int8 c = LibString.compare("abcd","abcd");// Expected to be 0
    }
```


### ***11. compareNocase 方法***

用于判断两个字符串的大小。忽视大小写

#### 参数

- self：字符串
- other：字符串

#### 返回值

- int8: -1：左值小于右边，0：相等，1-左值大于右边

#### 实例

```
    function f() public view returns(int8){
        
        int8 c = LibString.compareNocase("abcd","abcd");// Expected to be 0
    }
```

### ***12. toUppercase 方法***

转换成大写

#### 参数

- src: 字符串

#### 返回值

- string: 大写字符串

#### 实例

```
    function f() public view returns(string memory)  {
        
        string memory c = LibString.toUppercase("abcd");// Expected to be ABCD
        return c;
    }
```

### ***13. toLowercase 方法***

转换成小写

#### 参数

- src: 字符串

#### 返回值

- string: 小写字符串

#### 实例

```
    function f() public view returns(string memory)  {
        
        string memory c = LibString.toLowercase("ABCD");// Expected to be abcd
        return c;
    }
```

### ***14. indexOf 方法***

查找字符串中相同子字符串的位置

#### 参数

- string: 字符串
- string: 子字符串

#### 返回值

- int: 返回字符串的位置，如不存在返回-1

#### 实例

```
    function f() public view returns(int) {
        
        int c = LibString.indexOf("ABCD", "B");// Expected to be 1
        return c;
    }
```

### ***15. indexOf 方法***

查找字符串中相同子字符串的位置

#### 参数

- string: 字符串
- string: 子字符串
- uint: 查找起始位置

#### 返回值

- int: 返回字符串的位置，如不存在返回-1

#### 实例

```
    function f() public view returns(int){
        
        int c = LibString.indexOf("ABCD", "B", 0);// Expected to be 1
        return c;
        
    }
```


### ***16. split 方法***

对字符串按照提供的隔断符分成一个string数组

#### 参数

- string: 字符串
- string: 隔断符

#### 返回值

- string[]: 字符串数组

#### 实例

```
    
    function f() public view returns(string[] memory){
        
        string[] memory c = LibString.split("A,B,CD", ",");// Expected to be ["A", "B", "CD"]
        return c;
        
    }
```