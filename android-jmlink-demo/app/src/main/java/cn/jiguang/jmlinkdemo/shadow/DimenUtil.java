package cn.jiguang.jmlinkdemo.shadow;

import android.content.res.Resources;

public class DimenUtil {
    public static float dp2px(float dpValue) {
       return (0.5f + dpValue * Resources.getSystem().getDisplayMetrics().density);
    }
}
