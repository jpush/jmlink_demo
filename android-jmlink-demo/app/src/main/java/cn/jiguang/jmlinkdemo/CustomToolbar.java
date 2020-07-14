package cn.jiguang.jmlinkdemo;

import android.content.Context;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.appcompat.widget.Toolbar;

public class CustomToolbar extends Toolbar {
    /**
     * 左侧Title
     */
    private View mTxtLeftTitle;
    /**
     * 中间Title
     */
    private TextView mTxtMiddleTitle;
    /**
     * 右侧Title
     */
    private ImageView mTxtRightTitle;

    public CustomToolbar(Context context) {
        this(context,null);
    }

    public CustomToolbar(Context context, AttributeSet attrs) {
        this(context, attrs,0);
    }

    public CustomToolbar(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init(context);
    }

    private void init(Context context) {
        View view = LayoutInflater.from(context).inflate(R.layout.mytitlebar, this);
        mTxtLeftTitle = view.findViewById(R.id.bt_back);
        mTxtMiddleTitle = view.findViewById(R.id.mytitle);
        mTxtRightTitle = view.findViewById(R.id.right);
    }


    //设置中间title的内容
    public void setMainTitle(String text) {
        this.setTitle("");
        mTxtMiddleTitle.setText(text);
    }

    //设置title右边图标
    public void setRightTitleDrawable(int res) {
        mTxtRightTitle.setImageResource(res);
        mTxtRightTitle.setVisibility(VISIBLE);
    }

    //设置title右边点击事件
    public void setLeftTitleClickListener(OnClickListener onClickListener){
        mTxtLeftTitle.setOnClickListener(onClickListener);
    }

    //设置title右边点击事件
    public void setRightTitleClickListener(OnClickListener onClickListener){
        mTxtRightTitle.setOnClickListener(onClickListener);
    }
}
