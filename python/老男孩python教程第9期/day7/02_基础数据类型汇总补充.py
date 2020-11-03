'''基础数据类型汇总补充'''

##str
##int

'''
list:
'''
lis = [1,2,3,4,5]
for i in lis:
    if i % 2 != 0:
        lis.remove(i)

print(lis)



##0,'',[],(),{},set(),None转换成bool值都是False
a = None
print(bool(a))

##元组
##如果元组中只有一个元素,且不加逗号，则此元素是什么类型，就是什么类型。
tu1 = (1)   ##这是int类型
tu2 = (1,)  ##这是元组类型
print(tu1,type(tu1))
print(tu2,type(tu2))


