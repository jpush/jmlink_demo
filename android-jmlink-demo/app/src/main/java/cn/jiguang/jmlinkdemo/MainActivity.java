package cn.jiguang.jmlinkdemo;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;

import java.util.Map;

import androidx.annotation.RequiresApi;
import cn.jiguang.jmlinkdemo.scene.params.Game;
import cn.jiguang.jmlinkdemo.scene.params.GroupShop;
import cn.jiguang.jmlinkdemo.scene.params.ParamsActivity;
import cn.jiguang.jmlinkdemo.scene.params.Spread;
import cn.jiguang.jmlinkdemo.scene.replay.Goods;
import cn.jiguang.jmlinkdemo.scene.replay.News;
import cn.jiguang.jmlinkdemo.scene.replay.ReplayActivity;
import cn.jiguang.jmlinkdemo.scene.scheme.AKan;
import cn.jiguang.jmlinkdemo.scene.scheme.Novel;
import cn.jiguang.jmlinkdemo.scene.scheme.SchmeActivity;
import cn.jiguang.jmlinkdemo.scene.template.TemplateActivity;
import cn.jiguang.jmlinksdk.api.JMLinkAPI;
import cn.jiguang.jmlinksdk.api.JMLinkCallback;
import cn.jiguang.jmlinksdk.api.ReplayCallback;

;

public class MainActivity extends BaseActivity implements View.OnClickListener {
    private static String TAG = "MainActivity";
    @RequiresApi(api = Build.VERSION_CODES.N)
    @Override
    protected void onCreate(Bundle savedInstanceState) {
//        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
//                WindowManager.LayoutParams.FLAG_FULLSCREEN);
//        requestWindowFeature(Window.FEATURE_NO_TITLE);
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        findViewById(R.id.openScheme).setOnClickListener(this);
        findViewById(R.id.replay).setOnClickListener(this);
        findViewById(R.id.params).setOnClickListener(this);
        findViewById(R.id.models).setOnClickListener(this);
        init();
    }

    private void init() {
        Uri uri = getIntent().getData();
        JMLinkAPI.getInstance().registerDefault(new MyRegisterCallback(this));
        if (uri != null) {
            JMLinkAPI.getInstance().router(uri);
        } else {
            JMLinkAPI.getInstance().replay(new MyReplayCallback(this));
        }
    }

    static class MyRegisterCallback implements JMLinkCallback {
        Context context;
        MyRegisterCallback(Activity activity) {
            context = activity.getApplicationContext();
        }
        @Override
        public void execute(Map<String, String> map, Uri uri) {
            Intent intent = new Intent();
            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TOP);
            try {
                String scene = map.get("scene");
                if (scene != null) {
                    switch (scene) {
                        case "1":
                            intent.setClass(context, AKan.class);
                            context.startActivity(intent);
                            break;
                        case "2":
                            intent.setClass(context, Novel.class);
                            context.startActivity(intent);
                            break;
                        case "3":
                            intent.setClass(context, News.class);
                            context.startActivity(intent);
                            break;
                        case "4":
                            intent.setClass(context, Goods.class);
                            context.startActivity(intent);
                            break;
                        case "5":
                            intent.setClass(context, Spread.class);
                            String uid = map.get("uid");
                            intent.putExtra("uid", uid != null ? Long.valueOf(uid) : 0L);
                            intent.putExtra("username", Uri.decode(Uri.decode(map.get("username"))));
                            context.startActivity(intent);
                            break;
                        case "6":
                            intent.setClass(context, Game.class);
                            String roomId = map.get("room_id");
                            intent.putExtra("room_id", roomId != null ? Long.valueOf(roomId) : 0L);
                            intent.putExtra("username", Uri.decode(Uri.decode(map.get("username"))));
                            context.startActivity(intent);
                            break;
                        case "7":
                            intent.setClass(context, GroupShop.class);
                            String groupId = map.get("group_id");
                            intent.putExtra("group_id", groupId != null ? Long.valueOf(groupId) : 0L);
                            intent.putExtra("username", Uri.decode(Uri.decode(map.get("username"))));
                            context.startActivity(intent);
                            break;
                        default:
                            break;
                    }
                }
            } catch (Throwable t) {
                t.printStackTrace();
            }
        }
    }


    static class MyReplayCallback implements ReplayCallback {
        Context context;
        MyReplayCallback(Activity activity) {
            context = activity.getApplicationContext();;
        }
        @Override
        public void onFailed() {
            Log.d(TAG, "replay failed");
        }

        @Override
        public void onSuccess() {
            Log.d(TAG, "replay success");
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
    }

    @Override
    public void onClick(View v) {
        Intent intent = new Intent();
        Context context = MainActivity.this.getApplicationContext();
        switch (v.getId()) {
            case R.id.openScheme:
                intent.setClass(context, SchmeActivity.class);
                startActivity(intent);
                break;
            case R.id.replay:
                intent.setClass(context, ReplayActivity.class);
                startActivity(intent);
                break;
            case R.id.params:
                intent.setClass(context, ParamsActivity.class);
                startActivity(intent);
                break;
            case R.id.models:
                intent.setClass(context, TemplateActivity.class);
                startActivity(intent);
                break;
        }
    }
}
