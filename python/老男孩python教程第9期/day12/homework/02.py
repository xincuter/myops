'''
作业2：编写装饰器，为多个函数加上记录调用功能，要求每次调用函数都将被调用
函数名称写入文件；
'''
def log(func):
    def inner(*args,**kwargs):
        with open('log','a',encoding='utf-8') as f:
            f.write(func.__name__ + "\n")
        ret = func(*args,**kwargs)
        return ret
    return inner

@log
def shopping_list():
    print("list ...")

@log
def shopping_add():
    print("add ...")

@log
def shopping_del():
    print("del ...")

shopping_list()
shopping_list()
shopping_add()