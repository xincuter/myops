'''
#可迭代对象
#直接给你内存地址
#print([].__iter__())       ##结果输出为<list_iterator object at 0x00000000011E4358>

例子：在python3中，range返回的一个迭代器；
    print(range(10))    ##range(0, 10)
'''


'''
##for循环：
只有是可迭代对象的时候，才能使用for；

当我们遇到一个新的变量，不确定能不能for循环的时候，可以判断它是否可迭代；

#for i in l:
#     pass
# iterator = l.__iter__()
# iterator.__next__()

迭代器的好处：
    #从容器类型中一个一个的取值。会把所有的值都取到；
    #节省内存空间；
        #迭代器并不会在内存中再占用一大块内存：
            ##而是随着循环，每次生成一个；
            ##每次next每次给我一个；
            
例子：
l = [1,2,3]
iterator = l.__iter__()   ##基于列表l创建一个迭代器；
while True:
    print(iterator.__next__()) ##调用__next__()方法循环打印迭代器中的元素；

print(range(100000))
print(range(3))
print(list(range(3)))    ##将迭代器装换成列表，并打印该列表;

def func():
    for i in range(10):
        i = "wahaha: %s" %i
    print(i)

func()
'''

