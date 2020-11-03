#匿名函数：为了解决那些功能很简单的需求而设计的一句话函数

##例子1: 幂运算
def calc(n):
    return n ** n
print(calc(10))

##上述代码换成匿名函数如下：
calc = lambda n:n ** n
print(calc(10))
###解释说明：
#cacl：函数名
#lambda：定义匿名函数关键字
#n：参数
#n ** n：返回值
'''匿名函数格式如下：
函数名 = lambda 参数:返回值

#参数可以有多个，用逗号隔开；
#匿名函数不管逻辑多复杂，只能写一行，且逻辑执行结束后的内容就是返回值；
#返回值和正常函数一样可以是任意数据类型。
'''

##例子2：
dic = {'k1':10,'k2':100,'k3':30}
print(max(dic))    ##结果为：k3    [对于字典来说，默认取key值比较大小]
###以value的值比较大小
def func(k):
    return dic[k]
print(max(dic,key=func))   ##结果为：k2   【指定了key后，根据key的返回值来排序】
'''以上方法还可以使用匿名函数实现'''
print(max(dic,key=lambda k:dic[k]))   ###结果为：k2   【指定了key后，根据key的返回值来排序】

##map与匿名函数结合使用的案例
res = map(lambda x:x ** 2,[1,5,7,4,8])  ##将lambda函数作用于后面的集合，返回一个新列表
for i in res:
    print(i)

##filter与匿名函数结合使用的案例
res2 = filter(lambda x:x>10,[5,8,11,9,15])
for i in res2:
    print(i)


##习题1
'''
d = lambda p:p*2
t = lambda p:p*3
x = 2
x = d(x)
x = t(x)
x = d(x)
print(x)

提问：x的值为多少      ##结果为：24
'''

##习题2
'''
有两元组(('a'),('b')),(('c'),('d')),请使用python中匿名函数生成列表[{'a':'c'},{'b':'d'}]
'''
t1 = (('a'),('b'))
t2 = (('c'),('d'))
ret = zip(t1,t2)
###不使用匿名函数方法
# def func(tup):
#     return {tup[0]:tup[1]}
# res = map(func,ret)
# print(list(res))
###使用匿名函数
res2 = map(lambda x:{x[0]:x[1]},zip(t1,t2))
print(list(res2))

##习题3
'''
以下代码输出结果是多少？请给出结果并解释
def multipliers():
    return [lambda x:i*x for i in range(4)]  ###for执行完后，i=3
print([m(2) for m in multipliers()])    ###结果为：[6,6,6,6]

###如果想要结果为：[0,2,4,6],只需要将multipliers()函数中的返回值改成一个生成器
def multipliers():
    return (lambda x:i*x for i in range(4))
'''


'''
注意：
面试考匿名函数，不会单纯考匿名函数，一定要联想结合内置函数去思考问题
'''
