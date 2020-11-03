'''
#生成器 ---- 本质上是迭代器 【自己写的】

#实现生成器两种方法：
    ##生成器函数 ---- 本质上就是我们自己写的函数；
    ##生成器表达式
'''

##生成器函数：
    # 只要含有yield关键字的函数都是生成器函数；
    # yield不能和return共用且需要写在函数内；
    # 执行之后会得到一个生成器作为返回值，并不会执行函数中的代码，只有在调用了__next__()方法之后才会执行函数内的代码
    # 生成器是一个迭代器，含有__next__()和__iter__()方法；
    # yeild并不会直接结束函数

###生成器函数例子
# def generator():
#     print(1)
#     yield 'a'
#     print(2)
#     yield 'b'
#     yield 'c'
#
# g = generator()
# print(g)      ##这边输出结果是：<generator object generator at 0x0000000000AA8D58>
# ##第一次调用__next__()方法
# ret = g.__next__()
# print(ret)                  ##结果为：1 \n a
# ##第二次调用__next__()方法
# ret = g.__next__()
# print(ret)                  ##结果为：2 \n b      【会从2开始打印】
# ##第三次调用__next__()方法
# ret = g.__next__()
# print(ret)                  ##结果为：c

###生成器函数例子2：
# def wahaha():
#     for i in range(2000000):
#         yield 'wahaha: %s' %i
#
# g = wahaha()
# ##打印生成器中的值，只打印前50个
# count = 0
# for i in g:
#     count += 1
#     print(i)
#     if count > 50:
#         break
# print('****',g.__next__())


