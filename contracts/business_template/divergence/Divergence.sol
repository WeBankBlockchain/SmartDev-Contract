// SPDX-License-Identifier: UNLICENSED
pragma solidity^0.6.10;
import "./LibGameCompare.sol";
import "./IDivergence.sol";

// 玩家信息
struct Player {
    address addr;
    string  name;  
    uint8   opt;   // 出手选项 0 - 剪刀，1 - 石头，2 - 布
    bytes32 hash;  
    uint256 round; // 出手轮次
    uint8   status; // 状态：0 - 未出手；1 - 已经出手；2 - 已提交证明
}


// 合约实现
contract Divergence is IDivergence {

    // 控制玩家数量=2 
    uint8 userCount;
    // 记录玩家信息
    Player[2] playerlist;
    // 游戏是否结束
    bool isFinished; // 默认值 false
    // 记录胜利玩家
    uint8 winnerIndex;
    // 出手内容定义
    string[3]  gameOpts =  ["scissors", "rock", "paper"];

    // 出手event
    event Punch(address indexed addr, bytes32 hash);
    // 提出证明
    event Proof(address indexed addr, uint8 opt, string salt);
    // 胜出通知
    event WinnerBorn(address indexed winner, string name, uint8 opt, uint256 round);

    // 注册
    function register(string memory _name) override external {
        require(userCount < 2, "two player already go");
        playerlist[userCount].addr = msg.sender;
        playerlist[userCount].name = _name;
        userCount ++;
        if(userCount == 2) {
            require(playerlist[0].addr != playerlist[1].addr, "You can not play this game with yourself");
        }
    }
    // 出手 先出手不用关心对方出什么，后出手的需要判断对方是什么，决定游戏是否结束
    function punch(bytes32 _hash) override external {
        // 1. 玩家身份
        require(isPlayer(msg.sender), "only register player can do");
        // 2. 游戏没有结束 
        require(!isFinished, "game already finished");
        // 3. 两个玩家具备了再开始
        require(userCount == 2, "please wait a rival");
        
        (uint8 host, uint8 rival) = getIndex(msg.sender);

        Player storage player = playerlist[host];
        // 判断对方是否出手
        require(player.round <= playerlist[rival].round, "please wait");
        // 4. 玩家尚未出手 
        require(player.status == 0, "player already throw a punch");
        player.hash = _hash;
        player.round ++;
        player.status = 1;
        
        emit Punch(msg.sender, _hash);
        
    }
    // 证明
    function proofing(string memory _salt, uint8 _opt) override external {
        // 1. 游戏没有结束 
        require(!isFinished, "game already finished");
        bytes32 hash = keccak256(abi.encode(_salt, _opt));
        // 区分玩家1 和 玩家2 
        (uint8 host, uint8 rival) = getIndex(msg.sender);
        Player storage player = playerlist[host];
        require(player.round == playerlist[rival].round, "It may not safe to commit proof");
        require(player.status == 1, "user can not commit proof at current status");
        player.status = 2;
        if(_opt > 2 || hash != player.hash) {
            // 直接判负
            isFinished = true;
            winnerIndex = rival;
            // 触发事件
            emit WinnerBorn(playerlist[winnerIndex].addr, playerlist[winnerIndex].name, playerlist[winnerIndex].opt, playerlist[winnerIndex].round);
            return;
        }
        emit Proof(msg.sender, _opt, _salt);
        player.opt = _opt;
        if(player.status == 2 && playerlist[rival].status == 2) {
            // 处理胜负逻辑
            uint8 win = LibGameCompare.max(player.opt, playerlist[rival].opt);
            if(win == 1) {
                isFinished = true;
                winnerIndex = host;
            } else if(win == 2) {
                isFinished = true;
                winnerIndex = rival;
            } else {
                playerlist[rival].status = 0;
                player.status  = 0;
            }
            if(isFinished) {
                // 触发事件
                emit WinnerBorn(playerlist[winnerIndex].addr, playerlist[winnerIndex].name, playerlist[winnerIndex].opt, playerlist[winnerIndex].round);
            }
            
        }
        
    }
    // 查看获胜
    // 返回值： 1. 昵称 2. 玩家1出手 3. 玩家2出手 4. 轮次
    function winner() override external view returns (string memory, string memory, string memory, uint256) {
        if(!isFinished) {
            return ("none", "none", "none", 88888);
        }

        uint8 rival = 0; // 表示输的一方下标
        if(winnerIndex == 0) rival = 1;

        return (
            playerlist[winnerIndex].name, 
            gameOpts[playerlist[winnerIndex].opt],
            gameOpts[playerlist[rival].opt],
            playerlist[winnerIndex].round
        );
    }

    // 判断是否是注册玩家
    function isPlayer(address _addr) public view returns (bool) {
        if(_addr == playerlist[0].addr || _addr == playerlist[1].addr) return true;
        return false;
    }
    //yekai 123 2 0xe4c1209281b0ee06c09e03055af06926da954ba2697a9798e20ae11ed9bb531e
    //fuhongxue 123 1 0x5610d70754a691266ad97a972c2306bd75073fa9756a5cfeada56b6ab4aefd0e
    function helper(string memory _salt, uint8 _opt) public view returns (bytes32) {
        return keccak256(abi.encode(_salt, _opt));
    }
    
    // 区分本人和对手的序号
    function getIndex(address _addr) internal view returns (uint8, uint8) {
        // 区分玩家1 和 玩家2 
        uint8 host; // 代表本人
        uint8 rival; // 代表对方
        if(playerlist[0].addr == _addr) {
            host = 0;
            rival = 1;
        } else {
            host = 1;
            rival = 0;
        }
        
        return (host, rival);
    }
    
    // 重新开始游戏
    function reset() external {
        require(isFinished, "game is running");
        isFinished = false;
        playerlist[0].status = 0;
        playerlist[0].round  = 0;
        playerlist[1].status = 0;
        playerlist[1].round  = 0;
    }
}