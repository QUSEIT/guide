Title: Django 用户验证系统简单使用教程
Date: 2016-07-13
Category: U200

#Django用户验证系统
django自带有一套自身的用户验证系统，可以参考官方文档（连接到django authentication system）:

https://docs.djangoproject.com/en/1.9/topics/auth/default/#user-objects

####下面是django用户系统的一个小案例（看案例前建议先浏览一下官方文档用户系统验证部分）

新建django项目：项目结构很简单，只添加了四个html文件，index.html（首页）, login.html（登陆页）, register.html（注册页）, profile.html（个人中心）

其他是django自带的。基本只需修改views.py, urls.py文件

现在有一个需求是：

   （1）实现登录注册；

   （2）登陆的用户可以从首页index进入个人中心profile；
   
   （3）未登录用户访问个人中心profile将自动跳转到登陆页面；
   
   （4）用户可以退出登陆；
   
   <b>需求说完了，直接上代码！！！</b>
   
   <b>index.html代码：</b>
```
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>首页</title>
</head>
<body>
    <h1>这是首页</h1>
{% if user.is_authenticated %} 
    hello {{user.username}}, 欢迎您
    <a href="">退出登录</a>
{% else %}
    您还没登陆呢！！！
    <a href="">登陆</a>
    <a href="">注册</a>
{% endif %}
</body>
</html>
```
<p style="color:blue;font-size:15px">user.is_authenticated是django提供的一个用户验证方法，校验用户是否是合法的(<i style="color:#F1F">请再次参考官方文档</i>)</p>

<br>

<b>login.html代码：</b>
```
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>登陆</title>
</head>
<body>
<h1>XXX登陆页面</h1>
     <form method="POST">
         邮箱：<input type="email" name="email" id="email">
         密码：<input type="password" name="pw" id="pw">
          <input type="submit" value="点击注册">
           {% csrf_token %}
     </form>
</body>
</html>
```
<p style="color:blue;font-size:15px">{% csrf_token %}据说是防跨域攻击, 想深入了解的童鞋戳下面链接：</p>

http://www.jianshu.com/p/a178f08d9389

<br>

<b>regitser.html代码：</b>
```
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title></title>
</head>
<body>
    <h1>XXX注册页面</h1>
    <form method="POST">

        用户名:<input type="text" name="name" id="name"><br>
        邮箱：<input type="email" name="email" id="email"><br>
        密码：<input type="password" name="pw" id="pw"><br>
        <input type="submit" value="点击注册">
          {% csrf_token %}
    </form>
</body>
</html>
```

<br>
<b>profile.html代码:</b>
```
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>个人中心</title>
</head>
<body>
    <h1>个人中心</h1>
    <b>hello,{{ user.username }}</b> <a href="/logout">退出登录</a>
    <p>账户创建时间：{{ user.date_joined}}</p>
    <P>上一次登陆时间：{{ user.last_login }}</P>
</body>
</html>
```
<p style="color:blue;font-size:15px">{user.date_joined}以及{user.last_login}都是django提供的参数（<i style="color:#F1F">更多参数,再次请参考官方文档</i>），分别是用户注册时间、用户上一次登陆时间。</p>


<br>

<b>views.py代码：</b>
```
# coding:utf-8
from django.shortcuts import render, redirect
from django.http import HttpResponse
from django import forms
from django.contrib.auth.models import User
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required


def register(request):
    if request.method == 'GET':
        return render(request, 'register.html')
    elif request.method == 'POST':
        username = request.POST.get('name', False)
        email = request.POST.get('email', False)
        pw = request.POST.get('pw', False)
        print username, email, pw
        if not username or not email or not pw:
            return HttpResponse(u'请填写所有字段')
        User.objects.create_user(username, email, pw)  # 注册一个用户，接受参数：用户名、邮箱、密码(django内是对应的)
        return HttpResponse(u'注册成功')


def log(request):
    if request.method == 'GET':
        return render(request, 'login.html')
    elif request.method == 'POST':
        username = request.POST.get('username', False)
        pw = request.POST.get('pw', False)
        print username, pw
        if not username or not pw:
            return HttpResponse(u'请填写所有字段')
        user = authenticate(username=username, password=pw)  # django自带用户验证功能,第一个为用户名，第二个密码（好像不支持email登陆验证，但可以自己修改）
        if user is not None:
            login(request, user)
            return render(request, 'index.html')
        else:
            return HttpResponse(u'账号或密码错误')


def index(requset):
    return render(requset, 'index.html')


def logout_user(request):  
    logout(request)  #用django自带函数，退出登陆
    return redirect('/index')  #退出登陆后 重定向返回index页

# 下面这个标签（是叫标签吗？我只知道java里叫注解....），功能是告诉程序要执行下面这个函数（profile）就必须先登陆。未登录直接访问将跳转到"/login".
@login_required(login_url="/login")   # 用户登陆后方能访问profile，未登录访问跳转login页面
def profile(request):
    return render(request, 'profile.html')
    
```

<b>urls.py代码：</b>
```
from django.conf.urls import url
from django.contrib import admin
from logreg import views
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^register', views.register),
    url(r'^index', views.index),
    url(r'^login',views.log),
    url(r'^logout', views.logout_user),
    url(r'^profile', views.profile)
]

```
<p style="color:blue;font-size:15px">python文件的具体注释写在代码里了，如若有不当之处，求指正，谢谢！！</p>
