// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"
import socket from "./socket"
import ReactDOM from 'react-dom';
import React from 'react';
import App from './components/app.jsx';
import GameField from './components/game_field.jsx';

document.addEventListener('DOMContentLoaded', () => {
  if (document.querySelector('#game_field') != null) {
    return ReactDOM.render(<GameField />, document.querySelector('#game_field'));
  }
  if (document.querySelector('#app') != null) {
    return ReactDOM.render(<App />, document.querySelector('#app'));
  } 
});