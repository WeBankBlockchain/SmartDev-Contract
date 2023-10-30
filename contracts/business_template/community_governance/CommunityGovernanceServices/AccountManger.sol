pragma solidity >= 0.6 <= 0.9;

/*
作者：重庆电子工程职业学院 | 向键雄 杜小敏

还有一个modifer没写完，modiffer作为条件判断，增删查改等功能必须要constructor中的初始化的人才可以调用进来之前必须进行判断
*/



// SPDX-License-Identifier: SimPL-2.0
contract AccountManger { // 人员管理操作合约

/*实体定义区*/

    // 居民结构体
    struct   ResidentStruct{
        bool checkInBool;                   // 居民是否入住
        string  id;                         // id索引值
        uint banlance;                      // 账户余额用于提交物业管理费的积分
        string  blongsBuilding;             // 所属楼栋 
        bool isBuilding;                    // 是否为楼栋长
        address residentAddress;            // 居民用户地址
    }

    // 监管账户结构体
    struct  RegulatoryAccounts{
        string id;                          // id索引
        uint banlance;                      // 账户余额
    }

/*变量定义区*/

    uint public buildingNumber;               // 小区内有多少栋楼用于初始化生成楼栋长数量
    uint public buildingmember;              // 小区内有多少栋楼用于判断新增用户是否完成
    uint public buildingOccupants;          // 小区内有多少房间已经入住
    address public mangerAddress;          // 管理员地址

/*数组定义区*/

    string[] public Residents;            // 存储用户id数组

/*mapping定义区*/
    mapping(string => ResidentStruct) residentMapping; // 映射居民结构体
    mapping(string  => string) BlongsBuildingManger; // 映射楼栋长，如A栋属于XXX管理

// 构造函数 楼栋数用于确定楼栋长数量 、 可入住居民户数 、 已经入住居民户数 
    constructor(uint _buildingNumber,uint _buildingmember,uint _buildingOccupants) {

        buildingNumber = _buildingNumber;           // 初始化楼栋数量
        buildingmember = _buildingmember;           // 初始化居民数量
        buildingOccupants = _buildingOccupants;     // 初始化入住多少户居民数量
        mangerAddress = msg.sender;                 // 管理人员账户
    }

/*事件方法区*/
    event addResidentEvent(bool _checkInBool,string _id,uint _banlance,string _blongsBuilding,bool _isBuilding,address _residentaddress); // 添加新的居民账户事件
    event ModifyResidentEvent(bool _checkInBool,string _id,uint _banlance,string _blongsBuilding,bool _isBuilding,address _residentaddress);// 修改居民事件
    event setBuildingEvent(string blongsBuilding, string _id);                                                                              // 更换楼栋长事件



/*功能方法区*/

    // 添加新的居民账户
    function addResident ( bool _checkInBool,string memory _id, uint _banlance, string memory _blongsBuilding, bool  _isBuilding, address  _residentaddress) public returns (bool) {
        ResidentStruct memory _residentStruct = ResidentStruct(_checkInBool,_id,_banlance, _blongsBuilding, _isBuilding,_residentaddress);//创还能用户
        residentMapping[_id] = _residentStruct;             // 增加映射
        Residents.push(_id);                               // 将映射存储于数组当中用于判断
        if (_isBuilding){                                 // 如果是楼栋长将楼栋绑定自身ID
            BlongsBuildingManger[_blongsBuilding] = _id;
        } else {
                return true;
        }
        emit addResidentEvent(_checkInBool,_id,_banlance,_blongsBuilding,_isBuilding,_residentaddress);
        return true;
    }
    // 查看居民账户
    function getResident (string memory _id ) public view returns (bool,string memory ,uint ,string memory,bool ,address) {
        ResidentStruct memory _residentStruct = residentMapping[_id];       // 查看结构体 
        return (_residentStruct.checkInBool ,_residentStruct.id, _residentStruct.banlance, _residentStruct.blongsBuilding , _residentStruct.isBuilding , _residentStruct.residentAddress);// 返回参数
    }
    // 修改居民信息
    function ModifyResident (bool _checkInBool,string memory _id, uint _banlance, string memory _blongsBuilding, bool  _isBuilding, address  _residentaddress) public returns (bool){
        require(residentMapping[_id].checkInBool,"resident does not exist !");// 判断用户是否存在
        ResidentStruct memory _residentStruct = residentMapping[_id];        // 查看结构体  
        _residentStruct.checkInBool = _checkInBool;
        _residentStruct.id = _id;
        _residentStruct.banlance =_banlance;
        _residentStruct.blongsBuilding =_blongsBuilding;
        _residentStruct.isBuilding = _isBuilding;
        _residentStruct.residentAddress = _residentaddress;                // 修改结构体
        emit ModifyResidentEvent(_checkInBool,_id,_banlance,_blongsBuilding,_isBuilding,_residentaddress);
        return true;
    }
    // 删除居民信息
    function DeleteResident (string memory _id) public view returns (bool) {
        ResidentStruct memory _residentStruct = residentMapping[_id];   // 查看结构体  
        if(_residentStruct.checkInBool) {                               // 查看结构体 
            
            return true;
        } else {

            return false;
        }
        // 还没有想好这个逻辑判断，但是正常来说全员注册之后只需要修改了，所以这里先占个位
    }

    // 将用户设置为楼栋长
    function setBuilding(string memory _id) public returns (bool) {
        ResidentStruct memory _residentStruct = residentMapping[_id];   // 查看结构体 
        _residentStruct.isBuilding = true;                              // 将用户是否为楼栋长改为true
        BlongsBuildingManger[_residentStruct.blongsBuilding] = _id;     // 修改mapping中的映射
        emit setBuildingEvent(_residentStruct.blongsBuilding,_id);
        return true;
    }

}