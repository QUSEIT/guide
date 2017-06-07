### django + uwsgi + nginx

#### 安装uwsgi
```
pip install uwsgi
```

##### UWSGI 配置
###### 在项目目录下创建 app_uwsgi.ini
```
[uwsgi]

# Django-related settings
# the base directory (full path)
chdir           = /data/www/vhosts/pro/ #项目地址
# Django's wsgi file
module          = apps.wsgi  #项目wsgi 地址
# the virtualenv (full path)
# home            = /   #virtualenv 项目目录

# process-related settings
# master
master          = true
# maximum number of worker processes
processes       = 10
# the socket (use the full path to be safe
socket          = /data/www/vhosts/pro/uwsgi.sock #项目sock文件
# ... with appropriate permissions - may be needed
chmod-socket    = 664
# clear environment on exit
vacuum          = true

pidfile          = /data/www/vhosts/pro/uwsgi.pid  #pid文件地址

plugins = python  #不加会出现502

buffer-size=32768 #  解决 invalid request block size: 21573 (max 4096)...skip错误
```

###### 创建 uwsgi_params 文件

```
uwsgi_param QUERY_STRING        $query_string;
uwsgi_param REQUEST_METHOD      $request_method;
uwsgi_param CONTENT_TYPE        $content_type;
uwsgi_param CONTENT_LENGTH      $content_length;

uwsgi_param REQUEST_URI         $request_uri;
uwsgi_param PATH_INFO           $document_uri;
uwsgi_param DOCUMENT_ROOT       $document_root;
uwsgi_param SERVER_PROTOCOL     $server_protocol;
uwsgi_param UWSGI_SCHEME        $scheme;

uwsgi_param REMOTE_ADDR         $remote_addr;
uwsgi_param REMOTE_PORT         $remote_port;
uwsgi_param SERVER_PORT         $server_port;
uwsgi_param SERVER_NAME         $server_name;
```

#### 安装nginx

```
apt-get install nginx
```

##### nginx 配置

```
upstream django {
    server unix:///data/www/vhosts/pro/uwsgi.sock;
}

server {
    listen 80; 
    listen 443;
    server_name www.xx.com xx.com;
    access_log /var/log/nginx/website.net.access_log;
    error_log /var/log/nginx/website.net.error_log;

    location /static/ { # MEDIA_URL
        alias /data/www/vhosts/pro/static/; # MEDIA_ROOT
        expires 5d; 
        client_max_body_size    1000m;
    }   

    location /media/ { # MEDIA_URL
        alias /data/www/vhosts/pro/media/; # MEDIA_ROOT
        expires 5d; 
    }   


    location /static/admin/ { # MEDIA_URL
        alias /usr/local/lib/python2.7/dist-packages/django/contrib/admin/static/admin/; # MEDIA_ROOT
        expires 90d;
    }   


    location / { 
        #proxy_pass http://website/;
        uwsgi_pass django;
        include /data/www/vhosts/pro/uwsgi_params;
    }   

}
```
注意： /data/www/vhosts/pro/  目录为你的项目路径

#### 启动命令

```
uwsgi --ini apps_uwsgi.ini
```

#### 重启服务

```
uwsgi --reload uwsgi.pid
```