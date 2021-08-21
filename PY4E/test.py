file = input('Enter a file name: ')
read = open(file)

counts = {}

for line in read :
    sp_rm = line.rstrip()
    words = sp_rm.split()

    for word in words :
        counts[word] = counts.get(word, 0) + 1

bigcount = None
bigword = None

for word, count in counts.items() :
    if bigcount is None or count > bigcount :
        bigword = word
        bigcount = count

print(bigword, bigcount)
