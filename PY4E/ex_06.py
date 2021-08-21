def computepay(x, y) :
    gross = float(x)*float(y)
    over_rate = float(y) - 40

    if over_rate > 0 :
        gross = float(gross) + (float(over_rate)/2)*float(x)

    return gross

try :
    s_pay = input('ENTER HOUR: ',)
    f_pay = float(s_pay)
    s_rate = input('ENTER RATE: ',)
    f_rate = float(s_rate)

    gross = computepay(f_pay, f_rate)

    print('YOUR GROSS IS',gross)

except :
    print('Error, please enter numeric input!')
