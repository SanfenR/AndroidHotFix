.class public Lcom/example/fensan/andfixdemo/MainActivity_CF;
.super Landroid/support/v7/app/AppCompatActivity;
.source "MainActivity.java"

# interfaces
.implements Landroid/view/View$OnClickListener;


# static fields
.field private static final APATCH_PATH:Ljava/lang/String; = "/fix.apatch"

.field private static final TAG:Ljava/lang/String; = "MainActivity"


# instance fields
.field fix:Ljava/lang/String;


# direct methods
.method public constructor <init>()V
    .locals 1

    .prologue
    .line 8
    invoke-direct {p0}, Landroid/support/v7/app/AppCompatActivity;-><init>()V

    .line 13
    const-string v0, "\u6211\u6709\u4e00\u4e2abug"

    iput-object v0, p0, Lcom/example/fensan/andfixdemo/MainActivity_CF;->fix:Ljava/lang/String;

    return-void
.end method


# virtual methods
.method public onClick(Landroid/view/View;)V
    .locals 2
    .param p1, "v"    # Landroid/view/View;
    .annotation runtime Lcom/alipay/euler/andfix/annotation/MethodReplace;
        clazz = "com.example.fensan.andfixdemo.MainActivity"
        method = "onClick"
    .end annotation

    .prologue
    .line 25
    const-string v0, "\u4fee\u590d\u4e86"

    iput-object v0, p0, Lcom/example/fensan/andfixdemo/MainActivity_CF;->fix:Ljava/lang/String;

    .line 26
    iget-object v0, p0, Lcom/example/fensan/andfixdemo/MainActivity_CF;->fix:Ljava/lang/String;

    const/4 v1, 0x0

    invoke-static {p0, v0, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v0

    invoke-virtual {v0}, Landroid/widget/Toast;->show()V

    .line 27
    return-void
.end method

.method protected onCreate(Landroid/os/Bundle;)V
    .locals 1
    .param p1, "savedInstanceState"    # Landroid/os/Bundle;

    .prologue
    .line 17
    invoke-super {p0, p1}, Landroid/support/v7/app/AppCompatActivity;->onCreate(Landroid/os/Bundle;)V

    .line 18
    const v0, 0x7f04001b

    invoke-virtual {p0, v0}, Lcom/example/fensan/andfixdemo/MainActivity_CF;->setContentView(I)V

    .line 19
    const v0, 0x7f0b005f

    invoke-virtual {p0, v0}, Lcom/example/fensan/andfixdemo/MainActivity_CF;->findViewById(I)Landroid/view/View;

    move-result-object v0

    invoke-virtual {v0, p0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 21
    return-void
.end method
