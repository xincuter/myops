#数据类型：int、bool
#数据结构（容器型）：dict、list、tuple、set、str


##reversed()：保留源列表，翻转列表，返回的是一个反序迭代器；
# l = [1,2,3,4,5]
# l2 = reversed(l)
# print(l2)
# for i in l2:
#     print(i)


##slice()：切片函数
# l = (1,2,23,213,5612,342,43)
# sli = slice(1,5,2)
# print(l[sli])     ##(2,213)
#等价于
# print(l[1:5:2])   ##(2,213)



##format()：格式函数
# print(format('test','<20'))  ##左对齐，剩余字符默认用空格填充
# print(format('test','>20'))  ##右对齐
# print(format('test','^20'))   ##居中


##bytes: 转换成bytes类型
#拿到是gbk编码的，想转换成utf-8编码
print(bytes('你好',encoding='GBK')) ##unicode转换成GBK的bytes
print(bytes('你好',encoding='GBK').decode('GBK'))
print(bytes('你好',encoding='utf-8'))  ##unicode转换成utf-8的bytes

##从gbk ---> utf8
    ###在内存中过程为：gbk -----------------------> unicode ------------------------> utf-8
    ###                            decode                       bytes(encode过程)

##网络编程，只能传输二进制
##照片和视频也是以二进制存储
##html网页爬取到的也是编码


##bytearray


#切片：----字节类型，不占内存
#字节：----字符串，占内存

##ord()：将字母装换成数字
print(ord('a'))
print(ord('l'))

##chr()：将数字转换成字母
print(chr(97))

##ascii()：只要是ascii码中的内容，就打印出来，不是就转换成\u；
print(ascii('好'))  ##'\u597d'
print(ascii('1'))   ##'1'

##repr()：用%r格式化输出，原封不动输出拼接；
# name = 'egg'
# print('你好%r' %name)  ##你好'egg'
#
# %r：对应的就是repr
print(repr('1'))   ##'1'
print(repr(1))     ##1

##all()：元素中有一个为假，则整体为假；元素必须是可迭代对象
print(all(['a','','123']))  ##False
print(all(['a','123']))   ##True
print(all([0,123]))       ##False

##any()：元素中有一个为真，则整体为真；元素必须是可迭代对象
print(any([0,True,'',123]))   ##True


#最重要的4个内置函数
##zip()：可接受多个可迭代对象，以元素最少的为基准，返回一个新迭代器，该迭代器中的元素，是传入的每个可迭代对象元素的结合
L1 = [1,2,3]
L2 = ['a','b','c']
print(zip(L1,L2))    ##打印是一个迭代器地址；
for i in zip(L1,L2):
    print(i)
##返回结果为：
# (1, 'a')
# (2, 'b')
# (3, 'c')


##filter()：用于筛选元素；
def is_odd(x):
    return x % 2 == 1
'''等价于'''
# def is_odd(x):
#     if x % 2 == 1:
#         return True

ret = filter(is_odd,[1,4,6,7,8,9,12,17])   ##将函数作用于后面的可迭代对象的每个元素
print(ret)    ##打印出来是一个可迭代对象
for i in ret:
    print(i)
##返回结果为：
# 1
# 7
# 9
# 17


##map()：用于生成新的可迭代对象
ret = map(abs,[1,-4,6,-8])
print(ret)
for i in ret:
    print(i)

##map()与filter()的区别
#filter()：执行了filter之后的结果集合 <= 执行之前的个数；filter只管筛选，不会改变原来的值。
#map()：执行前后元素个数不变，值可能发生变化；


##sorted()：用于排序，生成一个新的列表，不改变原列表
l = [1,-4,6,5,-10]
print(sorted(l,reverse=True))        ##慎用，因为sorted直接返回整个列表，占用内存

##sort()：在原列表的基础上进行排序
l = [1,-4,6,5,-10]
l.sort(key = abs)  ##表示根据绝对值来排序
print(l)     ##结果为：[1, -4, 5, 6, -10]


##练习题目：已知一个列表，根据元素的长度进行排序
L = ['   ',13,[1,2],'python','hello world']
def func(x):
    return len(str(x))
new_l = sorted(L,key=func)
print(new_l)
