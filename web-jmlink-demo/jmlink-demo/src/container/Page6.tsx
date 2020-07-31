import React from 'react';
import { useLocation } from 'react-router-dom';
import { SHORT_URL } from '../constant';

import './page6.scss';

import avater1 from '../common/img/头像1@3x.png';
import avater2 from '../common/img/头像2@3x.png';
import avater3 from '../common/img/头像3@3x.png';
import avater4 from '../common/img/头像4@3x.png';
import avater5 from '../common/img/头像5@3x.png';
import defAvater from '../common/img/灰色头像.png';

function urlParse(search: string) {
  var res: any = {};
  var arr = search.replace('?', '').split('&');
  arr.map(v => {
    var params = v.split('=');
    res[params[0]] = decodeURIComponent(params[1]);
    return v;
  });
  return res;
}

const avaters = [avater1, avater2, avater3, avater4, avater5];

function Page6() {
  const search = useLocation().search;
  const params = search ? search.slice(1).replace(/=/g, ':').replace(/&/g, ',') : null;
  const param = urlParse(search);
  const my = avaters[Math.round(Math.random() * 4)];
 
  return (
    <div className='page6'>
      <div className='game'>
        <div className='title'>斗地主游戏房间一</div>
        <div className='id'>ID: {param.room_id}</div>
        <div className='main'>
          <div className='my'>
            <img src={my} alt='' />
            <div>{param.username}</div>
          </div>
          <div className='main-b'>
            <div className='player'>
              <img src={defAvater} alt='' />
              <span>?</span>
            </div>
            <div className="desktop">
              
            </div>
            <div className='player'>
              <img src={defAvater} alt='' />
              <span>?</span>
            </div>
          </div>
        </div>
      </div>
      <div className='btns'>
        <a
          role='button'
          className='btn'
          href={SHORT_URL}
          data-params={params ? '{' + params + '}' : null}
          data-jmlink='true'>
          加入游戏
        </a>
      </div>
    </div>
  );
}

export default Page6;
