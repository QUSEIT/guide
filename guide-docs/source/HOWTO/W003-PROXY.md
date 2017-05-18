Title: 工作室代理配置教程
Date: 2016-07-09 14:50
Category: HOWTO

# 工作室使用 Shadowsocks 进行翻墙，各系统的客户端可以[到此](https://github.com/shadowsocks/shadowsocks/wiki/Shadowsocks-%E4%BD%BF%E7%94%A8%E8%AF%B4%E6%98%8E)下载安装客户端

Mac:
>* 下载后 Mac 双击安装
>* Mac: 启动后如果弹出服务器配置直接关闭，将服务器二维码显示在屏幕上，右键右上方托盘区小飞机图标 -> 从屏幕上扫描二维码 -> 弹出服务器配置确认即可。
>* 右键小飞机确认 Shadowsocks 处于打开状态 -> 选择全局模式 -> 点击从 GFWlist 更新 PAC。
>* 切换回自动模式，打开[谷歌](www.google.com) 确认是否已经成功

Windows:
>* Windows 放到合适的目录解压即安装（第一期运行后同目录下会生成几个配置文件）
>* 方式基本同 Mac 其中扫描二维码在服务器的二级菜单，自动模式在 Windows 叫 PAC 模式

Linux:
>* 打开系统设置 -> 网络 -> 网络代理
>* 选择自动模式
>* 地址填 http://quseitlab/static/img/proxy.pac
>* 确认，可能需要输入管理员密码

IOS:
>* 如果没有打算购买收费应用只能使用 PAC 模式（每个 WIFI 都需要单独配置）
>* 打开设置 -> 无线局域网 -> 当前已连接 WIFI 最右侧的 i 形蓝色图标
>* 最下方 HTTP 代理选择自动模式
>* 地址填 http://quseitlab/static/img/proxy.pac
>* 回车确认，点击最左上角的返回按钮返回
>* 打开[谷歌](www.google.com) 确认是否已经成功

Android:
>* 可以使用 PAC 模式，方法同 IOS
>* 下载 Android 客户端后安装即可，添加服务器需手动配置
>* 地址: quseitlab 
>* 端口: 8388
>* 加密: aes-256-cfb
>* 密码: 问胡国涛要

Mac 或 Windows 可以通过编辑本地 PAC 文件使用我们的国内跳板进一步提高联网速度:
>* 打开 gfwlist.js 编辑 var proxy = xxxxx 这行
>* 将两个 127.0.0.1:1080 都改为 xx.xx.xx.xx:1080 即可

如果有任何问题可以直接找胡国涛，使用在线 PAC 模式的同学遇到某些无法访问的网址可以把地址提交给胡国涛添加进自动翻墙列表

SS 服务器二维码（请找HGT索取）
