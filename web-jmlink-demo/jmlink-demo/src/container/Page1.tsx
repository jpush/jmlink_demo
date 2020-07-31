import React, { useEffect } from 'react';
import { useLocation } from 'react-router-dom'
import styles from './Page1.module.scss';
import { SHORT_URL } from '../constant';
import goodsImage from '../common/img/拼团@3x.png';

function Page1() {
  const search = useLocation().search;
  const params = search ? search.slice(1).replace(/=/g, ':').replace(/&/g, ',') : null;

  useEffect(() => {
    document.title = '拼团邀请';
  });

  return (
    <div className='page1'>
      <div className={styles.banner}>
        <img src={goodsImage} alt='img' />
      </div>
      <div className='btns'>
        <a
          role='button'
          className='btn'
          href={SHORT_URL}
          data-params={params ? '{' + params + '}' : null}
          data-jmlink='true'>
          参加拼团
        </a>
      </div>
    </div>
  );
}

export default Page1;
