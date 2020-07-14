package cn.jiguang.jmlinkdemo.scene.template;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import cn.jiguang.jmlinkdemo.R;

public class TemplateFragment extends Fragment {
    private int resId;
    public TemplateFragment(int resId) {
        this.resId = resId;
    }
    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view =  inflater.inflate(R.layout.fragment, container, false);
        ((ImageView)view.findViewById(R.id.templateId)).setImageResource(resId);
        return view;
    }
}
