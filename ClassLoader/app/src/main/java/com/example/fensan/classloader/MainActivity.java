package com.example.fensan.classloader;

import android.os.Bundle;
import android.os.Environment;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.View;
import android.widget.Toast;
import com.interfaces.MainInterface;
import java.io.File;
import dalvik.system.DexClassLoader;

public class MainActivity extends AppCompatActivity {

    private static final String TAG = "MainActivity";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        ClassLoader classLoader = getClassLoader();
        if (classLoader != null) {
            Log.i(TAG, "[onCreate] classLoader " + " : " + classLoader.toString());
            while (classLoader.getParent() != null) {
                classLoader = classLoader.getParent();
                Log.i(TAG, "[onCreate] classLoader " + " : " + classLoader.toString());
            }
        }
        findViewById(R.id.loadjar)
                .setOnClickListener(v -> {
                    try {
                        File sourceFile = new File(
                                Environment.getExternalStorageDirectory() + File.separator
                                        + "dex.jar");// 导出的jar的存储位置
                        File file = getDir("osdk", 0);// dex临时存储路径
                        DexClassLoader dexClassLoader = new DexClassLoader(sourceFile.getAbsolutePath(), file.getAbsolutePath(), null,
                                getClassLoader());

                        Class<?> libProviderClazz = dexClassLoader
                                .loadClass("com.interfaces.InterfaceTest");

                        MainInterface mMainInterface = (MainInterface) libProviderClazz
                                .newInstance();// 接口
                        String str = mMainInterface.sayHello();// 获取jar包提供的数据
                        Toast.makeText(MainActivity.this, str, Toast.LENGTH_SHORT).show();

                    } catch (ClassNotFoundException e) {
                        e.printStackTrace();
                    } catch (InstantiationException e) {
                        e.printStackTrace();
                    } catch (IllegalAccessException e) {
                        e.printStackTrace();
                    }
                });
    }
}
