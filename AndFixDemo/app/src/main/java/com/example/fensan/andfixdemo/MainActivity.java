package com.example.fensan.andfixdemo;

import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.Toast;

public class MainActivity extends AppCompatActivity {
    String fix = "我有一个bug";
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
    }

    public void onClick(View v) {
        //fix ="修复了";
        Toast.makeText(this, fix, Toast.LENGTH_SHORT).show();
    }
}
