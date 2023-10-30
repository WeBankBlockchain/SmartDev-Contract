/* eslint-disable jsx-a11y/accessible-emoji */
import React, { useState, useEffect } from 'react';
import FiscoNetworkServer  from '../@fiscobcos-web3/fiscobcos-web3-link/network'
import { decodeContractData, encodeContractData } from '../@fiscobcos-web3/fiscobcos-web3-utils/encode';
import { TransactionResponse } from '../@fiscobcos-web3/fiscobcos-web3-server/types';
import { hexToNumber } from '../@fiscobcos-web3/fiscobcos-web3-utils/utils';
import { CALL_FUNC_NAME, CONTRACT_ADDRESS_TO, DEFAULT_CALLER, RANK_2048_GAME_ABI } from '../config';

interface Player {
    address: string;
    score: number;
    rank: number;
}

const Rank: React.FC = () => {
    const [players, setPlayers] = useState<Player[]>([]);
    const [WrongStatus, setWrongStatus] = useState(false);

    const wrongDiv = () => {
        return (
            <h2>😱😱😭😭Uh oh, it seems like something's wrong</h2>
        );
    }
    /** MOCK DATA
    const fetchMorePlayers = () => {
        const newPlayers: Player[] = [
            { address: '0xDf1b63139e75674CFE14855A42aDC5e3b9221C72', score: 2122, rank: 1 },
            { address: '0xDf1b63139e75674CFE14855A42aDC5e3b9221C72', score: 2122, rank: 2 },
            { address: '0xDf1b63139e75674CFE14855A42aDC5e3b9221C72', score: 2122, rank: 3 },
            { address: '0xDf1b63139e75674CFE14855A42aDC5e3b9221C72', score: 2122, rank: 4 }, 
            { address: '0xDf1b63139e75674CFE14855A42aDC5e3b9221C72', score: 2122, rank: 1 },
            { address: '0xDf1b63139e75674CFE14855A42aDC5e3b9221C72', score: 2122, rank: 2 },
            { address: '0xDf1b63139e75674CFE14855A42aDC5e3b9221C72', score: 2122, rank: 3 },
            { address: '0xDf1b63139e75674CFE14855A42aDC5e3b9221C72', score: 2122, rank: 4 },     
            { address: '0xDf1b63139e75674CFE14855A42aDC5e3b9221C72', score: 2122, rank: 1 },
            { address: '0xDf1b63139e75674CFE14855A42aDC5e3b9221C72', score: 2122, rank: 2 },
            { address: '0xDf1b63139e75674CFE14855A42aDC5e3b9221C72', score: 2122, rank: 3 },
            { address: '0xDf1b63139e75674CFE14855A42aDC5e3b9221C72', score: 2122, rank: 4 },     
            { address: '0xDf1b63139e75674CFE14855A42aDC5e3b9221C72', score: 2122, rank: 1 },
            { address: '0xDf1b63139e75674CFE14855A42aDC5e3b9221C72', score: 2122, rank: 2 },
            { address: '0xDf1b63139e75674CFE14855A42aDC5e3b9221C72', score: 2122, rank: 3 },
            { address: '0xDf1b63139e75674CFE14855A42aDC5e3b9221C72', score: 2122, rank: 4 },           
        ];
            setPlayers(prevPlayers => [...prevPlayers, ...newPlayers]);
            console.log(encodeContractData(RANK_2048_GAME_ABI, CALL_FUNC_NAME))

        };
*/
    const fetchMorePlayers = async () => {
        try {
            const server = new FiscoNetworkServer("http://127.0.0.1:3002/fiscobcos/call", '1');
            const data:TransactionResponse = await server.call(
                DEFAULT_CALLER,
                CONTRACT_ADDRESS_TO, 
                '', // empty value, do no send
                encodeContractData(RANK_2048_GAME_ABI, CALL_FUNC_NAME.getAllPlayersScore),
            );
            const decodeData = decodeContractData(
                RANK_2048_GAME_ABI,
                'getAllPlayersScore',
                data.result['output'],
            );
            const [players, scores] = decodeData;
            const playersData: Player[] = players.map((player: any, index: string | number) => {
                return {
                    address: player,
                    score: hexToNumber(scores[index]),
                    rank: 0,
                };
            });	
            playersData.sort((a, b) => b.score - a.score);
            // Calculate Ranking
            const sortedPlayersData = playersData.map((player, index) => {
                return {
                    ...player,
                    rank: index + 1
                };
            });

            if ( data.result['status'] === '0x0' || data.result === '') setWrongStatus(true);
            setPlayers(prevPlayers => [...prevPlayers, ...sortedPlayersData]);
        } catch (err) {
            console.error(err);
            setWrongStatus(true);
        }
    }; 

    useEffect(() => {
        fetchMorePlayers();
        const handleScroll = (e: any) => {
            // A tolerance of 5px
            const tolerance = 15;
            const bottom = e.target.scrollHeight - e.target.scrollTop <= e.target.clientHeight + tolerance;
            if (bottom) {
                // Load more data when scrolled to the bottom
                fetchMorePlayers();
            }
        };

        const rankDiv = document.querySelector('.rank');
        if (rankDiv) {
            rankDiv.addEventListener('scroll', handleScroll);
            return () => rankDiv.removeEventListener('scroll', handleScroll);
        }
    }, []);

    return (
        <div>
            <div className='rank'>
                <h2>Top Player Rank</h2>
                <div className='rank-column'>
                    {WrongStatus ? players.map(player => (
                        <div key={player.address} className='rank-player-card'>
                            <h6> Address: {player.address}</h6>
                            <h6> Score: {player.score}</h6>
                            <h6> Rank: {player.rank}</h6>
                        </div>
                    )) : wrongDiv}
                </div>
            </div>
        </div>
    );
}

export default Rank;
