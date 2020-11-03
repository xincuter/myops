##修改文件
##文件不能被修改，只能读取添加到另外一个文件中
with open('a.txt',encoding='utf-8') as f,open('a.txt.bak',mode='w',encoding='utf-8') as f1:
    for line in f:          ##遍历读取文件对象的每一行
        if '星儿' in line:
           line = line.replace('星儿','阿娇')  ##替换
        ##写文件
        f1.write(line)


##删除文件 和 重命名文件
import os
os.remove('a.txt')   ##删除文件
os.rename('a.txt.bak','a.txt')  ##重命名文件