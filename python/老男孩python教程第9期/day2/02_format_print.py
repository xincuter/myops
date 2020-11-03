##格式化输出 [%、d、s]
'''
%: 占位符;
d：表示替换的数字类型；
s：表示替换的字符串类型；
%%：输出单纯的%;
'''
name = input('请输入姓名: ')
age = input('请输入年龄: ')
job = input('请输入工作: ')
hobbie = input('你的爱好: ')

msg = '''
------------- info of %s ---------------
Name    : %s 
Age     : %d
Job     : %s
Hobbie  : %s
------------- end ---------------
''' %(name,name,int(age),job,hobbie)

print(msg)