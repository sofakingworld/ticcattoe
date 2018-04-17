import React from 'react';
import CreateGame from './create_game.jsx'
import GameField from './game_field.jsx'

export default class App extends React.Component {
  render() {
    return (
      <div id="content" className='container'>
        <div className='row align-items-center text-center'>
          <h1>TIC TAC TOE  </h1>
        </div>
        <div className='row align-items-center'>
          <CreateGame key={1} data={{ field: '3x3', size: 'small', avg_time: '1 minute', cells: 9, win_count: 3 }} />
          <CreateGame key={2} data={{ field: '5x5', size: 'medium', avg_time: '10 minutes', cells: 25, win_count: 4 }} />
          <CreateGame key={3} data={{ field: '10x10', size: 'large', avg_time: '30 minutes', cells: 100, win_count: 5 }} />
        </div>
      </div>
    );
  }
}
