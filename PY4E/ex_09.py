file = input('Enter a file name: ')
read = open(file)
for line in read :
    print(line.upper().rstrip())
