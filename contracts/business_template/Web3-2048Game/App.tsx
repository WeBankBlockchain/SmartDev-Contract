import React from 'react';
import './App.scss';
import { animationDuration, gridGap } from './config';
import Header from './components/Header';
import Board from './components/Board';
//import Info from './components/Info';
import BoardSizePicker from './components/BoardSizePicker';
import Rank from './components/Rank';

const App: React.FC = () => {
  return (
    <div
      className="app"
      style={
        {
          '--animation-duration': animationDuration + 'ms',
          '--grid-gap': gridGap,
        } as any
      }
    >
      <div className="page">
        <Header />
        <Board />
        <BoardSizePicker />
        {/** feat: Add leaderboard panel and initialize */}
        <Rank />
      </div>
    </div>
  );
};

export default App;
