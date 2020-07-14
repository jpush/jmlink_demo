package cn.jiguang.jmlinkdemo.scene.scheme;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Matrix;
import android.os.Bundle;
import android.view.View;
import android.view.ViewTreeObserver;
import android.widget.ImageView;

import cn.jiguang.jmlinkdemo.BaseActivity;
import cn.jiguang.jmlinkdemo.R;
import cn.jiguang.jmlinkdemo.ShareDialog;
import cn.jiguang.jmlinkdemo.common.Constants;


public class AKan extends BaseActivity {
    private static final String TITLE = "爱看视频";
    private static final String TEXT = "欢迎使用极光魔链";
    private static final String URL = Constants.SHARE + "/#/page4?type=1&scene=1";
    ShareDialog shareDiaog;
    ImageView imageView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_akan);
        imageView = findViewById(R.id.aikan);
        adjustImageView();
        shareDiaog = new ShareDialog(AKan.this, TITLE, TEXT, URL);
        initTitle(R.id.toolbar, TITLE, true, R.drawable.share_selector, new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (shareDiaog != null && !shareDiaog.isShowing()) {
                    shareDiaog.show();
                }
            }
        });
        findViewById(R.id.shareButton).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (shareDiaog != null && !shareDiaog.isShowing()) {
                    shareDiaog.show();
                }
            }
        });
    }

    private void adjustImageView() {
        if (imageView != null) {
            ViewTreeObserver viewTreeObserver = imageView.getViewTreeObserver();
            viewTreeObserver.addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() {
                @Override
                public void onGlobalLayout() {
                    imageView.getViewTreeObserver().removeOnGlobalLayoutListener(this);
                    int width = imageView.getWidth();
                    int height = imageView.getHeight();
                    Bitmap bitmap = BitmapFactory.decodeResource(getResources(), R.drawable.aikan);
                    int imageWidth = bitmap.getWidth();
                    int imaageHeight = bitmap.getHeight();
                    float scaleRate = width * 1.0f / imageWidth;
                    Matrix matrix = new Matrix();
                    matrix.postScale(scaleRate, scaleRate);
                    Bitmap bitmap1 = Bitmap.createBitmap(bitmap, 0, 0, imageWidth, imaageHeight, matrix, true);
                    Bitmap bitmap2 = Bitmap.createBitmap(bitmap1, 0, 0, bitmap1.getWidth(), bitmap1.getHeight() > height ? height : bitmap1.getHeight());
                    imageView.setImageBitmap(bitmap2);
                }
            });
        }
    }
}
