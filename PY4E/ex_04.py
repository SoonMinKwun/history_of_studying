pay = input('ADD YOUR PAY ',)
rate = input('ADD YOUR RATE ',)

gross = float(pay)*float(rate)
over_rate = float(rate) - 40

if over_rate > 0 :
    gross = float(gross) + (float(over_rate)/2)*float(pay)

print('YOUR GROSS IS',gross)
