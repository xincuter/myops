#字典的增删改查

#增 【两种方法】
a = {'name':'hzzx'}

##第一种方法：直接赋值
a['age'] = 22   ##存在就覆盖，不存在就添加
print(a)

##第二种方法：setdefault()
a.setdefault('friend','zx')  ##key存在则返回key对应的值，不存在就添加，并设置默认值
print(a)


#删除 【四种方法】
##第一种：pop(),按照key删除，有返回值；
a = {'name': 'zx', 'age': '22', 'friend': 'zxx'}
a.pop('name')

##第二种：clear()，清空字典；
a = {'name': 'zx', 'age': '22', 'friend': 'zxx'}
a.clear()  ##清空整个字典

##第三种：del，删除元素或者删除整个字典
a = {'name': 'zx', 'age': '22', 'friend': 'zxx'}
del a['name'] ##删除key为name的元素
del a   ##删除整个字典

##第四种：popitem()随机删除；以元组形式返回删除的键值对元素
a = {'name': 'zx', 'age': '22', 'friend': 'zxx'}
a.popitem()   ##随机删除，并以元组形式返回删除的键值对元素


#改 【两种方法】
##第一种方法：直接修改
##第二种方法：update(),将一个字典的元素添加到另一个字典的元素；
a = {'name': 'zx', 'age': '22', 'friend': 'zxx'}
d = {'wc':20}
a.update(d)



#查
a = {'name': 'zx', 'age': '22', 'friend': 'zxx'}
print(a.keys())  ##打印所有key
print(a.values()) ##打印所有value
print(a.items()) ##打印所有键值对，

##且以上三个都是可迭代对象
for k,v in a.items():
    print(k,v)


##获取字典中的键的值，存在就返回key的值，没有默认会返回None,可以设置返回的错误信息，
info = a.get('nam','Error: key is not exist...')
print(info)
