pragma solidity ^0.4.25;


import "./CopyrightManager.sol";
import "./LicenseManager.sol";
import "./RoyaltyManager.sol";

contract IntellectualPropertyManager {
  
 
    // 引用子合约
    CopyrightManager public copyrightManager;
    LicenseManager public licenseManager;
    RoyaltyManager public royaltyManager;

    struct Dispute {
    bytes32 workHash;
    address claimant;
    string reason;//理由
    uint256 timestamp;
    bool resolved;//纠纷是否已经解决。
   }

   Dispute[] public disputes;
   mapping(bytes32 => uint256[]) public workDisputes;
// 事件：纠纷解决
    event DisputeResolved(uint256 indexed disputeId, bool success);
  // 事件：纠纷创建
    event DisputeCreated(bytes32 indexed workHash, address indexed claimant, string reason);

   
    constructor(address _copyrightManager, address _licenseManager, address _royaltyManager) public {
        // 初始化子合约地址
        copyrightManager = CopyrightManager(_copyrightManager);
        licenseManager = LicenseManager(_licenseManager);
        royaltyManager = RoyaltyManager(_royaltyManager);
    }

    // 作品登记
    function registerWork(bytes32 workHash, string _title, string _metadata) public {
        copyrightManager.registerWork(workHash, _title, _metadata);
    }

    // 修改作品信息
    function updateWork(bytes32 workHash, string newTitle, string newMetadata) public {
        copyrightManager.updateWork(workHash, newTitle, newMetadata);
    }

    // 撤销作品登记
    function revokeWork(bytes32 workHash) public {
        copyrightManager.revokeWork(workHash);
    }
    // 获取作品信息
    function getWork(bytes32 workHash) public view returns (address owner, string title, uint256 timestamp, string metadata) {
    (owner, title, timestamp, metadata, ) = copyrightManager.works(workHash);
}

    // 授权许可
    function grantLicense(bytes32 workHash, uint256 licenseType, address licensee, uint256 validUntil) public {
    (address workOwner, , , ) = getWork(workHash);
    licenseManager.grantLicense(workHash, workOwner, licenseType, licensee, validUntil);
}

    // 修改许可
   function updateLicense(bytes32 workHash, uint256 licenseIndex, uint256 newLicenseType, uint256 newValidUntil) public {
    (address workOwner, , , ) = getWork(workHash);
    licenseManager.updateLicense(workHash, workOwner, licenseIndex, newLicenseType, newValidUntil);
}

    // 撤销许可
   function revokeLicense(bytes32 workHash, uint256 licenseIndex) public {
    (address workOwner, , , ) = getWork(workHash);
    licenseManager.revokeLicense(workHash, workOwner, licenseIndex);
}

   // 设置定价策略
   function setPricing(bytes32 workHash, uint256 price) public {
    (address workOwner, , , ) = getWork(workHash);
    royaltyManager.setPricing(workHash, workOwner, price);
}

   // 更新收益分配
   function updateDistribution(bytes32 workHash, address participant, uint256 percentage) public {
    (address workOwner, , , ) = getWork(workHash);
    royaltyManager.updateDistribution(workHash, workOwner, participant, percentage);
}

   // 撤销定价策略
   function revokePricing(bytes32 workHash) public {
    (address workOwner, , , ) = getWork(workHash);
    royaltyManager.revokePricing(workHash, workOwner);
}



// 创建纠纷
///作品所有者：如果作品所有者发现有人侵犯了他们的知识产权（例如未经授权地使用、复制或分发作品），他们可以发起纠纷来保护自己的权益。
//被许可者：如果被许可者发现许可的有效性或可执行性存在问题，或者认为自己的权益受到侵害（例如发现许可的内容与实际约定不符），他们也可以发起纠纷。
//第三方：在某些情况下，与作品或许可相关的第三方（例如合作伙伴、监管机构等）也可能会发起纠纷。这可能是因为他们发现了潜在的法律问题、权益冲突等。
function createDispute(bytes32 workHash, string reason) public {
    uint256 disputeId = disputes.length;
    disputes.push(Dispute(workHash, msg.sender, reason, now, false));
    workDisputes[workHash].push(disputeId);

    // 触发纠纷创建事件
    emit DisputeCreated(workHash, msg.sender, reason);
}

// 解决纠纷（只有作品拥有者可以操作）先调用getWorkDisputesCount或者getWorkDisputes，再来调用这个，填充disputeId 参数，通过disputes 和id 查看具体的纠纷
function resolveDispute(uint256 disputeId, bool success) public {
    Dispute storage dispute = disputes[disputeId];
    require(!dispute.resolved, "纠纷已解决");

    address workOwner;
    (workOwner, , , , ) = copyrightManager.works(dispute.workHash);
    require(workOwner == msg.sender, "只有作品拥有者可以进行操作");

    dispute.resolved = true;

    // 触发纠纷解决事件
    emit DisputeResolved(disputeId, success);
}

// 获取作品相关纠纷数量
function getWorkDisputesCount(bytes32 workHash) public view returns (uint256) {
    return workDisputes[workHash].length;
}

// 获取作品相关纠纷ID列表
function getWorkDisputes(bytes32 workHash) public view returns (uint256[]) {
    return workDisputes[workHash];
}   


  
}
