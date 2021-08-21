num = None
sum = 0
cnt = 0
avg = 0

while 1 :
    try :
        num = input("Enter a number: ")
        if num == 'done' :
            break
        sum = float(sum) + float(num)
        cnt = int(cnt) + 1
        avg = sum / cnt

    except :
        print("Invalid input")
        continue

print(sum, cnt, avg)
