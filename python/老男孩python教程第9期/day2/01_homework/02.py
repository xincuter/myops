#第2题：输出1-100内的所有奇数和偶数

count = 1
jishu_list = []
oushu_list = []

while count < 101:
    if count % 2 == 0:
        oushu_list.append(count)
    else:
        jishu_list.append(count)
    count += 1

print("奇数集合为: ",jishu_list)
print("偶数集合为: ",oushu_list)
