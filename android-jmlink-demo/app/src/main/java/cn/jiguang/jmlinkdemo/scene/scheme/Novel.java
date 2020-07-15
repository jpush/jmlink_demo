package cn.jiguang.jmlinkdemo.scene.scheme;

import cn.jiguang.jmlinkdemo.R;
import cn.jiguang.jmlinkdemo.ShareDialog;
import cn.jiguang.jmlinkdemo.BaseActivity;
import cn.jiguang.jmlinkdemo.common.Constants;

import android.os.Bundle;
import android.view.View;

public class Novel extends BaseActivity {
    private static final String TITLE = "三国演义";
    private static final String TEXT = "欢迎使用极光魔链";
    private static final String URL = Constants.SHARE  + "/#/page2?type=1&scene=2";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_novel);
        initTitle(R.id.toolbar, TITLE, true, R.drawable.share_selector, new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                new ShareDialog(Novel.this, TITLE, TEXT, URL).show();
            }
        });;
    }
}
