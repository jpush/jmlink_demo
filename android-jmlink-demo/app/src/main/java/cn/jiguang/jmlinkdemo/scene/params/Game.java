package cn.jiguang.jmlinkdemo.scene.params;

import android.app.Activity;
import android.content.DialogInterface;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;
import org.json.JSONArray;
import org.json.JSONObject;

import java.io.IOException;
import java.lang.ref.WeakReference;
import java.util.concurrent.TimeUnit;

import androidx.annotation.NonNull;
import cn.jiguang.jmlinkdemo.BaseActivity;
import cn.jiguang.jmlinkdemo.R;
import cn.jiguang.jmlinkdemo.ShareDialog;
import cn.jiguang.jmlinkdemo.common.Constants;
import cn.jiguang.jmlinkdemo.helper.UserInfoHelper;
import cn.jiguang.jmlinkdemo.model.UserInfo;
import cn.jiguang.jmlinkdemo.network.HttpClient;
import cn.jiguang.jmlinkdemo.utils.SPHelper;
import cn.jiguang.jmlinkdemo.utils.dialog.ConfirmDialog;
import cn.jiguang.jmlinkdemo.utils.dialog.LoadDialog;
import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.Response;

public class Game extends BaseActivity implements View.OnClickListener {
    private static final String TAG = "Game";
    private static final String TITLE = "游戏邀请";
    private static final String TEXT = "欢迎使用极光魔链";
    private static final String URL = Constants.SHARE + "/#/page6";
    private LoadDialog loadDialog;
    private static final int TYPE_GET_MEMBER = 1;
    private static final int TYPE_CREATE_ROOM_AND_JOIN = 2;
    private static final int TYPE_JOIN_ROOM = 3;
    private long mRoomId;
    private TextView mTextRoomId;
    private RefreshTask refreshTask;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_game);
        loadDialog = new LoadDialog(Game.this, false, "");
        mTextRoomId = findViewById(R.id.roomId);
        initTitle(R.id.toolbar, TITLE, true, R.drawable.refresh_selector, new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                loadDialog.show();
                refreshRoomMember();
            }
        });
        initView();
        startRefresh();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        stopRefresh();
    }

    private void initView() {
        Bundle bundle = getIntent().getExtras();
        final long roomId = bundle != null ? bundle.getLong("room_id") : 0L;
        final long originRoomId = SPHelper.getRoomId();
        if (roomId != 0) {
            if (originRoomId != 0 && originRoomId != roomId) {
                new ConfirmDialog(this, "您已经在游戏房间，确认要退出游戏并加入新的游戏房间吗？", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        loadDialog.show();
                        updateRoomId(roomId);
                        joinRoom();
                    }
                }, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        loadDialog.show();
                        updateRoomId(originRoomId);
                        refreshRoomMember();
                    }
                }).show();
            } else if (originRoomId == 0) {
                String username = bundle.getString("username");
                new ConfirmDialog(this, username + "邀请你加入房间， 是否加入", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        loadDialog.show();
                        updateRoomId(roomId);
                        joinRoom();
                    }
                }, null).show();
            } else {
                updateRoomId(originRoomId);
                loadDialog.show();
                refreshRoomMember();
            }
        } else if (originRoomId != 0){
            updateRoomId(originRoomId);
            loadDialog.show();
            refreshRoomMember();
        }
        findViewById(R.id.create).setOnClickListener(this);
        findViewById(R.id.invite).setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.create:
                loadDialog.show();
                createAndJoinRoom();
                break;
            case R.id.invite:
                if (mRoomId != 0) {
                    new ShareDialog(Game.this, TITLE, TEXT, URL + "?type=3&scene=6&uid=" + UserInfoHelper.getMyInfo().getUserId()
                            + "&username=" + Uri.encode(UserInfoHelper.getMyInfo().getUsername()) + "&room_id=" + mRoomId).show();
                } else {
                    Toast.makeText(Game.this, "请先创建房间", Toast.LENGTH_SHORT).show();
                }
                break;

        }
    }

    private static class RefreshTask implements Runnable {
        WeakReference<Activity> weakReference;
        private volatile boolean isCancelled;
        RefreshTask(Activity activity) {
            weakReference = new WeakReference<>(activity);
        }

        @Override
        public void run() {
            try {
                while (true) {
                    TimeUnit.SECONDS.sleep(10);
                    Activity activity = weakReference.get();
                    if (isCancelled || activity == null) {
                        break;
                    }
                    ((Game) activity).refreshRoomMember();
                }
            } catch (Throwable t) {
                t.printStackTrace();
            }
        }

        void stop() {
            isCancelled = true;
        }
    }

    private void startRefresh() {
        if (refreshTask == null) {
            refreshTask = new RefreshTask(this);
            Log.d(TAG, "startRefresh");
            new Thread(refreshTask).start();
        }
    }

    private void stopRefresh() {
        if (refreshTask != null) {
            Log.d(TAG, "stopRefresh");
            refreshTask.stop();
        }
    }

    private void resetMember() {
        ((ImageView) findViewById(R.id.user1_avatar)).setImageResource(R.drawable.user_default);
        ((TextView) findViewById(R.id.user1_name)).setText(R.string.game_user_name_default);
        ((ImageView) findViewById(R.id.user2_avatar)).setImageResource(R.drawable.user_default);
        ((TextView) findViewById(R.id.user2_name)).setText(R.string.game_user_name_default);
        ((ImageView) findViewById(R.id.user3_avatar)).setImageResource(R.drawable.user_default);
        ((TextView) findViewById(R.id.user3_name)).setText(R.string.game_user_name_default);
    }

    private void joinRoom() {
        try {
            JSONObject body = new JSONObject();
            body.put("room_id", mRoomId);
            body.put("uid", UserInfoHelper.getMyInfo().getUserId());
            body.put("username", UserInfoHelper.getMyInfo().getUsername());
            HttpClient.sendPost(Constants.HOST + Constants.GAME_JOIN_ROOM, body.toString(),
                    new MyCallback(Game.this, TYPE_JOIN_ROOM));
        } catch (Exception e) {
            e.printStackTrace();
            dismiss();
        }
    }

    private void updateRoomId(long roomId) {
        SPHelper.setRoomId(roomId);
        mRoomId = roomId;
        String text = "房间号: " + mRoomId;
        mTextRoomId.setText(text);

    }

    private void createAndJoinRoom() {
        HttpClient.sendGet(Constants.HOST + Constants.GAME_CREATE_ROOM, new MyCallback(Game.this, TYPE_CREATE_ROOM_AND_JOIN));
    }

    private synchronized void refreshRoomMember() {
        final long roomId = mRoomId;
        if (roomId != 0) {
            HttpClient.sendGet(Constants.HOST + Constants.GAME_GET_MEMBER + "?room_id=" + roomId,
                    new MyCallback(Game.this, TYPE_GET_MEMBER, roomId));
        } else {
            dismiss();
        }
    }

    private void dismiss() {
        if (loadDialog != null) {
            loadDialog.dismiss();
        }
    }

    private static class MyCallback implements Callback {
        private int type;
        private WeakReference<Activity> activityWeakReference;
        private long roomId;

        MyCallback(Activity activity, int type) {
            this(activity, type, 0);
        }

        MyCallback(Activity activity, int type, long roomId) {
            activityWeakReference = new WeakReference<>(activity);
            this.type = type;
            this.roomId = roomId;
        }

        public void onFailure(@NonNull Call call, @NonNull IOException e) {
            Activity activity = activityWeakReference.get();
            if (activity != null) {
                ((Game) activity).dismiss();
            }
            e.printStackTrace();
        }

        @Override
        public void onResponse(@NonNull Call call, @NonNull Response response) {
            switch (type) {
                case TYPE_GET_MEMBER:
                    handleGetMember(response);
                    break;
                case TYPE_CREATE_ROOM_AND_JOIN:
                    handleCreateAndJoinRoom(response);
                    break;
                case TYPE_JOIN_ROOM:
                    handleJoinRoom(response);
                    break;
                default:
                    break;
            }
        }

        private void handleGetMember(final Response response) {
            final Activity activity = activityWeakReference.get();
            if (response != null && response.isSuccessful() && response.body() != null && activity != null
            && roomId == ((Game)activity).mRoomId) {
                activity.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        try {
                            JSONObject jsonObject = new JSONObject(response.body().string());
                            int status = jsonObject.getInt("status");
                            if (status == 0) {
                                JSONArray users = jsonObject.getJSONArray("users");
                                int length = users.length();
                                UserInfo[] userInfos = new UserInfo[length];
                                for (int i = 0; i < length; i++) {
                                    userInfos[i] = new UserInfo(users.getJSONObject(i).getLong("uid"),
                                            users.getJSONObject(i).getString("username"));
                                }
                                ((Game) activity).resetMember();
                                switch (length) {
                                    case 3:
                                        ((ImageView) activity.findViewById(R.id.user3_avatar)).setImageResource(userInfos[2].getAvatar());
                                        ((TextView) activity.findViewById(R.id.user3_name)).setText(getName(userInfos[2]));
                                    case 2:
                                        ((ImageView) activity.findViewById(R.id.user2_avatar)).setImageResource(userInfos[1].getAvatar());
                                        ((TextView) activity.findViewById(R.id.user2_name)).setText(getName(userInfos[1]));
                                    case 1:
                                        ((ImageView) activity.findViewById(R.id.user1_avatar)).setImageResource(userInfos[0].getAvatar());
                                        ((TextView) activity.findViewById(R.id.user1_name)).setText(getName(userInfos[0]));
                                        break;
                                    default:
                                        break;
                                }
                            } else {
                                ((Game) activity).updateRoomId(0);
                                ((Game) activity).resetMember();
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                        ((Game) activity).dismiss();
                    }
                });
            } else {
                if (activity != null) {
                    ((Game) activity).dismiss();
                }
            }
        }

        private void handleJoinRoom(Response response) {
            final Activity activity = activityWeakReference.get();
            if (response != null && response.isSuccessful() && response.body() != null && activity != null) {
                try {
                    JSONObject result = new JSONObject(response.body().string());
                    final int status = result.getInt("status");
                    activity.runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            String text;
                            if (status == 0) {
                                text = "您已加入游戏";
                            } else if (status == 1){
                                text = "加入房间失败,房间人数已满";
                            } else {
                                text = "加入房间失败";
                            }
                            Toast.makeText(activity, text, Toast.LENGTH_SHORT).show();
                        }
                    });
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            // 不管加入是否成功.刷新成员
            if (activity != null) {
                ((Game) activity).refreshRoomMember();
            }
        }

        private void handleCreateAndJoinRoom(Response response) {
            final Activity activity = activityWeakReference.get();
            if (response != null && response.isSuccessful() && response.body() != null) {
                try {
                    JSONObject jsonObject = new JSONObject(response.body().string());
                    final UserInfo myInfo = UserInfoHelper.getMyInfo();
                    final long roomId = jsonObject.getLong("room_id");
                    JSONObject body = new JSONObject();
                    body.put("room_id", roomId);
                    body.put("uid", myInfo.getUserId());
                    body.put("username", myInfo.getUsername());
                    Response result = HttpClient.sendPostSync(Constants.HOST + Constants.GAME_JOIN_ROOM, body.toString());
                    if (result.isSuccessful() && result.body() != null) {
                        int status = new JSONObject(result.body().string()).getInt("status");
                        if (status == 0 && activity != null) {
                            activity.runOnUiThread(new Runnable() {
                                @Override
                                public void run() {
                                    ((Game) activity).updateRoomId(roomId);
                                    ((Game) activity).resetMember();
                                    ((ImageView) activity.findViewById(R.id.user1_avatar)).setImageResource(myInfo.getAvatar());
                                    ((TextView) activity.findViewById(R.id.user1_name)).setText("我");
                                    ((Game) activity).dismiss();
                                    Toast.makeText(activity, "创建成功", Toast.LENGTH_SHORT).show();
                                }
                            });
                            return;
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            if (activity != null) {
                ((Game) activity).dismiss();
            }
        }
    }

    private static String getName(UserInfo userInfo) {
        if (UserInfoHelper.getMyInfo().getUserId() == userInfo.getUserId()) {
            return "我";
        }
        return userInfo.getUsername();
    }
}
