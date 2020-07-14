package cn.jiguang.jmlinkdemo.scene.replay;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;

import com.adorkable.iosdialog.IOSBottomSheetDialog;

import cn.jiguang.jmlinkdemo.R;
import cn.jiguang.jmlinkdemo.BaseActivity;

public class ReplayActivity extends BaseActivity implements View.OnClickListener {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_replay);
        initTitle(R.id.toolbar, "场景还原", false, 0, null);
        findViewById(R.id.chooseScenes).setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.chooseScenes:
                new IOSBottomSheetDialog(ReplayActivity.this)
                        .init()
                        .setCancelable(true)    //设置手机返回按钮是否有效
                        .setCanceledOnTouchOutside(true)  //设置 点击空白处是否取消 Dialog 显示
                        //如果条目样式一样，可以直接设置默认样式
                        .setDefaultItemStyle(new IOSBottomSheetDialog.SheetItemTextStyle("#FF007AFF", 20))
                        .addSheetItem("选择场景\n\n请先下载魔链APP以便更好体验一链直达",
                                //可以对一个条目单独设置字体样式
                                new IOSBottomSheetDialog.SheetItemTextStyle("#FF8F8F8F", 13, 82),   //设置字体样式
                             null)
                        .addSheetItem("新闻资讯",
                                new IOSBottomSheetDialog.OnSheetItemClickListener() {
                                    @Override
                                    public void onClick(int which) {
                                        Intent intent = new Intent(getApplicationContext(), News.class);
                                        startActivity(intent);
                                    }
                                })
                        .addSheetItem("商品浏览",
                                new IOSBottomSheetDialog.OnSheetItemClickListener() {
                                    @Override
                                    public void onClick(int which) {
                                        Intent intent = new Intent(getApplicationContext(), Goods.class);
                                        startActivity(intent);
                                    }
                                })
                        .show();

                break;
        }
    }
}
