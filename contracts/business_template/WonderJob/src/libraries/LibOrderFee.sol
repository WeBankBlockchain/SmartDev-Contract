// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Order} from "./OrderExecutor.sol";

library OrderFeeFulfil {
    
    struct FeeConfig {
        // Gas saving, skip read from zero to ...
        uint24  feeDecimal; // [24: 256]  1: MINIMUM_PERCENT_PRECISION  2: MAXIMUM_PERCENT_PRECISION
        uint24  feeScale; // [48: 256]
        uint24  feeMaxScale; // [72: 256]
        uint24  feeMinScale; // [96: 256]
        address lastExecutor; // [256: 256]
        bool    feeOn;
        address feeTo;
    }

    uint256 internal constant MINIMUM_PERCENT_PRECISION = 1_000; // 0.0X% 
    uint256 internal constant MAXIMUM_PERCENT_PRECISION = 1_000_00; // 0.00X%

    function setFeeScale(FeeConfig storage self, uint24[4] memory feeScales, address executor, address feeTo) internal {
        if (self.lastExecutor != executor) self.lastExecutor = executor;
        require(
            feeScales[0] >= feeScales[1] && feeScales[0] <= feeScales[2],
                "FeeScale cannot exceed the limit"
        );

        self.feeScale = feeScales[0];
        self.feeMinScale = feeScales[1];
        self.feeMaxScale = feeScales[2];
        self.feeDecimal = feeScales[3];
        self.feeTo = feeTo;
    }

    function setFeeOn(FeeConfig storage self, address executor) internal {
        if (self.lastExecutor != executor) self.lastExecutor = executor;
        self.feeOn = true;
    }

    function setFilpFeeOn(FeeConfig storage self, address executor) internal {
        if (self.lastExecutor != executor) self.lastExecutor = executor;
        // Turn off fee.
        self.feeOn = false;
    }

    function _getFeeConfigParams(FeeConfig storage self) internal view returns (
        uint24 feeDecimal,
        uint24 feeScale,
        uint24 feeMaxScale,
        uint24 feeMinScale,
        address lastExecutor,
        bool feeOn,
        address feeTo
    ) {
        FeeConfig storage config = self;
        return (config.feeDecimal, config.feeScale, config.feeMaxScale, config.feeMinScale, config.lastExecutor, config.feeOn, config.feeTo);
    }
}
