#字典：以键值对作为元素,无序；
##例子
dict_1 = {
    'name':['alex','hz','wf'],
    'py9':{
        'time':'1213',
        'learn_money':19800,
        'addr':'CBD',
    },
    'age':21
}

##添加元素py9中添加键值对female = 6
dict_1['py9']['female'] = 6
print(dict_1)


##题目：任意输入一段文本，计算数字的个数
info = input('please input content: ')
for i in info:
    if not i.isdigit():    ##isdigit()判断是否是数字
        info = info.replace(i,"")   ##不是数字全部替换成空白，这样info中就只有数字了

print(len(info))
