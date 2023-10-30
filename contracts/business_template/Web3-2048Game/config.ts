/** Tile animation duration (in ms). */
export const animationDuration = 100;

/** Default board size. */
export const defaultBoardSize = 4;

/** A list of supported board sizes. */
export const supportedBoardSizes = [3, 4, 5, 6];

/** Tile value of the victorious tile. */
export const victoryTileValue = 2048;

/** Grid gap (used for animations). */
export const gridGap = '1rem';

/** ######### CUSTOM CONTRACT CONFIG ######### */
/** Contrat abi interface lsit */
export const RANK_2048_GAME_ABI = [
	{
		"constant": false,
		"inputs": [
			{
				"name": "player",
				"type": "address"
			},
			{
				"name": "score",
				"type": "uint256"
			}
		],
		"name": "storePlayerRankAndScore",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"name": "allPlayers",
		"outputs": [
			{
				"name": "",
				"type": "address"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "getAllPlayersScore",
		"outputs": [
			{
				"name": "",
				"type": "address[]"
			},
			{
				"name": "",
				"type": "uint256[]"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "player",
				"type": "address"
			}
		],
		"name": "getPlayerCurrentScoreAndBestScore",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			},
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "",
				"type": "address"
			}
		],
		"name": "historyBestScore",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "",
				"type": "address"
			}
		],
		"name": "playerScore",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	}
];

/** Contract call function name */
export const CALL_FUNC_NAME = {
    getAllPlayersScore: 'getAllPlayersScore()',
    getPlayerCurrentScoreAndBestScore: 'getPlayerCurrentScoreAndBestScore(address)',
    storePlayerRankAndScore: 'storePlayerRankAndScore(address, uint256)'
};

/** Contract address */
export const CONTRACT_ADDRESS_TO = '0x047665579775fdaba8d681c1c7b157186d4ef9c9';

/** Default caller address */
export const DEFAULT_CALLER = '0x5B38Da6a701c568545dCfcB03FcB875f56beddC4';

/** Assige groud id */
export const GROUP_ID = '1';