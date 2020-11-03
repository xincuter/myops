#[ 每一个元素或者是和元素相关的操作  for 元素 in 可迭代数据类型 ]    ##遍历之后挨个处理
#[ 满足条件的元素相关的操作 for 元素 in 可迭代数据类型 if 元素相关的条件 ]  ##筛选功能

###列表推导式练习
##30以内所有能被3整除的数
# ret = [ x for x in range(30) if x % 3 == 0]  ##完整的列表推导式
# print(ret)

##30以内所有能被3整除的数的平方
# ret2 = [ x * x for x in range(30) if x % 3 == 0]  ##完整的列表推导式
# print(ret2)

##练习题：已知名称列表names，找出名字中含有两个e的名字元素
# names = [['Tom','Billy','Jefferson','Andrew','Wesley','Steven','Joe'],
#          ['Alice','Jill','Ana','Wendy','Jennifer','Sherry','Eva']]
# ret = [name for lst in names for name in lst if name.count('e') == 2]
# print(ret)



###字典推导式
# 例子1： 将一个字典的key和value对调
# mcase = {'a':10 , 'b':34}
# ##{10:'a' , 34:'b'}
# mcase_frequency = {mcase[k]: k for k in mcase}   ##字典推导式
# print(mcase_frequency)

# 例子2：合并大小写对应的value值，将k统一成小写
mcase = {'a':10 , 'b':34 , 'A':7 , 'Z':3}
##{'a':10+7 , 'b':34 , 'z':3}
mcase_frequency = {k.lower():mcase.get(k.lower(),0) + mcase.get(k.upper(),0) for k in mcase.keys()}
print(mcase_frequency)

###集合推导式 [自带去重功能]
squared = {x**2 for x in [1,-1,2]}
print(squared)     ##结果为：{1,4}