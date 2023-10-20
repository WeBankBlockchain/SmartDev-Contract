# 一文搞懂Truffle如何测试自己的智能合约

>作者：张宇豪
>
>学校：深圳职业技术大学

## 1、什么是合约测试？

### 1.1、Truffle？

使用以太坊虚拟机（EVM）的世界一流的区块链开发环境、测试框架和资产管道，旨在让开发人员的生活变得更轻松。使用Truffle，您可以获得：

- 内置智能合约编译、链接、部署和二进制管理。
- 具有断点、变量分析和单步功能的[高级调试。](https://trufflesuite.com/docs/truffle/how-to/debug-test/use-the-truffle-debugger)
- 在智能合约中使用[console.log](https://trufflesuite.com/docs/truffle/reference/configuration/#soliditylog)
- 通过 MetaMask 和[Truffle Dashboard](https://trufflesuite.com/docs/truffle/how-to/use-the-truffle-dashboard)进行部署和交易，以保护您的助记词。
- 在 Truffle 环境中执行脚本的外部脚本运行程序。
- 用于直接合约通信的交互式控制台。
- 用于快速开发的自动化合同测试。
- 可编写脚本、可扩展的部署和迁移框架。
- 用于部署到任意数量的公共和专用网络的网络管理。
- 使用 NPM 进行包管理，使用[ERC190](https://github.com/ethereum/EIPs/issues/190)标准。
- 可配置的构建管道，支持紧密集成。



### 1.2、官方

官方网站：https://trufflesuite.com/docs/truffle/how-to/debug-test/write-tests-in-javascript/

## 2、环境配置

### 2.1、项目环境

如下环境请自行安装即可，可以安装Windows和Linux的版本都可以，当前我的环境使用的是Truffle进行项目的合约测试。

- Granache 2.7.1 
- Truffle  v5.11.4
- Solidity 0.4.25 

### 2.2、项目工程

- Vscode + Solidity + Truffle 插件

使用如下的命令创建一个Truffle的项目，并将测试合约添加到当前的项目当中去。

```bash
$ truffle init 
```

![image-20231018001136131](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202310180012526.png)



### 2.3、网络环境

- 使用Ganache添加当前的Truffle项目的truffle-config.js的测试文件，点击start。

![image-20231017233730119](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202310172337155.png)

- 成功启动当前项目的Ganache测试环境如下：

![image-20231018001643035](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202310180017094.png)



### 2.4、Truffle测试合约

主要的业务如下:

1. `用户注册`：用户通过调用合约的register函数进行注册，提供用户名和用户地址等信息，并在合约中创建对应的User结构体存储用户信息。
2. `用户充值`：注册后的用户可以调用updateBalance函数进行账户充值，增加自己的余额。
3. `用户发起众筹`：用户可以调用Initiate函数发起众筹活动。在函数中，会创建新的众筹历史记录（HistoryRecord），记录众筹的相关信息，如发起众筹的用户地址、众筹标题、描述、所需金额等，并将该记录存储在合约的recordMap映射中。同时，更新用户的众筹记录（records）。
4. `用户捐款`：其他用户可以通过调用Donation函数向指定的众筹记录进行捐款。在函数中，会判断众筹历史记录是否存在（_isHistoryRecordExist），捐款是否超过众筹所需金额，以及众筹记录的状态是否允许捐款。如果满足条件，将创建捐款记录（DonationRecord），记录捐款的相关信息，并更新众筹历史记录的总金额、参与捐款的用户列表，并更新捐款人的信息。
5. `用户提现`：当众筹记录已完成且未完成提现时，用户可以调用Withdrawal函数进行提现操作。在函数中，会判断提现条件是否满足（如结束时间、记录状态等），如果满足，则将众筹余额返还给发起众筹的用户，并更新相关状态。
6. `查询信息`：用户可以通过调用getHistoryRecordInfo、getDonationRecordInfo、getUserInfo等函数查询众筹历史记录、捐款记录和用户信息。
7. `分页查询众筹记录`：用户可以通过调用queryHistoryRecordOfPage函数进行分页查询链上的众筹记录，提供页数和每页大小参数，返回对应的众筹历史记录数组。

```solidity
pragma solidity ^0.4.25;
pragma experimental ABIEncoderV2;

contract Crowdfunding {
    // 用户的结构体
    struct User {
        uint256 userId;         // 用户ID
        address userAddr;       // 用户地址
        string  userName;       // 用户名称
        uint256 balance;        // 用户的余额
        uint256[] records;      // 用户的众筹记录
        uint256[] donations;    // 捐款的记录
        uint256 historyBalance; // 用户的历史捐赠余额
    }
    
    // 众筹历史记录
    struct HistoryRecord {
        uint256 recordId;       // 历史记录ID
        address recordAddress;  // 发起众筹的用户地址
        string  recordTitle;    // 众筹的用途标题
        string  recotdDesc;     // 众筹的历史记录描述
        uint8   recordStatus;   // 历史记录状态
        uint256 needAmount;     // 众筹余额
        uint256 overAmount;     // 已完成的余额
        uint256 crateTime;      // 历史记录时间
        uint256 endTime;        // 历史记录结束时间
        address[] userList;     // 用户的地址集合
    }
    
    struct DonationRecord {
        uint256 donationId;     // 捐款记录ID
        address userAddr;       // 捐款用户的地址
        uint256 donationAmount; // 捐款的金额
        uint256 historyRecordId;// 众筹的记录ID
        
    }
    
    // 
    uint256 userCount;
    uint256 recordCount;
    uint256 donationCount;  
    
    // 用户和记录的映射 使用map存储
    mapping(address => User) private userMap;
    mapping(uint256 => HistoryRecord) private recordMap;
    mapping(uint256 => DonationRecord) private donationMap;
    
    
    uint256[] private recordList;
    
    
    
    // 用户的注册
    function register(string memory _userName,address _userAddress) public returns(string memory){
        // 判断该用户是否存在
        require(userMap[_userAddress].userAddr == address(0),"当前用户已经存在");
        userCount++;
        User storage _user = userMap[_userAddress];
        _user.userId = userCount;
        _user.userAddr = _userAddress;
        _user.userName = _userName;
        _user.balance = 0;
        _user.historyBalance = 0;
        
        return _user.userName;
    }
    
    
    // 用户充值自己的账户
    function updateBalance(address _userAddress,uint256 _amount) public returns(User){
        // 判断当期的用户是否存在
        User storage _user = userMap[_userAddress];
        _user.balance += _amount;
        return _user;
        
    }
    
    
    // 用户发起众筹
    function Initiate(address _userAddress,string memory _title,string memory _desc,uint256 _amount) public returns(int8){
        int8 res_code = 0;
        HistoryRecord storage _historyRecord;
        // 判断当期的用户是否存在
        if (_isUserExist(_userAddress)){
            res_code = -1;
            return res_code;
        }
        
        recordCount++;
        _historyRecord = recordMap[recordCount];
        // 创建新的众筹历史记录
        _historyRecord.recordId = recordCount;
        _historyRecord.recordAddress = _userAddress;
        _historyRecord.recordTitle = _title;
        _historyRecord.recotdDesc = _desc;
        _historyRecord.recordStatus = 1;    // 1：初始化 2：在筹资 3：已完成
        _historyRecord.needAmount = _amount;
        _historyRecord.overAmount = 0;
        _historyRecord.crateTime = block.timestamp;
        
        recordList.push(_historyRecord.recordId);
        // 更新用户的历史记录
        User storage _user = userMap[_userAddress];
        _user.records.push(_historyRecord.recordId);
        
        return res_code;
        
    }
    
    
    // 用户的捐款操作
    function Donation(address _userAddress,uint256 _historyRecordId,uint256 _amount) public returns(int8,DonationRecord){
        int8 res_code = 0;
        // 众筹历史记录不存在
        DonationRecord storage _donationRecord;
        if (_isHistoryRecordExist(_historyRecordId)){
            res_code = -1;
            return (res_code,_donationRecord);
        }
        
        HistoryRecord storage _historyRecord = recordMap[_historyRecordId];
        // 假如已完成的金额是已经大于
        if (_historyRecord.overAmount >= _historyRecord.needAmount){
            res_code = 1;
            _historyRecord.recordStatus = 3;
            return (res_code,_donationRecord);
        }
        // 历史记录的状态不匹配
        if (_historyRecord.recordStatus == 3){
            res_code = -2;
            return (res_code,_donationRecord);
        }
        // 两个用户的信息更新
        User storage _donor = userMap[_userAddress];

        // 一切正常
        _historyRecord.recordStatus = 2;
        _historyRecord.overAmount += _amount;
        _historyRecord.userList.push(_userAddress);
        
        // 生成捐赠历史记录
        donationCount++;
        _donationRecord = donationMap[donationCount];
        _donationRecord.donationId = donationCount;
        _donationRecord.userAddr = _userAddress;
        _donationRecord.donationAmount = _amount;
        _donationRecord.historyRecordId = _historyRecordId;

        // 更新捐款人的信息
        _donor.donations.push(_donationRecord.donationId);
        _donor.historyBalance += _amount;
        _donor.balance -= _amount;
        
        return(res_code,_donationRecord);
    }
    
    // 用户提现的操作
    function Withdrawal(uint256 _historyRecordId,uint256 _amount) public returns(int8,uint256){
        int8 res_code = 0;
        HistoryRecord storage historyRecord = recordMap[_historyRecordId];
        User storage user = userMap[msg.sender];
        require(historyRecord.endTime == 0,"该订单已完成提现，请勿重复操作。");
        require(historyRecord.recordStatus == 3,"当前的订单状态不匹配，无法提现");
        if (historyRecord.recordAddress == msg.sender){
            historyRecord.endTime = block.timestamp;
            user.balance += historyRecord.overAmount;
            return(res_code,_amount);
        }else {
            res_code = -1;
            return (res_code,0);
        }
    }
    
    
    /**
     * 判断该用户是否存在
     * 返回true 是不存在
     * 返回false 是存在
    */
    function _isUserExist(address _userAddress) private view returns(bool){
        return userMap[_userAddress].userAddr == address(0);
    }
    
    /**
     * 判断众筹历史记录是否存在
     * true 是不存在
     * false 是存在
     */
    function _isHistoryRecordExist(uint256 _historyRecordId) private view returns(bool){
        return recordMap[_historyRecordId].recordAddress == address(0);
    }
    
    // 查询众筹历史记录ID详细
    function getHistoryRecordInfo(uint256 _historyRecordId) public view returns(uint256,address,string memory,string memory,uint8,uint256,uint256,uint256,uint256,address[]){
        HistoryRecord memory _HistoryRecord = recordMap[_historyRecordId];
        return (_HistoryRecord.recordId,_HistoryRecord.recordAddress,_HistoryRecord.recordTitle,
        _HistoryRecord.recotdDesc,_HistoryRecord.recordStatus,_HistoryRecord.needAmount,
        _HistoryRecord.overAmount,_HistoryRecord.crateTime,_HistoryRecord.endTime,_HistoryRecord.userList);
    }
    
    // 查询捐款历史记录详细
    function getDonationRecordInfo(uint256 _donationRecordId) public view returns(uint256,address,uint256,uint256){
        DonationRecord memory _DonationRecord =  donationMap[_donationRecordId];
        return (_DonationRecord.donationId,_DonationRecord.userAddr,_DonationRecord.donationAmount,_DonationRecord.historyRecordId);
    }
    // 查询用户的详细信息
    function getUserInfo(address _userAddress) public view returns(uint256,address,string memory,uint256,uint256[] memory,uint256[] memory,uint256){
        User memory user = userMap[_userAddress];
        return (user.userId,user.userAddr,user.userName,user.balance,user.records,user.donations,user.historyBalance);
    }
    
    // 分页查询链上众筹记录
    function queryHistoryRecordOfPage(uint256 _page,uint256 _pageSize) public returns(uint256,HistoryRecord[]){
        require(recordList.length != 0,"当前没有众筹记录");
        require(_page > 0, "页数不能为0");        
        uint256 startIndex = (_page -1) * _pageSize;
        uint256 endIndex = startIndex + _pageSize > recordList.length ? recordList.length : startIndex + _pageSize;
        HistoryRecord[] memory historyRecordArr = new HistoryRecord[](endIndex - startIndex);
        for (uint i = startIndex; i < endIndex; i++){
            historyRecordArr[i - startIndex] = recordMap[recordList[i]];
        }
        return (recordList.length,historyRecordArr);
    }
}
```



## 3、编写测试用例

### 3.1、基本使用

#### 1、artifacts.require()

引入合约的名称，返回一个合约的抽象。在部署脚本的其余部分使用该抽象，指定的名称应与该源文件中协定定义的名称匹配。不要传递源文件的名称，因为文件可以包含多个协定。

```javascript
const HelloWorld = artifacts.require("HelloWorld");
```

#### 2、module.exports

所有迁移都必须通过 `module.exports` 语法导出函数。每次迁移导出的函数应接受一个 `deployer` 对象作为其第一个参数。它们接受第二个参数，称为 `network` 。也接受第三个参数，称为`accounts`。

```javascript
module.exports = function(deployer, network, accounts) {
  // Use the accounts within your migrations.
}

// Deploy a single contract without constructor arguments
deployer.deploy(A);

// Deploy a single contract with constructor arguments
deployer.deploy(A, arg1, arg2, ...);

// Don't deploy this contract if it has already been deployed
deployer.deploy(A, {overwrite: false});

// Set a maximum amount of gas and `from` address for the deployment
deployer.deploy(A, {gas: 4612388, from: "0x...."});
```

#### 3、contract()

在结构上，您的测试应与 Mocha 的测试基本保持不变：您的测试应存在于 `./test` 目录中，它们应以 `.js` 扩展名结尾，并且它们应包含 Mocha 将识别为自动测试的代码。松露测试与摩卡测试的不同之处在于功能 `contract()` ：此功能的工作方式与 `describe()` 松露完全相同，只是它启用了松露的洁净室功能。

- 在每个 `contract()` 函数运行之前，您的合约将被重新部署到正在运行的以太坊客户端，以便其中的测试以干净的合约状态运行。
- 该 `contract()` 函数提供您的以太坊客户端可用的帐户列表，您可以使用这些帐户来编写测试。

#### 4、it()

每一个需要执行的测试用例。



### 3.2、合约部署Migrations

 迁移脚本（JavaScript 文件）可帮助我们将合约部署到以太坊网络。这些文件负责暂存我们的部署任务，并且假设我们的部署需求会随着时间的推移而发生变化。随着项目的发展，我们将创建新的迁移脚本，以进一步推动区块链的发展。先前运行的部署记录通过特殊的 `Migrations` 迁移合约记录在链上，详细信息如下。



在项目的`migrations`目录，编写`Crowdfunding`合约的迁移文件。

```javascript
const Crowdfunding = artifacts.require("Crowdfunding");

module.exports = function (deployer) {
    deployer.deploy(Crowdfunding);
}
```



执行如下命令：

```bash
PS C:\Users\27568\Desktop\合约漏洞测试\CharityFund_Truffle> truffle.cmd deploy  

Compiling your contracts...
===========================
> Compiling .\contracts\Crowdfunding.sol
> Compilation warnings encountered:
> Artifacts written to C:\Users\27568\Desktop\合约漏洞测试\CharityFund_Truffle\build\contracts
> Compiled successfully using:
   - solc: 0.4.25+commit.59dbf8f1.Emscripten.clang

Starting migrations...
======================
> Network name:    'development'
> Network id:      5777
> Block gas limit: 6721975 (0x6691b7)


1_init_crowdfunding.js
======================

   Replacing 'Crowdfunding'
   ------------------------
   > transaction hash:    0x50e8e2a4160329238ded9d6c7f0244f85f5eac2b09fe3d80f20cf59ab5a07dee
   > Blocks: 0            Seconds: 0
   > contract address:    0x796c77E743AF53221297593DcEBfd0C53F714Edf
   > block number:        31
   > block timestamp:     1697564137
   > account:             0x59BB87E4BE435CB54E25a8F25a02DC160CC5AC48
   > balance:             99.850729989998299879
   > gas used:            2711170 (0x295e82)
   > gas price:           2.613157405 gwei
   > value sent:          0 ETH
   > total cost:          0.00708471396171385 ETH

   > Saving artifacts
   -------------------------------------
   > Total cost:     0.00708471396171385 ETH

Summary
=======
> Total deployments:   1
> Final cost:          0.00708471396171385 ETH

```

查看Ganache的合约部署情况：

![image-20231018013654619](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202310180136657.png)

在 test 目录中，添加自定义的测试用例：

![image-20231018014011123](https://blog-1304715799.cos.ap-nanjing.myqcloud.com/imgs/202310180140158.png)



### 3.3、测试注册用户

- 获取`Crowdfunding`合约实例
- 调用`Crowdfunding`的成员方法
- 使用断言进行判断测试

```javascript
const Crowdfunding = artifacts.require("Crowdfunding");

contract("Crowdfunding", (accounts) =>{
    it("Register User Of Truffle", async () => {
        // 获取Crowdfunding合约部署的实例
        const crowdfunding = await Crowdfunding.deployed();
        await crowdfunding.register("lisi",accounts[0]);

        // 获取当前的用户地址
        const result =  await crowdfunding.getUserInfo(accounts[0]);
        const address = result[1];

        // 断言判断
        assert.equal(accounts[0],address,"The User is Error!");
    })
})
```

测试结果：

```javascript
PS C:\Users\27568\Desktop\合约漏洞测试\CharityFund_Truffle> truffle.cmd test
Using network 'development'.

Compiling your contracts...
===========================
> Compiling .\contracts\Crowdfunding.sol
> Compilation warnings encountered:
> Artifacts written to C:\Users\27568\AppData\Local\Temp\test--1964-32Zo5g71qiDa
> Compiled successfully using:
   - solc: 0.4.25+commit.59dbf8f1.Emscripten.clang


  Contract: Crowdfunding
    ✔ Register User Of Truffle (60ms)


  1 passing (121ms)
```

也可以使用批量注册的方式玩法：

```javascript
const Crowdfunding = artifacts.require("Crowdfunding");

contract("Crowdfunding", (accounts) =>{    
    it("Register some users",async () => {
        const crowdfunding = await Crowdfunding.deployed();
        for (let i = 0; i < accounts.length; i++) {
            const address = accounts[i];
            crowdfunding.register("user" + i,address);
        }
    })
})
```



### 3.4、测试用户发起众筹

- 获取`Crowdfunding`合约实例
- 调用`Crowdfunding`的成员方法
- 使用断言进行判断测试

```javascript
const Crowdfunding = artifacts.require("Crowdfunding");

contract("Crowdfunding", (accounts) =>{
    it("Initiate donation Test", async () => {
        // 获取Crowdfunding合约部署的实例
        const crowdfunding = await Crowdfunding.deployed();
        await crowdfunding.register("lisi",accounts[0]);

        // 更新用户的账户
        await crowdfunding.updateBalance(accounts[0],1000);
        await crowdfunding.Initiate(accounts[0],"公益慈善","用于灾区捐款",1000);
        const result  = await crowdfunding.getHistoryRecordInfo(1);
        
        // 判断当前的用户是否已经成功发起众筹
        const address = result[1]
        assert.equal(address,accounts[0],"Failed to initiate a charitable donation!");

    })
})
```

测试结果：

```bash
PS C:\Users\27568\Desktop\合约漏洞测试\CharityFund_Truffle> truffle.cmd test .\test\user_initiate.js
Using network 'development'.


Compiling your contracts...
===========================
> Compiling .\contracts\Crowdfunding.sol
> Compilation warnings encountered:
> Artifacts written to C:\Users\27568\AppData\Local\Temp\test--17224-QbqHOJ8NGd70
> Compiled successfully using:
   - solc: 0.4.25+commit.59dbf8f1.Emscripten.clang


  Contract: Crowdfunding
    ✔ Initiate donation Test (119ms)


  1 passing (179ms)
```



### 3.5、测试用户捐款

- 获取`Crowdfunding`合约实例
- 调用`Crowdfunding`的成员方法
- 使用断言进行判断测试

```java
const Crowdfunding = artifacts.require("Crowdfunding");

contract("Crowdfunding", (accounts) =>{
    it("Initiate donation Test", async () => {
        // 获取Crowdfunding合约部署的实例
        const crowdfunding = await Crowdfunding.deployed();
        await crowdfunding.register("lisi",accounts[0]);
        await crowdfunding.register("zhangsan",accounts[1]);

        // 获取当前的用户地址
        const user1Result =  await crowdfunding.getUserInfo(accounts[0]);
        const user1Address = user1Result[1];
        assert.equal(user1Address,accounts[0],"The user is register error");

        const user2Result =  await crowdfunding.getUserInfo(accounts[0]);
        const user2Address = user2Result[1];
        assert.equal(user2Address,accounts[0],"The user is register error");

        // 更新用户的账户
        await crowdfunding.updateBalance(accounts[1],1000);
        await crowdfunding.Initiate(accounts[0],"公益慈善","用于灾区捐款",1000);
        const result  = await crowdfunding.getHistoryRecordInfo(1);
        
        // 判断当前的用户是否已经成功发起众筹
        const address = result[1]
        const recordId = result[0]
        assert.equal(address,accounts[0],"Failed to initiate a charitable donation!");

        // 测试用户捐款
        await crowdfunding.Donation(accounts[1],recordId,10);

        // 判断当前的用户是否为捐款用户
        const donation = await crowdfunding.getDonationRecordInfo(1);
        const donationAddress = donation[1];
        assert.equal(donationAddress,accounts[1],"Failed to donation!");

    })
})
```

测试结果：

```bash
PS C:\Users\27568\Desktop\合约漏洞测试\CharityFund_Truffle> truffle.cmd test .\test\user_donation.js
Using network 'development'.


Compiling your contracts...
===========================
> Compiling .\contracts\Crowdfunding.sol
> Compilation warnings encountered:
> Artifacts written to C:\Users\27568\AppData\Local\Temp\test--20120-hTJ0NPxfcswD
> Compiled successfully using:
   - solc: 0.4.25+commit.59dbf8f1.Emscripten.clang


  Contract: Crowdfunding
    ✔ Initiate donation Test (271ms)


  1 passing (329ms)
```



## 4、总结

到此就完成了基于Truffle  + Ganache 测试自定义的智能合约了，不需要每一个业务都去进行调用的方式，编写好测试脚本直接使用Truffle进行批量测试，既方便又高效。
