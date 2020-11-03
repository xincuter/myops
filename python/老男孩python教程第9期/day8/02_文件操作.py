#  #创建文件对象(也叫文件句柄 )，打开文件
# # [打开文件固定格式: open('文件路径',mode='操作模式',encoding='utf-8')]
# f = open('C:/Users/zx/Desktop/测试文件.txt',mode='r',encoding='utf-8')
#
# ##读文件
# content = f.read()
# print(content)
#
# ##关闭文件[避免文件一直占用内存]
# f.close()


##采用rb方式读取文件
# f = open('测试文件',mode='rb') #[相对路径：会在当前目录路径下寻找文件]
# content = f.read()
# print(content)
# f.close()


##w: 写文件；
# 如果文件不存在会创建文件
# f = open('log',mode='w',encoding='utf-8')
# f.write('今天天气真好！')
# f.close()

#如果文件存在，会先清空源文件，再写
# f = open('log',mode='w',encoding='utf-8')
# f.write('今天工作安排如下：\n1.读书\n2.写字')
# f.close()


##wb：以bytes类型写文件
# f = open('log',mode='wb')    ##mode='wb'表示以bytes类型写文件
# f.write('今天工作安排如下：'.encode('utf-8'))   ##写入内容时str类型，需要使用encode('utf-8')转换成utf-8编码
# f.close()



##追加
#a
# f = open('log',mode='a',encoding='utf-8')
# f.write('新')
# f.close()


#ab
# f = open('log',mode='ab')
# f.write('新'.encode('utf-8'))
# f.close()


#读写（r+）
##(1)读写模式，先读后写，文本光标位于文档结尾，则是在后面添加内容
# f = open('log',mode='r+',encoding='utf-8')
# print(f.read())
# f.write('111')
# f.close()


##（2）写读模式，先写后读，文本光标位于文档开头，会占位，写多少占多少位，然后独处后面的内容
# f = open('log',mode='r+',encoding='utf-8')
# f.write('2222444')
# print(f.read())
# f.close()


##(3)r+b: 以字节流形式读写
# f = open('log',mode='r+b')
# print(f.read())
# f.write('电脑'.encode('utf-8'))
# f.close()



#写读（w+）
##（1）写读，先清除原来内容，在写入新内容
# f = open('log',mode='w+',encoding='utf-8')
# f.write('2222444')
# print(f.read())           #读出来为空，因为光标已经移动到文本开始读，后面无内容所以返回为空；
# f.close()



##移动文本光标
# f = open('log',mode='r+',encoding='utf-8')
# ##conent = f.read(3) ##读出来都是字符
# f.seek(0)  ##表示将光标移动到文本开头，这样就可以读到所有内容了 【按照字节定光标位置，如果是中文，一个中文是三个字节，所以必须是3的倍数才行】
# point = f.tell()   ##记录当前光标所在位置
# print(point)
# print(f.read())
# f.close()


##文件对象常用操作
#f = open('log',mode='r+',encoding='utf-8')
# f.tell()   ##记录光标位置
# f.seek(3)  ##按照字节定光标位置

#f.readline() 读一行
# print(f.readline())  ##读一行
# count = f.tell()    ##记录第一行读完的位置
# print(count)
# print(f.readline(count,))   ##从结束位置开始读，只会读取一行，所以就会读取第二行的内容

# f.readable()  ##是否可读
# f.readlines() ##每一行当成列表中的一个元素，添加到list中
# f.truncate(4) ##截取4个字符



##生产常用读取文件方法：
##语法：with + 文件句柄1 as + 文件句柄1的名称,+ 文件句柄2 as + 文件句柄2的名称 ......   【可以打开多个文件句柄】
# with open('log',mode='r+',encoding='utf-8') as file_obj:   ##读取完文件后自动会关闭文件
#     print(file_obj.read())



##习题：注册，登录验证，三次提示错误【账号密码从文件中读取】

