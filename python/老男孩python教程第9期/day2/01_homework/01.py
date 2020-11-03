#第1题： 使用while循环输出1 2 3 4 5 6 8 9 10

##第一种方法【for循环】
print("------for循环处理------")
for i in range(1,11):
    if i == 7:
        pass
    else:
        print(i)

##第二种方法：【while循环】
print("------while循环处理------")
count = 0
while count < 10:
    count += 1  ##等价于count = count + 1
    if count == 7:
        pass   ##等价于shell中true or :
        #continue
    else:
        print(count)