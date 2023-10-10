pragma solidity ^0.4.25;


contract LicenseManager {

    struct License {
        uint256 licenseType;//1 独家商业许可，2 非商业许可，3 免费分发
        address licensee;//被许可者。这是一个以太坊地址，表示获得许可的一方。例如，在知识产权管理的场景中，被许可者可以是获得使用作品权限的用户。
        uint256 validUntil;//有效期。这是一个 Unix 时间戳，表示许可的截止日期。在有效期内，被许可者可以依据许可类型使用作品。
        bool exists;//存在标志。这是一个布尔值，表示许可是否存在。当许可被创建或激活时，此值为 true；当许可被撤销或失效时，此值为 false。
    }

    mapping(bytes32 => License[]) public licenses;

    event LicenseGranted(bytes32 indexed workHash, uint256 indexed licenseType, address indexed licensee, uint256 validUntil);
    event LicenseUpdated(bytes32 indexed workHash, uint256 indexed licenseIndex, uint256 newLicenseType, uint256 newValidUntil);
    event LicenseRevoked(bytes32 indexed workHash, uint256 indexed licenseIndex);

    modifier onlyWorkOwner(address workOwner) {
        require(tx.origin == workOwner, "只有作品拥有者可以进行操作");
        _;
    }

    function grantLicense(bytes32 workHash, address workOwner, uint256 licenseType, address licensee, uint256 validUntil) public onlyWorkOwner(workOwner) {
        licenses[workHash].push(License(licenseType, licensee, validUntil, true));
        emit LicenseGranted(workHash, licenseType, licensee, validUntil);
    }

    //licenseIndex 默认为0
    function updateLicense(bytes32 workHash, address workOwner, uint256 licenseIndex, uint256 newLicenseType, uint256 newValidUntil) public onlyWorkOwner(workOwner) {
        require(licenses[workHash][licenseIndex].exists, "许可不存在");
        licenses[workHash][licenseIndex].licenseType = newLicenseType;
        licenses[workHash][licenseIndex].validUntil = newValidUntil;
        emit LicenseUpdated(workHash, licenseIndex, newLicenseType, newValidUntil);
    }

      function revokeLicense(bytes32 workHash, address workOwner, uint256 licenseIndex) public onlyWorkOwner(workOwner) {
        require(licenses[workHash][licenseIndex].exists, "许可不存在");
        delete licenses[workHash][licenseIndex];
        emit LicenseRevoked(workHash, licenseIndex);
    }
}
 
