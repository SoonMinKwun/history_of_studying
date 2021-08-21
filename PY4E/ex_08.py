str = 'X-DSPM-Confidence: 0.8475'

start = int(str.find(' '))+1

num = float(str[start:])

print(num)
