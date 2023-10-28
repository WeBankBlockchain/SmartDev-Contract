// SPDX-License-Identifier: GPL-2.0-or-laterpragma sol
pragma solidity ^0.6.10;
pragma experimental ABIEncoderV2;

import "AppealManagerment.sol";
import "MarkingManagerment.sol";
import "JudgeManagerment.sol";
import "PaperManagerment.sol";
import "Enum.sol";

contract Main is JudgeManagerment{

    using Roles for Roles.Role;

    struct Player {
        string ID; // 加密后的身份码，需要特定的密钥进行解密，解密后获得选手最终号码
        uint256 A; // A 模块分数
        uint256 B; // B 模块分数
        uint256 C; // C 模块分数
        uint256 updateCount; // 更新次数
    }

    /** @dev
     * 1. 各院校注册获得独一无二得地址
     * 2. 各省裁判注册获得独一无二地址
     * 3. 裁判 >= 18，部署评分管理合约
    */ 
    constructor(
    ) public {

    }
    
    mapping(uint256 => address) private markingMgrs; // 评分合约管理
    mapping(uint256 => address) private appealMgrs; // 申诉合约管理
    mapping(uint256 => address) private playerMgrs; // 选手合约管理
    mapping(uint256 => address) private paperMgrs; // 试卷合约管理
    uint256 public start;



    // TODO 评分合约生成
    function _newMarkingMgr() private onlyOwner {
        require(legalCount >= 18, "info: legalCount < 18, can't start"); // 裁判不够无法开始
        address[] memory judgeAddrs = showLegalJudgeAdrrList(); 
        address markingMgr = address(new MarkingManagerment(judgeAddrs)); // 申诉管理合约
        markingMgrs[start] = markingMgr;
    }

    // TODO 申诉合约生成
    function _newAppealMgr(address[] _schools) private onlyOwner {
        address appealMgr = address(new AppealManagerment(_schools)); // 申诉管理合约
        appealMgrs[start] = appealMgr;
    }

    // TODO 选手合约生成
    function _newPlayerMgr() private onlyOwner {
        address playerMgr = address(new PlayerManagerment()); 
        playerMgrs[start] = appealMgr;
    }

    // TODO 试卷合约生成
    function _newPaperMgr() private onlyOnwer {
        address paperMgr = addresss(new PaperManagerment());
        paperMgrs[start] = paperMgr;
    }

    // 开始比赛
    function startCompetition(address[] _schools) public onlyOwner returns(uint256) {
        _newMarkingMgr();
        _newAppealMgr(_schools);
        _newPlayerMgr();
        start += 1;
        return start;
    }
    
    /**
     * 裁判评分
     * @param
     * string memory _playerID,
        uint256 _score, // 分数需已进行倍增
        uint256 _questionIndex,
        address _judgeAddr
     */
    function giveMarking(
        string memory _playerID,
        uint256 _score,
        uint256 _questionIndex,
        address _judgeAddr
    ) public onlyJudge(msg.sender) {
        MarkingManagerment(markingMgrs[start - 1]).giveScore(_playerID, _score, _questionIndex, _judgeAddr);
    }


    /**
     * 汇总选手分数
     * @param
     * string memory _playerID
     */
    function sendPlayerMgrScore(string memory _playerID, uint256 index) public onlyJudge(msg.sender) {
        require(PlayerManagerment(playerMgrs[start - 1]).validataPlayerIndex(_playerID, index), "error: _playerID binding index does not different");
        (uint256 scoreA, uint256 scoreB, uint256 scoreC) = MarkingManagerment(markingMgrs[start - 1]).sendModuleScore(_playerID); // 需要除10;
        PlayerManagerment(playerMgrs[start - 1]).setPlayerScore([scoreA, scoreB, scoreC]);
    }

    /**
     * 添加选手
     * @param
     * stirng memory _playerID
     */
    function addPlayer(string memory _playerID) public onlyOwner returns(uint256) {
        uint256 playerIndex = PlayerManagerment(playerMgrs[start - 1]).addPlayer(_playerID);
        return playerIndex;
    }   

    /**
     * 查询所有选手分数
     */
    function getAllPlayerScore() public view returns(Player[] memory _players) {
        return PlayerManagerment(playerMgrs[start - 1]).getAllPlayerScore();
    }


     /**
     * 查询某个选手分数
     */
    function getPalyerByIndex(uint256 index) public returns(Player memory) {
        return PlayerManagerment(playerMgrs[start - 1]).getPalyerByIndex(index);
    }

    /**
     * 查询所有选手索引
     */
    function getAllIndexs() public view returns(uint256[] memory) {
        return PlayerManagerment(playerMgrs[start - 1]).indexs();
    }

    /**
     * 总查询次数
     */
    function getQuerySum() public view returns(uint256) {
        return PlayerManagerment(playerMgrs[start - 1]).querySum();
    }

    /**
     * 添加题目
     * @param
     * addQuestion(string memory title, string memory answer)
     */
    function addQuestion(string memory title, string memory answer) public onlyOwner {
        PaperManagerment(paperMgrs[start - 1]).addQuestion(title, answer);
    }

    /**
     * 验证题目
     * @param
     * verifyQuestion(uint256 _questionIndex, Enum.QuestionStatus _questionStatus)
     */
    function verifyQuestion(uint256 _questionIndex, Enum.QuestionStatus _questionStatus) public onlyOwner{
        PaperManagerment(paperMgrs[start - 1]).verifyQuestion(_questionIndex, _questionStatus);
    }

    /**
     * 查看所有已验证得题目
     * @param
     * function showRightQuestion() private view returns(Question[] memory) {
     */
    function showRightQuestion() private view returns(Question[] memory) { 
        return PaperManagerment(paperMgrs[start - 1]).showRightQuestion();
    }
}