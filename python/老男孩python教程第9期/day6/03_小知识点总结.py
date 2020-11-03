##总结
'''
（1）python2与python3的区别
python2：
    print "abc"  或  python("abc")  【可加括号可不加】
    range()    xrange() [生成器]
    raw_input()

python3:
    print("abc")    【必须加括号】
    range()    【python3中只有range()】
    input()

（2）= 赋值
    == 比较值是否相等
    is 比较，比较的是内存地址

    ##赋值运算：
    ##数字，字符串：存在小数据池
        数字范围：-5 - 200
        字符串范围：不包含特殊字符，同一个字符不能超过20次，则公用一个数据池；
    ###除了数字，列表，元组，字典，tuple，set没有小数据池的概念

    ###1
    l1 = 6
    l2 = 6
    print(id(l1),id(l2))    ##指向的对象一样，内存地址一致

    l1 = 300
    l2 = 300
    print(id(l1),id(l2))  ##内存地址不一样，指向对象不同

    ###2
    a = 'hzzxin'
    b = 'hzzxin'
    print(id(a),id(b))  ##内存地址一致

    a = 'hzzxin@'
    b = 'hzzxin@'
    print(id(a),id(b))  ##内存地址不一致

    ###3
    l1 = [1,2,3]
    l2 = [1,2,3]
    l3 = l1
    print(id(l1),id(l2))  ##内存地址不一致
    print(id(l1),id(l3))  ##内存地址一致


（3）编码
python2与python3通用：
ascii:
    英文：8位 一个字节

unicode:
    中文：32位，四个字节

uft-8:
    英文：8位，1个字节
    中文：24位，3个字节

gbk:
    英文：8位，一个字节
    中文：16位，两个字节

1、各个编码的之间的二进制，是不能互相识别的，会产生乱码
2、文件的传输不能是unicode，只能是utf-8、utf-16、gbk、gb2312、ascii等

python3：
    str在内存中使用unicode存储的，所以需要转换编码格式
        bytes类型
        对于英文：
            str：表现形式：s = 'alex'
                 编码方式：010101001 unicode

            bytes：表现形式：s = b'alex'
                   编码格式：01011100 uff-8,gbk

        对于中文：
            str：表现形式：s = ''
                 编码方式：010101001 unicode

            bytes：表现形式：s = b'x\e91\e91\e01\e21\e31\e32'
                   编码格式：01011100 uff-8,gbk

        例子：
        s = '中国'
        print(s,type(s))
        s1 = b'中国'
        print(s1,type(s1))

        ##encode编码：表现形式是将str ---> bytes，内部实际是将unicode转换成utf-8
        s1 = 'alex'
        s11 = s1.encode('utf-8')
        print(s11)

        s2 = '中文'
        s22 = s2.encode('utf-8')  ##中文一个字用3个字节
        print(s22)
'''

