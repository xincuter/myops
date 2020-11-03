##内置函数
'''
官方推荐，一共68个
分类如下：
（1）反射相关：4个
（2）基础数据类型相关：38个
（3）作用域相关：2个
（4）面向对象相关：9个
（5）迭代器/生成器相关：3个
（6）其他：12个
'''

##如下
# print()
# input()
# len()
# type()
# open()
# tuple()
# dict()
# list()
# int()
# set()
# id()
# str()
# int()
# bool()
# range()
# dir()    ##查看一个对象拥有的所有方法
#......


###作用域相关的内置函数
# locals()
# # globals()
# print(locals()) ##返回本地作用域中的所有名字；
# print(globals()) ##返回全局作用域中的所有名字；
# global 变量    #【全局生效】
# nonlocal 变量  #【前一个生效】

##迭代器方法
# 迭代器.__next__()

##迭代器函数
# next(迭代器)

##iter(可迭代的)


#dir()：查看一个变量或数据类型拥有的方法
# print(dir([]))


#callable：检验变量是否是可被调用的（即是否是函数还是值）
# a = 1
# print(callable(a))
# print(callable(print))



##help()：返回内置函数帮助信息


##import: 导入模块，调用的是__import__()
#import time
time = __import__('time')
print(time.time())

##某个方法属于某个数据类型的变量，就用.调用；
##如果某个方法不依赖于任何数据类型，就直接调用 --- 内置函数和自定义函数



###跟内存相关的
# id()
# hash()

##hash: hash内置函数,检测变量是否可哈希；
##对于相同可hash数据的hash值在一次程序执行过程中总是不变的
##字典的寻址方式
# print(hash(123456))
# print(hash('abc'))
# print(hash(('1','abc')))
# print(hash([]))       ##列表是可变对象，所以不可哈希



###输入输出相关的
# input()
# print()

# print(value,..., sep=' ', end='\n', file=sys.stdout, flush=False)
#     file:默认是输出到屏幕，如果设置为文件句柄，输出到文件；
#     sep:打印多个值之间的分隔符，默认为空格；
#     end:每一次打印的结尾，默认为换行符；
#     flush:立刻把内容输出到流文件，不做缓存。

##print：可以指定结尾分隔符，默认是\n，可以使用end=""指定；也可以指定输出多个值之间的分隔符
# print('this is good!',end="|")
# print('that is bad!',end="\n")
# print(1,2,3,4,sep='/')    ##结果为：1/2/3/4 ，使用sep指定文本之间的分隔符，默认是空格；


##使用print制作打印进度条
# import time
# for i in range(0,101,2):
#     time.sleep(0.1)
#     char_num = i // 2   ##打印多少个*
#     per_str = '\r%s%% : %s\n' %(i,'*' * char_num) if i == 100 else '\r%s%% : %s' %(i,'*'*char_num)
#     print(per_str,end='',flush=True)

##\r代表移动光标到行首且不换行



###跟字符串编码相关的
# exec('print(123)')   ##123
# eval('print(123)')   ##123
# print(eval('1+2+3+4'))  ##10     [执行了有返回值]
# print(exec('1+2+3+4'))  ##None   [执行了但是没有返回值]
##exec和eval都可以执行，字符串类型的代码
    #eval有返回值；
    #eval只能用在你明确知道你要执行的代码是什么；建议不用，为了安全；
    #exec没有返回值；

##compile：将字符串类型的代码编译，代码对象能够通过exec语句来执行或者eval()进行求值。
# code = 'for i in range(0.10): print(i)'
# compile1 = compile(code,'','exec')   ##编译成exec模式的代码
# exec(compile1)


###进制转换
# bin()   ##二进制
# oct()   ##八进制
# hex()   ##十六进制
print(bin(10))   ##0b1010
print(oct(10))   ##0o12
print(hex(10))   ##0xa


###数学运算
# abs(n)   ##绝对值
# divmod() ##返回商和余数
print(divmod(9,2))   ##(4,1)
print(divmod(5,7))   ##(0,5)
# round(x,y)   ##计算精确值，x是值，y是精度
print(round(3.14159,2))
# pow(x,y)   ##幂运算，求x的y次方
print(pow(2,4))   ##16
print(pow(3,2,1))  ##3的平方与1取余，结果为：0
# sum()   ##和
# min()   ##最小值
print(min(1,2,3,-4,key = abs))   ##key = abs表示以绝对值的结果判断最小值，结果为：1
# max()   ##最大值