'''
作业1：编写装饰器，为多个函数添加认证功能（用户的账号密码来源与文件，
要求登录成功一次，后续的函数都无需在输入用户名和密码；
'''
FLAG = False
def login(func):
    def inner(*args,**kwargs):
        global FLAG
        '''登录程序'''
        if FLAG:
            ret = func(*args,**kwargs)
            return ret
        else:
            username = input('username: ')
            password = input('password: ')
            if username == 'boss_gold' and password == '22222':
                FLAG = True
                ret = func(*args,**kwargs)
                return ret
            else:
                print("登录失败")
    return inner

@login
def shopping_list():
    print("list ...")

@login
def shopping_add():
    print("add ...")

@login
def shopping_del():
    print("del ...")

shopping_add()
shopping_list()