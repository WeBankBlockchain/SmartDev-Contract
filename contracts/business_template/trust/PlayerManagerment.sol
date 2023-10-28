pragma solidity ^0.6.10;
pragma experimental ABIEncoderV2;

import "./utils/Ownable.sol";

contract PlayerManagerment is Ownable {
    // 现阶段：选手加密流程 第一次加密抽取正式赛排队号码。 第二次加密抽取加密号码 。 第三次抽取座位号码
    // 劣势：排队号码抽取为厂家池抽取，也就是说，厂家1-10号码，那么只能抽取1-10号码。导致裁判不需要解密既可知道当前选手选择的厂家。打分带有主观性，而不具有公平性。
    // 问题：选手如何加密，才能使大家的身份混淆

    // 解决方案（基于统一比赛平台）：
    //  随机加密：对选手最终身份码进行加密；
    struct Player {
        string ID; // 加密后的身份码，需要特定的密钥进行解密，解密后获得选手最终号码
        uint256 A; // A 模块分数
        uint256 B; // B 模块分数
        uint256 C; // C 模块分数
        uint256 updateCount; // 更新次数
    }
    uint256 public querySum; // 总查询次数
    
    constructor() public {
        querySum = 0;
    }

    mapping(uint256 => Player) private players; 
    mapping(bytes32 => uint256) private playerMapIndexs;
    uint256[] private indexs; // 索引数组，每次加入新选手，需要打乱原顺序
    // 添加选手
    function addPlayer(string memory _ID) public onlyOwner returns(uint256) {
        // 使用无序号码(这里使用的伪随机数，存在被模拟出来的可能)
        uint256 seed = uint256(blockhash(block.number - 1));
        uint256 number = uint256(keccak256(abi.encodePacked(_ID, block.timestamp)));
        uint256 index = number ^ seed % 10;
        players[index] = Player(_ID, 0, 0 , 0, 0);
        indexs.push(index);
        playerMapIndexs[bytes32(keccak256(abi.encodePacked(_ID)))] = index;
        if(indexs.length % 2 == 0) {
            _randomIndexs();
        }
        return index;
    }

    function validataPlayerIndex(string memory _playerID, uint256 _index) external view returns(bool) {
        return playerMapIndexs[bytes32(keccak256(abi.encodePacked(_playerID)))] == _index;
    }



    // 将原索引数组顺序打乱
    function _randomIndexs() private {
        // 洗牌算法 Fisher-Yates Shuffle算法
        for (uint256 i = indexs.length - 1; i > 0; i--) {
            uint256 j = uint256(keccak256(abi.encodePacked(block.timestamp, i))) % (i + 1);
            (indexs[i], indexs[j]) = (indexs[j], indexs[i]);
        }
    }

    // 更新A B C 模块分数并添加更新分数次数
    function setPlayerScore(uint256 index, uint256[] memory scores) public onlyOwner {
        players[index].A = scores[0];
        players[index].B = scores[1];
        players[index].C = scores[2];
        players[index].updateCount += 1;
    }   


    // 查询所有选手分数信息
    function getAllPlayerScore() public returns(Player[] memory) {
        Player[] memory _players = new Player[](indexs.length);
        for(uint i = 0; i < indexs.length; i++) {
            _players[i] = players[indexs[i]];
        }
        querySum += indexs.length;
        return _players;
    }

    // 查看所有选手索引
    function getAllIndexs() public view returns(uint256[] memory) {
        return indexs;
    }

    // 查询某个选手分数信息
    function getPalyerByIndex(uint256 index) public returns(Player memory) {
        querySum += 1;
        return players[index];
    }

}