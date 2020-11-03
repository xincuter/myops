#1、处理文件，用户指定要查找的文件和内容，将文件中包含要查找的内容的每一行都输出到屏幕上；
def check_file(filename,content):
    with open(filename,encoding='utf-8') as f:   #句柄：handler，文件操作符，文件句柄
        for i in f:
            if content in i:
                yield i

g = check_file('1.txt','python')
for i in g:
    print(i.strip())


#2、写生成器，从文件中读取内容，在每一次读取到的内容之前加上'***'之后在返回给用户；
def check_file(filename):
    with open(filename,encoding='utf-8') as f:   #句柄：handler，文件操作符，文件句柄
        for i in f:
            yield '***' + i

g = check_file('1.txt')
for i in g:
    print(i.strip())