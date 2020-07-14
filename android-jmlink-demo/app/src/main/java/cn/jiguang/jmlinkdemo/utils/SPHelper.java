package cn.jiguang.jmlinkdemo.utils;

import android.content.Context;
import android.content.SharedPreferences;

import cn.jiguang.jmlinkdemo.model.UserInfo;

/**
 * Created by aaron on 14/12/25.
 */
public class SPHelper {
    private static SharedPreferences mSharedPreferences = null;
    private static final String SP_KEY_DEFAULT = "demo_data";
    private static final String USER_INFO = "user_info";
    private static final String ROOM_ID = "room_id";
    private static final String GROUP_ID = "group_id";

    public static void init(Context context) {
        mSharedPreferences = context.getSharedPreferences(SP_KEY_DEFAULT, Context.MODE_PRIVATE);
    }

    static void putLong(String key, Long value) {
        if (mSharedPreferences == null) {
            return;
        }
        SharedPreferences.Editor editor = mSharedPreferences.edit();
        editor.putLong(key, value);
        editor.apply();
    }

    static Long getLong(String key) {
        Long value = 0L;
        if (mSharedPreferences != null) {
            value = mSharedPreferences.getLong(key, 0L);

        }
        return value;
    }

    static void putString(String key, String value) {
        if (mSharedPreferences == null) {
            return;
        }
        SharedPreferences.Editor editor = mSharedPreferences.edit();
        editor.putString(key, value);
        editor.apply();
    }

    public static String getString(String key) {
        String value = "";
        if (mSharedPreferences != null) {
            value = mSharedPreferences.getString(key, "");

        }
        return value;
    }

    public static Long getLong(String key, Long defaultValue) {
        Long value = defaultValue;
        if (mSharedPreferences != null) {
            value = mSharedPreferences.getLong(key, defaultValue);

        }
        return value;
    }

    public static String getUserInfo() {
        return getString(USER_INFO);
    }

    public static void setUserInfo(String userInfo) {
        putString(USER_INFO, userInfo);
    }

    public static void setRoomId(long roomId) {
        putLong(ROOM_ID, roomId);
    }

    public static long getRoomId() {
        return getLong(ROOM_ID);
    }

    public static void setGroupId(long roomId) {
        putLong(GROUP_ID, roomId);
    }

    public static long getGroupId() {
        return getLong(GROUP_ID);
    }
}
