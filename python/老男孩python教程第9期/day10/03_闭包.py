#闭包：是嵌套函数，且内部函数调用外部函数的变量；
# def func():
#     name = "eva"
#     def inner():
#         print(name)
#     print(inner.__closure__)   ##结果中包含cell，就代表这是个闭包函数
#
# func()
# print(func.__closure__)  ##打印出来为None

'''
闭包函数：
内部函数包含对外部作用域而非全局作用域名字的引用，该内部函数称为
闭包函数；

函数内部定义的函数称为内部函数；
'''


##闭包函数的常见用法
# def outer():
#     a = 1
#     def inner():
#         print(a)
#     #inner()      ##可以直接调用内部函数
#     return inner    ##这是闭包的常见用法，将内部函数以返回值的形式返回，这样在外部就可以引用内部函数了
#
# inn = outer()
# inn()        ##在函数的外部，可以使用其内部的函数


'''
使用闭包的好处:
    延长了外部变量而非全局变量的生存周期，且能在外部调用它；
'''


'''
模块：可以直接理解为一个python文件
'''

#import urllib   ##导入url请求的模块
from urllib.request import urlopen #块中导入方法
#ret = urlopen('http://www.xiaohua100.cn/index.html').read()   ##读取网页，并保存到变量ret中
#print(ret)

def func():
    url = 'http://www.xiaohua100.cn/index.html'
    def get_url():
        ret = urlopen(url).read()
        print(ret)
    return get_url          ##闭包的例子

get = func()
get()

