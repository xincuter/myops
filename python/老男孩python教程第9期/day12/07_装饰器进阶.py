##带参数的装饰器
##为500个函数添加时间功能
# import time
# FLAGE = True
# def timmer_out(flag):
#     def timmer(func):
#         def inner(*args,**kwargs):
#             if flag:
#                 start_time = time.time()
#                 ret = func(*args,**kwargs)
#                 end_time = time.time()
#                 print("time of exec function: %s" %(end_time-start_time))
#                 return ret
#             else:
#                 ret = func(*args,**kwargs)
#                 return ret
#         return inner
#     return timmer
#
# @timmer_out(FLAGE)   ##分两部分：1、timmer_out(flag) == timmer；2、@timmer == [wahaha = timmer(wahaha)]
# def wahaha():
#     time.sleep(0.2)
#     print("wahaha is great.")
#
# @timmer_out(FLAGE)
# def erguotou():
#     time.sleep(0.1)
#     print("erguotou is great.")
#
# wahaha()
# erguotou()


##多个装饰器装饰同一个函数
##【python核心编程（第二版）】
def wrapper1(func):  ##func --> f
    def inner1():
        print("wrapper1,before func")
        ret = func()  ##f
        print("wrapper1,after func")
        return ret
    return inner1

def wrapper2(func):  ##func --> inner1
    def inner2():
        print("wrapper2,before func")
        ret = func()  ##inner1
        print("wrapper2,after func")
        return ret
    return inner2

@wrapper2  ##f = wrapper2(f) --> wrapper2(inner1) = inner2
@wrapper1  ##f = wrapper1(f) = inner1
def f():
    print("in f")
    return 'hahaha'

print(f())   ##inner2()
'''
##执行现象如下：[类似于俄罗斯套娃]
wrapper2,before func
wrapper1,before func
in f
wrapper2,after func
wrapper2,after func
hahaha
'''