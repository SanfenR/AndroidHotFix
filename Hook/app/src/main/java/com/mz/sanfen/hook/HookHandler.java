package com.mz.sanfen.hook;

import android.util.Log;

import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.util.Arrays;

/**
 * @author MZ
 * @email sanfenruxi1@163.com
 * @date 2017/4/15.
 */

public class HookHandler implements InvocationHandler {
    private static final String TAG = "HookHandler";

    private Object mBase;

    public HookHandler(Object base) {
        mBase = base;
    }

    @Override
    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
        Log.d(TAG, "嘿嘿，你被hook了");
        Log.d(TAG, "method:" + method.getName() + " called with args:" + Arrays.toString(args));
        return method.invoke(mBase, args);
    }
}
