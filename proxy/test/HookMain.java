
import java.lang.reflect.Array;
import java.lang.reflect.Proxy;
import java.util.Arrays;

/**
 * @author MZ
 * @email sanfenruxi1@163.com
 * @date 2017/4/15.
 */

public class HookMain {

    public static void main(String[] args) {
        Shopping people = new ShoppingImp();
        System.out.println(Arrays.toString(people.doShopping(100)));

        people = (Shopping) Proxy.newProxyInstance(Shopping.class.getClassLoader(),
                people.getClass().getInterfaces(), new ShoppingHandler(people));

        System.out.println(Arrays.toString(people.doShopping(100)));
    }
}
