package cn.jiguang.jmlinkdemo.utils;

import java.io.UnsupportedEncodingException;
import java.util.Random;

public class StringUtils {
    private static String[] names = {"泣幽咽", "山色远", "封尘忘", "醒复醉", "听江声", "柳眉梢", "山木夕",
            "温如言", "青烟尽", "忘太多", "遮青衣", "离城梦", "梦千遍", "夜微凉", "小情绪", "痴人心",
            "十指浅", "半心人", "小情歌", "花君子", "陌小伊", "糖果果", "萌小呆", "莎酷拉", "数流年",
            "旧巷情人", "笔墨书香", "沧笙踏歌", "南鸢离梦", "游于长野", "木槿昔年", "夏已微凉", "岁月静好",
            "灯火阑珊", "清烟无瘾", "孤寂深海", "离殇荡情", "挽袖清风", "淡若清风", "飞颜尘雪"};

    public static String getRandomName() {
        Random random = new Random(System.currentTimeMillis());
        return names[random.nextInt(names.length)];
    }

//    private static char getRandomChar() {
//        String str = "";
//        int hightPos;
//        int lowPos;
//
//        Random random = new Random();
//
//        hightPos = (176 + Math.abs(random.nextInt(39)));
//        lowPos = (161 + Math.abs(random.nextInt(93)));
//
//        byte[] b = new byte[2];
//        b[0] = (Integer.valueOf(hightPos)).byteValue();
//        b[1] = (Integer.valueOf(lowPos)).byteValue();
//
//        try {
//            str = new String(b, "GBK");
//        } catch (UnsupportedEncodingException e) {
//            e.printStackTrace();
//        }
//        return str.charAt(0);
//    }
}
