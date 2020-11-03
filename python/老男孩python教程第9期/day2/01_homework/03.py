##求1+2+3+...=99所有数的和
##第一种方法：for循环
sum = 0
for i in range(1,100):
    sum += i

print("采用for循环----[1-99所有数的和为]: ", sum)

##第二种方法：while循环
count = 1
sum = 0
while count < 100:
    sum += count
    count +=1

print ("采用while循环----[1-99所有数的和为]: ", sum)