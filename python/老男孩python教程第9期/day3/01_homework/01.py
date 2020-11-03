#计算1-2+3...+99中除了88以外所有数的和
sum = 0
for i in range(1,100):
    if i == 88:
        continue

    if i % 2 == 0:
        sum -= i
    else:
        sum += i

print("1-2+3...+99中除88外所有数的总和为：", sum)