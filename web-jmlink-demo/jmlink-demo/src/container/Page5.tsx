import React, { useEffect } from 'react';

import goodsImage from '../common/img/商品浏览@3x.jpg';

import AppTip from '../component/AppTip';

function Page1() {
  useEffect(() => {
    document.title = '拼团邀请';
  });

  return (
    <div className='page5'>
      <AppTip></AppTip>
      <div>
        <img src={goodsImage} alt='img' />
      </div>
    </div>
  );
}

export default Page1;
