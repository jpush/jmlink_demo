import React, { useEffect } from 'react';

import styles from './Page3.module.scss';

import bannerImg from '../common/img/新闻资讯@3x.jpg';

import AppTip from '../component/AppTip';

function Page3() {
  useEffect(() => {
    document.title = '新闻资讯';
  });

  return (
    <div className={styles.page3}>
      <AppTip></AppTip>
      <div className={styles.wrapper}>
        <div className={styles.title}>极光魔链正式入驻极光开发者控制平台</div>
        <img className={styles.banner} src={bannerImg} alt='' />
        <div className={styles.content}>
          深度链接技术是一个可以多种渠道中将用户带到应用内容页的简单方式，该技术可以让用户绕过的Web网站或者移动应用的首页直接访问其内容页，打破应用程序孤岛，实现网络与应用程序的无缝链接，在移动化的今天为应用程序的快速增长和变现提供新的可能。
        </div>
        <div className={styles.content}>
          早在今年3月21日，极光（Aurora
          Mobile，纳斯达克股票代码：JG）收购了魔窗（MagicWindow）旗下企业级深度链接（Deeplink）解决方案--mLink，并将其更名为极光魔链（JMLink），成为极光继消息推送，即时通讯，统计分析，社会化组件，短信和一键认证之后的又一全新产品线。极光魔链（JMLink）的加入，为开发者提供全方位的用户增长解决方案，助力产品商业互连提供了强有力的支持。
        </div>
        <div className={styles.content}>
          极光魔链（JMLink）目前已支持一链直达，场景还原，无码邀请，智能短链接，跨渠道监测等多种功能，并适配600+款机型，兼容20+款浏览器，支持的iOS和Android所有版本的一键直达。当用户未安装App时，其场景还原（Deferred
          Deeplink）功能会引导用户直接前往应用商店进行下载，下载后用户可以一步直达到想看的内容页。
        </div>
        <div className={styles.content}>
          即日起，开发者将可以通过极光开发者控制平台直接体验和使用新版本的极光魔链（JMLink），这也是继推送，统计，IM，短信，认证和分享之后加入极光开发者控制平台的又一新成员。
        </div>
        <div className={styles.content}>
          如您正使用旧版本的魔链服务，建议及时升级。请按照以下文档完成客户端集成和平台极光魔链应用的配置。同时极光会维护旧版本服务，若依旧使用旧版本服务，请访问（
          mlinks.jiguang.cn）。产品介绍详情请访问帮助中心介绍和集成请访问帮助中心（mlinks.jiguang.cn/doc），如有任何疑问，请联系support@jiguang.cn邮箱。
        </div>
        <div className={styles.content}>
          <div className='bold'>资源下载</div>
          <div>下载JMLink SDK，资源获取地址：</div>
          <a href='https://docs.jiguang.cn/jmlink/resources/'>https://docs.jiguang.cn/jmlink/resources/</a>
        </div>
        <div className={styles.content}>
          <div>完成SDK下载，查看JMLink产品集成指南：</div>
          <a href='https://docs.jiguang.cn/jmlink/guideline/intro/'>https://docs.jiguang.cn/jmlink/guideline/intro/</a>
        </div>
      </div>
    </div>
  );
}

export default Page3;
