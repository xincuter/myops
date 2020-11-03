##生成器函数的另外一种调用方法
# def generator():
#     print(123)
#     content = yield 1
#     print('======',content)
#     print(456)
#     arg = yield 2
#     ''''''
#     yield
#
# g = generator()
# ret = g.__next__()
# print('***',ret)
# #ret = g.send(None)   ##send的效果与next一样
# ret = g.send('hello')
# print('***',ret)
#
# ''''
# 结果为:
# 123
# *** 1
# ====== hello
# 456
# *** 2
# '''

##send 获取下一个值的效果和next基本一致；
##只是在获取下一个值的时候，给上一个值的位置传递一个数据；
##使用send的注意事项：
    #第一次使用生成器的时候，必须是使用next获取下一个值；
    #最后一个yield不能接受外部的值


##练习题：获取移动平均值
##第一种方法，不使用装饰器
# def average():
#     sum = 0
#     count = 0
#     avg = 0
#     while True:
#         num = yield avg
#         sum += num
#         count += 1
#         avg = sum / count
#
# avg_g = average() ##得到一个生成器avg_g
# avg_g.__next__()
# avg1 = avg_g.send(10)
# avg1 = avg_g.send(20)
# print(avg1)


##第二种方法，使用装饰器
# def init(func):
#     def inner(*args,**kwargs):
#         g = func(*args,**kwargs)
#         g.__next__()
#         return g
#     return inner
#
# @init
# def average():
#     sum = 0
#     count = 0
#     avg = 0
#     while True:
#         num = yield avg
#         sum += num
#         count += 1
#         avg = sum / count
#
# avg_g = average()
# ret = avg_g.send(10)
# print(ret)
# ret = avg_g.send(20)
# print(ret)



##python3中新加yield用法
##不使用yield from，循环打印字符串
# def generator():
#     a = 'abcde'
#     b = '12345'
#     for i in a:
#         yield i
#     for i in b:
#         yield i
#
# g = generator()
# for i in g:
#     print(i)

##使用yield from，循环打印字符串，与上述for循环实现同样的功能
def generator():
    a = 'abcde'
    b = '12345'
    yield from a     ##能和for循环达到同样的效果
    yield from b

g = generator()
for i in g:
    print(i)