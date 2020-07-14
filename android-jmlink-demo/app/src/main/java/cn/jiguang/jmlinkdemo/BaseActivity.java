package cn.jiguang.jmlinkdemo;

import android.app.Activity;
import android.graphics.Color;
import android.os.Build;
import android.os.Bundle;
import android.os.Looper;
import android.os.MessageQueue;
import android.view.View;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

public class BaseActivity extends AppCompatActivity {
    private View statusBarView;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (Build.VERSION.SDK_INT >= 21) {
            setStatusBarView();
        }
    }


    protected void initTitle(int toolbarId, String title, boolean rightBtn, int resId, View.OnClickListener clickListener) {
        CustomToolbar ct = findViewById(toolbarId);
        ct.setLeftTitleClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                BaseActivity.this.onBackPressed();
            }
        });
        ct.setMainTitle(title);
        if (rightBtn) {
            ct.setRightTitleDrawable(resId);
            ct.setRightTitleClickListener(clickListener);
        }
        setSupportActionBar(ct);
    }


    /**
     * 设置状态栏（渐变）
     * <p>
     * https://www.jb51.net/article/124110.htm
     * <p>
     * https://blog.csdn.net/u010127332/article/details/81502950
     */
    private void setStatusBarView() {
        //延时加载数据，保证Statusbar绘制完成后再findview。
        Looper.myQueue().addIdleHandler(new MessageQueue.IdleHandler() {
            @Override
            public boolean queueIdle() {
                initStatusBar();

                //不加监听,也能实现改变statusbar颜色的效果。但是会出现问题：比如弹软键盘后,弹popwindow后,引起window状态改变时,statusbar的颜色就会复原.
                getWindow().getDecorView().addOnLayoutChangeListener(new View.OnLayoutChangeListener() {
                    @Override
                    public void onLayoutChange(View v, int left, int top, int right, int bottom, int oldLeft, int oldTop, int oldRight, int oldBottom) {
                        initStatusBar();
                        getWindow().getDecorView().removeOnLayoutChangeListener(this);
                    }
                });

                //只走一次
                return false;
            }
        });
    }

    /**
     * 颜色渐变
     */
    private void initStatusBar() {
        if (statusBarView == null) {
            //利用反射机制修改状态栏背景
            int identifier = getResources().getIdentifier("statusBarBackground", "id", "android");
            statusBarView = getWindow().findViewById(identifier);
        }

        if (statusBarView != null) {
            if (BaseActivity.this instanceof MainActivity) {
                setNavigationBarStatusBarTranslucent(this);
            } else {
                statusBarView.setBackgroundResource(R.drawable.shape_gradient);
            }
        }
    }

    public void setNavigationBarStatusBarTranslucent(Activity activity){
        if (Build.VERSION.SDK_INT >= 21) {
            View decorView = activity.getWindow().getDecorView();
            int option = View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
                    | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
                    | View.SYSTEM_UI_FLAG_LAYOUT_STABLE;
            decorView.setSystemUiVisibility(option);
            activity.getWindow().setNavigationBarColor(Color.TRANSPARENT);
            activity.getWindow().setStatusBarColor(Color.TRANSPARENT);
        }
    }

}
