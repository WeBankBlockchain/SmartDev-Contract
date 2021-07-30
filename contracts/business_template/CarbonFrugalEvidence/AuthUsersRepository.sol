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
       bool authorityState;// true 正常，flase 关闭
       uint createTimeStamp;//创建时间戳
       uint removeTimeStamp;//删除时间戳
   }
    
    function add(AuthUser storage user, address account,string cardNo,string name) internal {
        require(!has(user, account), "AuthUsers add: 账户已经存在！");
         user.bearer[account].cardNo = cardNo;
         user.bearer[account].name = name;
         user.bearer[account].authorityState = true;
         user.bearer[account].createTimeStamp = now;
    }

    function remove(AuthUser storage user, address account) internal {
        require(has(user, account), "AuthUsers remove: 不存在指定账户！");
        user.bearer[account].authorityState= false;
        user.bearer[account].removeTimeStamp = now;
    }

    function has(AuthUser storage user, address account) internal view returns (bool) {
        require(account != address(0), "AuthUsers has: 账户为空地址！");
        return user.bearer[account].authorityState;
    }
    
    //添加余额
    function addBalance(AuthUser storage user,address to,uint256 value) internal{
        
         require(has(user, to), "AuthUsers addBalance: 接受方不是注册用户！");
          user.bearer[to].balance = user.bearer[to].balance.add(value);
    }
    
    //转账
   function send(AuthUser storage user,address from, address to, uint256 value) internal {
        require(to != address(0), "AuthUsers send: 接收方账户为空地址！");
         require(has(user, from), "AuthUsers send: 转出方不是注册用户！");
         require(has(user, to), "AuthUsers send: 接收方不是注册用户！");
        user.bearer[from].balance = user.bearer[from].balance.sub(value);
         user.bearer[to].balance  = user.bearer[to].balance.add(value);
       
    }
    
    //销毁
    function destroy(AuthUser storage user,address from, uint256 value) internal {
         require(has(user, from), "AuthUsers destroy: 指定账户不存在！");
        user.bearer[from].balance = user.bearer[from].balance.sub(value);
    }
    
    //查看余额
    function balance(AuthUser storage user,address account) internal view returns(uint256){
         require(has(user, account), "AuthUsers balance: 指定账户不存在！");
       return user.bearer[account].balance;
    }
}