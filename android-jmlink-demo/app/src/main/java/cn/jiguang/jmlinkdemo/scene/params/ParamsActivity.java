package cn.jiguang.jmlinkdemo.scene.params;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;

import com.adorkable.iosdialog.IOSBottomSheetDialog;

import cn.jiguang.jmlinkdemo.BaseActivity;
import cn.jiguang.jmlinkdemo.R;

public class ParamsActivity extends BaseActivity implements View.OnClickListener {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_params);
        initTitle(R.id.toolbar, "无码邀请", false, 0, null);
        findViewById(R.id.chooseScenes).setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        new IOSBottomSheetDialog(ParamsActivity.this)
                .init()
                .setCancelable(true)    //设置手机返回按钮是否有效
                .setCanceledOnTouchOutside(true)  //设置 点击空白处是否取消 Dialog 显示
                //如果条目样式一样，可以直接设置默认样式
                .setDefaultItemStyle(new IOSBottomSheetDialog.SheetItemTextStyle("#FF007AFF", 20))
                .addSheetItem("选择场景体验",
                        //可以对一个条目单独设置字体样式
                        new IOSBottomSheetDialog.SheetItemTextStyle("#FF8F8F8F", 13, 82),   //设置字体样式
                        null)
                .addSheetItem("地推",
                        new IOSBottomSheetDialog.OnSheetItemClickListener() {
                            @Override
                            public void onClick(int which) {
                                Intent intent = new Intent(getApplicationContext(), Spread.class);
                                startActivity(intent);
                            }
                        })
                .addSheetItem("游戏邀请",
                        new IOSBottomSheetDialog.OnSheetItemClickListener() {
                            @Override
                            public void onClick(int which) {
                                Intent intent = new Intent(getApplicationContext(), Game.class);
                                startActivity(intent);
                            }
                        })
                .addSheetItem("拼团邀请",
                        new IOSBottomSheetDialog.OnSheetItemClickListener() {
                            @Override
                            public void onClick(int which) {
                                Intent intent = new Intent(getApplicationContext(), GroupShop.class);
                                startActivity(intent);
                            }
                        })
                .show();
    }
}
