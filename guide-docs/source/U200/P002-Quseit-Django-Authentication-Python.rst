Title: Django 用户验证系统简单使用教程 Date: 2016-07-13 Category: U200

Django用户验证系统
==================

django自带有一套自身的用户验证系统，可以参考官方文档（连接到django
authentication system）:

https://docs.djangoproject.com/en/1.9/topics/auth/default/#user-objects

下面是django用户系统的一个小案例（看案例前建议先浏览一下官方文档用户系统验证部分）

新建django项目：项目结构很简单，只添加了四个html文件，index.html（首页）,
login.html（登陆页）, register.html（注册页）, profile.html（个人中心）

其他是django自带的。基本只需修改views.py, urls.py文件

现在有一个需求是：

（1）实现登录注册；

（2）登陆的用户可以从首页index进入个人中心profile；

（3）未登录用户访问个人中心profile将自动跳转到登陆页面；

（4）用户可以退出登陆；

需求说完了，直接上代码！！！

index.html代码：

::

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

.. raw:: html

   <p style="color:blue;font-size:15px">

user.is_authenticated 是 django提供的一个用户验证方法，校验用户是否是合法的(请再次参考官方文档)

.. raw:: html

   </p>

login.html代码：

::

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

.. raw:: html

   <p style="color:blue;font-size:15px">

{% csrf_token %}据说是防跨域攻击, 想深入了解的童鞋戳下面链接：

.. raw:: html

   </p>

http://www.jianshu.com/p/a178f08d9389

regitser.html代码：

::

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

 profile.html代码:

::

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

.. raw:: html

   <p style="color:blue;font-size:15px">

{user.date_joined} 以及 {user.last_login} 都是django提供的参数（更多参数,再次请参考官方文档），分别是用户注册时间、用户上一次登陆时间。

.. raw:: html

   </p>

views.py代码： 

..  code-block:: python
    :linenos:

    #coding:utf-8
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


