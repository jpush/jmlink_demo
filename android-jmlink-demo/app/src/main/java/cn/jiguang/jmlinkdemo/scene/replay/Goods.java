package cn.jiguang.jmlinkdemo.scene.replay;

import cn.jiguang.jmlinkdemo.R;
import cn.jiguang.jmlinkdemo.ShareDialog;
import cn.jiguang.jmlinkdemo.BaseActivity;
import cn.jiguang.jmlinkdemo.common.Constants;

import android.os.Bundle;
import android.view.View;

public class Goods extends BaseActivity {
    private static final String TITLE = "商品浏览";
    private static final String TEXT = "欢迎使用极光魔链";
    private static final String URL = Constants.SHARE + "/#/page5?type=2&scene=4";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_goods);
        initTitle(R.id.toolbar, TITLE, true, R.drawable.share_selector, new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                new ShareDialog(Goods.this, TITLE, TEXT, URL).show();
            }
        });
    }
}
