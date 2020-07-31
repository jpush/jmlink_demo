import React from 'react';
import { useLocation } from 'react-router-dom'
import styles from './Page4.module.scss';
import bgImg from '../common/img/videoPage.jpg';
import { SHORT_URL } from '../constant';

function Page4() {
  const search = useLocation().search;
  const params = search ? search.slice(1).replace(/=/g, ':').replace(/&/g, ',') : null;

  return (
    <div className={styles.page4}>
      <img width='100%' src={bgImg} alt='' />
      <div className={'btns ' + styles.btns}>
        <a
          role='button'
          className={'btn ' + styles.btn}
          href={SHORT_URL}
          data-params={params ? '{' + params + '}' : null}
          data-jmlink='true'>
          打开App
        </a>
      </div>
    </div>
  );
}

export default Page4;
