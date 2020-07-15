package cn.jiguang.jmlinkdemo.scene.replay;

import cn.jiguang.jmlinkdemo.R;
import cn.jiguang.jmlinkdemo.ShareDialog;
import cn.jiguang.jmlinkdemo.BaseActivity;
import cn.jiguang.jmlinkdemo.common.Constants;

import android.os.Bundle;
import android.view.View;

public class News extends BaseActivity {
    private static final String TITLE = "新闻资讯";
    private static final String TEXT = "欢迎使用极光魔链";
    private static final String URL = Constants.SHARE + "/#/page3?type=2&scene=3";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_news);
        initTitle(R.id.toolbar, TITLE, true, R.drawable.share_selector, new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                new ShareDialog(News.this, TITLE, TEXT, URL).show();
            }
        });;
    }
}
