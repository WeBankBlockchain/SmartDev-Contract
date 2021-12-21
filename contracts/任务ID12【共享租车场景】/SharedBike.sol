pragma solidity >=0.4.26;
import "./library.sol";
contract SharedBike{
    address public AdminAddress;  //可以理解为系统管理员只要AdminAddress地址的人可以添加单车
    //构造函数，在创造这个合约时传入，即系统管理员。  
    constructor(address _AdminAddress) public{
          AdminAddress=_AdminAddress;
          
    }  
    struct user_info{
        string username;//名字
        uint phonenumber;//电话
        address useraddress;//注册地址
        uint time;//时间戳
        mapping(uint => address) find_bike;//通过车的地址找到租车人是谁。前面一个uint是车的id，后一个address是用户地址
        mapping(address => bool)user_status;//用户状态，为true可以借车，否则不可以借车
        mapping(address => uint)bike_points;//通过租车人的地址，来查找他的信用积分。
    }
    mapping(bytes32 => user_info) user_dic;
    //引用library库及其中数据结构
    using Library for *;
    Library.user_info private _userself;
    Library.mappingcontrol_info private _bikeself;//调用这里面的结构体中的mapping（address => uint）去表明车的状态；
   //车的状态 0 可以骑，1 已经被他人骑了 2 车已经被报修了
    function Registeruser(string _username,uint _phonenumber) public returns(bytes32 _usersecretkey){
        _usersecretkey=Library.RegisterUser(_userself,_username,_phonenumber,msg.sender,block.timestamp);
        user_dic[_usersecretkey]=user_info(_username,_phonenumber,msg.sender,block.timestamp);//注册时默认信用积分100分
        user_dic[_usersecretkey].bike_points[msg.sender]=100;//注册用户默认积分为100分
        user_dic[_usersecretkey].user_status[msg.sender]=true;
        return _usersecretkey;
    }
    //管理员可以上架新车，将车的编号作为凭证。车的唯一编号映射车的状态
    function AddBike(uint _bikeid)public returns(string){
        require(AdminAddress==msg.sender,"只有管理员可以上架单车");
        _bikeself.uintTouint[_bikeid]=0;//上架一部车时，车的状态默认为0
            return("上架成功");
    }
    function  BorrowBikes(bytes32 _usersecretkey,uint _bikeid)public returns(string){
        address user_address=user_dic[_usersecretkey].useraddress;
        //首先检查用户的状态能不能借车，已经借了车就不能再借车
        if(user_dic[_usersecretkey].user_status[msg.sender]==false){
            revert("您已经借车了，还车后才可以再借车！");
        }
        //检查信用积分，低于60分不可借车
        if(user_dic[_usersecretkey].bike_points[user_address]<60){
            revert("信用积分过低，不可借车！");
        }
        //用户骑车，通过这个地址 ，去查验车的状态
        if( _bikeself.uintTouint[_bikeid]==1)
        {
            revert("车已经被人骑走了，再去找找其他车吧");
        }
        //车被报修了
             if( _bikeself.uintTouint[_bikeid]==2)
        {
            revert("该车已经被报修了，再去找找其他车吧");
        }
        //可以租借，首先改变车状态,然后把这部车的地址和租借走的用户的地址绑定起来
               if( _bikeself.uintTouint[_bikeid]==0)
        {
            //改变车的状态
             _bikeself.uintTouint[_bikeid]=1;
            //把这部车的地址和租借走的用户的地址绑定起来
            user_dic[_usersecretkey].find_bike[_bikeid]=user_dic[_usersecretkey].useraddress;
             //将用户可借车状态修改为false，不可以再租车了
            user_dic[_usersecretkey].user_status[msg.sender]=false;
            return("借车成功，还车时请规范停车");
        }
    }
    //归还单车函数
    function ReturnBikes(bytes32 _usersecretkey,uint _bikeid)public returns(string){
        require(user_dic[_usersecretkey].user_status[msg.sender]==false,"You have not BorrowBikes");
        require((user_dic[_usersecretkey].find_bike[_bikeid])==msg.sender,"这个车不是你租的");
        //改变车的状态
        _bikeself.uintTouint[_bikeid]=0;
         //将用户可借车状态修改为true，可以继续租车了
        user_dic[_usersecretkey].user_status[msg.sender]=true;
        return("Success return");
    }
    //Repair报修函数，用户在骑车时碰到车有问题可以报修，该车其他用户将不再能骑
    function Repair(uint _bikeid)public returns(string){
        //将车的状态改为报修状态
        _bikeself.uintTouint[_bikeid]=2;
        return("已经收到您的反馈，我们将派人尽快维修");
    }
    //管理员功能:给予停车规范的车加分,上传车的地址 ，通过这部车的地址去找到租这部车的人的地址，再通过租车人的地址去加分
    function Reward(bytes32 _usersecretkey, uint _bikeid)public returns(bool){
       address addressuser=user_dic[_usersecretkey].find_bike[_bikeid];
       if(addressuser!=user_dic[_usersecretkey].useraddress){
           revert("user error");
       }
       user_dic[_usersecretkey].bike_points[addressuser]+=10;
       return true;
    }
    //管理员功能：给予不规范停车的扣分， ，通过这部车的地址去找到租这部车的人的地址，再通过租车人的地址去扣分
    function Punishment(bytes32 _usersecretkey,uint _bikeid)public returns(bool){
        address addressuser=user_dic[_usersecretkey].find_bike[_bikeid];
         if(addressuser!=user_dic[_usersecretkey].useraddress){
           revert("user error");
       }
        user_dic[_usersecretkey].bike_points[addressuser]-=10;
        return true;
    }
    //查看用户信用积分
    function see(bytes32 _usersecretkey)public view returns(uint){
        return user_dic[_usersecretkey].bike_points[msg.sender];
    }
}