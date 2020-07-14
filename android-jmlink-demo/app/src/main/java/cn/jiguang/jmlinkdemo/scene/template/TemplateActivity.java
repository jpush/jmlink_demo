package cn.jiguang.jmlinkdemo.scene.template;

import android.os.Bundle;
import android.view.View;
import android.widget.TextView;

import com.google.android.material.tabs.TabLayout;

import java.util.ArrayList;
import java.util.List;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentPagerAdapter;
import androidx.viewpager.widget.ViewPager;
import cn.jiguang.jmlinkdemo.BaseActivity;
import cn.jiguang.jmlinkdemo.R;

public class TemplateActivity extends BaseActivity {
    private static final String TITLE = "丰富模版页";
    private String[] titles = new String[]{"模板一", "模板二", "模板三", "模板四", "模板五", "模板六"};
    private int[] resIds = new int[]{R.drawable.template1, R.drawable.template2, R.drawable.template3,
            R.drawable.template4, R.drawable.template5, R.drawable.template6};
    private ViewPager mViewPager;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_template);
        initTitle(R.id.toolbar, TITLE, false, 0, null);
        mViewPager = findViewById(R.id.viewPager);
        MyFragmentPagerAdapter myFragmentPagerAdapter = new MyFragmentPagerAdapter(getSupportFragmentManager());
        mViewPager.setAdapter(myFragmentPagerAdapter);

        //将TabLayout与ViewPager绑定在一起
        TabLayout mTabLayout = findViewById(R.id.tabLayout);
        mTabLayout.setupWithViewPager(mViewPager);
        for (int i = 0; i < titles.length; i++) {
            TabLayout.Tab tab = mTabLayout.getTabAt(i);
            if (tab != null) {
                View inflate = View.inflate(this, R.layout.template_item, null);
                String text = tab.getText() != null ? tab.getText().toString() : "";
                ((TextView)inflate.findViewById(R.id.btn)).setText(text);
                tab.setCustomView(inflate);
            }
        }
//        mViewPager.addOnPageChangeListener(new TabLayout.TabLayoutOnPageChangeListener(mTabLayout));
        mTabLayout.addOnTabSelectedListener(new TabLayout.OnTabSelectedListener() {
            @Override
            public void onTabSelected(TabLayout.Tab tab) {
                mViewPager.setCurrentItem(tab.getPosition());
            }

            @Override
            public void onTabUnselected(TabLayout.Tab tab) {

            }

            @Override
            public void onTabReselected(TabLayout.Tab tab) {

            }
        });
    }

    private class MyFragmentPagerAdapter extends FragmentPagerAdapter {
        private List<TemplateFragment> fragmentList = new ArrayList<>();

        MyFragmentPagerAdapter(@NonNull FragmentManager fm) {
            super(fm, BEHAVIOR_RESUME_ONLY_CURRENT_FRAGMENT);
            for (int resId : resIds) {
                fragmentList.add(new TemplateFragment(resId));
            }
        }

        @NonNull
        @Override
        public Fragment getItem(int position) {
            return fragmentList.get(position);
        }

        @Override
        public int getCount() {
            return resIds.length;
        }

        @Nullable
        @Override
        public CharSequence getPageTitle(int position) {
            return titles[position];
        }
    }
}
