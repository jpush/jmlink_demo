import React from 'react';
import { HashRouter as Router, Switch, Route } from 'react-router-dom';
import Page1 from './container/Page1';
import Page2 from './container/Page2';
import Page3 from './container/Page3';
import Page4 from './container/Page4';
import Page5 from './container/Page5';
import Page6 from './container/Page6';

import Logo from './common/img/logo.png';

function App() {
  return (
    <div className='App'>
      <Router>
        <Switch>
          <Route path='/' exact>
            <div className="logo">
              <img src={Logo} alt="logo"/>
            </div>
            <div className='btns'>
              <a className='btn' href='/#/page1'>
                拼团邀请
              </a>
            </div>
            <div className='btns'>
              <a className='btn' href='/#/page2'>
                小说分享
              </a>
            </div>
            <div className='btns'>
              <a className='btn' href='/#/page3'>
                新闻推荐
              </a>
            </div>
            <div className='btns'>
              <a className='btn' href='/#/page4'>
                VIP推广
              </a>
            </div>
            <div className='btns'>
              <a className='btn' href='/#/page5'>
                商品详情
              </a>
            </div>
            <div className='btns'>
              <a className='btn' href='/#/page6'>
                游戏邀请
              </a>
            </div>
          </Route>
          <Route path='/page1'>
            <Page1></Page1>
          </Route>
          <Route path='/page2'>
            <Page2></Page2>
          </Route>
          <Route path='/page3'>
            <Page3></Page3>
          </Route>
          <Route path='/page4'>
            <Page4></Page4>
          </Route>
          <Route path='/page5'>
            <Page5></Page5>
          </Route>
          <Route path='/page6'>
            <Page6></Page6>
          </Route>
        </Switch>
      </Router>
    </div>
  );
}

export default App;
