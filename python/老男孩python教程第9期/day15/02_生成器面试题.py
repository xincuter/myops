##题目1    【生成器中的元素只能取一次】
# def demo():
#     for i in range(4):
#         yield i
#
# g = demo()
#
# g1 = (i for i in g)
# g2 = (i for i in g1)
#
# print(list(g1))   ##结果为 [0,1,2,3]
# print(list(g2))   ##结果为 []    【因为生成器只能取一次，上面的表达式已经将g1的值悉数取出，所以g2获取不到值了】


##题目2   【生成器表达式和生成器函数一样，只有在调用时才会执行】
def add(n,i):
    return n + i

def test():
    for i in range(4):
        yield i

g = test()
# for n in [1,10]:
#     g = (add(n,i) for i in g)
'''等价于'''
n = 1
g = (add(n,i) for i in g)
##等价于g = (add(n,i) for i in test())
n = 10
g = (add(n,i) for i in g)
##等价于g = (add(n,i) for i in (add(n,i) for i in test()))


print(list(g))     ##结果为：[20,21,22,23]