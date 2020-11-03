##python装饰器

##例子：
# import  logging
#
# def use_logging(level):
#     def decorator(func):
#         def wrapper(*args, **kwargs):
#             if level == "warn":
#                 logging.warn("%s is running" % func.__name__)
#             elif level == "info":
#                 logging.info("%s is running" % func.__name__)
#             return func(*args)
#         return wrapper
#
#     return decorator
#
# @use_logging(level="warn")   ##相当于foo = decorator(foo)
# def foo(name='foo'):
#     print("i am %s" % name)
#
# foo('hzzxin')


##例子2：
# from functools import wraps
# def logged(func):
#     @wraps(func)
#     def with_logging(*args, **kwargs):
#         print(func.__name__)      # 输出 'f'
#         print(func.__doc__)       # 输出 'does some math'
#         return func(*args, **kwargs)
#     return with_logging
#
# @logged
# def f(x):
#    """does some math"""
#    return x + x * x
#
# a = f(2)
# print(a)
#
# '''
# 如果不加functools.wraps，不难发现，函数 f 被with_logging取代了，当然它的docstring，__name__就是变成了
# with_logging函数的信息了。好在我们有functools.wraps，wraps本身也是一个装饰器，它能把原函数的元信息拷贝
# 到装饰器里面的 func 函数中，这使得装饰器里面的 func 函数也有和原函数 foo 一样的元信息了。
#
# 输出结果：
# f
# does some math
# 6
# '''
