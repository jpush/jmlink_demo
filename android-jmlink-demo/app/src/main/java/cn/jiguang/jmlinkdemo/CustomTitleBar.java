package cn.jiguang.jmlinkdemo;

import android.app.Activity;
import android.view.View;
import android.view.Window;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.TextView;

public class CustomTitleBar {

    private Activity mActivity;
    //不要使用 static 因为有三级页面返回时会报错

    /**
     * @param activity
     * @param title
     * @see [自定义标题栏]
     */
    public void getTitleBar(Activity activity, String title, boolean right, int resId, View.OnClickListener listener) {
        mActivity = activity;
        activity.requestWindowFeature(Window.FEATURE_CUSTOM_TITLE);
        //指定自定义标题栏的布局文件
        activity.setContentView(R.layout.mytitlebar);
        activity.getWindow().setFeatureInt(Window.FEATURE_CUSTOM_TITLE,
                R.layout.mytitlebar);
//获取自定义标题栏的TextView控件并设置内容为传递过来的字符串
        TextView textView = (TextView) activity.findViewById(R.id.mytitle);
        textView.setText(title);
        //设置返回按钮的点击事件
        ImageView titleBack = activity.findViewById(R.id.bt_back);
        titleBack.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                //调用系统的返回按键的点击事件
                mActivity.onBackPressed();
            }
        });
        if (right) {
            ImageView rightBtn = activity.findViewById(R.id.right);
            rightBtn.setImageResource(resId);
            rightBtn.setVisibility(View.VISIBLE);
            rightBtn.setOnClickListener(listener);
        }
    }
}
