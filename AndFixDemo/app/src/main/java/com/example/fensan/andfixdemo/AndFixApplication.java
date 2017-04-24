package com.example.fensan.andfixdemo;

import android.app.Application;

import com.alipay.euler.andfix.patch.PatchManager;

/**
 * Created on 2017/4/17
 * Created by sanfen
 *
 * @version 1.0.0
 */

public class AndFixApplication extends Application {
    public static PatchManager mPatchManager;

    @Override
    public void onCreate() {
        super.onCreate();
        // 初始化patch管理类
        mPatchManager = new PatchManager(this);

        // 初始化patch版本
        mPatchManager.init("1.0");
//        String appVersion = getPackageManager().getPackageInfo(getPackageName(), 0).versionName;
//        mPatchManager.init(appVersion);

        // 加载已经添加到PatchManager中的patch
        mPatchManager.loadPatch();
    }
}
