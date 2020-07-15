package cn.jiguang.jmlinkdemo.helper;

import org.json.JSONObject;

import cn.jiguang.jmlinkdemo.utils.SPHelper;
import cn.jiguang.jmlinkdemo.utils.StringUtils;
import cn.jiguang.jmlinkdemo.model.UserInfo;

public class UserInfoHelper {
    private static UserInfo myInfo;
    private static String KEY_UID = "uid";
    private static String KEY_USERNAME = "username";

    public static UserInfo getMyInfo() {
        if (myInfo != null) {
            return myInfo;
        }
        String info = SPHelper.getUserInfo();
        if (info.equals("")) {
            long uid = System.currentTimeMillis();
            myInfo = new UserInfo(uid, StringUtils.getRandomName());
            saveUserInfo(myInfo);
        } else {
            myInfo = parseFrom(info);
        }
        return myInfo;
    }

    private static void saveUserInfo(UserInfo userInfo) {
        try {
            JSONObject jsonObject = new JSONObject();
            jsonObject.put(KEY_UID, userInfo.getUserId());
            jsonObject.put(KEY_USERNAME, userInfo.getUsername());
            SPHelper.setUserInfo(jsonObject.toString());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static UserInfo parseFrom(String json) {
        try {
            JSONObject jsonObject = new JSONObject(json);
            long uid = jsonObject.getLong(KEY_UID);
            String username = jsonObject.getString(KEY_USERNAME);
            return new UserInfo(uid, username);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;

    }
}
