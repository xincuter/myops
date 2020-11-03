#复习
#开发原则：开放封闭原则
#装饰器的的作用：在不改变原函数的调用方式的情况下，在函数的前后添加功能；
#装饰器的本质：闭包函数

def wrapper(func):
    def inner(*args,**kwargs):   ##inner((7,)),接收的是一个元组
        print('在被装饰的函数执行之前做的事')
        ret = func(*args,**kwargs)    ##holiday(*(3,),**{})，调用会打散元组
        print('在被装饰的函数执行之后做的事')
        return ret
    return inner

@wrapper  #等价于 holiday = wrapper(holiday)
def holiday(day):
    print("全体放假%s天" %day)
    return "好开心"

a = holiday(7)    ##相当于inner(7)
print(a)

'''
详解：
（1）未使用装饰器函数，函数执行过程：
        传参数
   我 <---------> 函数
        返回值
        
（2）使用装饰器函数，函数执行过程：
        传参数
   我  <---------> 装饰器 <---------> 函数
                          返回值
'''