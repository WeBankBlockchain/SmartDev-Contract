// SPDX-License-Identifier: MIT
pragma solidity ^0.6.10;

// 许可证是授予自然人（例如您）或法人（例如公司）的有限且临时的权限，可以根据法律框架做一些本来是非法的事情
// 政府负责许可证的颁发和管理。然而，维护和共享这些数据可能很复杂且效率低下
// 许可证的授予通常需要提交纸质申请表、人工监督适用的立法和将数据输入注册表，以及颁发纸质许可证
// 如果个人希望查看有关许可证登记处的信息，他们通常需要到政府办公室并填写进一步​​的纸质查询表格，以便访问该数据（如果公开可用）
// Licences合约允许通过智能合约授予和/或管理许可证。其动机本质上是为了解决当前许可系统固有的低效率问题
// 基于EIP-1753协议实现，参考https://eips.ethereum.org/EIPS/eip-1753

//IEIP1753 接口：定义了一组函数，包括授权、撤销授权、发放许可证、撤销许可证、检查许可证是否有效等。
interface IEIP1753 {
function grantAuthority(address who) external;
function revokeAuthority(address who) external;
function hasAuthority(address who) external view returns (bool);

function issue(address who, uint256 from, uint256 to)  external;
function revoke(address who) external;

function hasValid(address who)  external view returns (bool);
function purchase(address who, uint256 validFrom, uint256 validTo) external;
function getName() external view returns (string memory);
function getTotalSupply() external view returns(uint);
}

//EIP1753 合约：实现了 IEIP1753 接口，提供了授权、撤销授权、发放许可证、撤销许可证、检查许可证是否有效等功能。合约中包括 Permit 结构体，用于存储许可证信息。合约还实现了 onlyOwner 和 onlyAuthority 修饰符，用于限制某些函数只能由所有者或授权者调用。
contract EIP1753 is IEIP1753 {
// 返回许可证的名称 - 例如"MyPermit"。
string public name;
// 返回许可证总数量
uint256 public totalSupply;

address private _owner;
mapping(address => bool) private _authorities;
mapping(address => Permit) private _holders;

struct Permit {
	address issuer;
	uint256 validFrom;
	uint256 validTo;
    bool    forever;
}

constructor(address owner, string memory _name) public {
	_owner = owner;
    	name  = _name;
}

// 将地址添加到有权修改许可的地址白名单中
function grantAuthority(address who) override public onlyOwner {
	_authorities[who] = true;
}

// 从有权修改许可的地址白名单中删除地址
function revokeAuthority(address who) override public onlyOwner {
	delete _authorities[who];
}

// 检查地址是否有权授予或撤销许可
function hasAuthority(address who)  override public view returns (bool) {
	return _authorities[who] == true;
}

// 在指定的日期范围内向地址颁发许可证
function issue(address who, uint256 start, uint256 end)  override public onlyAuthority {
    if (start == 0 && end == 0) {
        _holders[who] = Permit(_owner, start, end, true);
    } else {
        _holders[who] = Permit(_owner, start, end, false);
    }
	totalSupply += 1;
}

// 从地址撤销许可
function revoke(address who) override public onlyAuthority {
	delete _holders[who];
}

// 检查地址是否具有有效许可
function hasValid(address who) override public view returns (bool) {
    // 如果许可证类型为永久，直接返回
   return (_holders[who].validFrom > now && _holders[who].validTo < now && !_holders[who].forever) || (_holders[who].forever);
}

// 允许用户自行购买许可证
function purchase(address who, uint256 validFrom, uint256 validTo)  override external {
    issue(who, validFrom, validTo);
}

function getName() public override view returns (string memory) {
    return name;
}

function getTotalSupply() public override view returns(uint) {
    return totalSupply;
}

modifier onlyOwner() {
	require(tx.origin == _owner, "Only owner can perform this function");
	_;
}

modifier onlyAuthority() {
	require(hasAuthority(msg.sender), "Only an authority can perform this function");
    _;
}
