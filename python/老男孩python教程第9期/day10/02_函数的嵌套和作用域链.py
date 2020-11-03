##函数的嵌套定义：
    #内部函数可以使用外部函数的变量


##例子1
##定义两个数求最大值函数
# def max(a,b):
#     return a if a > b else b    ##三元运算【如果a>b,返回a，否则返回b】

# ##定义三个数求最大值函数
# def the_max(x,y,z):
#     c = max(x,y)       ##复用上面两个数求最大值的函数，即函数的嵌套
#     return max(c,z)
#
# print(the_max(1,2,3))


##例子2
# a = 1
# def outer():
#     a = 1
#     def inner():
#         b = 2
#         print(a)
#         print('inner')
#         def inner2():
#             nonlocal a ##声明一个上面第一层局部变量
#             a += 1   ##不可变数据类型的修改
#             print('inner2')
#         inner2()
#     inner()
#     print('**a** : ',a)
#
# outer()
# print('全局: ',a)

##nonlocal只能用于局部变量，找上层中离当前函数最近一层的局部变量；
##声明了nonlocal的内部函数的变量修改会影响到离当前函数最近的一层的局部变量；
##对全局无效
##对局部，也只是对最近的一层有影响；

##例子
# a = 0
# def outer():
#     a = 1
#     def inner():
#         a = 2
#         def inner2():
#             nonlocal a  ##只会影响找到的上一层，不会影响全局
#             a = 3
#             print(a)
#         inner2()
#     inner()
#
# outer()
# print("全局：", a)       ##结果为：全局： 0



# def func():
#     print(123)
# #func()
# func2 = func #函数名就是内存地址
# func2()
#
# l = [func,func2]  ##函数名可以作为容器类型的元素【基本的数据类型都可以称之为容器，是数据的载体】
# print(l)    ##打印出来是内存地址



# def func():
#     print(123)
#
# def wahh(f):
#     f()
#     return f   ##函数名可以作为函数的返回值
#
# qqxing = wahh(func)    ##函数名可以作为函数的参数
# qqxing()