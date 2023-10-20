pragma solidity^0.6.0;

import "./IERC20.sol";
import "./SafeMath.sol";


//定义接口
contract mytoken is  IERC20 {
    using SafeMath for uint256;
    //定义name
    string tokenName;
    string tokenSymbol;
    uint256 tokenTotalSupply;
    address owner;
    //user's balance 
    mapping(address=>uint256) balances;
    // A->B = 100 A->C 200 
    mapping(address=>mapping(address=>uint256)) allows;
    
    constructor(string memory n, string memory s) public {
        tokenName = n;
        tokenSymbol = s;
        owner = msg.sender;
    }
    
    function mint(address _to, uint256 _value) external returns (bool success) {
        require(_value > 0, "_value must > 0");
        require(address(0) != _to, "to must a valid address");
        require(msg.sender == owner, "only owner can do");
        
        //balances[_to] += _value;
        balances[_to] = balances[_to].add(_value);
        //tokenTotalSupply += _value;
        tokenTotalSupply = tokenTotalSupply.add(_value);
        emit Transfer(address(0), _to, _value);
        success = true;
    }
    
   function name() override external view returns (string memory) {
       return tokenName;
   }
   function symbol() override external view returns (string memory) {
       return tokenSymbol;
   }
   function totalSupply() override external view returns (uint256) {
       return tokenTotalSupply;
   }
   function balanceOf(address _owner) override external view returns (uint256 balance) {
       return balances[_owner];
   }
   function transfer(address _to, uint256 _value) override external returns (bool success) {
       require(_value > 0, "_value must > 0");
       require(address(0) != _to, "to must a valid address");
       require(balances[msg.sender] >= _value, "user's balance must enough");
       
       //balances[msg.sender] -= _value;
       balances[msg.sender] = balances[msg.sender].sub(_value);
       //balances[_to] += _value;
       balances[_to] = balances[_to].add(_value);
       
       emit Transfer(msg.sender, _to, _value);
       return true;
   }
   function approve(address _spender, uint256 _value) override external returns (bool success) {
       success = false;
       require(_value > 0, "_value must > 0");
       require(address(0) != _spender, "_spender must a valid address");
       require(balances[msg.sender] >= _value, "user's balance must enough");
       
       allows[msg.sender][_spender] = _value;
       
       emit Approval(msg.sender, _spender, _value);
       success = true;
       return true;
   }
   function transferFrom(address _from, address _to, uint256 _value) override external returns (bool success) {
       require(_value > 0, "_value must > 0");
       require(address(0) != _to, "to must a valid address");
       require(balances[_from] >= _value, "user's balance must enough");
       
       //balances[_from]  -= _value;
       balances[_from] = balances[_from].sub(_value);
       //balances[_to] += _value;
       balances[_to] = balances[_to].add(_value);
       //allows[_from][msg.sender] -= _value;
       allows[_from][msg.sender] = allows[_from][msg.sender].sub(_value);
       
       success = true;
       emit Transfer(_from, _to, _value);
   }
   function allowance(address _owner, address _spender) override external view returns (uint256 remaining) {
       return allows[_owner][_spender];
   }

}
