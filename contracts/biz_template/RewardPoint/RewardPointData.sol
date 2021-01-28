pragma solidity ^0.6.10;

import "./BasicAuth.sol";
import "./IssuerRole.sol";

contract RewardPointData is BasicAuth, IssuerRole {

    mapping(address => uint256) private _balances;
    mapping(address => bool) private _accounts;
    uint256 public _totalAmount;
    string public _description;
    address _latestVersion; 

    constructor(string memory description) public {
        _description = description;
    }

    modifier onlyLatestVersion() {
       require(msg.sender == _latestVersion);
        _;
    }

    function upgradeVersion(address newVersion) public {
        require(msg.sender == _owner);
        _latestVersion = newVersion;
    }
    

    function setBalance(address a, uint256 value) onlyLatestVersion public returns (bool) {
        _balances[a] = value;
        return true;
    }

    function setAccount(address a, bool b) onlyLatestVersion public returns (bool) {
        _accounts[a] = b;
        return true;
    }

    function setTotalAmount(uint256 amount) onlyLatestVersion public returns (bool) {
        _totalAmount = amount;
        return true;
    }

    function getAccountInfo(address account) public view returns (bool, uint256) {
        return (_accounts[account], _balances[account]);
    }

    function hasAccount(address account) public view returns(bool) {
         return _accounts[account];
    }

    function getBalance(address account) public view returns (uint256) {
        return _balances[account];
    }
   
}

