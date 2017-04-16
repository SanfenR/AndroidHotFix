package com.mz.sanfen.hook.test;

/**
 * @author MZ
 * @email sanfenruxi1@163.com
 * @date 2017/4/15.
 */

public class ProxyShopping implements Shopping {
    Shopping base;

    ProxyShopping(Shopping base) {
        this.base = base;
    }

    @Override
    public Object[] doShopping(long money) {
        // 先黑点钱(修改输入参数)
        long readCost = (long) (money * 0.5);
        // 帮忙买东西
        return base.doShopping(readCost);
    }
}
