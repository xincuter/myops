##编码：
# ascii：字母、数字、特殊字符；1个字节，8位
# unicode：16位，两个字节，升级 32位，四个字节；
# utf-8：unicode的升级版，
#     一个英文用8位（1个字节表示），
#     欧洲16位（2个字节），
#     中文24位（3个字节）
# gbk：英文一个字节，中文2个字节；


A = 7
print(A.bit_length())

s = 'alexab'
s1 = s[0:-1]   ##取除最后一个字符的所有字符，-1代表最后一个字符，顾头不顾尾
s2 = s[2::2]
print(s1)
print(s2)


##字符串内置方法
# s.capitalize() ##首字母大写
# s.upper() ##全大写
# s.lower() ##全小写
# s.find() ##通过元素找索引，找不到返回-1
# s.index() ##通过元素找索引，找不到报错
# s.swapcase() ##大小写翻转
# s.len() ##长度
# replace(old,new,count) ##替换
# isdigit() ##返回bool值
# startswith endswith
# count() ##计数
# title() ##首字母大写
# strip() ##默认删除前后的空格
# lstrip()##默认删除左边的空格
# rstrip() ##默认删除右边的空格
# split() ##分隔符
# format() ##格式化输出
#     {} {} {} ##按顺序
#     {index1} {index2} {index3} ##安索引
#     {key_name1} {key_name2} {key_name3} ##按键名


##for循环
for i in range(10):
    print(i)

##python2在编译安装的时候，可以通过参数--enable-unicode=ucs2 或
# --enable-unicode=ucs4分别用于指定使用2个字节、4个字节表示一个unicode
# 字符；python3无法进行选择，if 默认使用ucs4:
#
# 查看当前python中表示unicode字符串时占用的空间：
#     import sys
#     print(sys.maxunicode)
#     #如果值是65535，则表示使用ucs2标准，即2个字节表示；
#     #如果值是1114111，则表示使用ucs4标准，即4个字节表示；


##任意输入一段文本，统计数字的个数
s = input('请输入文本: ')
count = 0
for i in s:
    if i.isdigit():
        count += 1
print("文本中含有数字个数: %d" %count)