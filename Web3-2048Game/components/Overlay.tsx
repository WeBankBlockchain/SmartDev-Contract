/* eslint-disable jsx-a11y/accessible-emoji */
import React, { useCallback, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { dismissAction, resetAction } from '../actions';
import { StateType } from '../reducers';
import FiscoNetworkServer from '../@fiscobcos-web3/fiscobcos-web3-link/network';
import { CALL_FUNC_NAME, CONTRACT_ADDRESS_TO, GROUP_ID, RANK_2048_GAME_ABI } from '../config';
import { TransactionResponse } from '../@fiscobcos-web3/fiscobcos-web3-server/types';
import { TxnBody, createCustomRawTransaction, createRawTransaction, encodeContractData } from '../@fiscobcos-web3/fiscobcos-web3-utils/encode';

const Overlay: React.FC = () => {
  const dispatch = useDispatch();
  const reset = useCallback(() => dispatch(resetAction()), [dispatch]);
  const dismiss = useCallback(() => dispatch(dismissAction()), [dispatch]);

  const defeat = useSelector((state: StateType) => state.defeat);
  const victory = useSelector(
    (state: StateType) => state.victory && !state.victoryDismissed
  );
  const [playerAddress, setPlayerAddress] = useState('');
  const score = useSelector((state: StateType) => state.score);

  const onChain = async () => {
      console.log("current score and player", score, playerAddress);
      /*
      try {
        const server = new FiscoNetworkServer("http://127.0.0.1:3002/fiscobcos/call", GROUP_ID);
        const txnBody: TxnBody = {
          to: CONTRACT_ADDRESS_TO,
        };
        const rawTransactionData = await createCustomRawTransaction(
          txnBody,
          RANK_2048_GAME_ABI, 
          'storePlayerRankAndScore',
          [playerAddress, score.toString()],
        );
        const data:TransactionResponse = await server.sendRawTransaction(rawTransactionData);
        console.log('response', data);
    } catch (err) {
      console.error("error", err);
    }*/
  };

  const setupPlayerAddress = (event:any) => {
    setPlayerAddress(event.target.value);
  }

  if (victory) {
    console.log("victory", score)

    return (
      <div className="overlay overlay-victory">
        <h1>You win!</h1>
        <div className="overlay-buttons">
          {/** feat: Add user login */}
          <div className='sign-contanier'>
            <h2>❤️‍❤️Victory !! You're amazing you must stay your address‍</h2>
            <div className='sign'>
            <input onChange={setupPlayerAddress} className='sign-input'/>
            </div>
          </div>
          <button onClick={dismiss}>Keep going</button>
          <button onClick={reset}>Try again</button>
          <button onClick={onChain}>Record rank on chain</button>
        </div>
      </div>
    );
  }

  if (defeat) {
    return (
      <div className="overlay overlay-defeat">
        <h1>Game over!</h1>
        <div className="overlay-buttons">
          {/** feat: Add user login */}
          <div className='sign-contanier'>
            <h2>❤️‍❤️You're already great please stay your address‍</h2>
            <div className='sign'>
            <input onChange={setupPlayerAddress} className='sign-input'/>
            </div>
          </div>          
          <button onClick={reset}>Try again</button>
          <button onClick={onChain}>Record rank on chain</button>
        </div>
      </div>
    );
  }

  return null;
};

export default Overlay;
