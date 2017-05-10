# Android热修复

* [hook篇](#hook篇)
    * [hook原理](#hook原理)
    * [AndFix使用](#AndFix使用)
* [dex篇](#dex篇)
   * [插桩](#插桩)
   * [ClassLoader使用](#ClassLoader使用)
   * [Tinker](#Tinker)
* [现有几种实现热修复框架的对比](#现有几种实现热修复框架的对比)
* [参考资料](#参考资料)

## hook篇

### hook原理

#### 了解Hook

我们知道，在Android操作系统中系统维护着自己的一套事件分发机制。应用程序，包括应用触发事件和后台逻辑处理，也是根据事件流程一步步的向下执行。而“钩子”的意思，就是在事件传送到终点前截获并监控事件的传输，像个钩子勾上事件一样。并且能够在勾上事件时，处理一些自己特定的事件。如下图所示：

#### 动态代理

传统的静态代理模式需要为每一个需要代理的类写一个代理类，如果需要代理的类有几百个那不是要累死？为了更优雅地实现代理模式，JDK提供了动态代理方式，可以简单理解为JVM可以在运行时帮我们动态生成一系列的代理类，这样我们就不需要手写每一个静态的代理类了。依然以购物为例，用动态代理实现如下：

```
    public static void main(String[] args) {
        Shopping people = new ShoppingImp();
        System.out.println(Arrays.toString(people.doShopping(100)));

        people = (Shopping) Proxy.newProxyInstance(Shopping.class.getClassLoader(),
                people.getClass().getInterfaces(), new ShoppingHandler(people));

        System.out.println(Arrays.toString(people.doShopping(100)));
    }
```


#### Hook Android的startActivity方法

Android在启动的时候会创建```ActivityThread```, 这是一个单例的对象，而```startActivity```实际上是```Instrumentation```中的```execStartActivity()```来实现的。所有我们只要替换掉```ActivityThread```中的```Instrumentation```的对象成我们自己的方法。


创建代理类
```java
public class ProxyInstrumentation extends Instrumentation {
    private static final String TAG = "EvilInstrumentation";

    // ActivityThread中原始的对象, 保存起来
    Instrumentation mBase;

    public ProxyInstrumentation(Instrumentation base) {
        mBase = base;
    }

    public ActivityResult execStartActivity(
            Context who, IBinder contextThread, IBinder token, Activity target,
            Intent intent, int requestCode, Bundle options){
        // Hook之前, XXX到此一游!

        Log.d(TAG, "sanfen到此一游！！！");
        Log.d(TAG, "\n执行了startActivity, 参数如下: \n" + "who = [" + who + "], " +
                "\ncontextThread = [" + contextThread + "], \ntoken = [" + token + "], " +
                "\ntarget = [" + target + "], \nintent = [" + intent +
                "], \nrequestCode = [" + requestCode + "], \noptions = [" + options + "]");

        // 开始调用原始的方法, 调不调用随你,但是不调用的话, 所有的startActivity都失效了.
        // 由于这个方法是隐藏的,因此需要使用反射调用;首先找到这个方法
        try {
            Method execStartActivity = Instrumentation.class.getDeclaredMethod(
                    "execStartActivity",
                    Context.class, IBinder.class, IBinder.class, Activity.class,
                    Intent.class, int.class, Bundle.class);
            execStartActivity.setAccessible(true);
            return (ActivityResult) execStartActivity.invoke(mBase, who,
                    contextThread, token, target, intent, requestCode, options);
        } catch (Exception e) {
            // 某该死的rom修改了  需要手动适配
            throw new RuntimeException("do not support!!! pls adapt it");
        }
    }
}
```



通过反射修改```ActivityThread```中的```mInstrumentation```。
```java

  public static void hookStartActivity(){

        try {
            // 先获取到当前的ActivityThread对象
            Class<?> activityThreadClass = Class.forName("android.app.ActivityThread");

            Method currentActivityThreadMethod = activityThreadClass.getDeclaredMethod("currentActivityThread");
            currentActivityThreadMethod.setAccessible(true);
            Object currentActivityThread = currentActivityThreadMethod.invoke(null);

            // 拿到原始的 mInstrumentation字段
            Field mInstrumentationField = activityThreadClass.getDeclaredField("mInstrumentation");
            mInstrumentationField.setAccessible(true);
            Instrumentation mInstrumentation = (Instrumentation) mInstrumentationField.get(currentActivityThread);

            // 创建代理对象
            Instrumentation evilInstrumentation = new ProxyInstrumentation(mInstrumentation);

            // 偷梁换柱
            mInstrumentationField.set(currentActivityThread, evilInstrumentation);
        } catch (ClassNotFoundException
                | NoSuchMethodException
                | IllegalAccessException
                | InvocationTargetException
                | NoSuchFieldException e) {
            e.printStackTrace();
        }

    }
```

执行效果，在运行startActivty的时候打出了一段日志。

![hook](http://ohqvqufyf.bkt.clouddn.com/hookActivity.png)


### AndFix使用

![AndFix](http://ohqvqufyf.bkt.clouddn.com/andfix.png)


AndFix采用native hook的方式，这套方案直接使用dalvik_replaceMethod替换class中方法的实现。由于它并没有整体替换class, 而field在class中的相对地址在class加载时已确定，所以AndFix无法支持新增或者删除filed的情况(通过替换init与clinit只可以修改field的数值)。


也正因如此，Andfix可以支持的补丁场景相对有限，仅仅可以使用它来修复特定问题。结合之前的发布流程，我们更希望补丁对开发者是不感知的，即他不需要清楚这个修改是对补丁版本还是正式发布版本(事实上我们也是使用git分支管理+cherry-pick方式)。另一方面，使用native替换将会面临比较复杂的兼容性问题。

#### 引入andfix

在gradle中添加依赖
```xml
dependencies {
    compile 'com.alipay.euler:andfix:0.5.0@aar'
}
```

#### 在Application中初始化AndFix

```java
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

```

#### 生成patch包

为了方便演示，我们设置点击按钮来加载patch

```java
public class MainActivity extends AppCompatActivity {

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
    }

    private void update() {
        String patchFileStr = Environment.getExternalStorageDirectory().getAbsolutePath() + APATCH_PATH;
        try {
            AndFixApplication.mPatchManager.addPatch(patchFileStr);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
```

![patch](http://ohqvqufyf.bkt.clouddn.com/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202017-04-17%20%E4%B8%8B%E5%8D%883.12.31.png)

patch命令
- -f <new.apk> ：新apk
- -t <old.apk> : 旧apk
- -o <output> ： 输出目录（补丁文件的存放目录）
- -k <keystore>： 打包所用的keystore
- -p <password>： keystore的密码
- -a <alias>： keystore 用户别名
- -e <alias password>： keystore 用户别名密码

```
sh apkpatch.sh -f app-debug-2.0.apk -t app-debug-1.0.apk -o output -k abc.keystore -p qwe123 -a abc.keystore -e qwe123
```

![patch_diff](http://ohqvqufyf.bkt.clouddn.com/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202017-04-17%20%E4%B8%8B%E5%8D%884.15.44.png)

#### 运行

load patch
```
#安装应用
adb install app-debug-1.0.apk
#将patch push到手机中
adb push fix.apatch /storage/emulated/0/fix.apatch
```

## Dex篇

### 插桩

#### 插桩原理

> 插桩的概念是以静态的方式修改第三方的代码，也就是从编译阶段，对源代码（中间代码）进行编译，而后重新打包，是静态的篡改； 而hook则不需要再编译阶段修改第三方的源码或中间代码，是在运行时通过反射的方式修改调用，是一种动态的篡改

#### 插桩的概念

插桩就是在代码中插入一段我们自定义的代码。

#### Android插桩实践

[apktool download](https://bitbucket.org/iBotPeaches/apktool/downloads/)

```
#反编译出smail文件
java -jar apktool.jar d <包名>

#重新打包
java -jar apktool.jar b <文件夹> -o <输出包名>

#使用keytool生成签名
keytool -genkey -alias abc.keystore -keyalg RSA -validity 20000 -keystore abc.keystore

#用jarsigner签名apk
jarsigner -verbose -keystore abc.keystore -signedjar test_sign.apk test.apk abc.keystore

```

### ClassLoader使用

![classload](http://ohqvqufyf.bkt.clouddn.com/1437930-bb9d359f4c7e9935.png)

对于Java程序来说，编写程序就是编写类，运行程序也就是运行类（编译得到的class文件），其中起到关键作用的就是类加载器ClassLoader。

#### Android
Android平台上虚拟机运行的是Dex字节码,一种对class文件优化的产物,传统Class文件是一个Java源码文件会生成一个.class文件，而Android是把所有Class文件进行合并，优化，然后生成一个最终的class.dex,目的是把不同class文件重复的东西只需保留一份,如果我们的Android应用不进行分dex处理,最后一个应用的apk只会有一个dex文件。

#### Android中的ClassLoad

```java
  @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        ClassLoader classLoader = getClassLoader();
        if (classLoader != null){
            Log.i(TAG, "[onCreate] classLoader " + " : " + classLoader.toString());
            while (classLoader.getParent()!=null){
                classLoader = classLoader.getParent();
                Log.i(TAG,"[onCreate] classLoader " + " : " + classLoader.toString());
            }
        }
    }
```

```
05-08 16:22:43.115 10289-10289/com.example.fensan.classloader I/MainActivity: [onCreate] classLoader  : dalvik.system.PathClassLoader[DexPathList[[zip file "/data/app/com.example.fensan.classloader-1.apk"],nativeLibraryDirectories=[/data/app-lib/com.example.fensan.classloader-1, /vendor/lib, /system/lib, /data/datalib]]]
05-08 16:22:43.115 10289-10289/com.example.fensan.classloader I/MainActivity: [onCreate] classLoader  : java.lang.BootClassLoader@415cb330

```

#### 类加载过程

```
    protected Class<?> loadClass(String name, boolean resolve)
        throws ClassNotFoundException
    {
            // First, check if the class has already been loaded
            Class c = findLoadedClass(name);
            if (c == null) {
                long t0 = System.nanoTime();
                try {
                    if (parent != null) {
                        c = parent.loadClass(name, false);
                    } else {
                        c = findBootstrapClassOrNull(name);
                    }
                } catch (ClassNotFoundException e) {
                    // ClassNotFoundException thrown if class not found
                    // from the non-null parent class loader
                }

                if (c == null) {
                    // If still not found, then invoke findClass in order
                    // to find the class.
                    long t1 = System.nanoTime();
                    c = findClass(name);

                    // this is the defining class loader; record the stats
                }
            }
            return c;
    }

```

#### 特点
从源码中我们也可以看出，loadClass方法在加载一个类的实例的时候，

- 会先查询当前ClassLoader实例是否加载过此类，有就返回；
- 如果没有。查询Parent是否已经加载过此类，如果已经加载过，就直接返回Parent加载的类；
- 如果继承路线上的ClassLoader都没有加载，才由Child执行类的加载工作；

#### DexClassLoader 和 PathClassLoader

##### PathClassLoader
用来加载安装了的应用中的dex文件。它也是Android里面的一个最核心的ClassLoader了。相当于Java中的那个AppClassLoader。

```java
public class PathClassLoader extends BaseDexClassLoader {
    public PathClassLoader(String dexPath, ClassLoader parent) {
        super(dexPath, null, null, parent);
    }
    public PathClassLoader(String dexPath, String librarySearchPath, ClassLoader parent) {
        super(dexPath, null, librarySearchPath, parent);
    }
}
```

它的实例化是通过调用``` ApplicationLoaders.getClassLoader ```来实现的。

它是在``` ActivityThread ```启动时发送一个``` BIND_APPLICATION ``` 消息后在``` handleBindApplication ```中创建``` ContextImpl ```时调用``` LoadedApk ```里面的``` getResources(ActivityThread mainThread) ```最后回到``` ActivityThread ```中又调用``` LoadedApk ```的``` getClassLoader ```生成的，具体的在``` LoadedApk的createOrUpdateClassLoaderLocked ```。

那么问题来了，当Android加载class的时候，``` LoadedApk ```中的``` ClassLoader ```是怎么被调用到的呢？

其实Class里面，如果你不给``` ClassLoader ```的话，它默认会去拿Java虚拟机栈里面的``` CallingClassLoader ```，而这个就是LoadedApk里面的同一个``` ClassLoader ```。

##### DexClassLoader

它是一个可以用来加载包含dex文件的jar或者apk文件的，但是它可以用来加载非安装的apk。比如加载sdcard上面的，或者NetWork的。

比如现在很流行的插件化/热补丁，其实都是通过DexClassLoader来实现的。具体思路是： 创建一个DexClassLoader，通过反射将前者的DexPathList跟系统的PathClassLoader中的DexPathList合并，就可以实现优先加载我们自己的新类，从而替换旧类中的逻辑了。


#### 使用DexClassLoader加载本地SD卡中的jar包

```
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
```



### nuwa, QZone 实现原理

一个ClassLoader可以包含多个dex文件，每个dex文件是一个Element，多个dex文件排列成一个有序的数组dexElements，当找类的时候，会按顺序遍历dex文件，然后从当前遍历的dex文件中找类，如果找类则返回，如果找不到从下一个dex文件继续查找。
理论上，如果在不同的dex中有相同的类存在，那么会优先选择排在前面的dex文件的类

![link](http://ohqvqufyf.bkt.clouddn.com/fcab18b9-a744-4ffc-9bb9-be5414fc47ba.png)

[参考这篇文章](https://mp.weixin.qq.com/s?__biz=MzI1MTA1MzM2Nw==&mid=400118620&idx=1&sn=b4fdd5055731290eef12ad0d17f39d4a)

### Tinker

>   微信的热补丁方案叫做Tinker，也算缅怀一下Dota中的地精修补匠，希望能做到无限刷新
    ![Tinker](http://ohqvqufyf.bkt.clouddn.com/tinker.png)

#### Tinker实现原理

![Tinker](http://ohqvqufyf.bkt.clouddn.com/0-1.jpg)


简单来说，在编译时通过新旧两个Dex生成差异path.dex。在运行时，将差异patch.dex重新跟原始安装包的旧Dex还原为新的Dex。这个过程可能比较耗费时间与内存，所以我们是单独放在一个后台进程:patch中。为了补丁包尽量的小，微信自研了DexDiff算法，它深度利用Dex的格式来减少差异的大小。它的粒度是Dex格式的每一项，可以充分利用原本Dex的信息，而BsDiff的粒度是文件，AndFix/QZone的粒度为class。



#### Tinker使用

```xml
#添加依赖
dependencies {
    compile("com.tencent.tinker:tinker-android-lib:${TINKER_VERSION}") { changing = true }
    provided("com.tencent.tinker:tinker-android-anno:${TINKER_VERSION}") { changing = true }
}
```

```
#添加依赖
dependencies {
    compile("com.tencent.tinker:tinker-android-lib:${TINKER_VERSION}") { changing = true }
    provided("com.tencent.tinker:tinker-android-anno:${TINKER_VERSION}") { changing = true }
}

#设置版本
ext {
    //for some reason, you may want to ignore tinkerBuild, such as instant run debug build?
    tinkerEnabled = true
    //for normal build
    //old apk file to build patch apk
    tinkerOldApkPath = "${bakPath}/app-debug-1018-17-32-47.apk"
    //proguard mapping file to build patch apk
    tinkerApplyMappingPath = "${bakPath}/app-debug-1018-17-32-47-mapping.txt"
    //resource R.txt to build patch apk, must input if there is resource changed
    tinkerApplyResourcePath = "${bakPath}/app-debug-1018-17-32-47-R.txt"

    //only use for build all flavor, if not, just ignore this field
    tinkerBuildFlavorDirectory = "${bakPath}/app-1018-17-32-47"
}
```

```java

使用ApplicationLike代理Appilcation
@SuppressWarnings("unused")
@DefaultLifeCycle(application = "tinker.sample.android.app.SampleApplication",
                  flags = ShareConstants.TINKER_ENABLE_ALL,
                  loadVerifyFlag = false)
public class SampleApplicationLike extends DefaultApplicationLike {
    private static final String TAG = "Tinker.SampleApplicationLike";

    public SampleApplicationLike(Application application, int tinkerFlags, boolean tinkerLoadVerifyFlag,
                                 long applicationStartElapsedTime, long applicationStartMillisTime, Intent tinkerResultIntent) {
        super(application, tinkerFlags, tinkerLoadVerifyFlag, applicationStartElapsedTime, applicationStartMillisTime, tinkerResultIntent);
    }

    @TargetApi(Build.VERSION_CODES.ICE_CREAM_SANDWICH)
    public void registerActivityLifecycleCallbacks(Application.ActivityLifecycleCallbacks callback) {
        getApplication().registerActivityLifecycleCallbacks(callback);
    }
}
```

加载本地的补丁包
```java

TinkerInstaller.onReceiveUpgradePatch(getApplicationContext(), Environment.getExternalStorageDirectory().getAbsolutePath() + "/patch_signed_7zip.apk");

```
## 现有几种实现热修复框架的对比

Tinker对比目前几种热门框架
![对比](http://ohqvqufyf.bkt.clouddn.com/%E7%83%AD%E4%BF%AE%E5%A4%8D%E5%AF%B9%E6%AF%94.jpg)

![对比2](http://ohqvqufyf.bkt.clouddn.com/wechat-dexdiff.png)

### 由于原理与系统限制，Tinker有以下已知问题：

- Tinker不支持修改AndroidManifest.xml，Tinker不支持新增四大组件；
- 由于Google Play的开发者条款限制，不建议在GP渠道动态更新代码；
- 在Android N上，补丁对应用启动时间有轻微的影响；
- 不支持部分三星android-21机型，加载补丁时会主动抛出"TinkerRuntimeException:checkDexInstall failed"；
- 对于资源替换，不支持修改remoteView。例如transition动画，notification icon以及桌面图标。


### 参考资料

[微信Android热补丁实践演进之路](https://github.com/WeMobileDev/article/blob/master/%E5%BE%AE%E4%BF%A1Android%E7%83%AD%E8%A1%A5%E4%B8%81%E5%AE%9E%E8%B7%B5%E6%BC%94%E8%BF%9B%E4%B9%8B%E8%B7%AF.md)

[各大热补丁方案分析和比较](http://blog.zhaiyifan.cn/2015/11/20/HotPatchCompare/)

[Android插件化原理解析——Hook机制之动态代理](http://weishu.me/2016/01/28/understand-plugin-framework-proxy-hook/)

[android 插桩基本概念plugging or Swap](http://blog.csdn.net/fei20121106/article/details/51879047)

[Android热修复之AndFix使用教程](http://www.jianshu.com/p/907a2c599996)

[Instant Run工作原理及用法](http://www.jianshu.com/p/2e23ba9ff14b)

[Android热补丁之Tinker原理解析](http://w4lle.github.io/2016/12/16/tinker/)

[Tinker 接入指南](https://github.com/Tencent/tinker/wiki/Tinker-%E6%8E%A5%E5%85%A5%E6%8C%87%E5%8D%97)
