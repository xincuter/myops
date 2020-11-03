'''
进阶作业：
1、编写下载网页内容的函数，要求功能是：用户传入一个url，函数返回下载结果；
2、为题目1编写装饰器，实现缓存网页内容的功能：
具体：实现下载的页面存放于文件中，如果文件内有值（文件大小不为0），就优先从文件
中读取网页内容，否则，就去下载，然后保存到该文件中；
'''
import os
from urllib.request import urlopen
def cache(func):
    def inner(*args,**kwargs):
        if os.path.getsize('web_cache'):
            with open('web_cache','rb') as f:
                return f.read()

        ret = func(*args,**kwargs)
        with open('web_cache','wb') as f:
            f.write(b"****" + ret)
        return ret
    return inner

@cache
def download(url):
    code = urlopen(url).read()
#    print(type(code))
    return code

a = download("http://www.baidu.com")
print(a)
a = download("http://www.baidu.com")
print(a)
a = download("http://www.baidu.com")
print(a)

