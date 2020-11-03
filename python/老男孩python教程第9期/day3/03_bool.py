##int ---> bool;[只要是0就为False，非零就是True]
a = 123
b = bool(a)
print(b)

##bool ---> int;[True --> 1,Flase ---> 0]
a = True
b = False
print(int(a))
print(int(b))

##while死循环【两种写法】
#（1）while True:
#（2）while 1:    【效率比while True高】


#str ---> bool;[空字符串转成bool类型为False，非空字符串为True]
s = ""
s1 = "0"
print(bool(s)) #False
print(bool(s1)) #True



