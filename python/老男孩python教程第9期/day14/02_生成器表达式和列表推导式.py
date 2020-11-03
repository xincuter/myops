##列表表达式，列表解析
a = [1,2,3,4]
##根据已有的列表a，得到b = [1,4,9,16]
b = [i * i for i in a]
print(b)

##生成器表达式
g = (i * i for i in range(10))
print(g)
for i in g:
    print(i)


##生成器表达式与列表表达式区别：
    #括号不一样
    #返回的值不一样，生成器表达式几乎不占用内存