import React from 'react';
import Cell from './cell.jsx'
import socket from "../socket.js";

export default class GameField extends React.Component {
  constructor(props) {
    super(props);
    
    let channel = socket.channel("room:" + $('#lobby').text())
    var game_state = null

    channel.join()
      .receive("ok", resp => { console.log("joined lobby", resp)
        this.setState({game: resp})
      })

    channel.on("change", data => {
      console.log("game_state_changed", data)
      this.setState({game: data })
    })

    channel.on("info", data => {
      console.log("info", data)
    })

    this.state = {channel: channel, game: {winner: null}};
  }

  componentDidUpdate() {
    setTimeout(() => {
      if (this.state.game.turn == "none") {
        alert("Game Ended - Draw")
      }
      
      if (["xs", "os"].indexOf(this.state.game.winner) >= 0) {
        alert(`Game Ended - ${this.state.game.winner}  Won`)
      }
    }, 400);
    
  }
  render() {

    return (
      
      <div className='container'> 
        {this.invite_friend()}
        {this.field().map((row, r_i) => {
          return (
            <div key={r_i} className='row'>
            { row.map((col, c_i) => {
              return <Cell key={c_i} data={col} channel={this.state.channel}/>  
            })}
            </div>
          )
        })}
      </div>
    );
  }

  invite_friend() {
    var link = window.location.origin +'/join?lobby=' + $('#lobby').text()
    return (
      <div style={{color: 'white'}}>
        For inviting oppponent just send him link: 
        <a href={link}>copy me </a> 
      </div>
    )
  }

  field() {
    if ((this.state.game && this.state.game.field) == undefined) {
      return []
    } else {
      var field = this.state.game.field
      return Array.apply(null, { length: Math.sqrt(field.length) }).map((v, row_idx) => {
        return field.filter((cell) => { return cell.row == row_idx + 1})
      })
    }
  }
}

