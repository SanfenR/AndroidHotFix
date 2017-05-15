package com.example.fensan.andfixdemo;

import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.Toast;

public class MainActivity extends AppCompatActivity {
    String name ="你好";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
    }

    //一个按钮的点击事件
    public void onClick(View view) {
//        name = "修复了";
        Toast.makeText(this, name, Toast.LENGTH_SHORT).show();
    }
}
