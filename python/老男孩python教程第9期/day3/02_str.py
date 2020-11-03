##字符串操作
#（1）首字母大写、全大写、全小写
str1 = "hzzxin"
str2 = str1.capitalize()  ##首字母大写
print(str2)

s3 = str1.upper()  ##全大写
s4 = str1.lower()  ##全小写
print(s3,s4)

#（2）大小写翻转
s = "HzXin"
s1 = s.swapcase() ##大小写翻转
print(s1)

#（3）返回title【每个隔开（带特殊字符或空格）的单词首字母大写】
s = "this is my site"
s1 = s.title()   #返回title
print(s1)

#（4）居中，空白填充
s = "hzzxin@123"
s1 = s.center(20,'#')   ##【20表示文本总长度，#表示空白填充，然后文本居中】
print(s1)

#（5）公共方法（字符串、元组、列表、字典）
##字符串长度
s = "hzxin"
l = len(s)
print(l)

##以什么开头
s = "hzzxin"
s1 = s.startswith('hz',0,5)  ##表示以从索引0到索引5结束字符为整体，该整体是否以'hz'开头
print(s1)   ##True,返回布尔值

##以什么结尾
s = "hzzxin"
s1 = s.endswith('hz')  ##是否以'hz'结尾
print(s1)

#通过元素找下标（索引），找不到返回-1
s = "alexWWuser"
s1 = s.find('W')
print(s1,type(s1))

#通过元素找下标（索引），找不到返回错误
s = "alexWWuser"
s1 = s.index('W')
print(s1,type(s1))


#默认去除字符串前后的空格，也可以指定要去除的字符
s = "   hzzxin   "
a = " %a%hzxin%%"
a1 = a.strip(' %*')
s1 = s.strip()
print(s1)
print(a1)

##rstrip/lstrip: 从右边或左边删


#统计字符出现次数
a = "hzzzxin"
a1 = a.count('z')
print(a1)

#分隔文本(默认以空格作为分隔符，可以指定分隔符),将字符串转换成列表
a = "alex wusir; taibai"
a1 = a.split()
a2 = a.split(';')
print(a1)
print(a2)


#格式化输出（format）
#format的三种玩法：
##第一种按照顺序依次填入，格式化输出
res1 = '{} {} {}'.format('egon',18,'male')
##第二种按照索引位置依次填入，格式化输出
res2 = '{1} {0} {1}'.format('egon',18,'male')
##第三种按照k-v形式对应，格式化输出
res3 = '{name} {age} {sex}'.format(sex='male',name='egon',age=18)

print(res1)
print(res2)
print(res3)


#替换
a = "this is my site"
a1 = a.replace('is','IS') ##默认全部替换
a2 = a.replace('is','IS',1) ##1表示替换几个
print(a1)
print(a2)


##字符串索引与切片
#索引
s = 'abcdef'
s1 = s[0] #'a'
s2 = s[2] #'c'
print(s1,s2)

#取倒数的元素
s3 = s[-2] #取倒数第二个元素
print(s3)


#切片【取abcd】,截取书写格式：[起始索引位置:结尾索引位置:步长]（注：不包含结尾的索引元素）
s4 = s[0:4] #顾头不顾尾，不包含索引位置4的元素
print(s4)

s5 = s[0:] #取所有元素
print(s5)

s6 = s[0:5:2]
print(s6)

s7 = s[4:0:-1]
print(s7)  ##edcb

s8 = s[3::-1] #dcba
print(s8)

s9 = s[-1::-1]  ##倒着打印所有元素
print(s9)