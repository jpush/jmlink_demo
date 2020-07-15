package cn.jiguang.jmlinkdemo.scene.params;

import android.app.Activity;
import android.content.DialogInterface;
import android.net.Uri;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.ScrollView;
import android.widget.TextView;
import android.widget.Toast;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.IOException;
import java.lang.ref.WeakReference;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.concurrent.TimeUnit;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
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

public class GroupShop extends BaseActivity {
    private static final String TITLE = "拼团邀请";
    private static final String TEXT = "欢迎使用极光魔链";
    private static final String URL = Constants.SHARE + "/#/page1";
    private LoadDialog loadDialog;
    private static final int TYPE_JOIN_GROUP = 1;
    private static final int TYPE_GET_GROUP_MEMBER = 2;
    private static final int TYPE_CREATE_AND_JOIN = 3;
    private List<UserInfo> mdatas = new ArrayList<>();
    private long mGroupId;
    private GroupAdapter madapter;
    private ScrollView scrollView;
    private TextView mTextBtn;
    private RefreshTask mRefreshTask;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_group_shop);
        scrollView = findViewById(R.id.group_shop);
        mTextBtn = findViewById(R.id.createOrInvtite);
        loadDialog = new LoadDialog(GroupShop.this, false, "");
        initTitle(R.id.toolbar, TITLE, true, R.drawable.refresh_selector, new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                loadDialog.show();
                refreshGroup();
            }
        });
        RecyclerView recyclerView = findViewById(R.id.group_users);
        recyclerView.setLayoutManager(new LinearLayoutManager(this));
        recyclerView.setNestedScrollingEnabled(false);
        madapter = new GroupAdapter();
        recyclerView.setAdapter(madapter);
        initData();
        findViewById(R.id.createOrInvtite).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (mGroupId != 0) {
                    String url = URL + "?type=3&scene=7&uid=" + UserInfoHelper.getMyInfo().getUserId() +
                            "&username=" + Uri.encode(UserInfoHelper.getMyInfo().getUsername()) + "&group_id=" + mGroupId;
                    new ShareDialog(GroupShop.this, TITLE, TEXT, url).show();
                } else {
                    loadDialog.show();
                    createAndJoin();
                }
            }
        });
        startRefresh();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        stopRefresh();
    }

    private void startRefresh() {
        if (mRefreshTask == null) {
            mRefreshTask = new RefreshTask(this);
            new Thread(mRefreshTask).start();
        }
    }

    private void stopRefresh() {
        if (mRefreshTask != null) {
            mRefreshTask.stop();
        }
    }

    private static class RefreshTask implements Runnable {
        WeakReference<Activity> weakReference;
        private volatile boolean isStopped;
        RefreshTask(Activity activity) {
            weakReference = new WeakReference<>(activity);
        }

        @Override
        public void run() {
            try {
                while (true) {
                    TimeUnit.SECONDS.sleep(10);
                    Activity activity = weakReference.get();
                    if (isStopped || activity == null) {
                        break;
                    }
                    ((GroupShop) activity).refreshGroup();
                }
            } catch (Throwable t) {
                t.printStackTrace();
            }
        }

        void stop() {
            isStopped = true;
        }
    }

    private void updateGroupId(long groupId) {
        SPHelper.setGroupId(groupId);
        mGroupId = groupId;
        if (mGroupId != 0 && mTextBtn != null) {
            mTextBtn.setText("邀请其他人加入");
        }
    }

    private void initData() {
        Bundle bundle = getIntent().getExtras();
        final long groupId = bundle != null ? bundle.getLong("group_id") : 0L;
        final long originGroupId = SPHelper.getGroupId();
        if (groupId != 0) {
            if (originGroupId != groupId && originGroupId != 0) {
                new ConfirmDialog(this, "您已在拼团中，是否加入其他拼团", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        updateGroupId(groupId);
                        loadDialog.show();
                        joinGroup();
                    }
                }, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        updateGroupId(originGroupId);
                        refreshGroup();
                    }
                }).show();
            } else if (originGroupId == 0){
                String userName = bundle.getString("username");
                new ConfirmDialog(this, userName + "邀请你加入拼团，是否加入", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        updateGroupId(groupId);
                        loadDialog.show();
                        joinGroup();
                    }
                }, null).show();
            } else {
                updateGroupId(originGroupId);
                loadDialog.show();
                refreshGroup();
            }
        } else if (originGroupId != 0){
            updateGroupId(originGroupId);
            loadDialog.show();
            refreshGroup();
        }
    }

    private void dismiss() {
        if (loadDialog != null) {
            loadDialog.dismiss();
        }
    }

    private void updateData(List<UserInfo> userInfos) {
        mdatas.clear();
        mdatas.addAll(userInfos);
        if (madapter != null) {
            madapter.notifyDataSetChanged();
        }
        scrollView.postDelayed(new Runnable() {
            @Override
            public void run() {
                scrollView.fullScroll(ScrollView.FOCUS_DOWN);
            }
        }, 30);

    }

    private void createAndJoin() {
        HttpClient.sendGet(Constants.HOST + Constants.GROUP_CREATE, new MyCallback(GroupShop.this,
                TYPE_CREATE_AND_JOIN));
    }

    private synchronized void refreshGroup() {
        if (mGroupId != 0) {
            HttpClient.sendGet(Constants.HOST + Constants.GROUP_GET_MEMBER + "?group_id=" + mGroupId,
                    new MyCallback(GroupShop.this, TYPE_GET_GROUP_MEMBER, mGroupId));
        } else {
            dismiss();
        }
    }

    private void joinGroup() {
        try {
            JSONObject body = new JSONObject();
            body.put("group_id", mGroupId);
            body.put("uid", UserInfoHelper.getMyInfo().getUserId());
            body.put("username", UserInfoHelper.getMyInfo().getUsername());
            HttpClient.sendPost(Constants.HOST + Constants.GROUP_JOIN, body.toString(),
                    new MyCallback(GroupShop.this, TYPE_JOIN_GROUP));
        } catch (Exception e) {
            e.printStackTrace();
            dismiss();
        }
    }

    static class MyCallback implements Callback {
        WeakReference<Activity> weakReference;
        int type;
        long groupId;
        MyCallback(Activity activity, int type) {
            this(activity, type, 0);
        }

        MyCallback(Activity activity, int type, long groupId) {
            weakReference = new WeakReference<>(activity);
            this.type = type;
            this.groupId = groupId;
        }
        @Override
        public void onFailure(@Nullable Call call, @Nullable IOException e) {
            Activity activity = weakReference.get();
            if (activity != null) {
                ((GroupShop) activity).dismiss();
            }
            if (e != null) {
                e.printStackTrace();
            }
        }

        @Override
        public void onResponse(@Nullable Call call, @Nullable Response response) {
            switch (type) {
                case TYPE_JOIN_GROUP:
                    handleJoinGroup(response);
                    break;
                case TYPE_GET_GROUP_MEMBER:
                    handleGetGroupMember(response);
                    break;
                case TYPE_CREATE_AND_JOIN:
                    handleCreateAndJoin(response);
                    break;

            }
        }

        private void handleCreateAndJoin(Response response) {
            final Activity activity = weakReference.get();
            if (response != null && response.isSuccessful() && response.body() != null) {
                try {
                    JSONObject jsonObject = new JSONObject(response.body().string());
                    final long groupId = jsonObject.getLong("group_id");
                    if (activity != null) {
                        JSONObject body = new JSONObject();
                        body.put("group_id", groupId);
                        body.put("uid", UserInfoHelper.getMyInfo().getUserId());
                        body.put("username", UserInfoHelper.getMyInfo().getUsername());
                        Response result = HttpClient.sendPostSync(Constants.HOST + Constants.GROUP_JOIN, body.toString());
                        if (result.isSuccessful() && result.body() != null) {
                            JSONObject object = new JSONObject(result.body().string());
                            if (object.getInt("status") == 0) {
                                final List<UserInfo> userInfos = Collections.singletonList(UserInfoHelper.getMyInfo());
                                activity.runOnUiThread(new Runnable() {
                                    @Override
                                    public void run() {
                                        ((GroupShop) activity).updateGroupId(groupId);
                                        ((GroupShop) activity).updateData(userInfos);
                                        ((GroupShop) activity).dismiss();
                                    }
                                });
                                return;
                            }
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
                if (activity != null) {
                    ((GroupShop) activity).dismiss();
                }
            }
        }

        private void handleGetGroupMember(final Response response) {
            final Activity activity = weakReference.get();
            if (response != null && response.isSuccessful() && response.body() != null && activity != null
            && groupId == ((GroupShop) activity).mGroupId) {
                activity.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        try {
                            JSONObject jsonObject = new JSONObject(response.body().string());
                            final List<UserInfo> userInfos = new ArrayList<>();
                            if (jsonObject.getInt("status") == 0) {
                                JSONArray array = jsonObject.getJSONArray("users");
                                for (int i = 0; i < array.length(); i++) {
                                    JSONObject object = array.getJSONObject(i);
                                    userInfos.add(new UserInfo(object.getLong("uid"), object.getString("username")));
                                }
                            } else {
                                ((GroupShop) activity).updateGroupId(0L);
                            }
                            ((GroupShop) activity).updateData(userInfos);
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }
                });
            }
            if (activity != null) {
                ((GroupShop) activity).dismiss();
            }
        }


        private void handleJoinGroup(Response response) {
            final Activity activity = weakReference.get();
            if (response != null && response.isSuccessful() && response.body() != null && activity != null) {
                try {
                    JSONObject result = new JSONObject(response.body().string());
                    final int status = result.getInt("status");
                    activity.runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            if (status == 0) {
                                Toast.makeText(activity, "您已加入拼团", Toast.LENGTH_SHORT).show();
                            } else {
                                Toast.makeText(activity, "加入拼团失败", Toast.LENGTH_SHORT).show();
                            }
                        }
                    });
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            // 不管加入是否成功.刷新成员
            if (activity != null) {
                ((GroupShop) activity).refreshGroup();
            }
        }
    }

    class MyViewHolder extends RecyclerView.ViewHolder {
        ImageView userAvatar;
        TextView userName;
        MyViewHolder(@NonNull View itemView) {
            super(itemView);
            userAvatar = itemView.findViewById(R.id.group_user_avatar);
            userName = itemView.findViewById(R.id.group_user_name);
        }
    }

    private class GroupAdapter extends RecyclerView.Adapter<MyViewHolder> {

        @NonNull
        @Override
        public MyViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
            return new MyViewHolder(LayoutInflater.from(
                    parent.getContext()).inflate(R.layout.group_user_item, parent,
                    false));
        }

        @Override
        public void onBindViewHolder(@NonNull MyViewHolder holder, int position) {
            holder.userAvatar.setImageResource(mdatas.get(position).getAvatar());
            holder.userName.setText(mdatas.get(position).getUsername());
        }

        @Override
        public int getItemCount() {
            return mdatas.size();
        }
    }
}
