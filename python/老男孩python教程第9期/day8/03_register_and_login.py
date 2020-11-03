##习题：实现注册，登录验证，三次提示错误【账号密码从文件中读取】
##（1）老男孩alex程序源码（简洁版）
# username = input('请输入你要注册的用户名：')
# password = input('请输入你要注册的密码：')
# with open('list_of_info',mode='w',encoding='utf-8') as f:
#     f.write('{}\n{}'.format(username,password))   ##格式化写入，将账号和密码分两行写入文件
# print('恭喜您，注册成功')
# lis = []
# i = 0
# while i < 3:
#     usn = input('请输入你的用户名：')
#     pwd = input('请输入你的密码：')
#     with open('list_of_info',mode='r+',encoding='utf-8') as f1:
#         for line in f1:
#             lis.append(line)
#     if usn == lis[0].strip() and pwd == lis[1].strip():
#         print('登录成功')
#         break
#     else:print('账号和密码错误')
#     i+=1

##（3）自己的代码逻辑
##注册
def register():
    with open('account.txt', mode="r+", encoding='utf-8') as user_obj:
        s = user_obj.readlines()
        print(s)

        username = input('请输入你的账号: ')
        password = input('请输入你的密码: ')

        for i in s:
            if username == i.strip():
                print('用户名已注册，请重新输入!')
                exit(0)
            else:
                continue

        user_obj.write("{}\n".format(username))
        print('注册成功')



    # with open('account.txt',mode="w+",encoding='utf-8') as user_obj:
    #     user_obj.write('{}\n{}\n'.format(username, password))
    #
    # print('恭喜你，注册成功')

register()

##登录
# def login():
#     usn = input('请输入你的账号: ')
#     passwd = input('请输入你的密码: ')

