#函数：实现某个功能的代码块，提升代码复用率

'''
##语法格式
###定义函数
def FUNC_NAME(arg1,arg2,...):
    statement1
    statement2
    ...

###应用函数[或者调用函数]
FUNC_NAME()
'''


##函数的返回值的重要性
##语法：return [VALUE | EXPRESSION]

'''
返回值的3种情况：
    (1)没有返回值 --- 返回None
        #不写return，默认返回None；
        #写return，但不写返回值，默认返回None
        #return None --- 【最不常用】
    (2)返回一个值；
        可以返回任何数据类型；
        只要返回就可以接收到；
        如果一个程序有多个return值，只执行第一个；
    (3)返回多个值；
        多个返回值用多个变量接收，有多少返回就用多少变量接收；
        多个返回值用1个变量接收时，则会得到一个元组；
    
return代表结束一个函数，后续代码不会在执行；
'''

##函数分类
    # 内置函数
    # 自定义函数

##自定义函数例子
##1
# def mylen(s):    ##接收参数，s是形式参数，形参
#     i = 0
#     for k in s:
#         i += 1
#     return i   ##返回值
#
# a = mylen('xin is good!')   ##'xin is good!'是实际传入的参数，简称实参
# print(a)

#2
# def func2():
#     return 1,2,3
#
# r1 = func2()
# print(r1)     ##返回的是一个元组
# r2,r3,r4 = func2()
# print(r2,r3,r4)



'''
函数的参数:
    形参：形式参数
    实参：实际参数
    
传递参数个数分类情况：
    没有参数：
        定义函数和调用函数时括号里都不写内容；
    有一个参数：
        传什么就是什么；
    有多个参数：
        位置参数
        默认参数
        关键字参数
        可变参数（动态参数）
        
##站在实参的角度上：【调用函数时】
    #按照位置传参；
    #按照关键字传参；
    #混着用可以：但是，必须先按照位置传参，在按照关键字传参（即位置传参必须写在前面）
            #不能同一个变量传递多个值
            
##站在形参的角度上：【定义函数时】
    #位置参数，必须传，且有几个就传几个值；
    #默认参数，关键字参数：参数名 = 'value'
    #动态参数：可以接受任意个参数,有以下两种：
        ##*args: 参数名前必须带*，接收到的是按照位置传参的值，组织成一个元组；
        ##**kwargs：参数名前必须带**，接收到的是按照关键字传参的值，组织成一个字典；
        ##两个一起用是，*args必须在**kwargs之前；
        
参数优先级顺序：【定义函数的时候必须严格按照这个标准来】
    位置参数 > *args > 默认参数 > 关键字参数/**kwargs【优先级大的必须写在前面】       
'''

##例1：两个参数
# def my_sum(a,b):
#     res = a + b   ##result
#     return res
#
# #ret = my_sum(1,2)  ##位置传参，a = 1，b = 2
# ret = my_sum(a = 1,b = 2)  ##关键字传参
# print(ret)


##例2：默认参数，关键字参数
# def classmate(name,sex = '男'):    ##sex = '男'是默认参数
#     print('%s : %s' %(name,sex))
#
# classmate('二哥','男')
# classmate('小孟')          ##因为sex是默认参数，所以可以不传，默认sex = '男'
# classmate('大猛')
# classmate('朗哥','女')


##例3：动态参数：*args    【*args是将所有传递的位置参数作为一个元组】
# def sum(*args):    ##定义时args前的*必须带上，不然就只是一个参数args
#     n = 0
#     for i in args:
#         n += i
#     print(args, type(args))  ##打印出来args是一个元组，将传入的所有参数作为一个元组返回
#     return n
#
# print(sum(1,2))
# print(sum(1,2,3,4))


##例4：动态参数：**kwargs  【**kwargs是将所有传递的关键字参数做为一个字典】
# def func(**kwargs):    ##定义时kwargs前的**必须带上；
#     print(kwargs)
#
# func(a = 1,b = 3,c = 4)       ##得到的结果是一个字典，元素是传递的所有的关键字参数
# func(a = 1,b = 3)


##例5：动态参数（*args和**kwargs一起用，可以传递所有类型的参数）
# def func(*args,**kwargs):
#     print(args,kwargs)
#
# func(1,2,3,4,[1,2,3],a = '123',b = 'bbbb',c = [1,2,3])



##动态参数*args的另外一种传参方式
def func(*args): ##站在形参的角度，给变量加上*，就是组合所有传来的值
    print(args)

func(1,2,3,4,5)   ##直接传
l = [3,4,5,6,7]
func(*l)   ##站在实参的角度上，给一个序列加上*，就是将这个序列按照顺序打散，将每个元素都作为参数传递；


##动态参数**kwargs的另外一种传参方式
def func(**kwargs):  ##
    print(kwargs)

func(a = 1,b = 2,c = 3)
d = {'a':123,'b':234,'c':345}
func(**d)   ##给一个字典加上**,就是将这个字典按照顺序打散，将每个元素都作为参数传递



'''
函数章节总结：
1、函数的定义
2、函数的调用
3、函数的返回值：
    :return
4、函数参数
    形参：【顺序优先级如下】
        位置参数 > *args > 默认参数 > **kwargs
        
        位置参数: 必须传； 
        *args：可以接受任意多个位置参数；
        默认参数：可以不传；
        **kwargs：可以接受任意多个关键字参数
        
    实参：按照位置传参，按照关键字传参；先按照位置传参，在按照关键字传参
5、函数分类：
    内置函数
    自定义函数
'''


##参数时可变类型时
##例子
def qqxing(l = []):
    l.append(1)
    print(l)

qqxing()   ##[1]
qqxing([]) ##[1]
qqxing()    ##[1,1]
qqxing()   ##[1,1,1]

'''
如果默认参数的值是一个可变数据类型，那么
每一次调用函数的时候，如果不传值就会公用
这个数据类型的资源。
'''


