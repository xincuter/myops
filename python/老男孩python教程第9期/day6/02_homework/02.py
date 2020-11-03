'''题目：输出商品列表，用户输入序号，显示用户选中的商品
    商品 li = ["手机","电脑","鼠标垫","游艇"]
要求：
    1、页面显示序号 + 商品名称，如：
        [1] 手机
        [2]电脑
        ...
    2、用户输入选择的商品序号，然后打印商品名称；
    3、如果用户输入的序号有误，则提示输入有误，并重新输入。
    4、用户输入q或Q，退出程序。
'''

#程序如下:  【两种方法】
##第一种方法：自己的想法
# import time
#
# li = ["手机","电脑","鼠标垫","游艇"]
#
# ##打印商品列表
# def print_msg():
#     global dic;dic = {}    ##声明dic为全局变量，以便在全局复用
#     print("本店商品如下: ")
#     for i in li:
#         dic_key = str(li.index(i)+1)
#         dic[dic_key] = i
#         print("{}\t{}".format([li.index(i)+1],i))   ##使用format格式化输出商品信息
#
# ##用户操作
# def user_operator():
#     ##打印商品信息
#     print_msg()
#     ##暂停3s
#     time.sleep(3)
#
#     while 1:
#         ##用户输入判断
#         choice = input("请输入商品序号: ")
#         if choice in dic.keys():
#             print("你的选择是: ",dic.get(choice))
#             break
#         elif choice == "Q" or choice == "q":
#             print("退出...")
#             break
#         else:
#             print("输入无效商品序号，请重新输入...")
#             continue
#
#
# #main
# if __name__ == "__main__":
#     user_operator()



##第二种方法：老男孩alex的思路
flag = True
while flag:
    li = ["手机", "电脑", "鼠标垫", "游艇"]
    for i in li:
        print('{}\t\t{}'.format(li.index(i)+1,i))
    num_of_chioce = input('请输入选择的商品序号/输入Q或者q退出程序：')
    if num_of_chioce.isdigit():
        num_of_chioce = int(num_of_chioce)
        if num_of_chioce > 0 and num_of_chioce <= len(li):
            print(li[num_of_chioce-1])
        else:print('请输入有效数字')
    elif num_of_chioce.upper() == 'Q':break
    else:print('请输入数字')