#列表：python基础数据类型之一，有序，有索引，能切片；
li = ['alex','wusir','egon','女神','taibai']
##索引
l1 = li[0] ##取出'alex'
print(l1)

##切片
l2 = li[0:3] ##取前三个元素
print(l2)


##列表增删改查
#增加 【三种方法】
##第一种：append(object) 【增加到列表末尾】
li.append('hzxin')
print(li)

##第二种：insert(index,object)  【增加元素到指定索引位置】
li.insert(4,'hz')
print(li)

##第三种：extend(iterable_object) 【元素必须是可迭代的对象，且会把可迭代对象的每个元素都添加】
a = [1,2,3]
b = 'hzzx'
a.extend(b)
print(a)

#删除[四种方法]
##第一种：pop(index): 按照索引删除,并返回删除的元素，索引位置不加默认删除最后一个元素
a = [1,2,3]
print(a.pop(1))  ##删除2，索引位置不加默认删除最后一个元素
print(a)

##第二种：remove(value)：按元素去删除，没有返回值；
a = [1,2,3,'hz']
a.remove('hz')
print(a)

##第三种：clear()：清空列表；
a = [1,2,3,'hz']
a.clear()
print(a)

##第四种：del：切片删除，顾头不顾尾；
a = [1,2,3,'hz']
del a[2:3]
print(a)

##改
a = [1,2,3,'hz']
a[0] = "wb"  #单个元素修改
a[1:3] = "234" ##切片迭代修改，在原列表索引1 - 索引2之间迭代添加，有多少添加多少。
print(a)

##查
a = [1,2,3]
for i in a:
    print(i)
print(a[0:2])



##列表公共方法
##大部分与字符串相同

##排序
##正向排序
a = [3,2,1,2]
a.sort()
print(a)

##倒序排序
a = [3,2,1,2]
a.sort(reverse=True)
print(a)

##翻转
a = [3,2,1,2]
a.reverse()
print(a)



##列表的嵌套
a = ['taibai','武藤兰','hz',['alex','wb',66],23]
print(a[1][0]) ##打印'武'