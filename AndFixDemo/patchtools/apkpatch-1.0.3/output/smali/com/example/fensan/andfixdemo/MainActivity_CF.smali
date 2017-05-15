.class public Lcom/example/fensan/andfixdemo/MainActivity_CF;
.super Landroid/support/v7/app/AppCompatActivity;
.source "MainActivity.java"


# instance fields
.field name:Ljava/lang/String;


# direct methods
.method public constructor <init>()V
    .locals 1

    .prologue
    .line 8
    invoke-direct {p0}, Landroid/support/v7/app/AppCompatActivity;-><init>()V

    .line 9
    const-string v0, "\u4f60\u597d"

    iput-object v0, p0, Lcom/example/fensan/andfixdemo/MainActivity_CF;->name:Ljava/lang/String;

    return-void
.end method


# virtual methods
.method public onClick(Landroid/view/View;)V
    .locals 2
    .param p1, "view"    # Landroid/view/View;
    .annotation runtime Lcom/alipay/euler/andfix/annotation/MethodReplace;
        clazz = "com.example.fensan.andfixdemo.MainActivity"
        method = "onClick"
    .end annotation

    .prologue
    .line 19
    const-string v0, "\u4fee\u590d\u4e86"

    iput-object v0, p0, Lcom/example/fensan/andfixdemo/MainActivity_CF;->name:Ljava/lang/String;

    .line 20
    iget-object v0, p0, Lcom/example/fensan/andfixdemo/MainActivity_CF;->name:Ljava/lang/String;

    const/4 v1, 0x0

    invoke-static {p0, v0, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v0

    invoke-virtual {v0}, Landroid/widget/Toast;->show()V

    .line 21
    return-void
.end method

.method protected onCreate(Landroid/os/Bundle;)V
    .locals 1
    .param p1, "savedInstanceState"    # Landroid/os/Bundle;

    .prologue
    .line 13
    invoke-super {p0, p1}, Landroid/support/v7/app/AppCompatActivity;->onCreate(Landroid/os/Bundle;)V

    .line 14
    const v0, 0x7f04001b

    invoke-virtual {p0, v0}, Lcom/example/fensan/andfixdemo/MainActivity_CF;->setContentView(I)V

    .line 15
    return-void
.end method
