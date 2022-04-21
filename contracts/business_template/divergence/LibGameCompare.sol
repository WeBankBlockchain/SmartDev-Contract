// SPDX-License-Identifier: UNLICENSED

// 定义library 计算获胜方
library LibGameCompare {
    // 玩家1 & 玩家2 
    // 返回值: 0 - 相等 ; 1 - 大于 ; 2 - 小于
    function max(uint8 a, uint8 b) internal pure returns (uint8) {
        require(a <= 2);
        require(b <= 2);
        if(a == b) {
            return 0;
        } else if(a > b) {
            // 1 ,0 ; 2,1; 2, 0
            return a - b;

        } else {
            if(b - a == 2) return 1;
            if(b - a == 1) return 2;
        }

        return 0;
    }
}