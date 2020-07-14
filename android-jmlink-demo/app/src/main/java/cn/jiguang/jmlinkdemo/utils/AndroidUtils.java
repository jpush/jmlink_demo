package cn.jiguang.jmlinkdemo.utils;

import android.content.Context;

public class AndroidUtils {
    public static float getDesnity(Context context) {
        float desnity = 0;
        try {
            desnity = context.getResources().getDisplayMetrics().density;
        } catch (Throwable t) {
            t.printStackTrace();
        }
        return desnity;
    }
}
