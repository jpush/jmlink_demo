package cn.jiguang.jmlinkdemo.common;

import okhttp3.MediaType;

public class Constants {
    public static final String HOST = "https://demo-jmlink.jpush.cn/jmlink-demo/v1/demo";
    public static final String SHARE = "https://demo.jmlk.co";
    public static final String SPREAD_GET_COUNT = "/getGeneralizeCount";
    public static final String SPREAD_REPORT = "/reportGeneralizeUid";
    public static final String GAME_GET_MEMBER = "/getRoomMembers";
    public static final String GAME_CREATE_ROOM = "/getRoomId";
    public static final String GAME_JOIN_ROOM = "/enterRoom";
    public static final String GROUP_JOIN = "/enterGroup";
    public static final String GROUP_GET_MEMBER= "/getGroupMembers";
    public static final String GROUP_CREATE = "/getGroupId";
    public static final MediaType JSON = MediaType.parse("application/json; charset=utf-8");
}
