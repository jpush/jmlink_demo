package cn.jiguang.jmlinkdemo.scene.scheme;

import android.content.Intent;
import android.os.Bundle;
import android.view.MenuItem;
import android.view.View;

import com.adorkable.iosdialog.IOSBottomSheetDialog;

import androidx.annotation.NonNull;
import cn.jiguang.jmlinkdemo.BaseActivity;
import cn.jiguang.jmlinkdemo.R;

public class SchmeActivity extends BaseActivity implements View.OnClickListener{

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_schme);
        initTitle(R.id.toolbar, "一链直达", false, 0, null);
        findViewById(R.id.chooseScenes).setOnClickListener(this);
    }

    @Override
    public boolean onOptionsItemSelected(@NonNull MenuItem item) {
        if (item.getItemId() == android.R.id.home) {
            finish();
        }
        return super.onOptionsItemSelected(item);
    }

    @Override
    public void onClick(View v) {
        new IOSBottomSheetDialog(SchmeActivity.this)
                .init()
                .setCancelable(true)    //设置手机返回按钮是否有效
                .setCanceledOnTouchOutside(true)  //设置 点击空白处是否取消 Dialog 显示
                //如果条目样式一样，可以直接设置默认样式
                .setDefaultItemStyle(new IOSBottomSheetDialog.SheetItemTextStyle("#FF007AFF", 20))
                .addSheetItem("选择场景\n\n请先下载魔链APP以便更好体验一链直达",
                        //可以对一个条目单独设置字体样式
                        new IOSBottomSheetDialog.SheetItemTextStyle("#FF8F8F8F", 13, 82),   //设置字体样式
                       null)
                .addSheetItem("爱看视频",
                        new IOSBottomSheetDialog.OnSheetItemClickListener() {
                            @Override
                            public void onClick(int which) {
                                Intent intent = new Intent(getApplicationContext(), AKan.class);
                                startActivity(intent);
                            }
                        })
                .addSheetItem("小说阅读",
                        new IOSBottomSheetDialog.OnSheetItemClickListener() {
                            @Override
                            public void onClick(int which) {
                                Intent intent = new Intent(getApplicationContext(), Novel.class);
                                startActivity(intent);
                            }
                        })
                .show();
    }
}
