package com.example.fensan.andfixdemo;

import android.os.Environment;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.TextView;

import java.io.IOException;
import java.util.UUID;

public class MainActivity extends AppCompatActivity {
    private static final String TAG = "MainActivity";

    private static final String APATCH_PATH = "/fix.apatch"; // 补丁文件名

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        findViewById(R.id.load).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                update();
            }
        });
//        ((TextView)findViewById(R.id.bug)).setText("我被修复了！！！");
    }

    private void update() {
        String patchFileStr = Environment.getExternalStorageDirectory().getAbsolutePath() + APATCH_PATH;
        try {
            AndFixApplication.mPatchManager.addPatch(patchFileStr);
            AndFixApplication.mPatchManager.loadPatch();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
