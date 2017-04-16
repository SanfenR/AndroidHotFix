
/**
 * @author MZ
 * @email sanfenruxi1@163.com
 * @date 2017/4/15.
 */

public class ShoppingImp implements Shopping {
    @Override
    public Object[] doShopping(long money) {
        System.out.println("do shopping");
        System.out.println(String.format("花了%s块钱", money));
        return new Object[]{"鞋子", "衣服"};
    }
}
