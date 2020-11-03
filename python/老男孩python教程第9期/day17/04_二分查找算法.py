#什么叫算法
#计算的方法

##我们学习的算法，都是过去时
##了解基础的算法，才能创造出更好的算法
##不是所有的事情都能套用现成的方法解决的；
##有些时候会用到学过的算法只是来解决新的问题

#二分查找算法，必须处理有序的列表
#已知列表：l=[2,3,5,10,15,16,18,22,26,30,32,35,40,41,42,43,55,56,57,66,67,69,72,76,82,83,88]
#请找出66的位置

##代码实现
'''第一种方法：'''
#l=[3,3,5,10,15,16,18,22,26,30,32,35,40,41,42,43,55,56,57,66,67,69,72,76,82,83,88]
# def find_num(l,aim):
#     mid_index = len(l) // 2
#     if l[mid_index] < aim:
#         new_l = l[mid_index+1:]
#         find_num(new_l,aim)
#     elif l[mid_index] > aim:
#         new_l = l[:mid_index]
#         find_num(new_l,aim)
#     else:
#         print("find it",mid_index,l[mid_index])
#
#  find_num(l,66)

'''第二种方法'''
# l=[2,3,5,10,15,16,18,22,26,30,32,35,41,42,55,56,57,66,67,69,72,76,82,83,88]
# def find(l,aim,start = 0,end = None):
#     end = len(l) if end is None else end
#     mid_index = (end - start) // 2 + start  ##计算中间值
#     if start <= end:
#         if l[mid_index] < aim:
#             find(l,aim,start = mid_index+1,end = end)
#         elif l[mid_index] > aim:
#             find(l,aim,start = start,end = mid_index - 1)
#         else:
#             print('找到了',mid_index,aim)
#     else:
#         print('找不到这个值')
# find(l,44)
