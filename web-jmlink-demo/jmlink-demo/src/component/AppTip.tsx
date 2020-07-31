import React from 'react';
import { useLocation } from 'react-router-dom'

import styles from './AppTip.module.scss';

import logoImg from '../common/img/logo.png';
import { SHORT_URL } from '../constant';

interface AppTipProps {
  params?: object;
  auto?: boolean;
}

function AppTip(props: AppTipProps) {
  const { auto } = props;
  const search = useLocation().search;
  const params = search ? search.slice(1).replace(/=/g, ':').replace(/&/g, ',') : null;
  return (
    <div className={styles.tip}>
      <img src={logoImg} alt='' />
      <div className={styles.text}>
        <div className={styles.title}>魔链App</div>
        <div className={styles.desc}>企业级深度链接服务，高效提升移动用户的增长和活跃</div>
      </div>
      <div className={styles.btns}>
        <a
          className={styles.btn}
          href={SHORT_URL}
          data-jmlink='true'
          data-params={params ? '{' + params + '}' : null}
          data-auto={auto}>
          打开App
        </a>
      </div>
    </div>
  );
}

export default AppTip;
