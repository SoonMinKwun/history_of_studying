file = input('Enter a file name: ')
read = open(file)
for line in read :
    sp_rm = line.rstrip()

    if sp_rm.startswith('From') :
        sp_rm_From = sp_rm.split()

        if len(sp_rm_From) > 2 :
            print(sp_rm_From[3])
