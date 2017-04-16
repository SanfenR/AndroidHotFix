package com.mz.sanfen.hook.test;

import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;

/**
 * @author MZ
 * @email sanfenruxi1@163.com
 * @date 2017/4/15.
 */

public class ShoppingHandler implements InvocationHandler {



    /**
     * 被代理的原始对象
     */
    Object base;

    public ShoppingHandler(Object base) {
        this.base = base;
    }

    /**　
     * @param proxy 指代我们所代理的那个真实对象
     * @param method 指代的是我们所要调用真实对象的某个方法的Method对象
     * @param args 指代的是调用真实对象某个方法时接受的参数
     * @return
     * @throws Throwable
     */
    @Override
    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {

        if ("doShopping".equals(method.getName())) {
            // 这里是代理Shopping接口的对象
            // 先黑点钱(修改输入参数)
            Long money = (Long) args[0];
            long readCost = (long) (money * 0.5);
            Object[] things = (Object[]) method.invoke(base, readCost);
            // 偷梁换柱(修改返回值)
            if (things != null && things.length > 1) {
                things[0] = "被掉包的东西!!";
            }
            // 帮忙买东西
            return things;
        }

        return null;
    }
}
