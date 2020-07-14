package cn.jiguang.jmlinkdemo.utils.dialog;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;

public class ConfirmDialog {
    private Context mContext;
    private String mMessage;
    private DialogInterface.OnClickListener mPositiveListener;
    private DialogInterface.OnClickListener mNegativeListener;
    public ConfirmDialog(Context context, String message,  DialogInterface.OnClickListener positiveListener,
                         DialogInterface.OnClickListener negativeListener) {
        mContext = context;
        mMessage = message;
        mPositiveListener = positiveListener;
        mNegativeListener = negativeListener;
    }

    public void show() {
        final AlertDialog.Builder normalDialog =
                new AlertDialog.Builder(mContext);
        normalDialog.setMessage(mMessage);
        normalDialog.setPositiveButton("确定",
                new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        if (mPositiveListener != null) {
                            mPositiveListener.onClick(dialog, which);
                        }
                    }
                });
        normalDialog.setNegativeButton("取消",
                new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        if (mNegativeListener != null) {
                            mNegativeListener.onClick(dialog, which);
                        }
                    }
                });
        normalDialog.setCancelable(false);
        // 显示
        normalDialog.show();
    }
}
