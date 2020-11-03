##while else语句
'''
当while循环没有被break打断，则会执行else语句
'''

count =  0
while count <= 5:
    count += 1
    if count == 3:
        pass                ##使用break，else语句不会执行
    print("Loop",count)

else:
    print("循环正常执行完毕")
print("--------end--------")
