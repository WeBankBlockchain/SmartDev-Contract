pragma solidity 0.4.25;

import "./BasicAuth.sol";
import "./RewardPointController.sol";
import "./RewardPointData.sol";


contract Admin is BasicAuth {
    address public _dataAddress; 
    address public _controllerAddress;

    constructor() public {
        RewardPointData data = new RewardPointData("Point of V1");
        _dataAddress = address(data);
        RewardPointController controller = new RewardPointController(_dataAddress);
        _controllerAddress = address(controller);
        data.upgradeVersion(_controllerAddress);
        data.addIssuer(msg.sender);
        data.addIssuer(_controllerAddress);
    }

    function upgradeVersion(address newVersion) public {
        RewardPointData data = RewardPointData(_dataAddress);
        data.upgradeVersion(newVersion);
    }
    
}