#3、用map处理字符串列表，把列表中所有人都变成sb，比方alex_sb
'''第一种方法'''
# name = ['alex','wupeiqi','yuanhao','nezha']
# def func(item):
#     return item+'_sb'
# ret = map(func,name)  ##ret是迭代器
# print(list(ret))

'''第二种方法(匿名函数)'''
# name = ['alex','wupeiqi','yuanhao','nezha']
# ret = map(lambda x:x+"_sb",name)
# print(list(ret))


#4、 用filter函数处理数字列表，将列表中的偶数筛选出来
# num = [1,3,5,6,7,8]
# odd_list = filter(lambda x:x % 2 == 0,num)  ##odd_list是一个迭代器
# odd_list2 = filter(lambda x:True if x % 2 ==0 else False,num)  ##lambda函数还可以写简单的条件表达式
# print(list(odd_list2))
# print(list(odd_list))

#5、随意写一个20行以上的文件
#运行程序，先将内容读取到内存中，用列表存储；
#接收用户输入页码，每页5个，仅输出当页的内容
# with open('1.txt',encoding='utf-8') as f:
#     l = f.readlines()
# page_num = int(input('please input your choice: '))
# pages,mod = divmod(len(l),5)  ##求有多少页，有没有剩余的行
# if mod:
#     pages += 1          ##一共多少页
# if page_num > pages or pages_num <= 0:  ##用户输入的页数大于总数或者小于等于0
#     print('Sorry,input error!!!')
# elif page_num == pages and mod != 0:   ##用户输入的页码是最后一页，且之前有过剩余行数
#     for i in range(mod):
#         print(l[(page_num-1)*5 +i].strip())   ##只输出这一页剩余的行数
# else:
#     for i in range(5):
#         print(l[(page_num-1)*5 +i].strip())   ##正常输出5行


#6、如下，每个小字典name对应的股票的名字，shares对应多少股，price对应股票的价格；
portfolio = [
    {'name':'IBM','shares':100,'price':91.1},
    {'name':'AAPL','shares':50,'price':543.22},
    {'name':'FB','shares':200,'price':21.09},
    {'name':'HPQ','shares':35,'price':31.75},
    {'name':'YHOO','shares':45,'price':16.35},
    {'name':'ACME','shares':75,'price':115.65}
]

##计算每只股票的总价格
# ret = map(lambda dic : {dic['name']:dic['shares'] * dic['price']},portfolio)
# print(list(ret))

##用filter过滤出，单价大于100的股票有哪些？
# ret1 = filter(lambda x : x['price'] > 100,portfolio)
# print(list(ret1))