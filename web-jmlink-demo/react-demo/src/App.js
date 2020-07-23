import React from 'react';
import logo from './logo.png';
import './App.css';

class App extends React.Component {
  constructor(props) {
    super(props);
    this.openAppRef = React.createRef();
  }

  componentDidMount() {
    const btn = this.openAppRef.current;
    new window.JMLink({
      jmlink: 'https://arguys.jmlk.co/AAlq?a=1',
      button: btn,
      params: {
        name: 'xxx',
      },
      plhparams: {
        type: 3,
      },
      invtparams: {
        u_id: '6666',
      },
    });
  }

  render() {
    return (
      <div className='App'>
        <header className='App-header'>
          <img src={logo} className='App-logo' alt='logo' />
          <p>
            <a className='App-link' ref={this.openAppRef} rel='noopener noreferrer'>
              打开APP
            </a>
          </p>
        </header>
      </div>
    );
  }
}

export default App;
