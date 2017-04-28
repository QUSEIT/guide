Title: 支付宝Python 接入使用说明
Date: 2016-07-07
Category: U200

### 支付宝Python 接入使用说明

#### 依赖包  
`from hashlib import md5`  
`import types`  
`from urllib import urlencode, urlopen`  

#### 帐户配置  

字段 | 说明 | 备注
---|---|---
ALIPAY_KEY | 安全验证码 | *必填
ALIPAY_INPUT_CHARSET | 编码（默认utf-8） | 可空
ALIPAY_PARTNER | 合作身份Id | *必填
ALIPAY_SELLER_EMAIL | 签约支付宝帐号或卖家支付宝帐号 | *必填
ALIPAY_SIGN_TYPE | 加密类型(默认为：md5) | 可空
ALIPAY_RETURN_URL | 付款成功后跳转链接，不允许加?id=1格式链接 | 必填
ALIPAY_NOTIFY_URL | 交易过程中服务器异步通知地址 | *必填
ALIPAY_TRANSPORT | 访问模式，根据自己的服务器是否支持ssl访问，若支持请选择https；若不支持请选择http | *必填

#### 二、支付宝各个接口使用说明
#### 2.1 支付宝即时到账接口
##### 2.1.1参数配置  
字段 | 说明 | 备注  
---|---|---
out_trade_no | 订单号 | *必填
subject | 商品名称 | *必填
body | 支付说明 | *必填
total_fee | 支付金额 | *必填

##### 2.1.2 示例代码

```
#coding:utf-8
author: Anlim
"""
from hashlib import md5
import types
from urllib import urlencode, urlopen


class AlipayMain(object):  
    GATEWAY = 'https://mapi.alipay.com/gateway.do?' #支付宝接口地址
    def smart_str(self, s, encoding='utf-8', strings_only=False, errors='strict'):
    
        if strings_only and isinstance(s, (types.NoneType, int)):
            return s
            
        if not isinstance(s, basestring):
            try:
                return str(s)
            except UnicodeEncodeError:
                if isinstance(s, Exception):
                    # further exception.
                    return ' '.join([smart_str(arg, encoding, strings_only,
                            errors) for arg in s]) 
                return unicode(s).encode(encoding, errors)
        elif isinstance(s, unicode):
            return s.encode(encoding, errors)
        elif s and encoding != 'utf-8':
            return s.decode('utf-8', errors).encode(encoding, errors)
        else:
            return s
    
    # 对数组排序并除去数组中的空值和签名参数
    # 返回数组和链接串
    def params_filter(self, params):
        ks = params.keys()
        ks.sort()
        newparams = {}
        prestr = ''
        for k in ks: 
            v = params[k]
            k = self.smart_str(k, settings.ALIPAY_INPUT_CHARSET)
            if k not in ('sign','sign_type') and v != '':
                newparams[k] = self.smart_str(v, settings.ALIPAY_INPUT_CHARSET)
                prestr += '%s=%s&' % (k, newparams[k])
        prestr = prestr[:-1]
        return newparams, prestr
    
    def sign_str(self, prestr, key, sign_type= 'MD5'):
        """生成签名"""
        if sign_type == 'MD5':
            return md5(prestr + key).hexdigest()
        else:
            return ''
    
    def create_direct_pay_by_user(self, out_trade_no, subject, body, total_fee):
        """即时到账交易接口"""
        params = {}
        params['service'] = 'create_direct_pay_by_user'
        params['partner'] = ALIPAY_PARTNER
        params["seller_id"] = ALIPAY_PARTNER
        params['payment_type']  = '1'

        # 获取配置文件
        params['_input_charset'] = ALIPAY_INPUT_CHARSET
        # 扩展功能参数——网银提前
        #params['paymethod'] = 'directPay'   # 默认支付方式，四个值可选：bankPay(网银); cartoon(卡通); directPay(余额); CASH(网点>支付)
        #params['defaultbank'] = ''          # 默认网银代号，代号列表见http://club.alipay.com/read.php?tid=8681379

        params['seller_email'] = ALIPAY_SELLER_EMAIL
        params['return_url'] =  ALIPAY_RETURN_URL
        params['notify_url'] = settings.ALIPAY_NOTIFY_URL
        params['error_notify _url'] = ALIPAY_NOTIFY_URL
        params['show_url'] = ALIPAY_SHOW_URL

        # 从订单数据中动态获取到的必填参数
        params['out_trade_no']  = out_trade_no        # 请与贵网站订单系统中的唯一订单号匹配
        params['subject']       = subject   # 订单名称，显示在支付宝收银台里的“商品名称”里，显示在支付宝的交易管理的“商品名称”的列
表里。
        params['body']          = body      # 订单描述、订单详细、订单备注，显示在支付宝收银台里的“商品描述”里
        params['total_fee']     = total_fee # 订单总金额，显示在支付宝收银台里的“应付总额”里

        params['transport'] = settings.ALIPAY_TRANSPORT
        # 扩展功能参数——防钓鱼
        #params['anti_phishing_key'] = ''
        #params['exter_invoke_ip'] = ''

        # 扩展功能参数——自定义参数
        #params['buyer_email'] = ''
        #params['extra_common_param'] = ''

        # 扩展功能参数——分润
        #params['royalty_type'] = ''
        #params['royalty_parameters'] = ''

        params, prestr = self.params_filter(params)
        params['sign_type'] = settings.ALIPAY_SIGN_TYPE
        params['sign'] = self.sign_str(prestr, ALIPAY_KEY, ALIPAY_SIGN_TYPE)
        
        #返回的地址是支付宝即时到账支付接口
        return self.GATEWAY + urlencode(params)
```

 
