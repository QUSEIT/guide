# Django models AES 加密、解密

### 思路

django Field 在存入 Mysql 时会调用 get_prep_value 方法，从 Mysql 中取数据时会调用 to_python 方法，根据这个逻辑，我们就有方案啦。
1. 存数据时加密（重写 get_prep_value方法）;
2. 取数据时解密（重写 to_python 方法）。

### 安装
AES 包安装
```
pip install pycrypto
```

### Example Demo
```
# coding: utf-8
# name: aes_field.py
# date: '2016-12-16'
from Crypto.Cipher import AES
import base64
from django.db import models

__author__ = 'Anlim'


class AesField(models.TextField):
    """ 
        model Fields for aes
    """
    PADDING = '{'
    block_size = 16
    secret = 'this_is_secret'

    def __init__(self, *args, **kwargs):
        self.coder = kwargs.pop("coder", None)
        self.secret = self.pad(self.secret)
        self.cipher = AES.new(self.secret)
        super(AesField, self).__init__(*args, **kwargs)

    def from_db_value(self, value, expression, connection, context):
        return self.to_python(value)

    def to_python(self, value):
        #print "to python"
        # django  get db data
        """ 
        if not value:
            return value
        return self.coder.decode(value)
        """
        #try:
        return self.decode(value)
        #except Exception:
        #    return value

    def get_prep_value(self, value):
        # django 保存数据时会调用
        if not value:
            return value
        if not isinstance(value, str):
            value = str(value)
        return self.encode(value)

    def pad(self, s):
        return s + (self.block_size - len(s) % self.block_size) * self.PADDING
```

### 定义models
```
from django.db import models
from aes_field.py import AesField

class UserInfo(models.Model):
      name = AesField(verbose_name='姓名')
      id_card = AesField(verbose_name='身份证号')
      address = AesField(verbose_name='家庭住址')
```
