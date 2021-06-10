pragma solidity ^0.4.24;
import "./SafeMath.sol";

   
library AuthUsersRepository {
    
    using SafeMath for uint256;
    struct AuthUser {
        mapping (address=>UserInfo) bearer;
    }
    
    struct UserInfo{
       string cardNo;
       string name;
       uint256 balance;
       bool authorityState;// true ������flase �ر�
       uint createTimeStamp;//����ʱ���
       uint removeTimeStamp;//ɾ��ʱ���
   }
    
    function add(AuthUser storage user, address account,string cardNo,string name) internal {
        require(!has(user, account), "AuthUsers add: �˻��Ѿ����ڣ�");
         user.bearer[account].cardNo = cardNo;
         user.bearer[account].name = name;
         user.bearer[account].authorityState = true;
         user.bearer[account].createTimeStamp = now;
    }

    function remove(AuthUser storage user, address account) internal {
        require(has(user, account), "AuthUsers remove: ������ָ���˻���");
        user.bearer[account].authorityState= false;
        user.bearer[account].removeTimeStamp = now;
    }

    function has(AuthUser storage user, address account) internal view returns (bool) {
        require(account != address(0), "AuthUsers has: �˻�Ϊ�յ�ַ��");
        return user.bearer[account].authorityState;
    }
    
    //������
    function addBalance(AuthUser storage user,address to,uint256 value) internal{
        
         require(has(user, to), "AuthUsers addBalance: ���ܷ�����ע���û���");
          user.bearer[to].balance = user.bearer[to].balance.add(value);
    }
    
    //ת��
   function send(AuthUser storage user,address from, address to, uint256 value) internal {
        require(to != address(0), "AuthUsers send: ���շ��˻�Ϊ�յ�ַ��");
         require(has(user, from), "AuthUsers send: ת��������ע���û���");
         require(has(user, to), "AuthUsers send: ���շ�����ע���û���");
        user.bearer[from].balance = user.bearer[from].balance.sub(value);
         user.bearer[to].balance  = user.bearer[to].balance.add(value);
       
    }
    
    //����
    function destroy(AuthUser storage user,address from, uint256 value) internal {
         require(has(user, from), "AuthUsers destroy: ָ���˻������ڣ�");
        user.bearer[from].balance = user.bearer[from].balance.sub(value);
    }
    
    //�鿴���
    function balance(AuthUser storage user,address account) internal view returns(uint256){
         require(has(user, account), "AuthUsers balance: ָ���˻������ڣ�");
       return user.bearer[account].balance;
    }
}
