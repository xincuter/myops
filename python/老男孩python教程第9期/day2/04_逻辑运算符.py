##and、or、not
#优先级：() > not > and > or

#print(2 > 1 and 1 < 4 or 2 < 3 and 9 > 6 or 2 < 4 and 3 < 2)

"""
运算逻辑说明：
##计算顺序：先算and，再算or
[ 2 > 1 and 1 < 4 ] or [ 2 < 3 and 9 > 6 ] or [ 2 < 4 and 3 < 2 ]
#T or T or F
结果为：True
"""

##练习：
'''
print(3 > 4 or 4 < 3 and 1 == 1) #F
print(1 < 2 and 3 < 4 or 1 < 2) #T
print(1 > 2 and 3 < 4 or 4 > 5 and 2 > 1 or 9 < 8) #F
print(1 > 1 and 3 < 4 or 4 > 5 and 2 > 1 and 9 > 8 or 7 < 6) #F
print(not 2 > 1 and 3 < 4 or 4 > 5 and 2 > 1 and 9 > 8 or 7 < 6) #F
'''

##x or y : x为非零，则返回x
##非零转换成bool，值为True，0装换成bool，值为False

##例如：int ---> bool
print(bool(2))   #T
print(bool(-2))  #T
print(bool(0))   #F

##bool ---> int
print(int(True)) #1
print(int(False)) #0

###x or y,x为True，则返回x；反之，返回y
print(1 or 2)  #1
print(3 or 2)  #3
print(0 or 2)  #2
print(0 or 100) #100
print(0 or 0) #0

###x and y,x为True，则返回y；反之，返回x
print(1 and 2) #2
print(0 and 2) #0
print(0 and 0) #0

#综合题
print(0 or 4 and 3 or 2) #3
print(1 > 2 or 3) #3
print(1 > 2 and 3) #F
print(2 > 1 or 5) #T
print(1 > 2 and 3 or 4 and 3 < 2)#F
print(3 or 2 > 1) #3     [x or y,x为true，则返回x，所以结果为：3]
print(3 > 1 and 0) #0
print(3 > 1 and 2) #2
print(3 > 1 and 2 or 2 < 3 and 3 and 4 or 3 < 2) #2
print(1 < 2 or 2 == 2 and not 2 > 3 and 3 < 6 or 3 and 5 or 7 > 6 and 6 < 1)  #T


