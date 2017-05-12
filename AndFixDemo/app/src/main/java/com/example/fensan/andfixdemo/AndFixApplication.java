package com.example.fensan.andfixdemo;

import android.app.Application;
import android.nfc.Tag;
import android.os.Environment;
import android.util.Log;

import com.alipay.euler.andfix.patch.PatchManager;

import java.io.File;
import java.io.IOException;

/**
 * Created on 2017/4/17
 * Created by sanfen
 *
 * @version 1.0.0
 */

public class AndFixApplication extends Application {
    private static final String TAG = "AndFixApplication";
    public static PatchManager mPatchManager;
    private String path;
    @Override
    public void onCreate() {
        super.onCreate();
        mPatchManager = new PatchManager(this);
        mPatchManager.init("1.0");
        mPatchManager.loadPatch();

        path = Environment.getExternalStorageDirectory().getAbsoluteFile() + File.separator + "fix.apatch";

        Log.e(TAG, path);
        File file = new File(path);
        if (file.exists()){
            Log.e("fmy","文件存在");
            try {
                mPatchManager.addPatch(path);
                mPatchManager.removeAllPatch();
                Log.e("fmy","热修复成功");
            } catch (IOException e) {
                Log.e("fmy","热修复失败:"+e.getMessage());
            }
        }else{
            Log.e("fmy","文件不存在");
        }

    }
}
