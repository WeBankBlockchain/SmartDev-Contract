pragma solidity^0.6.0;
import "./IERC20.sol";

//负责接受token合约的授权，以完成token转移
contract proxy {
    IERC20 token;
    address owner;
    constructor() public {
       owner = msg.sender; 
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "only owner can do");
        _;
    }
    
    function setTokenAddr(address _addr) public onlyOwner {
        token = IERC20(_addr);
    }
    
    function transfer(address _from, address _to, uint256 _value) external returns (bool success) {
        token.transferFrom(_from, _to, _value);
    }
    
    function allowance(address _from) public view returns (uint256) {
        return token.allowance(_from, address(this));
    }
    
    function balanceOf(address _who) public view returns (uint256) {
        return token.balanceOf(_who);
    }
    
    function addr() public view returns (address) {
        return address(this);
    }
}