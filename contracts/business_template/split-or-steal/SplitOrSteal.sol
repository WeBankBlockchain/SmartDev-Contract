// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

struct PlayerOpt {
    uint8 opt;
    bool  isCommited; // 是否提交哈希
    bytes32 hash;
    bool  isVerified; // 是否通过验证
}

contract SplitOrSteal {
    address player1; // 玩家1
    address player2; // 玩家2
    uint    reward = 100; // 模拟的奖金
    address owner; // 合约部署者
    uint    expireTime; // 结束时间
    PlayerOpt[2] opts;
    uint[2] results; // 仅存储玩家的分配方案，不包括超时的情况

    uint8 constant OPT_SPLIT = 2; // 平分
    uint8 constant OPT_STEAL = 4; // 独享


    constructor(address _p1, address _p2) {
        owner = msg.sender;
        player1 = _p1;
        player2 = _p2;
        expireTime = block.timestamp + 600 * 1000;
    }

    modifier onlyPlayer() {
        require(msg.sender == player1 || msg.sender == player2, "only player can operator");
        _;
    }

    modifier checkOpt(uint8 _opt) {
        require(block.timestamp <= expireTime, "timeout!!");
        require(_opt == OPT_SPLIT || _opt == OPT_STEAL, "opt is invalid");
        _;
    }

    // 提交选择
    function submitHash(bytes32 _hash) public onlyPlayer {
        uint index = 0;
        if(player2 == msg.sender) index = 1;
        require(!opts[index].isCommited, "player already submited");
        opts[index].hash = _hash;
        opts[index].isCommited = true;
    }

    // 提交哈希验证
    function submitVerify(uint8 _opt, bytes memory _salt) public onlyPlayer checkOpt(_opt) {
        (uint idx1, uint idx2) = (0, 1);
        if(msg.sender == player2) {
            (idx1, idx2) = (1, 0);
        }
        require(opts[idx2].isCommited, "Opponent did not submit");
        require(opts[idx1].isCommited, "You did not submit");
        opts[idx1].isVerified = true;
        opts[idx1].opt = _opt;
        require(getHash(_opt, _salt) == opts[idx1].hash, "The verification you submitted cannot pass");
        if(opts[idx2].isVerified) {
            //可以计算结果
            calculate(opts[0].opt, opts[1].opt);

            return;
        }
    }
    // 计算分配方案
    function calculate(uint8 _opt1, uint8 _opt2) private {
        if(_opt1 == OPT_SPLIT) {
            if(_opt2 == OPT_SPLIT) {
                results[0] = reward / 2;
                results[1] = reward / 2;
            } else {
                results[0] = 0;
                results[1] = reward;
            }
        } else {
            if(_opt2 == OPT_SPLIT) {
                results[0] = reward ;
                results[1] = 0;
            } else {
                results[0] = 0;
                results[1] = 0;
            }
        }
    }

    // 获得分配结果: player1, player2, owner
    function getResult() public view returns (uint, uint, uint) {
        if(opts[0].isVerified && opts[1].isVerified) {
            return (results[0], results[1], reward - results[0] - results[1]);
        } 
        if(block.timestamp > expireTime) {
            if(opts[0].isVerified && !opts[1].isVerified) {
                return (reward, 0, 0);
            } else if(!opts[0].isVerified && opts[1].isVerified) {
                return (0, reward, 0);
            } else if(!opts[0].isVerified && !opts[1].isVerified) {
                return (0, 0, reward);
            } 
        }
        return (0, 0, 0);  
    }


    // 计算哈希
    function getHash(uint8 _opt, bytes memory _salt) public pure returns (bytes32) {
        return keccak256(abi.encode(_opt, _salt));
    }
}