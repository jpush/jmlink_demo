package cn.jiguang.jmlinkdemo.model;

import cn.jiguang.jmlinkdemo.R;

public class UserInfo {
    private long uid;
    private String username;
    private int avatar;

    public UserInfo(long uid, String name) {
        this.uid = uid;
        this.username = name;
        int mod =(int) (uid % 5);
        switch (mod) {
            case 0:
                avatar = R.drawable.user0;
                break;
            case 1:
                avatar = R.drawable.user1;
                break;
            case 2:
                avatar = R.drawable.user2;
                break;
            case 3:
                avatar = R.drawable.user3;
                break;
            case 4:
                avatar = R.drawable.user4;;
                break;
            default:
        }
    }

    public long getUserId() {
        return uid;
    }

    public String getUsername() {
        return username;
    }

    public int getAvatar() {
        return avatar;
    }
}
