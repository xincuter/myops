# 装饰器的的作用：在不改变原函数的调用方式的情况下，在函数的前后添加功能；
# 装饰器的本质：闭包函数

###例子1：
# def wrapper(func):
#     def inner(*args, **kwargs):  ##inner((7,)),接收的是一个元组
#         print('在被装饰的函数执行之前做的事')
#         ret = func(*args, **kwargs)  ##holiday(*(3,),**{})，调用会打散元组
#         print('在被装饰的函数执行之后做的事')
#         return ret
#
#     return inner
#
#
# @wrapper  # 等价于 holiday = wrapper(holiday)
# def holiday(day):
#     print("全体放假%s天" % day)
#     return "好开心"
#
# print(holiday.__name__)    ##结果为inner，所以这种情况下，函数的属性改变了
# a = holiday(7)  ##相当于inner(7)
# print(a)

##例子2：【使用wraps方法保持函数的属性值】
from functools import wraps   ##导入wraps方法
def wrapper(func):
    @wraps(func)
    def inner(*args, **kwargs):  ##inner((7,)),接收的是一个元组
        print('在被装饰的函数执行之前做的事')
        ret = func(*args, **kwargs)  ##holiday(*(3,),**{})，调用会打散元组
        print('在被装饰的函数执行之后做的事')
        return ret

    return inner


@wrapper
def holiday(day):
    print("全体放假%s天" % day)
    return "好开心"

print(holiday.__name__)    ##结果依然为holiday，这样真正做到了只扩展函数功能，不改变函数原有的属性
a = holiday(7)  ##相当于inner(7)
print(a)


'''
详解：
（1）未使用装饰器函数，函数执行过程：
        传参数
   我 <---------> 函数
        返回值

（2）使用装饰器函数，函数执行过程：
        传参数
   我  <---------> 装饰器 <---------> 函数
                          返回值
'''


##打印方法函数的__name__属性
# def wahaha():
#     '''
#     function of wahaha;
#     :return:
#     '''
#     print('娃哈哈')
#
# print(wahaha.__name__)   ##打印函数的__name__属性
# print(wahaha.__doc__)    ##打印函数注释文档信息