##第一种，简单函数方法
# def tail(filename):
#     f = open(filename,encoding='utf-8')
#     while True:
#         line = f.readline()
#         if line:
#             print('++++',line.strip())
#
# tail('1')


##第二种，使用生成器函数方法  【实时监听文件输入】
def tail(filename):
    f = open(filename,encoding='utf-8')
    while True:
        # f.seek(0,2)    ##0表示从行的开头开始读，2表示每次都从文件末尾开始
        line = f.readline()
        if line.strip():
            yield line.strip()

g = tail('1')
for i in g:
    print('++++',i)