import React, { useCallback, useEffect, useRef, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { resetAction, undoAction } from '../actions';
import { StateType } from '../reducers';
import FiscoNetworkServer from '../@fiscobcos-web3/fiscobcos-web3-link/network';
import { CALL_FUNC_NAME, CONTRACT_ADDRESS_TO, DEFAULT_CALLER, GROUP_ID, RANK_2048_GAME_ABI } from '../config';
import { decodeContractData, encodeContractData } from '../@fiscobcos-web3/fiscobcos-web3-utils/encode';
import { TransactionResponse } from '../@fiscobcos-web3/fiscobcos-web3-server/types';
import { hexArrayToNumber } from '../@fiscobcos-web3/fiscobcos-web3-utils/utils';

const Header: React.FC = () => {
  const dispatch = useDispatch();
  const reset = useCallback(() => dispatch(resetAction()), [dispatch]);
  const undo = useCallback(() => dispatch(undoAction()), [dispatch]);

  const score = useSelector((state: StateType) => state.score);
  const scoreIncrease = useSelector((state: StateType) => state.scoreIncrease);
  const moveId = useSelector((state: StateType) => state.moveId);
  const best = useSelector((state: StateType) => state.best);
  const previousBoard = useSelector((state: StateType) => state.previousBoard);

  const [TopPlayerSCore, setTopPlayerSCore] = useState('');
  
  const fetchTopPlayerScore = async () => {
    try {
        const server = new FiscoNetworkServer("http://127.0.0.1:3002/fiscobcos/call", GROUP_ID);
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
        const [_, scores] = decodeData;
        const topScores = Math.max(...hexArrayToNumber(scores)).toString();
        setTopPlayerSCore(topScores);
    } catch (err) {
        console.error(err);
    }
};

  useEffect(() => {
    fetchTopPlayerScore();
  }, []); 

  return (
    <div className="header">
      <div className="header-row">
        <h1>2048</h1>
        <div className="header-scores">
          <div className="header-scores-score">
            <div>Score</div>
            <div>{score}</div>
            {!!scoreIncrease && (
              <div className="header-scores-score-increase" key={moveId}>
                +{scoreIncrease}
              </div>
            )}
          </div>
          <div className="header-scores-score">
            <div>Best</div>
            <div>{best}</div>
          </div>
          <div className="header-scores-score">
            {/** Display player data with the highest score */}
            <div>Top Player Score</div>
            <div>{TopPlayerSCore !== '' ? TopPlayerSCore : best}</div>
          </div>
        </div>
      </div>
      <div className="header-row">
        <div>
          Join the numbers and get to the <strong>2048 tile!</strong>
        </div>
        <div className="header-buttons">
          <button onClick={undo} disabled={!previousBoard}>
            Undo
          </button>
          <button onClick={reset}>New game</button>
        </div>
      </div>
    </div>
  );
};

export default Header;
