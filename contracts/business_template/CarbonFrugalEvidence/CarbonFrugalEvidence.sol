pragma solidity ^0.4.24;
import "./SafeMath.sol";
import "./AuthUsersRepository.sol";
import "./Address.sol";
import './ECDSA.sol';
import './EvidencesRepository.sol';

contract AuthService{

    using AuthUsersRepository for AuthUsersRepository.AuthUser;
    event AuthUserAdded(address indexed account);
    event AuthUserRemoved(address indexed account);
    event SetPermitUserEvent(address indexed msgAddress,address indexed userAddress,uint256 state, bool setPermitState,uint256 timeStamp, string remark);
 
    AuthUsersRepository.AuthUser private _authUsers;

     //1、基础身份 部分
      
      //设定超级管理员
    address internal _admin;
 
      //授权许可管理者用户集合
    mapping(address=>bool) internal permitManagerMapping;
  
   
    modifier onlyAdmin(){
        require(tx.origin == _admin, "AuthService onlyAdmin：你不是超级管理员，无法进行对应操作！");      
        _;
    }
    modifier onlyManager(){
        require(permitManagerMapping[tx.origin] ==true, "AuthService onlyManager：你不是授权管理者，无法进行对应操作！");      
        _;
    }
    

    constructor() public {
   
       _admin = tx.origin;
       changePermitManager(tx.origin,true);
    }

   

    function isAuthUser(address account) public view returns (bool) {
        return _authUsers.has(account);
    }

    function addAuthUser(address account,string cardNo,string name) public onlyManager {
        _addAuthUser(account, cardNo, name);
    }
    
   function  addBalance(address to,uint256 value)internal  {
       
       _authUsers.addBalance(to,value);
   }
    
    function send(address account,address to,uint256 value) internal {
        _authUsers.send(account, to, value);
    }
    
    function destroy(address account,uint256 value) internal onlyManager{
        _authUsers.destroy(account, value);
    }
    
    function balance(address account) internal view returns(uint256){
    return _authUsers.balance(account);
   }

    //注销用户，授权者操作
    function renounceAuthUser(address account) public  onlyManager{
        _removeAuthUser(account);
    }

    function _addAuthUser(address account,string cardNo,string name) internal onlyManager {
        _authUsers.add(account,cardNo,name);
        emit AuthUserAdded(account);
    }

    function _removeAuthUser(address account) internal onlyManager{
        _authUsers.remove(account);
        emit AuthUserRemoved(account);
    }
    
        //修改授权，address userAddress 用户地址 .bool permitState 授权状态 true 开启，false关闭
    function changePermitManager(address userAddress,bool permitState) public onlyAdmin returns(uint256){
         require(userAddress != address(0), "AuthService changePermitManager: 账户为空地址！");
          uint256 state=0;
         string memory stateMessage="";
         permitManagerMapping[userAddress]=permitState;
         if(permitManagerMapping[userAddress]==permitState){
                state=1;
               stateMessage="AuthService addAuthUser:授权状态修改成功!";
            }else{
               stateMessage="AuthService addAuthUser:授权状态修改失败!";
         }
          emit  SetPermitUserEvent(tx.origin,userAddress,state,permitState,now,stateMessage);
          return state;
    }
}

//充电节能存证积分合约
contract CarbonFrugalEvidence is AuthService {


    using EvidencesRepository for EvidencesRepository.Evidence;
    
    event authDeviceOperation(address indexed operaAccount,address indexed account,bool state);
    event EvidenceAdded(address indexed operaAccount,address indexed account,bytes32 indexed dataHash, string dataJson,bytes signStr,string timeCertificate,uint256 value);
    event EvidenceRemoved(address indexed operaAccount, address indexed account,bytes32 indexed dataHash);
    
     //给用户余额添加积分能量，只有存证成功后调用
     event AddBalanced(address indexed operaAccount,address indexed to, uint256 value, bytes32 dataHash);
     //转让
     event Send(address indexed from, address indexed to, bytes32 dataHash, string dataJson,bytes signStr,string timeCertificate);
     //销毁，平台承兑用户，进行销毁，需要用户的签名
     event Destroy(address indexed operaAccount, address indexed account, bytes32 indexed dataHash,string dataJson,bytes signStr,string timeCertificate);
     
    EvidencesRepository.Evidence private _evidence;
    
    //授权充电设备
    mapping(address=>bool) private _authDevice;

    //保证是注册用户
    modifier onlyUser(address account){
        require(AuthService.isAuthUser(account)==true, "CarbonFrugalEvidence onlyUser:必须是注册用户,才可以进行碳节能存证！");      
        _;
    }
    
     modifier onlyAuthDevice(){
         require(_authDevice[msg.sender] ==true, "CarbonFrugalEvidence onlyAuthDevice：未授权设备，无法进行对应操作！");      
        _;
    }
    

    //保证用户存储数据签名和指定账户是匹配的
      modifier signVerify(address account,bytes32 dataHash,bytes signStr){
       address  retAddr= ECDSA.recover(dataHash,signStr);
        require(retAddr==account,"CarbonFrugalEvidence signVerify:数据签名和当前需要存证用户不一致!");
        _;
    }
    
    //可扩展构造函数传递
    constructor() AuthService() public {
    
    }
    
    //为设备授权
    function setAuthDevice(address account) public onlyManager{
         require(account != address(0), "CarbonFrugalEvidence  setAuthDevice: 授权设备为空地址！");
        _authDevice[account]=true;
      emit authDeviceOperation(msg.sender,account,true);
    }
    //关闭设备权限
    function changeAuthDevice(address account) public onlyManager{
         require(account != address(0), "CarbonFrugalEvidence  changeAuthDevice: 授权设备为空地址！");
        _authDevice[account]=false;
    emit authDeviceOperation(msg.sender,account,false);
    }
    
    
    /**
     * 添加存证,平台方操作
     * account      : 用户地址
     * dataHash     : dataJson的sha256
     * dataJson     : 业务数据
     * signStr      : 用户私钥对dataHash的签名数据
     * timeCertificate  : 时间授时SN
     * value        : 积分数额
     * 
    **/
   function addEvidence(address account,bytes32 dataHash, string dataJson,bytes signStr,string timeCertificate,uint256 value)  public onlyUser(account) onlyAuthDevice signVerify(account,dataHash,signStr) {
           
         _evidence.add(account,dataHash,dataJson,signStr,timeCertificate);
        require(_evidence.has(account,dataHash),"CarbonFrugalEvidence addEvidence： 存证失败，存入区块链异常！"); 
        emit EvidenceAdded(msg.sender,account,dataHash,dataJson,signStr,timeCertificate,value);
        //产生能量记录
        AuthService.addBalance(account,value);
        emit AddBalanced(msg.sender,account,value,dataHash);
      
   }
   
    
     //查找 开放给所有人查询,提供相关摘要信息，业务端需要开发给指定的用户查询，或者后台核查
     function selectEvidence(address account,bytes32 dataHash)  public view returns(string) {
        return _evidence.selectEvidence(account,dataHash);
     }
     
     //删除存证，授权管理者操作
      function removeEvidence(address account, bytes32 dataHash) public onlyUser(account) onlyManager{
         require(_evidence.has(account,dataHash),"CarbonFrugalEvidence removeEvidence：不存在对应的存证数据！");
          _evidence.remove(account,dataHash);
          emit EvidenceRemoved(msg.sender,account,dataHash);
     }
    
    
    //用户转让，用户操作
    function sendTransaction(address to, uint256 value, bytes32 dataHash, string dataJson,bytes signStr,string timeCertificate) public onlyUser(msg.sender) signVerify(msg.sender,dataHash,signStr){
        AuthService.send(msg.sender, to, value);
       emit Send(msg.sender, to, dataHash, dataJson, signStr, timeCertificate);
    }
    
    //用户核对，销毁
    //平台操作，需要用户签名
    function destroyTransaction(address account, uint256 value, bytes32 dataHash, string dataJson,bytes signStr,string timeCertificate) public onlyUser(account) onlyManager  signVerify(account,dataHash,signStr){
        AuthService.destroy(account, value);
       emit Destroy(msg.sender, account, dataHash, dataJson, signStr, timeCertificate);
    }
    
    //查看用户余额，开放无权限限制，需要业务端有选择性开放给指定用户查询
     function selectBalance(address account) public  view returns(uint256){
       return AuthService.balance(account);
     }
}