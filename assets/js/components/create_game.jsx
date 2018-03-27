import React from 'react';
export default class CreateGame extends React.Component {
  constructor(props) {
    super(props);

    this.state = {data: props.data};
  }

  render() {
    return (
      <div className='col-md-4'>
        <div className='card text-md-center'>
          <h3 className='card-header'>Game Field</h3>
          <div className='card-block text-xs-center'>
            <h5 className='card-title'>Field size: {this.state.data.field}</h5>
            <p className='card-text'>There are {this.state.data.cells} cells on field. 
            Player have to put {this.state.data.win_count} signs in one line 
            (horizontally, vertically or diagonally) for win. </p>
            <br/>
            <p className='card-text'>Average match time: <i><u>{this.state.data.avg_time}</u></i></p>
            <a href={"/new?field_size=" + this.state.data.size}>
              <div className='btn btn-dark'> Create </div>
            </a>
          </div>
        </div>
      </div>
    );
  }
}
