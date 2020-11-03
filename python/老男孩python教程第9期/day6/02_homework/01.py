'''
题目：元素分类
有如下值li = [11,22,33,44,55,66,77,88,99,90],将所有大于66的值保存到字典第一个key中，所有小于66的保存到
第2个key中，等于66的保存到第3个key中；
即：{'k1':大于66的所有值列表,'k2':小于66的所有值列表,'k3':等于66列表}
'''

li = [11,22,33,44,55,66,77,88,99,90]
k1_list = []
k2_list = []
k3_list = []

for i in li:
    if i > 66:
        k1_list.append(i)
    elif i < 66:
        k2_list.append(i)
    else:
        k3_list.append(i)

d = {'k1':k1_list,'k2':k2_list,'k3':k3_list}
print(d)