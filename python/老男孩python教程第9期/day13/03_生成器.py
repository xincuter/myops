#生成器
#生成器函数 --- 本质就是我们自己写的函数
#生成器表达式


##生成器函数：只要含有yield关键字的函数都是生成器函数；
#yield不能和return共用且需要写在函数内部；
#生成器函数执行之后会得到一个生成器作为返回值；
# def generator():
#     print(1)
#     yield 'a'
#     print(2)
#     yield 'b'
#
# ret = generator()
# print(ret)
# print(ret.__next__())
# print(ret.__next__())

##娃哈哈例子（制造两百个万个娃哈哈）
# def wahaha():
#     for i in range(1,2000001):
#         yield '娃哈哈%s' %i
#
# a = wahaha()
# print(a)
# for i in a:
#     print(i)


