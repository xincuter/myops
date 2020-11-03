##监听文件输入的例子

##第一种方法：不使用生成器
# def tail(filename):
#     f = open(filename,encoding='utf-8')
#     while True:
#         line = f.readline()
#         if line:
#             print(line.strip())
#
# tail('test1')

##第二种方法：使用生成器
def tail2(filename):
    f = open(filename,encoding='utf-8')
    while True:
        line = f.readline()
        if line.strip():
            yield line.strip()

g = tail2('test1')
for i in g:
    print(i)