pragma solidity ^0.4.25;
import "./SafeMath.sol";
import "./Proxy.sol";

contract RedPacket {
    //定义土豪
    address theRich;
    //定义红包的数据
    uint256 public totalAmount;//红包金额
    uint256 public leftAmount;//剩余金额
    uint256 public count;//红包数量
    bool    isEqual;//是否等额
    Proxy proxyContract;//红包的合约地址
    using SafeMath for uint256;
    //抢过了不能再抢
    mapping(address=>bool) isGrabed;
    
    //构造函数：土豪执行，顺带将红包也发了
    constructor() public  {
        proxyContract = new Proxy();//创建代理合约对象
        
    }
    
    //调用前，用户需要先调用积分合约的授权给本合约
    function sendRedPacket(uint256 c, bool ok, address addr, uint256 amount) public {
        require(count == 0, "the red packet already exists");
        require(address(0) != addr, "addr is 0");
        require(amount > 0, "amount is 0");
        require(c > 0, "c is 0");
        isEqual = ok;
        count   = c;
        proxyContract.setPointAddr(addr);//绑定要发送的积分合约地址
        require(proxyContract.balanceOf(msg.sender) > 0, "user's balance not enough");
        leftAmount = totalAmount = amount;
        theRich = msg.sender;
    }
    
    //抢红包
    function grabRedpacket() public  {
        require(count > 0, "count must > 0");
        require(leftAmount > 0, "leftAmount must > 0");
        require(!isGrabed[msg.sender], "msg.sender must has not grabed");
        isGrabed[msg.sender] = true;
        
        //如果是最后一个红包-- 直接拿走
        if(count == 1) {
            proxyContract.transfer(theRich, msg.sender, leftAmount);
            leftAmount = 0;
        } else {
            //是否为等额
            if(isEqual) {
               uint256 transferAmount = leftAmount / count;
               leftAmount = leftAmount.sub(amount);
               proxyContract.transfer(theRich, msg.sender, amount);
            } else {
                //计算一个10以内的随机值 
                uint256 random = uint256(keccak256(abi.encode(msg.sender, theRich, count, leftAmount, now))) % 8 + 1;
                uint256 amount = totalAmount * random / 10;
                proxyContract.transfer(theRich, msg.sender, amount);
                leftAmount = leftAmount.sub(amount);
                
            }
        }
        count --;
    }
    
    function getProxy() public view returns (address) {
        return proxyContract.addr();
    }
}