import React from 'react';

export default class Cell extends React.Component {
  constructor(props) {
    super(props);

    this.state = {};
  }

  render() {
    const style = { width: '70px', height: '70px', border: '1px solid', background: 'white'}
    return (
      <div style={style} onClick={() => this.put_sign()}>
        <div className={'sign ' +this.class_popepicteam(this.props.data.value)}></div>
      </div>
    );
  }

  class_popepicteam(value) {
    if (value == "xs") {
      return "popuko"
    }
    if (value == "os") {
      return "pipimi"
    }
    return ""
  }

  put_sign() {
    this.props.channel.push("put_sign", { row: this.props.data.row, col: this.props.data.col})
  }
}
