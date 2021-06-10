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

     //1��������� ����
      
      //�趨��������Ա
    address internal _admin;
 
      //��Ȩ��ɹ������û�����
    mapping(address=>bool) internal permitManagerMapping;
  
   
    modifier onlyAdmin(){
        require(tx.origin == _admin, "AuthService onlyAdmin���㲻�ǳ�������Ա���޷����ж�Ӧ������");      
        _;
    }
    modifier onlyManager(){
        require(permitManagerMapping[tx.origin] ==true, "AuthService onlyManager���㲻����Ȩ�����ߣ��޷����ж�Ӧ������");      
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

    //ע���û�����Ȩ�߲���
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
    
        //�޸���Ȩ��address userAddress �û���ַ .bool permitState ��Ȩ״̬ true ������false�ر�
    function changePermitManager(address userAddress,bool permitState) public onlyAdmin returns(uint256){
         require(userAddress != address(0), "AuthService changePermitManager: �˻�Ϊ�յ�ַ��");
          uint256 state=0;
         string memory stateMessage="";
         permitManagerMapping[userAddress]=permitState;
         if(permitManagerMapping[userAddress]==permitState){
                state=1;
               stateMessage="AuthService addAuthUser:��Ȩ״̬�޸ĳɹ�!";
            }else{
               stateMessage="AuthService addAuthUser:��Ȩ״̬�޸�ʧ��!";
         }
          emit  SetPermitUserEvent(tx.origin,userAddress,state,permitState,now,stateMessage);
          return state;
    }
}

//�����ܴ�֤���ֺ�Լ
contract CarbonFrugalEvidence is AuthService {


    using EvidencesRepository for EvidencesRepository.Evidence;
    
    event authDeviceOperation(address indexed operaAccount,address indexed account,bool state);
    event EvidenceAdded(address indexed operaAccount,address indexed account,bytes32 indexed dataHash, string dataJson,bytes signStr,string timeCertificate,uint256 value);
    event EvidenceRemoved(address indexed operaAccount, address indexed account,bytes32 indexed dataHash);
    
     //���û������ӻ���������ֻ�д�֤�ɹ������
     event AddBalanced(address indexed operaAccount,address indexed to, uint256 value, bytes32 dataHash);
     //ת��
     event Send(address indexed from, address indexed to, bytes32 dataHash, string dataJson,bytes signStr,string timeCertificate);
     //���٣�ƽ̨�ж��û����������٣���Ҫ�û���ǩ��
     event Destroy(address indexed operaAccount, address indexed account, bytes32 indexed dataHash,string dataJson,bytes signStr,string timeCertificate);
     
    EvidencesRepository.Evidence private _evidence;
    
    //��Ȩ����豸
    mapping(address=>bool) private _authDevice;

    //��֤��ע���û�
    modifier onlyUser(address account){
        require(AuthService.isAuthUser(account)==true, "CarbonFrugalEvidence onlyUser:������ע���û�,�ſ��Խ���̼���ܴ�֤��");      
        _;
    }
    
     modifier onlyAuthDevice(){
         require(_authDevice[msg.sender] ==true, "CarbonFrugalEvidence onlyAuthDevice��δ��Ȩ�豸���޷����ж�Ӧ������");      
        _;
    }
    

    //��֤�û��洢����ǩ����ָ���˻���ƥ���
      modifier signVerify(address account,bytes32 dataHash,bytes signStr){
       address  retAddr= ECDSA.recover(dataHash,signStr);
        require(retAddr==account,"CarbonFrugalEvidence signVerify:����ǩ���͵�ǰ��Ҫ��֤�û���һ��!");
        _;
    }
    
    //����չ���캯������
    constructor() AuthService() public {
    
    }
    
    //Ϊ�豸��Ȩ
    function setAuthDevice(address account) public onlyManager{
         require(account != address(0), "CarbonFrugalEvidence  setAuthDevice: ��Ȩ�豸Ϊ�յ�ַ��");
        _authDevice[account]=true;
      emit authDeviceOperation(msg.sender,account,true);
    }
    //�ر��豸Ȩ��
    function changeAuthDevice(address account) public onlyManager{
         require(account != address(0), "CarbonFrugalEvidence  changeAuthDevice: ��Ȩ�豸Ϊ�յ�ַ��");
        _authDevice[account]=false;
    emit authDeviceOperation(msg.sender,account,false);
    }
    
    
    /**
     * ��Ӵ�֤,ƽ̨������
     * account      : �û���ַ
     * dataHash     : dataJson��sha256
     * dataJson     : ҵ������
     * signStr      : �û�˽Կ��dataHash��ǩ������
     * timeCertificate  : ʱ����ʱSN
     * value        : ��������
     * 
    **/
   function addEvidence(address account,bytes32 dataHash, string dataJson,bytes signStr,string timeCertificate,uint256 value)  public onlyUser(account) onlyAuthDevice signVerify(account,dataHash,signStr) {
           
         _evidence.add(account,dataHash,dataJson,signStr,timeCertificate);
        require(_evidence.has(account,dataHash),"CarbonFrugalEvidence addEvidence�� ��֤ʧ�ܣ������������쳣��"); 
        emit EvidenceAdded(msg.sender,account,dataHash,dataJson,signStr,timeCertificate,value);
        //����������¼
        AuthService.addBalance(account,value);
        emit AddBalanced(msg.sender,account,value,dataHash);
      
   }
   
    
     //���� ���Ÿ������˲�ѯ,�ṩ���ժҪ��Ϣ��ҵ�����Ҫ������ָ�����û���ѯ�����ߺ�̨�˲�
     function selectEvidence(address account,bytes32 dataHash)  public view returns(string) {
        return _evidence.selectEvidence(account,dataHash);
     }
     
     //ɾ����֤����Ȩ�����߲���
      function removeEvidence(address account, bytes32 dataHash) public onlyUser(account) onlyManager{
         require(_evidence.has(account,dataHash),"CarbonFrugalEvidence removeEvidence�������ڶ�Ӧ�Ĵ�֤���ݣ�");
          _evidence.remove(account,dataHash);
          emit EvidenceRemoved(msg.sender,account,dataHash);
     }
    
    
    //�û�ת�ã��û�����
    function sendTransaction(address to, uint256 value, bytes32 dataHash, string dataJson,bytes signStr,string timeCertificate) public onlyUser(msg.sender) signVerify(msg.sender,dataHash,signStr){
        AuthService.send(msg.sender, to, value);
       emit Send(msg.sender, to, dataHash, dataJson, signStr, timeCertificate);
    }
    
    //�û��˶ԣ�����
    //ƽ̨��������Ҫ�û�ǩ��
    function destroyTransaction(address account, uint256 value, bytes32 dataHash, string dataJson,bytes signStr,string timeCertificate) public onlyUser(account) onlyManager  signVerify(account,dataHash,signStr){
        AuthService.destroy(account, value);
       emit Destroy(msg.sender, account, dataHash, dataJson, signStr, timeCertificate);
    }
    
    //�鿴�û���������Ȩ�����ƣ���Ҫҵ�����ѡ���Կ��Ÿ�ָ���û���ѯ
     function selectBalance(address account) public  view returns(uint256){
       return AuthService.balance(account);
     }
}