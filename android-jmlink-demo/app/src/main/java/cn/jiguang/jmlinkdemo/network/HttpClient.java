package cn.jiguang.jmlinkdemo.network;


import android.util.Log;

import java.io.IOException;

import cn.jiguang.jmlinkdemo.common.Constants;
import okhttp3.Callback;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;

public class HttpClient {
    private static final String TAG = "HttpClient";
    private static OkHttpClient okHttpClient = new OkHttpClient();
    public static void sendGet(String url, Callback callback) {
        Log.d(TAG, "send get request url:" + url);
        Request request = new Request.Builder().url(url).build();
        okHttpClient.newCall(request).enqueue(callback);
    }

    public static void sendPost(String url, String jsonBody, Callback callback) {
        Log.d(TAG, "send post request url:" + url);
        RequestBody requestBody = RequestBody.create(Constants.JSON, jsonBody);
        Request request = new Request.Builder().url(url).post(requestBody).build();
        okHttpClient.newCall(request).enqueue(callback);
    }

    public static Response sendPostSync(String url, String jsonBody) throws IOException {
        Log.d(TAG, "send post sync request url:" + url);
        RequestBody requestBody = RequestBody.create(Constants.JSON, jsonBody);
        Request request = new Request.Builder().url(url).post(requestBody).build();
        return okHttpClient.newCall(request).execute();
    }
}
