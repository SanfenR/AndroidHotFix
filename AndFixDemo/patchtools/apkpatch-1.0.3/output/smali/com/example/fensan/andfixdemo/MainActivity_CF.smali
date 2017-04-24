.class public Lcom/example/fensan/andfixdemo/MainActivity_CF;
.super Landroid/support/v7/app/AppCompatActivity;
.source "MainActivity.java"


# static fields
.field private static final APATCH_PATH:Ljava/lang/String; = "/fix.apatch"

.field private static final TAG:Ljava/lang/String; = "MainActivity"


# direct methods
.method public constructor <init>()V
    .locals 0

    .prologue
    .line 14
    invoke-direct {p0}, Landroid/support/v7/app/AppCompatActivity;-><init>()V

    return-void
.end method

.method static synthetic access$000(Lcom/example/fensan/andfixdemo/MainActivity;)V
    .locals 0
    .param p0, "x0"    # Lcom/example/fensan/andfixdemo/MainActivity;

    .prologue
    .line 14
    invoke-direct {p0}, Lcom/example/fensan/andfixdemo/MainActivity_CF;->update()V

    return-void
.end method

.method static synthetic access$100(Lcom/example/fensan/andfixdemo/MainActivity;)V
    .locals 0
    .param p0, "x0"    # Lcom/example/fensan/andfixdemo/MainActivity;

    .prologue
    .line 14
    invoke-direct {p0}, Lcom/example/fensan/andfixdemo/MainActivity_CF;->showToast()V

    return-void
.end method

.method private showToast()V
    .locals 2
    .annotation runtime Lcom/alipay/euler/andfix/annotation/MethodReplace;
        clazz = "com.example.fensan.andfixdemo.MainActivity"
        method = "showToast"
    .end annotation

    .prologue
    .line 39
    const-string v0, "\u6211\u6709\u4e00\u4e2abug, \u6211\u88ab\u4fee\u590d\u4e86"

    const/4 v1, 0x1

    invoke-static {p0, v0, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v0

    invoke-virtual {v0}, Landroid/widget/Toast;->show()V

    .line 40
    return-void
.end method

.method private update()V
    .locals 5

    .prologue
    .line 43
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-static {}, Landroid/os/Environment;->getExternalStorageDirectory()Ljava/io/File;

    move-result-object v3

    invoke-virtual {v3}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, "/fix.apatch"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 44
    .local v1, "patchFileStr":Ljava/lang/String;
    const-string v2, "MainActivity"

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "load patch + --- "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v2, v3}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 45
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "load patch + --- "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    const/4 v3, 0x1

    invoke-static {p0, v2, v3}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v2

    invoke-virtual {v2}, Landroid/widget/Toast;->show()V

    .line 47
    :try_start_0
    sget-object v2, Lcom/example/fensan/andfixdemo/AndFixApplication;->mPatchManager:Lcom/alipay/euler/andfix/patch/PatchManager;

    invoke-virtual {v2, v1}, Lcom/alipay/euler/andfix/patch/PatchManager;->addPatch(Ljava/lang/String;)V

    .line 48
    sget-object v2, Lcom/example/fensan/andfixdemo/AndFixApplication;->mPatchManager:Lcom/alipay/euler/andfix/patch/PatchManager;

    invoke-virtual {v2}, Lcom/alipay/euler/andfix/patch/PatchManager;->loadPatch()V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    .line 52
    :goto_0
    return-void

    .line 49
    :catch_0
    move-exception v0

    .line 50
    .local v0, "e":Ljava/io/IOException;
    invoke-virtual {v0}, Ljava/io/IOException;->printStackTrace()V

    goto :goto_0
.end method


# virtual methods
.method protected onCreate(Landroid/os/Bundle;)V
    .locals 2
    .param p1, "savedInstanceState"    # Landroid/os/Bundle;

    .prologue
    .line 21
    invoke-super {p0, p1}, Landroid/support/v7/app/AppCompatActivity;->onCreate(Landroid/os/Bundle;)V

    .line 22
    const v0, 0x7f04001b

    invoke-virtual {p0, v0}, Lcom/example/fensan/andfixdemo/MainActivity_CF;->setContentView(I)V

    .line 23
    const v0, 0x7f0b005f

    invoke-virtual {p0, v0}, Lcom/example/fensan/andfixdemo/MainActivity_CF;->findViewById(I)Landroid/view/View;

    move-result-object v0

    new-instance v1, Lcom/example/fensan/andfixdemo/MainActivity$1;

    invoke-direct {v1, p0}, Lcom/example/fensan/andfixdemo/MainActivity$1;-><init>(Lcom/example/fensan/andfixdemo/MainActivity;)V

    invoke-virtual {v0, v1}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 30
    const v0, 0x7f0b005e

    invoke-virtual {p0, v0}, Lcom/example/fensan/andfixdemo/MainActivity_CF;->findViewById(I)Landroid/view/View;

    move-result-object v0

    new-instance v1, Lcom/example/fensan/andfixdemo/MainActivity$2;

    invoke-direct {v1, p0}, Lcom/example/fensan/andfixdemo/MainActivity$2;-><init>(Lcom/example/fensan/andfixdemo/MainActivity;)V

    invoke-virtual {v0, v1}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 36
    return-void
.end method
