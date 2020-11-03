##用户三次登录（三次机会重试）
account_db = {'hzzx':'hzzx@123','hzwjf':'hzwjf@123','hztzp':'hztzp@123'}

def login():
    count = 1
    while count < 4:
        username = input("please input your account: ")
        password = input("please input your password: ")

        if username in account_db.keys():
            if password == account_db[username]:
                print('congradulations,login successed.')
                break
            else:
                print('sorry,password is fault.')
        else:
            print('sorry,username is fault.')

        count += 1

##main
if __name__ == "__main__":
    login()

