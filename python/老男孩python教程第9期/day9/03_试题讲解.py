##已知列表：li = ['alex','wusir','rain']
##(1)根据li生成字符串s = 'alexwusirrain'
li = ['alex','wusir','rain']
s = ''.join(li)   ##【join(可迭代对象)】
print(s)