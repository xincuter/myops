##集合：可变的数据类型，但集合中的元素必须是不可变的数据类型，无序，不重复；

##语法格式：  {}表示；
s1 = set({1,2,3})
s2 ={1,2,3,'2e43e'}
print(s1,type(s1))
print(s2,type(s2))


##集合常用操作方法：
#增: 两种方法
##(1)add
s1 = {'alex','wusir','ritian','egon','barry','barry'}
s1.add('女神')
print(s1)

##(2)update
s1.update('abc')
print(s1)


#删除：【三种方法】
##pop()：随机删除
#s1.pop()  ##随机删除

##remove()：删除指定元素；
s1.remove('alex')
print(s1)

##clear()：清空集合
s1.clear()
print(s1)


#查：只能用for循环去查询打印


##集合的交集、并集、差集
set1 = {1,2,3,4}
set2 = {2,3,5,6,7}

#交集
set3 = set1 & set2
##或者
set3 = set1.intersection(set2)
print(set3)   ##{2,3}

#并集
set4 = set1 | set2
#或者
set4 = set1.union(set2)
print(set4)      ##{1, 2, 3, 4, 5, 6, 7}


#反交集：除了共有的剩下的
set5 = set1 ^ set2
#或者
set5 = set1.symmetric_difference(set2)

#差集
set6 = set1 - set2  ##set1与set2的差集，即set1独有的
#或者
set6 = set1.difference(set2)
print(set6)

#子集
set1 = {1,2,3}
set2 = {1,2,3,4,6,5}
##set2全部包含set1的元素，即set1 < set2,则set1是set2的子集
print(set1 < set2)
print(set1.issubset(set2))   ##这两个相同，set1是set2的子集

##set2全部包含set1的元素，即set2 > set1,则set2是set1的超集
print(set2 > set1)
print(set2.issuperset(set1)) ##这两个相同，set2是set1的超集



##面试题：已知li = [1,2,33,33,2,1,4,5,6,6]，请去重；
li = [1,2,33,33,2,1,4,5,6,6]
set1 = set(li)
li = list(set1)
print(li)


##不可变集合（frozenset）
s = frozenset('barry')
print(s,type(s))