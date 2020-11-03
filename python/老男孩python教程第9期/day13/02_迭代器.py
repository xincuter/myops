##查看指定数据类型包含哪些方法，使用dir(type)
# print(dir([])) ##查看列表数据类型有哪些操作方法
# print(dir({})) ##查看字典数据类型有哪些操作方法
#
# #双下方法：
# print([1].__add__([2]))
# #等价于
# print([1]+[2])

# print('__iter__' in dir(int))   ##False
# print('__iter__' in dir(list))  ##True
# print('__iter__' in dir(dict))   ##True

##只要是能被for循环的数据类型的就一定拥有__iter__方法；
# print([].__iter__())

#一个列表执行了__iter__()之后的返回值是一个迭代器；
# print(dir([]))
# print(dir([].__iter__()))
# print(set(dir([].__iter__())) - set(dir([])))
##例子
# l = [1,2,3]
# a = l.__iter__()   ##将列表l转换成迭代器，并赋值给变量a
# print(a.__next__())   ##1
# print(a.__next__())   ##2
# print(a.__next__())   ##3
# print(a.__next__())   ##报错了，因为迭代器已经没有元素可以取了

#iterable 可迭代的  ---> __iter__ #只要含有__iter__方法的都是可迭代对象
#[].__iter__() 迭代器 ---> __next__ #通过next就可以从迭代器中一个一个的取值

#只要含有__iter__方法的都是可迭代的 ---- 可迭代协议
#迭代器协议：---- 内部同时含有__next__ 和 __iter__方法的就是迭代器；
print('__iter__' in dir([].__iter__()))
print('__next__' in dir([].__iter__()))

from collections import Iterable   ##可迭代
from collections import Iterator   ##迭代器
print(isinstance([],Iterator))    ##判断列表是否是迭代器  【False】
print(isinstance([],Iterable))    ##判断列表是否是可迭代 【True】


##迭代器协议和可迭代协议
    #可以被for循环的都是可迭代；
    #可迭代的内部都有__iter__方法；
    #只要是迭代器，一定可迭代；
    #可迭代的不一定是迭代器，因为不一定含有__next__()方法；
    #可迭代对象.__iter__()方法就可以得到一个迭代器；
    #迭代器中的__next__()方法可以一个一个的获取值；

#for循环其实就是在使用迭代器；
# for i in l:
#     pass
#iterator = l.__iter__()
#iterator.__next__()

#迭代器的好处：
    #从容器类型中一个一个的取值，会把所有的值都取到；
    #节省内存空间；
        #迭代器并不会在内存中再占用一大块内存，
            #而是随着循环，每次生成一个；
            #每次next每次给我一个

##生成器

