// SPDX-License-Identifier: MIT
pragma solidity ^0.6.10;

// 许可证是授予自然人（例如您）或法人（例如公司）的有限且临时的权限，可以根据法律框架做一些本来是非法的事情
// 政府负责许可证的颁发和管理。然而，维护和共享这些数据可能很复杂且效率低下
// 许可证的授予通常需要提交纸质申请表、人工监督适用的立法和将数据输入注册表，以及颁发纸质许可证
// 如果个人希望查看有关许可证登记处的信息，他们通常需要到政府办公室并填写进一步​​的纸质查询表格，以便访问该数据（如果公开可用）
// Licences合约允许通过智能合约授予和/或管理许可证。其动机本质上是为了解决当前许可系统固有的低效率问题
// 基于EIP-1753协议实现，参考https://eips.ethereum.org/EIPS/eip-1753
interface IEIP1753 {
	function grantAuthority(address who)  external;
	function revokeAuthority(address who)  external;
	function hasAuthority(address who)  external view returns (bool);
	
	function issue(address who, uint256 from, uint256 to)  external;
	function revoke(address who) external;
	
	function hasValid(address who)  external view returns (bool);
	function purchase(address who, uint256 validFrom, uint256 validTo) external;
    function getName() external view returns (string memory);
    function getTotalSupply() external view returns(uint);
}

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
}

// 在EIP-1753上进行了改进：增加了许可证可永久授权，适配更多应用场景
contract Licences {

    enum LicencesMode{
        DeadlineLicence,
        ForeverLicence
    }

    IEIP1753 public licences;
    
    constructor(string memory _name) public {
        // 初始化许可证协议
        licences = IEIP1753(new EIP1753(msg.sender, _name));
        // 合约默认具备修改权限
        licences.grantAuthority(address(this));
        licences.grantAuthority(address(msg.sender));
    }

    function addAuthority(address[] calldata authors) public {
        require(authors[0] != address(0), "The wrong address");
        
        if (authors.length == 1) licences.grantAuthority(authors[0]);
        for (uint i=0; i < authors.length; i++) {
            require(authors[i] != address(0), "The wrong address");
            licences.grantAuthority(authors[i]);
        }
    }

    function revokeAuthority(address[] calldata authors) public {
        require(authors[0] != address(0), "The wrong address");

        if (authors.length == 1) licences.revokeAuthority(authors[0]);
        for (uint i=0; i < authors.length; i++) {
            require(authors[i] != address(0), "The wrong address");
            licences.revokeAuthority(authors[i]);
        }
    }

    // 允许用户自行购买许可证
    function purchase(uint256 validFrom, uint256 validTo, uint mode) public {
        if (mode == uint(LicencesMode.DeadlineLicence)) {
            licences.purchase(msg.sender, validFrom, validTo);
        } else if (mode == uint(LicencesMode.ForeverLicence)) {
            licences.purchase(msg.sender, 0, 0);
        } else {
            revert("The wrong licence mode");
        }
    }

    function authorityIssue(
        address[] calldata users,
        uint256[] calldata validFrom, 
        uint256[] calldata validTo,
        uint256[] calldata mode
    ) public {
        require(
            users.length == validFrom.length && 
            users.length == validTo.length &&
            users.length == mode.length,
                "The wrong number of users and wrong number of mode");

        if (users.length == 1) {
            if (mode[0] == uint(LicencesMode.DeadlineLicence)) licences.issue(users[0], validFrom[0], validTo[0]);
            licences.issue(users[0], 0, 0);
        }
        for (uint i=0; i < users.length; i++) {
            // 如果`mode`为0
            // 则当前许可证颁发为有效期限，则设置时间期限[start: end]
            if (mode[i] == uint(LicencesMode.DeadlineLicence)) {
                licences.issue(users[i], validFrom[i], validTo[i]);
            // 如果`mode` 为1
            // 当前许可证为永久颁发，则不需要设置时间期限[0: 0]
            } else if (mode[i] == uint(LicencesMode.ForeverLicence)) {
                licences.issue(users[i], 0, 0);
            } else {
                revert("The wrong licence mode");
            }
        }
    }

    function hasValid(address who) public view returns (bool) {
        // 如果许可证类型为永久，直接返回
        return licences.hasValid(who);
	}

    function name() public view returns(string memory) {
        return licences.getName();
    }

    function totalSupply() public view returns(uint) {
        return licences.getTotalSupply();
    }
}
