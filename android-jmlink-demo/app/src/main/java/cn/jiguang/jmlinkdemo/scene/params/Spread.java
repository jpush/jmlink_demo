package cn.jiguang.jmlinkdemo.scene.params;

import android.app.Activity;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import org.json.JSONObject;

import java.io.IOException;
import java.lang.ref.WeakReference;
import java.util.concurrent.TimeUnit;

import cn.jiguang.jmlinkdemo.helper.UserInfoHelper;
import cn.jiguang.jmlinkdemo.BaseActivity;
import cn.jiguang.jmlinkdemo.R;
import cn.jiguang.jmlinkdemo.common.Constants;
import cn.jiguang.jmlinkdemo.network.HttpClient;
import cn.jiguang.jmlinkdemo.utils.AndroidUtils;
import cn.jiguang.jmlinkdemo.utils.QRCodeUtil;
import cn.jiguang.jmlinkdemo.utils.dialog.LoadDialog;
import cn.jiguang.jmlinkdemo.model.UserInfo;
import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.Response;

public class Spread extends BaseActivity {
    private static final String TAG = "Spread";
    private static final String TITLE = "地推";
    private LoadDialog loadDialog;
    private static final int TYPE_REPORT = 1;
    private static final int TYPE_GET_NUMBER = 2;
    private static final String URL = "https://arguys.jmlk.co/AAlq";
    private TextView numberText;
    private RefreshTask refreshTask;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_spread);
        numberText = findViewById(R.id.number);
        loadDialog = new LoadDialog(Spread.this, false, "");
        initTitle(R.id.toolbar, TITLE, true, R.drawable.refresh_selector, new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                loadDialog.show();
                refreshNumber(UserInfoHelper.getMyInfo());
            }
        });
        initView();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        stopRefresh();
    }

    private static class RefreshTask implements Runnable {
        private volatile boolean isStopped;
        private WeakReference<Activity> weakReference;
        RefreshTask(Activity activity) {
            weakReference = new WeakReference<>(activity);
        }
        @Override
        public void run() {
            while (true) {
                try {
                    Activity activity = weakReference.get();
                    if (isStopped || activity == null) {
                        break;
                    }
                    ((Spread) activity).refreshNumber(UserInfoHelper.getMyInfo());
                    TimeUnit.SECONDS.sleep(10);
                } catch (Throwable t) {
                    t.printStackTrace();
                }
            }
        }

        void stop() {
            isStopped = true;
        }
    }

    private void startRefresh() {
        if (refreshTask == null) {
            refreshTask = new RefreshTask(this);
            new Thread(refreshTask).start();
        }
    }

    private void stopRefresh() {
        if (refreshTask != null) {
            refreshTask.stop();
        }
    }

    private void initView() {
        UserInfo myInfo = UserInfoHelper.getMyInfo();
        if (myInfo != null) {
            ((ImageView) findViewById(R.id.user_avatar)).setImageResource(myInfo.getAvatar());
            ((TextView) findViewById(R.id.user_name)).setText(myInfo.getUsername());
            String id = "ID: " + myInfo.getUserId();
            ((TextView) findViewById(R.id.user_id)).setText(id);
            String url = URL + "?type=3&scene=5&uid=" + myInfo.getUserId() + "&username=" + Uri.encode(myInfo.getUsername());
            float desnity = AndroidUtils.getDesnity(this);
            int width = (int) (180 * desnity + 0.5f);
            int height = (int) (180 * desnity + 0.5f);
            ((ImageView) findViewById(R.id.image)).setImageBitmap(QRCodeUtil.createQRCodeBitmap(url, width, height));
            startRefresh();
            Bundle bundle = getIntent().getExtras();
            if (bundle != null && bundle.size() > 1) {
                long uid = bundle.getLong("uid");
                if (uid != 0 && uid != myInfo.getUserId()) {
                    report(uid);
                    Toast.makeText(this, "你通过扫描" + bundle.getString("username") + "的二维码下载魔链APP", Toast.LENGTH_LONG).show();
                }
            }
        }
    }

    private void refreshNumber(int number) {
        String text = number + "人";
        numberText.setText(text);
    }

    private void report(long uid) {
        try {
            JSONObject postJson = new JSONObject();
            postJson.put("uid", uid);
            String body = postJson.toString();
            HttpClient.sendPost(Constants.HOST + Constants.SPREAD_REPORT, body, new MyCallback(Spread.this, TYPE_REPORT));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void dismiss() {
        if (loadDialog != null) {
            loadDialog.dismiss();
        }
    }

    private void refreshNumber(UserInfo userInfo) {
        if (userInfo != null) {
            HttpClient.sendGet(Constants.HOST + Constants.SPREAD_GET_COUNT + "?uid=" + userInfo.getUserId(),
                    new MyCallback(Spread.this, TYPE_GET_NUMBER));
        } else {
            dismiss();
        }
    }

    private static class MyCallback implements Callback {
        WeakReference<Activity> activityWeakReference;
        int type;
        MyCallback(Activity activity, int type) {
            activityWeakReference = new WeakReference<>(activity);
            this.type = type;
        }
        @Override
        public void onFailure(Call call, IOException e) {
            if (type == TYPE_GET_NUMBER) {
                Activity activity = activityWeakReference.get();
                if (activity != null) {
                    ((Spread)activity).loadDialog.dismiss();
                }
            }
            e.printStackTrace();
        }

        @Override
        public void onResponse(Call call, final Response response) {
            if (!response.isSuccessful()) {
                Log.e(TAG, "type:" + type + ", code:" + response.code());
            }
            if (type == TYPE_GET_NUMBER) {
                final Activity activity = activityWeakReference.get();
                if (response.isSuccessful() && activity != null) {
                    activity.runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            try {
                                String data = response.body() != null ? response.body().string() : null;
                                if (data != null) {
                                    JSONObject jsonObject = new JSONObject(data);
                                    int count = jsonObject.getInt("count");
                                    ((Spread) activity).refreshNumber(count);
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                            ((Spread)activity).dismiss();
                        }
                    });
                } else {
                    if (activity != null) {
                        ((Spread)activity).dismiss();
                    }
                }
            }
        }
    }
}
