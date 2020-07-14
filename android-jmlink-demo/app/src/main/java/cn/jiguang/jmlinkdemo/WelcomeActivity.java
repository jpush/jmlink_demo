package cn.jiguang.jmlinkdemo;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.WindowManager;

public class WelcomeActivity extends BaseActivity {
    private static final String TAG = "WelcomeActivity";
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_welcome);
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
                WindowManager.LayoutParams.FLAG_FULLSCREEN);
        init();
    }

    private void init() {
        Uri uri = getIntent().getData();
        Log.e(TAG, "data = " + uri);
        Intent intent = new Intent();
        intent.setClass(this, MainActivity.class);
        if (uri != null) {
            intent.setData(uri);
        }
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TOP);
        startActivity(intent);
        finish();
    }
}
