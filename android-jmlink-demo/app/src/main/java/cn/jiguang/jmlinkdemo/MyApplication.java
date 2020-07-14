package cn.jiguang.jmlinkdemo;

import android.app.Application;

import cn.jiguang.jmlinkdemo.utils.SPHelper;
import cn.jiguang.jmlinksdk.api.JMLinkAPI;
import cn.jiguang.share.android.api.JShareInterface;

public class MyApplication extends Application {
    @Override
    public void onCreate() {
        super.onCreate();
        JMLinkAPI.getInstance().setDebugMode(true);
        JShareInterface.setDebugMode(true);
        JMLinkAPI.getInstance().init(this);
        JShareInterface.init(this);
        SPHelper.init(this);
    }
}
