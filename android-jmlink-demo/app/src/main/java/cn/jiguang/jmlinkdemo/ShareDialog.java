package cn.jiguang.jmlinkdemo;

import android.app.Dialog;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Toast;

import cn.jiguang.share.android.api.JShareInterface;
import cn.jiguang.share.android.api.Platform;
import cn.jiguang.share.android.api.ShareParams;
import cn.jiguang.share.qqmodel.QQ;
import cn.jiguang.share.qqmodel.QZone;
import cn.jiguang.share.wechat.Wechat;
import cn.jiguang.share.wechat.WechatMoments;

public class ShareDialog implements View.OnClickListener {
    private Context mContext;
    private Dialog dialog;
    private String title;
    private String text;
    private String url;

    public ShareDialog(Context context, String title, String text, String url) {
        mContext = context;
        this.title = title;
        this.text = text;
        this.url = url;
    }
    public void show() {
        View view = LayoutInflater.from(mContext).inflate(R.layout.share, null);
        initView(view);
        dialog = new Dialog(mContext, com.adorkable.iosdialog.R.style.ActionSheetDialogStyle);
        dialog.setContentView(view);
        Window dialogWindow = dialog.getWindow();
        dialogWindow.setGravity(Gravity.LEFT | Gravity.BOTTOM);
        WindowManager.LayoutParams lp = dialogWindow.getAttributes();
        lp.x = 0;
        lp.y = 0;
        dialogWindow.setAttributes(lp);
        dialog.show();
    }

    @Override
    public void onClick(View v) {
        if (dialog != null) {
            dialog.dismiss();
        }
        ShareParams shareParams = new ShareParams();
        shareParams.setShareType(Platform.SHARE_WEBPAGE);
        shareParams.setTitle(title);
        shareParams.setText(text);
        shareParams.setUrl(url);
        switch (v.getId()) {
            case R.id.view_share_wx:
                JShareInterface.share(Wechat.Name, shareParams, null);
                break;
            case R.id.view_share_wxp:
                JShareInterface.share(WechatMoments.Name, shareParams, null);
                break;
            case R.id.view_share_qq:
                JShareInterface.share(QQ.Name, shareParams, null);
                break;
            case R.id.view_share_qqk:
                JShareInterface.share(QZone.Name, shareParams, null);
                break;
            case R.id.view_share_browser:
                Intent intent = new Intent();
                intent.setData(Uri.parse(url));
                intent.setAction("android.intent.action.VIEW");
                mContext.startActivity(intent);
                break;
            case R.id.view_share_copy:
                ClipboardManager clipboardManager = (ClipboardManager) mContext.getSystemService(Context.CLIPBOARD_SERVICE);
                if (clipboardManager != null) {
                    ClipData clipData = ClipData.newPlainText("", url);
                    clipboardManager.setPrimaryClip(clipData);
                    Toast.makeText(mContext, "复制成功", Toast.LENGTH_SHORT).show();
                }
                break;
        }
    }

    public boolean isShowing() {
        return dialog != null && dialog.isShowing();
    }

    private void initView(View view) {
        view.findViewById(R.id.view_share_wx).setOnClickListener(this);
        view.findViewById(R.id.view_share_wxp).setOnClickListener(this);
        view.findViewById(R.id.view_share_qq).setOnClickListener(this);
        view.findViewById(R.id.view_share_qqk).setOnClickListener(this);
        view.findViewById(R.id.view_share_browser).setOnClickListener(this);
        view.findViewById(R.id.view_share_copy).setOnClickListener(this);
    }

}
