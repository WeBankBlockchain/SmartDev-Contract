// SPDX-License-Identifier: MIT
pragma solidity ^0.4.25;
pragma experimental ABIEncoderV2;

import "./CarbonCertificationV2.sol";

// 用于计算企业排名 对企业的排名做积分奖励
contract CarbonExcitationV2 is CarbonCertificationV2 {
    
    // 所有企业的地址
    struct Credit {
        string  enterpriseName;
        address enterpriseAddr;
        uint256 overEmission;
        uint256 enterpriseCredit;
    }
    
    Credit[] public credits;
    
    address[] public winers;
    
    // 这里是返回所有的address
    function selectWinnerOfCompute() public returns(Credit[] memory){
        Credit[] memory credits = new Credit[](enterprisesAddress.length);
        uint256 enterpriseLength = enterprisesAddress.length;
        for (uint i = 0; i < enterpriseLength; ++i){
            credits[i].enterpriseName = enterpriseMap[enterprisesAddress[i]].enterpriseName;
            credits[i].enterpriseAddr = enterpriseMap[enterprisesAddress[i]].enterpriseAddress;
            credits[i].overEmission = enterpriseMap[enterprisesAddress[i]].enterpriseOverEmission;
            credits[i].enterpriseCredit = enterpriseMap[enterprisesAddress[i]].enterpriseCarbonCredits;
        }
        return credits;
    }
    
    
    function winersCredit(address[] memory queryWinners,uint256 _credits) public {
        uint256 _5Credits = _credits * 5;
        uint256 _4Credits = _credits * 4;
        uint256 _3Credits = _credits * 3;
        uint256 _2Credits = _credits * 2;
        for (uint i = 0; i < queryWinners.length; i++) {
            if (i == 0) {
                enterpriseMap[queryWinners[i]].enterpriseCarbonCredits += _5Credits;
                enterpriseMap[queryWinners[i]].qualification.qualificationEmissionLimit += _credits;
            }else if (i == 1) {
                enterpriseMap[queryWinners[i]].enterpriseCarbonCredits += _4Credits;
                enterpriseMap[queryWinners[i]].qualification.qualificationEmissionLimit += _credits;
            }else if(i == 2) {
                enterpriseMap[queryWinners[i]].enterpriseCarbonCredits += _3Credits;
                enterpriseMap[queryWinners[i]].qualification.qualificationEmissionLimit += _credits;
            }else if (i == 3){
                enterpriseMap[queryWinners[i]].enterpriseCarbonCredits += _2Credits;
            }else if (i == 4){
                enterpriseMap[queryWinners[i]].enterpriseCarbonCredits += _credits;
            }
        }
    }
}