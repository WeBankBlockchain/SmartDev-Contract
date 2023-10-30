pragma solidity ^0.4.25;

contract Rank2048Game {

    mapping (address => uint256) public playerScore;
    mapping (address => uint256) public historyBestScore;
    address[] private allPlayers;

    function storePlayerRankAndScore(address player, uint256 score) external {
        require(player != address(0), "The user cannot be zero");
        require(
            score > 0, 
                "The score is zero");
        // Cover the pre-score
        uint256 _historyBestScore = historyBestScore[player];
        if (score > _historyBestScore) historyBestScore[player] = score;
        playerScore[player] = score;
        allPlayers.push(player);
    }

    function getPlayerCurrentScoreAndBestScore(address player) external view returns (uint256, uint256) {
        return (playerScore[player], historyBestScore[player]);
    }

    function getAllPlayersScore() public view returns (address[] memory, uint256[] memory) {
        uint256[] memory scores = new uint256[](allPlayers.length);

        // Read all players address from memory.
        address[] memory _allPlayers = allPlayers;
        for (uint i = 0; i < _allPlayers.length; ++i) {
            scores[i] = playerScore[_allPlayers[i]];
        }

        return (allPlayers, scores);
    }
}
