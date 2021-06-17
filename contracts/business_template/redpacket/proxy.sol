pragma solidity^0.6.10;
import "./IERC20.sol";

//负责接受积分合约的授权，以完成积分转移
contract proxy {
    IERC20 point;
    address owner;
    constructor() public {
       owner = msg.sender; 
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "only owner can do");
        _;
    }
    
    function setPointAddr(address _addr) public onlyOwner {
        point = IERC20(_addr);
    }
    
    function transfer(address _from, address _to, uint256 _value) external returns (bool success) {
        point.transferFrom(_from, _to, _value);
    }
    
    function allowance(address _from) public view returns (uint256) {
        return point.allowance(_from, address(this));
    }
    
    function balanceOf(address _who) public view returns (uint256) {
        return point.balanceOf(_who);
    }
    
    function addr() public view returns (address) {
        return address(this);
    }
}